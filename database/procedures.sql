-- ============================================
-- Stored Procedures and Functions
-- Blood & Organ Donation Management System
-- ============================================

USE blood_organ_donation;

DELIMITER $$

-- ============================================
-- 1. Check Blood Compatibility
-- ============================================
CREATE FUNCTION check_blood_compatibility(donor_blood VARCHAR(10), recipient_blood VARCHAR(10))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- O- is universal donor
    IF donor_blood = 'O-' THEN
        RETURN TRUE;
    END IF;
    
    -- AB+ is universal recipient
    IF recipient_blood = 'AB+' THEN
        RETURN TRUE;
    END IF;
    
    -- Exact match
    IF donor_blood = recipient_blood THEN
        RETURN TRUE;
    END IF;
    
    -- Specific compatibility rules
    IF recipient_blood = 'A+' AND donor_blood IN ('A+', 'A-', 'O+', 'O-') THEN
        RETURN TRUE;
    END IF;
    
    IF recipient_blood = 'A-' AND donor_blood IN ('A-', 'O-') THEN
        RETURN TRUE;
    END IF;
    
    IF recipient_blood = 'B+' AND donor_blood IN ('B+', 'B-', 'O+', 'O-') THEN
        RETURN TRUE;
    END IF;
    
    IF recipient_blood = 'B-' AND donor_blood IN ('B-', 'O-') THEN
        RETURN TRUE;
    END IF;
    
    IF recipient_blood = 'AB-' AND donor_blood IN ('AB-', 'A-', 'B-', 'O-') THEN
        RETURN TRUE;
    END IF;
    
    IF recipient_blood = 'O+' AND donor_blood IN ('O+', 'O-') THEN
        RETURN TRUE;
    END IF;
    
    RETURN FALSE;
END$$

-- ============================================
-- 2. Calculate Organ Matching Score
-- ============================================
CREATE PROCEDURE calculate_organ_match_score(
    IN p_request_id INT,
    IN p_organ_id INT
)
BEGIN
    DECLARE v_compatibility_score DECIMAL(5,2) DEFAULT 0;
    DECLARE v_blood_compatible BOOLEAN DEFAULT FALSE;
    DECLARE v_hla_match_level VARCHAR(20) DEFAULT 'Poor';
    DECLARE v_urgency_weight DECIMAL(5,2) DEFAULT 0;
    DECLARE v_waiting_weight DECIMAL(5,2) DEFAULT 0;
    DECLARE v_overall_score DECIMAL(8,2) DEFAULT 0;
    
    DECLARE v_patient_blood VARCHAR(10);
    DECLARE v_donor_blood VARCHAR(10);
    DECLARE v_urgency VARCHAR(20);
    DECLARE v_waiting_days INT;
    
    -- Get request details
    SELECT p.blood_type, tr.urgency_level, tr.waiting_time_days
    INTO v_patient_blood, v_urgency, v_waiting_days
    FROM transplant_requests tr
    JOIN patients p ON tr.patient_id = p.patient_id
    WHERE tr.request_id = p_request_id;
    
    -- Get organ blood type
    SELECT blood_type INTO v_donor_blood
    FROM organ_inventory
    WHERE organ_id = p_organ_id;
    
    -- Check blood compatibility
    SET v_blood_compatible = check_blood_compatibility(v_donor_blood, v_patient_blood);
    
    IF v_blood_compatible THEN
        SET v_compatibility_score = 50;
    ELSE
        SET v_compatibility_score = 0;
    END IF;
    
    -- Urgency weight
    CASE v_urgency
        WHEN 'critical' THEN SET v_urgency_weight = 40;
        WHEN 'urgent' THEN SET v_urgency_weight = 30;
        WHEN 'normal' THEN SET v_urgency_weight = 15;
        WHEN 'low' THEN SET v_urgency_weight = 5;
    END CASE;
    
    -- Waiting time weight (max 30 points, 1 point per 30 days)
    SET v_waiting_weight = LEAST(30, v_waiting_days / 30);
    
    -- Calculate overall score
    SET v_overall_score = v_compatibility_score + v_urgency_weight + v_waiting_weight;
    
    -- Insert into matching_logs
    INSERT INTO matching_logs (
        request_id, organ_id, compatibility_score, blood_type_compatible,
        hla_match_level, urgency_weight, waiting_time_weight, overall_priority_score
    ) VALUES (
        p_request_id, p_organ_id, v_compatibility_score, v_blood_compatible,
        v_hla_match_level, v_urgency_weight, v_waiting_weight, v_overall_score
    );
    
    SELECT v_overall_score AS match_score, v_blood_compatible AS is_compatible;
END$$

-- ============================================
-- 3. Find Best Organ Match
-- ============================================
CREATE PROCEDURE find_best_organ_match(
    IN p_organ_type VARCHAR(50)
)
BEGIN
    -- Find all waiting requests for this organ type
    SELECT 
        tr.request_id,
        tr.patient_id,
        CONCAT(u.first_name, ' ', u.last_name) AS patient_name,
        tr.urgency_level,
        tr.waiting_time_days,
        p.blood_type,
        tr.request_date
    FROM transplant_requests tr
    JOIN patients p ON tr.patient_id = p.patient_id
    JOIN users u ON p.user_id = u.user_id
    WHERE tr.organ_type = p_organ_type
      AND tr.request_status = 'waiting'
    ORDER BY 
        CASE tr.urgency_level
            WHEN 'critical' THEN 1
            WHEN 'urgent' THEN 2
            WHEN 'normal' THEN 3
            WHEN 'low' THEN 4
        END,
        tr.waiting_time_days DESC;
END$$

-- ============================================
-- 4. Check Donor Eligibility
-- ============================================
CREATE FUNCTION check_donor_eligibility(p_donor_id INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE v_last_donation DATE;
    DECLARE v_days_since_donation INT;
    DECLARE v_is_eligible BOOLEAN DEFAULT FALSE;
    DECLARE v_donor_status VARCHAR(20);
    
    -- Get donor status
    SELECT donor_status, last_donation_date
    INTO v_donor_status, v_last_donation
    FROM donors
    WHERE donor_id = p_donor_id;
    
    -- Check if donor is active
    IF v_donor_status != 'active' THEN
        RETURN FALSE;
    END IF;
    
    -- Check last health record
    SELECT is_eligible INTO v_is_eligible
    FROM donor_health_records
    WHERE donor_id = p_donor_id
    ORDER BY record_date DESC
    LIMIT 1;
    
    IF v_is_eligible IS NULL OR v_is_eligible = FALSE THEN
        RETURN FALSE;
    END IF;
    
    -- Check time since last donation (minimum 56 days for blood)
    IF v_last_donation IS NOT NULL THEN
        SET v_days_since_donation = DATEDIFF(CURDATE(), v_last_donation);
        IF v_days_since_donation < 56 THEN
            RETURN FALSE;
        END IF;
    END IF;
    
    RETURN TRUE;
END$$

-- ============================================
-- 5. Update Blood Inventory
-- ============================================
CREATE PROCEDURE update_blood_inventory(
    IN p_blood_type VARCHAR(10),
    IN p_component VARCHAR(50),
    IN p_quantity_change INT,
    IN p_location VARCHAR(100)
)
BEGIN
    UPDATE blood_inventory
    SET units_available = units_available + p_quantity_change,
        last_updated = CURRENT_TIMESTAMP
    WHERE blood_type = p_blood_type
      AND component_type = p_component
      AND location = p_location;
    
    -- Return current inventory
    SELECT * FROM blood_inventory
    WHERE blood_type = p_blood_type
      AND component_type = p_component
      AND location = p_location;
END$$

-- ============================================
-- 6. Get Low Inventory Alert
-- ============================================
CREATE PROCEDURE get_low_inventory_alerts()
BEGIN
    SELECT 
        blood_type,
        component_type,
        units_available,
        minimum_threshold,
        location,
        (minimum_threshold - units_available) AS shortage
    FROM blood_inventory
    WHERE units_available < minimum_threshold
    ORDER BY (minimum_threshold - units_available) DESC;
END$$

-- ============================================
-- 7. Register Blood Donation
-- ============================================
CREATE PROCEDURE register_blood_donation(
    IN p_donor_id INT,
    IN p_blood_type VARCHAR(10),
    IN p_donation_type VARCHAR(50),
    IN p_quantity_ml INT,
    IN p_donation_center VARCHAR(200),
    IN p_collected_by INT,
    IN p_bag_number VARCHAR(50)
)
BEGIN
    DECLARE v_expiry_date DATE;
    
    -- Calculate expiry date based on component type
    CASE p_donation_type
        WHEN 'Whole Blood' THEN SET v_expiry_date = DATE_ADD(CURDATE(), INTERVAL 35 DAY);
        WHEN 'Plasma' THEN SET v_expiry_date = DATE_ADD(CURDATE(), INTERVAL 365 DAY);
        WHEN 'Platelets' THEN SET v_expiry_date = DATE_ADD(CURDATE(), INTERVAL 5 DAY);
        WHEN 'Double RBC' THEN SET v_expiry_date = DATE_ADD(CURDATE(), INTERVAL 42 DAY);
        ELSE SET v_expiry_date = DATE_ADD(CURDATE(), INTERVAL 35 DAY);
    END CASE;
    
    -- Insert donation record
    INSERT INTO blood_donations (
        donor_id, blood_type, donation_type, quantity_ml,
        donation_center, collected_by, bag_number, expiry_date
    ) VALUES (
        p_donor_id, p_blood_type, p_donation_type, p_quantity_ml,
        p_donation_center, p_collected_by, p_bag_number, v_expiry_date
    );
    
    -- Update donor's last donation date
    UPDATE donors
    SET last_donation_date = CURDATE(),
        total_donations = total_donations + 1
    WHERE donor_id = p_donor_id;
    
    SELECT LAST_INSERT_ID() AS donation_id, v_expiry_date AS expiry_date;
END$$

-- ============================================
-- 8. Get Dashboard Statistics
-- ============================================
CREATE PROCEDURE get_dashboard_stats()
BEGIN
    -- Total counts
    SELECT 
        (SELECT COUNT(*) FROM donors WHERE donor_status = 'active') AS active_donors,
        (SELECT COUNT(*) FROM patients WHERE patient_status = 'active') AS active_patients,
        (SELECT SUM(units_available) FROM blood_inventory WHERE component_type = 'Whole Blood') AS total_blood_units,
        (SELECT COUNT(*) FROM organ_inventory WHERE organ_status = 'available') AS available_organs,
        (SELECT COUNT(*) FROM transplant_requests WHERE request_status = 'waiting') AS pending_requests,
        (SELECT COUNT(*) FROM appointments WHERE appointment_status = 'scheduled' AND appointment_date >= CURDATE()) AS upcoming_appointments,
        (SELECT COUNT(*) FROM donation_campaigns WHERE campaign_status = 'active') AS active_campaigns;
END$$

-- ============================================
-- 9. Search Available Donors
-- ============================================
CREATE PROCEDURE search_donors(
    IN p_blood_type VARCHAR(10),
    IN p_city VARCHAR(100),
    IN p_min_age INT,
    IN p_max_age INT
)
BEGIN
    SELECT 
        d.donor_id,
        CONCAT(u.first_name, ' ', u.last_name) AS donor_name,
        d.blood_type,
        d.gender,
        TIMESTAMPDIFF(YEAR, d.date_of_birth, CURDATE()) AS age,
        d.city,
        d.phone,
        d.last_donation_date,
        d.total_donations,
        check_donor_eligibility(d.donor_id) AS is_eligible
    FROM donors d
    JOIN users u ON d.user_id = u.user_id
    WHERE d.donor_status = 'active'
      AND (p_blood_type IS NULL OR d.blood_type = p_blood_type)
      AND (p_city IS NULL OR d.city = p_city)
      AND TIMESTAMPDIFF(YEAR, d.date_of_birth, CURDATE()) BETWEEN COALESCE(p_min_age, 18) AND COALESCE(p_max_age, 65)
    ORDER BY d.last_donation_date ASC;
END$$

-- ============================================
-- 10. Schedule Appointment
-- ============================================
CREATE PROCEDURE schedule_appointment(
    IN p_user_id INT,
    IN p_appointment_type VARCHAR(100),
    IN p_appointment_date DATETIME,
    IN p_location VARCHAR(200),
    IN p_assigned_doctor INT,
    IN p_notes TEXT
)
BEGIN
    INSERT INTO appointments (
        user_id, appointment_type, appointment_date,
        location, assigned_doctor, notes
    ) VALUES (
        p_user_id, p_appointment_type, p_appointment_date,
        p_location, p_assigned_doctor, p_notes
    );
    
    SELECT LAST_INSERT_ID() AS appointment_id;
END$$

DELIMITER ;
