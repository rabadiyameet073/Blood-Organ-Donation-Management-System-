-- ============================================
-- Sample Data
-- Blood & Organ Donation Management System
-- ============================================

USE blood_organ_donation;

-- ============================================
-- Sample Users (Password: 'password123' - hashed with bcrypt)
-- ============================================
INSERT INTO users (email, password_hash, role, first_name, last_name, phone, is_active) VALUES
('admin@bloodbank.com', '$2a$10$rB6LJ48JCw0aRC8vvhf8ZuDhULB4zG0QnRtZPZQNL8yK5LDL.G2qu', 'admin', 'Admin', 'User', '555-0001', TRUE),
('dr.smith@hospital.com', '$2a$10$rB6LJ48JCw0aRC8vvhf8ZuDhULB4zG0QnRtZPZQNL8yK5LDL.G2qu', 'doctor', 'John', 'Smith', '555-0002', TRUE),
('dr.jones@hospital.com', '$2a$10$rB6LJ48JCw0aRC8vvhf8ZuDhULB4zG0QnRtZPZQNL8yK5LDL.G2qu', 'doctor', 'Sarah', 'Jones', '555-0003', TRUE),
('donor1@email.com', '$2a$10$rB6LJ48JCw0aRC8vvhf8ZuDhULB4zG0QnRtZPZQNL8yK5LDL.G2qu', 'donor', 'Michael', 'Johnson', '555-0101', TRUE),
('donor2@email.com', '$2a$10$rB6LJ48JCw0aRC8vvhf8ZuDhULB4zG0QnRtZPZQNL8yK5LDL.G2qu', 'donor', 'Emily', 'Williams', '555-0102', TRUE),
('donor3@email.com', '$2a$10$rB6LJ48JCw0aRC8vvhf8ZuDhULB4zG0QnRtZPZQNL8yK5LDL.G2qu', 'donor', 'Robert', 'Brown', '555-0103', TRUE),
('donor4@email.com', '$2a$10$rB6LJ48JCw0aRC8vvhf8ZuDhULB4zG0QnRtZPZQNL8yK5LDL.G2qu', 'donor', 'Jennifer', 'Davis', '555-0104', TRUE),
('patient1@email.com', '$2a$10$rB6LJ48JCw0aRC8vvhf8ZuDhULB4zG0QnRtZPZQNL8yK5LDL.G2qu', 'patient', 'David', 'Miller', '555-0201', TRUE),
('patient2@email.com', '$2a$10$rB6LJ48JCw0aRC8vvhf8ZuDhULB4zG0QnRtZPZQNL8yK5LDL.G2qu', 'patient', 'Lisa', 'Wilson', '555-0202', TRUE),
('patient3@email.com', '$2a$10$rB6LJ48JCw0aRC8vvhf8ZuDhULB4zG0QnRtZPZQNL8yK5LDL.G2qu', 'patient', 'James', 'Moore', '555-0203', TRUE);

-- ============================================
-- Sample Doctors
-- ============================================
INSERT INTO doctors (user_id, license_number, specialization, hospital_affiliation, department, experience_years) VALUES
(2, 'MD-12345', 'Hematology', 'City General Hospital', 'Blood Bank', 15),
(3, 'MD-23456', 'Transplant Surgery', 'City General Hospital', 'Organ Transplant', 12);

-- ============================================
-- Sample Donors
-- ============================================
INSERT INTO donors (user_id, national_id, blood_type, date_of_birth, gender, weight, height, address, city, state, zip_code, emergency_contact_name, emergency_contact_phone, donor_status) VALUES
(4, 'DN-001-2024', 'O+', '1990-05-15', 'M', 75.5, 178.0, '123 Main St', 'New York', 'NY', '10001', 'Sarah Johnson', '555-0111', 'active'),
(5, 'DN-002-2024', 'A+', '1985-08-20', 'F', 62.0, 165.0, '456 Oak Ave', 'New York', 'NY', '10002', 'Tom Williams', '555-0112', 'active'),
(6, 'DN-003-2024', 'B+', '1992-03-10', 'M', 82.0, 182.0, '789 Pine Rd', 'Brooklyn', 'NY', '11201', 'Mary Brown', '555-0113', 'active'),
(7, 'DN-004-2024', 'AB+', '1988-11-25', 'F', 58.5, 160.0, '321 Elm St', 'Queens', 'NY', '11354', 'John Davis', '555-0114', 'active');

-- ============================================
-- Sample Donor Health Records
-- ============================================
INSERT INTO donor_health_records (donor_id, record_date, blood_pressure_systolic, blood_pressure_diastolic, hemoglobin_level, temperature, pulse_rate, is_eligible, examined_by) VALUES
(1, '2024-11-15', 120, 80, 14.5, 98.6, 72, TRUE, 2),
(2, '2024-11-20', 118, 78, 13.2, 98.4, 68, TRUE, 2),
(3, '2024-11-18', 125, 82, 15.1, 98.5, 75, TRUE, 2),
(4, '2024-11-22', 115, 75, 12.8, 98.6, 70, TRUE, 2);

-- ============================================
-- Sample Patients
-- ============================================
INSERT INTO patients (user_id, national_id, blood_type, date_of_birth, gender, weight, height, address, city, state, zip_code, emergency_contact_name, emergency_contact_phone, patient_status, urgency_level) VALUES
(8, 'PT-001-2024', 'A+', '1975-02-14', 'M', 70.0, 175.0, '111 Hope St', 'New York', 'NY', '10003', 'Karen Miller', '555-0211', 'active', 'urgent'),
(9, 'PT-002-2024', 'O+', '1980-07-30', 'F', 65.0, 168.0, '222 Care Ave', 'Brooklyn', 'NY', '11202', 'Robert Wilson', '555-0212', 'active', 'critical'),
(10, 'PT-003-2024', 'B+', '1972-12-05', 'M', 78.0, 180.0, '333 Health Blvd', 'Queens', 'NY', '11355', 'Nancy Moore', '555-0213', 'active', 'normal');

-- ============================================
-- Sample Blood Donations
-- ============================================
INSERT INTO blood_donations (donor_id, blood_type, donation_type, quantity_ml, donation_center, collected_by, bag_number, screening_status, expiry_date, usage_status) VALUES
(1, 'O+', 'Whole Blood', 450, 'Main Blood Bank', 2, 'BAG-2024-001', 'passed', DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'available'),
(1, 'O+', 'Whole Blood', 450, 'Main Blood Bank', 2, 'BAG-2024-002', 'passed', DATE_ADD(CURDATE(), INTERVAL 28 DAY), 'available'),
(2, 'A+', 'Whole Blood', 450, 'Main Blood Bank', 2, 'BAG-2024-003', 'passed', DATE_ADD(CURDATE(), INTERVAL 32 DAY), 'available'),
(3, 'B+', 'Whole Blood', 450, 'Main Blood Bank', 2, 'BAG-2024-004', 'passed', DATE_ADD(CURDATE(), INTERVAL 29 DAY), 'available'),
(4, 'AB+', 'Plasma', 600, 'Main Blood Bank', 2, 'BAG-2024-005', 'passed', DATE_ADD(CURDATE(), INTERVAL 350 DAY), 'available');

-- Update donor statistics
UPDATE donors SET last_donation_date = DATE_SUB(CURDATE(), INTERVAL 60 DAY), total_donations = 2 WHERE donor_id = 1;
UPDATE donors SET last_donation_date = DATE_SUB(CURDATE(), INTERVAL 75 DAY), total_donations = 1 WHERE donor_id = 2;
UPDATE donors SET last_donation_date = DATE_SUB(CURDATE(), INTERVAL 90 DAY), total_donations = 1 WHERE donor_id = 3;
UPDATE donors SET last_donation_date = DATE_SUB(CURDATE(), INTERVAL 120 DAY), total_donations = 1 WHERE donor_id = 4;

-- ============================================
-- Sample Organ Inventory
-- ============================================
INSERT INTO organ_inventory (organ_type, donor_id, blood_type, hla_type, procurement_hospital, organ_status, quality_grade, expiry_datetime) VALUES
('Kidney', 1, 'O+', 'A1-B8-DR3', 'City General Hospital', 'available', 'Excellent', DATE_ADD(NOW(), INTERVAL 24 HOUR)),
('Liver', 2, 'A+', 'A2-B44-DR4', 'City General Hospital', 'available', 'Good', DATE_ADD(NOW(), INTERVAL 12 HOUR)),
('Cornea', 3, 'B+', 'A3-B7-DR15', 'City General Hospital', 'available', 'Excellent', DATE_ADD(NOW(), INTERVAL 7 DAY));

-- ============================================
-- Sample Transplant Requests
-- ============================================
INSERT INTO transplant_requests (patient_id, organ_type, blood_type, hla_type, urgency_level, requesting_doctor, medical_reason, patient_condition, request_status) VALUES
(1, 'Liver', 'A+', 'A2-B44-DR4', 'urgent', 2, 'Chronic liver failure', 'Patient requires urgent liver transplant', 'waiting'),
(2, 'Kidney', 'O+', 'A1-B8-DR3', 'critical', 1, 'End-stage renal disease', 'Patient on dialysis, critical condition', 'waiting'),
(3, 'Kidney', 'B+', 'A3-B7-DR2', 'normal', 1, 'Chronic kidney disease', 'Stable but requires transplant', 'waiting');

-- ============================================
-- Sample Appointments
-- ============================================
INSERT INTO appointments (user_id, appointment_type, appointment_date, location, assigned_doctor, appointment_status) VALUES
(4, 'Blood Donation', DATE_ADD(NOW(), INTERVAL 2 DAY), 'Main Blood Bank', 2, 'scheduled'),
(5, 'Blood Donation', DATE_ADD(NOW(), INTERVAL 3 DAY), 'Main Blood Bank', 2, 'confirmed'),
(6, 'Health Screening', DATE_ADD(NOW(), INTERVAL 5 DAY), 'Main Blood Bank', 2, 'scheduled'),
(8, 'Transplant Consultation', DATE_ADD(NOW(), INTERVAL 1 DAY), 'City General Hospital', 1, 'confirmed'),
(9, 'Follow-up', DATE_ADD(NOW(), INTERVAL 7 DAY), 'City General Hospital', 1, 'scheduled');

-- ============================================
-- Sample Donation Campaigns
-- ============================================
INSERT INTO donation_campaigns (campaign_name, campaign_type, start_date, end_date, location, target_units, collected_units, organizer_name, organizer_contact, description, campaign_status) VALUES
('Winter Blood Drive 2024', 'Blood Drive', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'Community Center', 500, 125, 'Red Cross', 'contact@redcross.org', 'Annual winter blood donation campaign to build reserves for the season', 'active'),
('Organ Donation Awareness Week', 'Organ Awareness', DATE_ADD(CURDATE(), INTERVAL 15 DAY), DATE_ADD(CURDATE(), INTERVAL 22 DAY), 'Multiple Locations', 0, 0, 'National Organ Foundation', 'info@organfoundation.org', 'Educational campaign to increase organ donor registrations', 'planned'),
('Emergency Appeal - O Negative', 'Emergency Appeal', DATE_SUB(CURDATE(), INTERVAL 5 DAY), DATE_ADD(CURDATE(), INTERVAL 10 DAY), 'Main Blood Bank', 100, 45, 'City Blood Bank', 'emergency@bloodbank.com', 'Critical shortage of O negative blood', 'active');

-- ============================================
-- Sample Notifications
-- ============================================
INSERT INTO notifications (user_id, notification_type, title, message, is_read) VALUES
(4, 'appointment_reminder', 'Upcoming Donation Appointment', 'Your blood donation appointment is scheduled for 2 days from now at Main Blood Bank', FALSE),
(5, 'donation_eligible', 'You Are Eligible to Donate', 'It has been 60 days since your last donation. You are now eligible to donate blood again!', FALSE),
(8, 'match_found', 'Potential Organ Match Found', 'A potential organ match has been identified for your transplant request. Please contact your doctor.', TRUE),
(9, 'appointment_reminder', 'Follow-up Appointment', 'Your follow-up appointment is scheduled for next week', FALSE);

-- ============================================
-- Sample Feedback
-- ============================================
INSERT INTO feedback (user_id, feedback_type, rating, comments, is_anonymous) VALUES
(4, 'Donation Experience', 5, 'The staff was very professional and the donation process was smooth', FALSE),
(5, 'Service', 4, 'Great experience overall, but waiting time could be reduced', FALSE),
(6, 'Facility', 5, 'Very clean and well-maintained facility', FALSE);

COMMIT;
