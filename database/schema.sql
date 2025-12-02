-- ============================================
-- Blood & Organ Donation Management System
-- Database Schema
-- ============================================

DROP DATABASE IF EXISTS blood_organ_donation;
CREATE DATABASE blood_organ_donation CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE blood_organ_donation;

-- ============================================
-- Users & Authentication
-- ============================================

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'doctor', 'donor', 'patient', 'staff') NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB;

-- ============================================
-- Donors
-- ============================================

CREATE TABLE donors (
    donor_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE,
    national_id VARCHAR(50) UNIQUE NOT NULL,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('M', 'F', 'Other') NOT NULL,
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20),
    emergency_contact_name VARCHAR(200),
    emergency_contact_phone VARCHAR(20),
    donor_status ENUM('active', 'inactive', 'blacklisted', 'deceased') DEFAULT 'active',
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_donation_date DATE NULL,
    total_donations INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_blood_type (blood_type),
    INDEX idx_donor_status (donor_status),
    INDEX idx_city (city),
    INDEX idx_national_id (national_id)
) ENGINE=InnoDB;

-- ============================================
-- Donor Health Records
-- ============================================

CREATE TABLE donor_health_records (
    health_record_id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT NOT NULL,
    record_date DATE NOT NULL,
    blood_pressure_systolic INT,
    blood_pressure_diastolic INT,
    hemoglobin_level DECIMAL(4,2),
    temperature DECIMAL(4,2),
    pulse_rate INT,
    medical_conditions TEXT,
    medications TEXT,
    recent_surgeries TEXT,
    allergies TEXT,
    diseases TEXT,
    is_eligible BOOLEAN DEFAULT TRUE,
    ineligibility_reason TEXT,
    examined_by INT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (donor_id) REFERENCES donors(donor_id) ON DELETE CASCADE,
    FOREIGN KEY (examined_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_donor_date (donor_id, record_date),
    INDEX idx_eligibility (is_eligible)
) ENGINE=InnoDB;

-- ============================================
-- Patients/Recipients
-- ============================================

CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE,
    national_id VARCHAR(50) UNIQUE NOT NULL,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('M', 'F', 'Other') NOT NULL,
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20),
    emergency_contact_name VARCHAR(200),
    emergency_contact_phone VARCHAR(20),
    patient_status ENUM('active', 'inactive', 'deceased', 'transplanted') DEFAULT 'active',
    urgency_level ENUM('critical', 'urgent', 'normal', 'low') DEFAULT 'normal',
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_blood_type (blood_type),
    INDEX idx_urgency (urgency_level),
    INDEX idx_patient_status (patient_status),
    INDEX idx_city (city)
) ENGINE=InnoDB;

-- ============================================
-- Doctors
-- ============================================

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    specialization VARCHAR(200),
    hospital_affiliation VARCHAR(200),
    department VARCHAR(100),
    experience_years INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_specialization (specialization),
    INDEX idx_hospital (hospital_affiliation)
) ENGINE=InnoDB;

-- ============================================
-- Blood Inventory
-- ============================================

CREATE TABLE blood_inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    component_type ENUM('Whole Blood', 'RBC', 'Plasma', 'Platelets', 'Cryoprecipitate') NOT NULL,
    units_available INT DEFAULT 0,
    units_reserved INT DEFAULT 0,
    minimum_threshold INT DEFAULT 10,
    location VARCHAR(100),
    storage_temp DECIMAL(4,2),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_blood_component (blood_type, component_type, location),
    INDEX idx_blood_type (blood_type),
    INDEX idx_component (component_type),
    INDEX idx_availability (units_available)
) ENGINE=InnoDB;

-- ============================================
-- Blood Donations
-- ============================================

CREATE TABLE blood_donations (
    donation_id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT NOT NULL,
    donation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    donation_type ENUM('Whole Blood', 'Plasma', 'Platelets', 'Double RBC') NOT NULL,
    quantity_ml INT NOT NULL,
    donation_center VARCHAR(200),
    collected_by INT,
    bag_number VARCHAR(50) UNIQUE,
    screening_status ENUM('pending', 'passed', 'failed') DEFAULT 'pending',
    expiry_date DATE,
    usage_status ENUM('available', 'used', 'expired', 'discarded') DEFAULT 'available',
    used_for_patient INT NULL,
    used_date TIMESTAMP NULL,
    notes TEXT,
    FOREIGN KEY (donor_id) REFERENCES donors(donor_id) ON DELETE CASCADE,
    FOREIGN KEY (collected_by) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (used_for_patient) REFERENCES patients(patient_id) ON DELETE SET NULL,
    INDEX idx_donor (donor_id),
    INDEX idx_donation_date (donation_date),
    INDEX idx_screening_status (screening_status),
    INDEX idx_usage_status (usage_status),
    INDEX idx_bag_number (bag_number)
) ENGINE=InnoDB;

-- ============================================
-- Organ Inventory
-- ============================================

CREATE TABLE organ_inventory (
    organ_id INT PRIMARY KEY AUTO_INCREMENT,
    organ_type ENUM('Heart', 'Liver', 'Kidney', 'Lung', 'Pancreas', 'Intestine', 'Cornea', 'Skin', 'Bone', 'Heart Valve') NOT NULL,
    donor_id INT NOT NULL,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    hla_type VARCHAR(100),
    procurement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    procurement_hospital VARCHAR(200),
    organ_status ENUM('available', 'allocated', 'transplanted', 'discarded') DEFAULT 'available',
    quality_grade ENUM('Excellent', 'Good', 'Fair', 'Poor') DEFAULT 'Good',
    allocated_to_patient INT NULL,
    allocation_date TIMESTAMP NULL,
    expiry_datetime TIMESTAMP NULL,
    notes TEXT,
    FOREIGN KEY (donor_id) REFERENCES donors(donor_id) ON DELETE CASCADE,
    FOREIGN KEY (allocated_to_patient) REFERENCES patients(patient_id) ON DELETE SET NULL,
    INDEX idx_organ_type (organ_type),
    INDEX idx_organ_status (organ_status),
    INDEX idx_blood_type (blood_type),
    INDEX idx_donor (donor_id)
) ENGINE=InnoDB;

-- ============================================
-- Transplant Requests
-- ============================================

CREATE TABLE transplant_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    organ_type ENUM('Heart', 'Liver', 'Kidney', 'Lung', 'Pancreas', 'Intestine', 'Cornea', 'Skin', 'Bone', 'Heart Valve') NOT NULL,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    hla_type VARCHAR(100),
    urgency_level ENUM('critical', 'urgent', 'normal', 'low') DEFAULT 'normal',
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    requesting_doctor INT,
    medical_reason TEXT,
    patient_condition TEXT,

    request_status ENUM('waiting', 'matched', 'transplanted', 'cancelled', 'expired') DEFAULT 'waiting',
    matched_organ_id INT NULL,
    transplant_date TIMESTAMP NULL,
    outcome TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (requesting_doctor) REFERENCES doctors(doctor_id) ON DELETE SET NULL,
    FOREIGN KEY (matched_organ_id) REFERENCES organ_inventory(organ_id) ON DELETE SET NULL,
    INDEX idx_patient (patient_id),
    INDEX idx_organ_type (organ_type),
    INDEX idx_urgency (urgency_level),
    INDEX idx_status (request_status),
    INDEX idx_request_date (request_date)
) ENGINE=InnoDB;

-- ============================================
-- Appointments
-- ============================================

CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    appointment_type ENUM('Blood Donation', 'Organ Donation Consultation', 'Follow-up', 'Health Screening', 'Transplant Consultation') NOT NULL,
    appointment_date DATETIME NOT NULL,
    duration_minutes INT DEFAULT 30,
    location VARCHAR(200),
    assigned_doctor INT NULL,
    appointment_status ENUM('scheduled', 'confirmed', 'completed', 'cancelled', 'no-show') DEFAULT 'scheduled',
    notes TEXT,
    reminder_sent BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_doctor) REFERENCES doctors(doctor_id) ON DELETE SET NULL,
    INDEX idx_user (user_id),
    INDEX idx_appointment_date (appointment_date),
    INDEX idx_status (appointment_status),
    INDEX idx_doctor (assigned_doctor)
) ENGINE=InnoDB;

-- ============================================
-- Donation Campaigns
-- ============================================

CREATE TABLE donation_campaigns (
    campaign_id INT PRIMARY KEY AUTO_INCREMENT,
    campaign_name VARCHAR(200) NOT NULL,
    campaign_type ENUM('Blood Drive', 'Organ Awareness', 'Emergency Appeal', 'Community Event') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    location VARCHAR(200),
    target_units INT,
    collected_units INT DEFAULT 0,
    organizer_name VARCHAR(200),
    organizer_contact VARCHAR(100),
    description TEXT,
    campaign_status ENUM('planned', 'active', 'completed', 'cancelled') DEFAULT 'planned',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_campaign_dates (start_date, end_date),
    INDEX idx_status (campaign_status),
    INDEX idx_type (campaign_type)
) ENGINE=InnoDB;

-- ============================================
-- Matching Algorithm Logs
-- ============================================

CREATE TABLE matching_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    request_id INT NOT NULL,
    organ_id INT NOT NULL,
    compatibility_score DECIMAL(5,2),
    blood_type_compatible BOOLEAN,
    hla_match_level ENUM('Perfect', 'Good', 'Moderate', 'Poor'),
    distance_km DECIMAL(8,2),
    urgency_weight DECIMAL(5,2),
    waiting_time_weight DECIMAL(5,2),
    overall_priority_score DECIMAL(8,2),
    match_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    selected_for_transplant BOOLEAN DEFAULT FALSE,
    notes TEXT,
    FOREIGN KEY (request_id) REFERENCES transplant_requests(request_id) ON DELETE CASCADE,
    FOREIGN KEY (organ_id) REFERENCES organ_inventory(organ_id) ON DELETE CASCADE,
    INDEX idx_request (request_id),
    INDEX idx_organ (organ_id),
    INDEX idx_score (overall_priority_score DESC)
) ENGINE=InnoDB;

-- ============================================
-- Compliance & Audit Logs
-- ============================================

CREATE TABLE compliance_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    log_type ENUM('donation', 'transplant', 'inventory', 'access', 'modification', 'deletion') NOT NULL,
    entity_type VARCHAR(50),
    entity_id INT,
    action_performed VARCHAR(255),
    performed_by INT,
    ip_address VARCHAR(45),
    details TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (performed_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_log_type (log_type),
    INDEX idx_timestamp (timestamp),
    INDEX idx_user (performed_by)
) ENGINE=InnoDB;

-- ============================================
-- Feedback & Ratings
-- ============================================

CREATE TABLE feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    feedback_type ENUM('Service', 'Donation Experience', 'Staff', 'Facility', 'Other') NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    is_anonymous BOOLEAN DEFAULT FALSE,
    response TEXT,
    responded_by INT NULL,
    response_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (responded_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_rating (rating),
    INDEX idx_type (feedback_type),
    INDEX idx_date (created_at)
) ENGINE=InnoDB;

-- ============================================
-- Notifications
-- ============================================

CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    notification_type ENUM('appointment_reminder', 'donation_eligible', 'match_found', 'campaign_alert', 'system_message') NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_sent_at (sent_at)
) ENGINE=InnoDB;

-- ============================================
-- Initial Data for Blood Inventory
-- ============================================

INSERT INTO blood_inventory (blood_type, component_type, units_available, units_reserved, minimum_threshold, location) VALUES
-- Whole Blood
('A+', 'Whole Blood', 45, 5, 20, 'Main Blood Bank'),
('A-', 'Whole Blood', 15, 2, 10, 'Main Blood Bank'),
('B+', 'Whole Blood', 35, 3, 20, 'Main Blood Bank'),
('B-', 'Whole Blood', 10, 1, 8, 'Main Blood Bank'),
('AB+', 'Whole Blood', 12, 1, 8, 'Main Blood Bank'),
('AB-', 'Whole Blood', 5, 0, 5, 'Main Blood Bank'),
('O+', 'Whole Blood', 60, 8, 30, 'Main Blood Bank'),
('O-', 'Whole Blood', 20, 3, 15, 'Main Blood Bank'),
-- Red Blood Cells
('A+', 'RBC', 80, 10, 30, 'Main Blood Bank'),
('O-', 'RBC', 45, 8, 25, 'Main Blood Bank'),
-- Plasma
('AB+', 'Plasma', 30, 2, 15, 'Main Blood Bank'),
('AB-', 'Plasma', 12, 1, 8, 'Main Blood Bank'),
-- Platelets
('A+', 'Platelets', 25, 3, 15, 'Main Blood Bank'),
('O+', 'Platelets', 35, 5, 20, 'Main Blood Bank');

COMMIT;
