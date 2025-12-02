-- ============================================
-- Database Triggers
-- Blood & Organ Donation Management System
-- ============================================

USE blood_organ_donation;

DELIMITER $$

-- ============================================
-- 1. Auto-update blood inventory after donation
-- ============================================
CREATE TRIGGER after_blood_donation_insert
AFTER INSERT ON blood_donations
FOR EACH ROW
BEGIN
    -- Only update if screening passed
    IF NEW.screening_status = 'passed' THEN
        -- Determine component type for inventory
        SET @component = CASE 
            WHEN NEW.donation_type = 'Whole Blood' THEN 'Whole Blood'
            WHEN NEW.donation_type = 'Plasma' THEN 'Plasma'
            WHEN NEW.donation_type = 'Platelets' THEN 'Platelets'
            WHEN NEW.donation_type = 'Double RBC' THEN 'RBC'
            ELSE 'Whole Blood'
        END;
        
        -- Update inventory (1 unit = ~450ml)
        UPDATE blood_inventory
        SET units_available = units_available + FLOOR(NEW.quantity_ml / 450)
        WHERE blood_type = NEW.blood_type 
          AND component_type = @component
          AND location = COALESCE(NEW.donation_center, 'Main Blood Bank');
    END IF;
END$$

-- ============================================
-- 2. Create compliance log for donations
-- ============================================
CREATE TRIGGER after_donation_compliance_log
AFTER INSERT ON blood_donations
FOR EACH ROW
BEGIN
    INSERT INTO compliance_logs (
        log_type, entity_type, entity_id, 
        action_performed, performed_by, details
    ) VALUES (
        'donation', 'blood_donations', NEW.donation_id,
        'New blood donation registered', NEW.collected_by,
        CONCAT('Donor: ', NEW.donor_id, ', Type: ', NEW.blood_type, 
               ', Volume: ', NEW.quantity_ml, 'ml')
    );
END$$

-- ============================================
-- 3. Send notification when inventory is low
-- ============================================
CREATE TRIGGER after_inventory_update_check
AFTER UPDATE ON blood_inventory
FOR EACH ROW
BEGIN
    DECLARE admin_id INT;
    
    -- Check if inventory dropped below threshold
    IF NEW.units_available < NEW.minimum_threshold 
       AND OLD.units_available >= OLD.minimum_threshold THEN
        
        -- Get first admin user
        SELECT user_id INTO admin_id
        FROM users
        WHERE role = 'admin' AND is_active = TRUE
        LIMIT 1;
        
        -- Create notification
        IF admin_id IS NOT NULL THEN
            INSERT INTO notifications (
                user_id, notification_type, title, message
            ) VALUES (
                admin_id, 'system_message',
                'Low Blood Inventory Alert',
                CONCAT('Blood type ', NEW.blood_type, ' (', NEW.component_type, 
                       ') has fallen below minimum threshold. Available: ', 
                       NEW.units_available, ' units, Threshold: ', NEW.minimum_threshold, ' units')
            );
        END IF;
    END IF;
END$$

-- ============================================
-- 4. Auto-create notification when donor is eligible again
-- ============================================
CREATE TRIGGER after_donation_eligibility_check
AFTER UPDATE ON donors
FOR EACH ROW
BEGIN
    DECLARE days_since_last INT;
    
    -- Check if last donation date changed
    IF NEW.last_donation_date != OLD.last_donation_date THEN
        SET days_since_last = DATEDIFF(CURDATE(), NEW.last_donation_date);
        
        -- If 56 days have passed, create eligibility notification
        IF days_since_last >= 56 AND NEW.user_id IS NOT NULL THEN
            INSERT INTO notifications (
                user_id, notification_type, title, message
            ) VALUES (
                NEW.user_id, 'donation_eligible',
                'You Are Eligible to Donate Again!',
                CONCAT('It has been ', days_since_last, 
                       ' days since your last donation. You can now donate blood again!')
            );
        END IF;
    END IF;
END$$

-- ============================================
-- 5. Log organ allocation
-- ============================================
CREATE TRIGGER after_organ_allocation
AFTER UPDATE ON organ_inventory
FOR EACH ROW
BEGIN
    -- Check if organ was allocated
    IF NEW.organ_status = 'allocated' AND OLD.organ_status = 'available' THEN
        INSERT INTO compliance_logs (
            log_type, entity_type, entity_id,
            action_performed, details
        ) VALUES (
            'transplant', 'organ_inventory', NEW.organ_id,
            'Organ allocated to patient',
            CONCAT('Organ: ', NEW.organ_type, ', Patient ID: ', 
                   NEW.allocated_to_patient, ', Blood Type: ', NEW.blood_type)
        );
        
        -- Notify patient if they have a user account
        IF NEW.allocated_to_patient IS NOT NULL THEN
            INSERT INTO notifications (
                user_id, notification_type, title, message
            )
            SELECT 
                p.user_id, 'match_found',
                'Organ Match Found!',
                CONCAT('A matching ', NEW.organ_type, 
                       ' has been allocated. Your transplant coordinator will contact you soon.')
            FROM patients p
            WHERE p.patient_id = NEW.allocated_to_patient 
              AND p.user_id IS NOT NULL;
        END IF;
    END IF;
END$$

-- ============================================
-- 6. Update transplant request status automatically
-- ============================================
CREATE TRIGGER after_organ_allocation_update_request
AFTER UPDATE ON organ_inventory
FOR EACH ROW
BEGIN
    -- Update transplant request status when organ is allocated
    IF NEW.organ_status = 'allocated' AND NEW.allocated_to_patient IS NOT NULL THEN
        UPDATE transplant_requests
        SET request_status = 'matched',
            matched_organ_id = NEW.organ_id
        WHERE patient_id = NEW.allocated_to_patient
          AND request_status = 'waiting'
          AND organ_type = NEW.organ_type
        LIMIT 1;
    END IF;
END$$

-- ============================================
-- 7. Auto-expire old blood donations
-- ============================================
CREATE EVENT cleanup_expired_donations
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    -- Mark expired donations
    UPDATE blood_donations
    SET usage_status = 'expired'
    WHERE expiry_date < CURDATE()
      AND usage_status = 'available';
    
    -- Log the cleanup
    INSERT INTO compliance_logs (
        log_type, entity_type, action_performed, details
    ) VALUES (
        'inventory', 'blood_donations', 
        'Automatic expiry cleanup',
        CONCAT('Marked expired donations as of ', CURDATE())
    );
END$$

-- ============================================
-- 8. Send appointment reminders
-- ============================================
CREATE EVENT send_appointment_reminders
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    -- Create notifications for appointments in next 24 hours
    INSERT INTO notifications (user_id, notification_type, title, message)
    SELECT 
        a.user_id,
        'appointment_reminder',
        'Upcoming Appointment Reminder',
        CONCAT('You have a ', a.appointment_type, 
               ' appointment tomorrow at ', a.location)
    FROM appointments a
    WHERE DATE(a.appointment_date) = DATE_ADD(CURDATE(), INTERVAL 1 DAY)
      AND a.appointment_status IN ('scheduled', 'confirmed')
      AND a.reminder_sent = FALSE;
    
    -- Mark reminders as sent
    UPDATE appointments
    SET reminder_sent = TRUE
    WHERE DATE(appointment_date) = DATE_ADD(CURDATE(), INTERVAL 1 DAY)
      AND appointment_status IN ('scheduled', 'confirmed')
      AND reminder_sent = FALSE;
END$$

-- ============================================
-- 9. Track user login activity
-- ============================================
CREATE TRIGGER after_user_login_log
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    -- Log when last_login changes
    IF NEW.last_login != OLD.last_login OR (NEW.last_login IS NOT NULL AND OLD.last_login IS NULL) THEN
        INSERT INTO compliance_logs (
            log_type, entity_type, entity_id,
            action_performed, performed_by, details
        ) VALUES (
            'access', 'users', NEW.user_id,
            'User login', NEW.user_id,
            CONCAT('Role: ', NEW.role, ', Email: ', NEW.email)
        );
    END IF;
END$$

-- ============================================
-- 10. Prevent deletion of active patients with pending requests
-- ============================================
CREATE TRIGGER before_patient_delete_check
BEFORE DELETE ON patients
FOR EACH ROW
BEGIN
    DECLARE pending_requests INT;
    
    -- Check for pending transplant requests
    SELECT COUNT(*) INTO pending_requests
    FROM transplant_requests
    WHERE patient_id = OLD.patient_id
      AND request_status IN ('waiting', 'matched');
    
    IF pending_requests > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete patient with pending transplant requests';
    END IF;
END$$

DELIMITER ;

-- Enable event scheduler (required for automated events)
SET GLOBAL event_scheduler = ON;

-- Verify triggers were created
SELECT 
    TRIGGER_NAME, 
    EVENT_MANIPULATION, 
    EVENT_OBJECT_TABLE,
    ACTION_TIMING
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'blood_organ_donation'
ORDER BY EVENT_OBJECT_TABLE, ACTION_TIMING;

COMMIT;
