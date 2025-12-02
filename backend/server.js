const express = require('express');
const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const dotenv = require('dotenv');
const { body, validationResult } = require('express-validator');

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors({
    origin: process.env.CORS_ORIGIN || '*',
    credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Database Connection Pool
const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME || 'blood_organ_donation',
    port: process.env.DB_PORT || 3306,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Authentication Middleware
const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ error: 'Access token required' });
    }

    jwt.verify(token, process.env.JWT_SECRET || 'default_secret', (err, user) => {
        if (err) {
            return res.status(403).json({ error: 'Invalid or expired token' });
        }
        req.user = user;
        next();
    });
};

// Role-based authorization middleware
const authorize = (...roles) => {
    return (req, res, next) => {
        if (!roles.includes(req.user.role)) {
            return res.status(403).json({ error: 'Insufficient permissions' });
        }
        next();
    };
};

// ============================================
// AUTHENTICATION ROUTES
// ============================================

// Login
app.post('/api/auth/login', [
    body('email').isEmail(),
    body('password').notEmpty()
], async (req, res) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const { email, password } = req.body;

        const [users] = await pool.query(
            'SELECT * FROM users WHERE email = ? AND is_active = TRUE',
            [email]
        );

        if (users.length === 0) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const user = users[0];
        const validPassword = await bcrypt.compare(password, user.password_hash);

        if (!validPassword) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        // Update last login
        await pool.query('UPDATE users SET last_login = NOW() WHERE user_id = ?', [user.user_id]);

        const token = jwt.sign(
            { userId: user.user_id, email: user.email, role: user.role },
            process.env.JWT_SECRET || 'default_secret',
            { expiresIn: process.env.SESSION_TIMEOUT || '24h' }
        );

        res.json({
            message: 'Login successful',
            token,
            user: {
                userId: user.user_id,
                email: user.email,
                firstName: user.first_name,
                lastName: user.last_name,
                role: user.role
            }
        });
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Register
app.post('/api/auth/register', [
    body('email').isEmail(),
    body('password').isLength({ min: 6 }),
    body('firstName').notEmpty(),
    body('lastName').notEmpty(),
    body('role').isIn(['donor', 'patient'])
], async (req, res) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const { email, password, firstName, lastName, phone, role } = req.body;

        // Check if user exists
        const [existing] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);
        if (existing.length > 0) {
            return res.status(409).json({ error: 'Email already registered' });
        }

        // Hash password
        const passwordHash = await bcrypt.hash(password, 10);

        // Insert user
        const [result] = await pool.query(
            'INSERT INTO users (email, password_hash, role, first_name, last_name, phone) VALUES (?, ?, ?, ?, ?, ?)',
            [email, passwordHash, role, firstName, lastName, phone]
        );

        res.status(201).json({
            message: 'Registration successful',
            userId: result.insertId
        });
    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// ============================================
// DASHBOARD ROUTES
// ============================================

app.get('/api/dashboard/stats', async (req, res) => {
    try {
        const [stats] = await pool.query('CALL get_dashboard_stats()');
        res.json(stats[0][0]);
    } catch (error) {
        console.error('Dashboard stats error:', error);
        res.status(500).json({ error: 'Failed to fetch dashboard statistics' });
    }
});

// ============================================
// DONOR ROUTES
// ============================================

// Get all donors
app.get('/api/donors', authenticateToken, authorize('admin', 'doctor', 'staff'), async (req, res) => {
    try {
        const [donors] = await pool.query(`
            SELECT d.*, u.email, u.first_name, u.last_name, u.phone, u.is_active
            FROM donors d
            JOIN users u ON d.user_id = u.user_id
            ORDER BY d.registration_date DESC
        `);
        res.json(donors);
    } catch (error) {
        console.error('Get donors error:', error);
        res.status(500).json({ error: 'Failed to fetch donors' });
    }
});

// Search donors
app.get('/api/donors/search', authenticateToken, async (req, res) => {
    try {
        const { bloodType, city, minAge, maxAge } = req.query;
        const [results] = await pool.query(
            'CALL search_donors(?, ?, ?, ?)',
            [bloodType || null, city || null, minAge || null, maxAge || null]
        );
        res.json(results[0]);
    } catch (error) {
        console.error('Search donors error:', error);
        res.status(500).json({ error: 'Failed to search donors' });
    }
});

// Get donor by ID
app.get('/api/donors/:id', authenticateToken, async (req, res) => {
    try {
        const [donors] = await pool.query(`
            SELECT d.*, u.email, u.first_name, u.last_name, u.phone
            FROM donors d
            JOIN users u ON d.user_id = u.user_id
            WHERE d.donor_id = ?
        `, [req.params.id]);

        if (donors.length === 0) {
            return res.status(404).json({ error: 'Donor not found' });
        }

        res.json(donors[0]);
    } catch (error) {
        console.error('Get donor error:', error);
        res.status(500).json({ error: 'Failed to fetch donor' });
    }
});

// Create donor profile
app.post('/api/donors', authenticateToken, [
    body('nationalId').notEmpty(),
    body('bloodType').isIn(['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']),
    body('dateOfBirth').isDate(),
    body('gender').isIn(['M', 'F', 'Other'])
], async (req, res) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const {
            nationalId, bloodType, dateOfBirth, gender, weight, height,
            address, city, state, zipCode, emergencyContactName, emergencyContactPhone
        } = req.body;

        const [result] = await pool.query(
            `INSERT INTO donors (user_id, national_id, blood_type, date_of_birth, gender, weight, height,
             address, city, state, zip_code, emergency_contact_name, emergency_contact_phone)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [req.user.userId, nationalId, bloodType, dateOfBirth, gender, weight, height,
                address, city, state, zipCode, emergencyContactName, emergencyContactPhone]
        );

        res.status(201).json({
            message: 'Donor profile created successfully',
            donorId: result.insertId
        });
    } catch (error) {
        console.error('Create donor error:', error);
        res.status(500).json({ error: 'Failed to create donor profile' });
    }
});

// ============================================
// BLOOD INVENTORY ROUTES
// ============================================

// Get blood inventory
app.get('/api/blood-inventory', async (req, res) => {
    try {
        const [inventory] = await pool.query(`
            SELECT * FROM blood_inventory
            ORDER BY blood_type, component_type
        `);
        res.json(inventory);
    } catch (error) {
        console.error('Get blood inventory error:', error);
        res.status(500).json({ error: 'Failed to fetch blood inventory' });
    }
});

// Get low inventory alerts
app.get('/api/blood-inventory/alerts', authenticateToken, authorize('admin', 'staff'), async (req, res) => {
    try {
        const [alerts] = await pool.query('CALL get_low_inventory_alerts()');
        res.json(alerts[0]);
    } catch (error) {
        console.error('Get inventory alerts error:', error);
        res.status(500).json({ error: 'Failed to fetch inventory alerts' });
    }
});

// ============================================
// BLOOD DONATION ROUTES
// ============================================

// Get all blood donations
app.get('/api/blood-donations', authenticateToken, authorize('admin', 'doctor', 'staff'), async (req, res) => {
    try {
        const [donations] = await pool.query(`
            SELECT bd.*, d.national_id, u.first_name, u.last_name
            FROM blood_donations bd
            JOIN donors d ON bd.donor_id = d.donor_id
            JOIN users u ON d.user_id = u.user_id
            ORDER BY bd.donation_date DESC
            LIMIT 100
        `);
        res.json(donations);
    } catch (error) {
        console.error('Get blood donations error:', error);
        res.status(500).json({ error: 'Failed to fetch blood donations' });
    }
});

// Register new blood donation
app.post('/api/blood-donations', authenticateToken, authorize('doctor', 'staff'), [
    body('donorId').isInt(),
    body('bloodType').isIn(['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']),
    body('donationType').notEmpty(),
    body('quantityMl').isInt({ min: 200, max: 600 })
], async (req, res) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const { donorId, bloodType, donationType, quantityMl, donationCenter, bagNumber } = req.body;

        const [result] = await pool.query(
            'CALL register_blood_donation(?, ?, ?, ?, ?, ?, ?)',
            [donorId, bloodType, donationType, quantityMl, donationCenter, req.user.userId, bagNumber]
        );

        res.status(201).json({
            message: 'Blood donation registered successfully',
            donation: result[0][0]
        });
    } catch (error) {
        console.error('Register blood donation error:', error);
        res.status(500).json({ error: 'Failed to register blood donation' });
    }
});

// ============================================
// ORGAN INVENTORY ROUTES
// ============================================

// Get organ inventory
app.get('/api/organ-inventory', authenticateToken, authorize('admin', 'doctor'), async (req, res) => {
    try {
        const [organs] = await pool.query(`
            SELECT oi.*, d.national_id, u.first_name AS donor_first_name, u.last_name AS donor_last_name
            FROM organ_inventory oi
            JOIN donors d ON oi.donor_id = d.donor_id
            JOIN users u ON d.user_id = u.user_id
            WHERE oi.organ_status IN ('available', 'allocated')
            ORDER BY oi.procurement_date DESC
        `);
        res.json(organs);
    } catch (error) {
        console.error('Get organ inventory error:', error);
        res.status(500).json({ error: 'Failed to fetch organ inventory' });
    }
});

// ============================================
// TRANSPLANT REQUEST ROUTES
// ============================================

// Get transplant requests
app.get('/api/transplant-requests', authenticateToken, authorize('admin', 'doctor'), async (req, res) => {
    try {
        const [requests] = await pool.query(`
            SELECT tr.*, p.national_id, u.first_name AS patient_first_name, u.last_name AS patient_last_name,
                   d.license_number, du.first_name AS doctor_first_name, du.last_name AS doctor_last_name
            FROM transplant_requests tr
            JOIN patients p ON tr.patient_id = p.patient_id
            JOIN users u ON p.user_id = u.user_id
            LEFT JOIN doctors d ON tr.requesting_doctor = d.doctor_id
            LEFT JOIN users du ON d.user_id = du.user_id
            WHERE tr.request_status IN ('waiting', 'matched')
            ORDER BY 
                CASE tr.urgency_level
                    WHEN 'critical' THEN 1
                    WHEN 'urgent' THEN 2
                    WHEN 'normal' THEN 3
                    WHEN 'low' THEN 4
                END,
                tr.waiting_time_days DESC
        `);
        res.json(requests);
    } catch (error) {
        console.error('Get transplant requests error:', error);
        res.status(500).json({ error: 'Failed to fetch transplant requests' });
    }
});

// ============================================
// APPOINTMENT ROUTES
// ============================================

// Get appointments
app.get('/api/appointments', authenticateToken, async (req, res) => {
    try {
        let query;
        let params;

        if (req.user.role === 'admin' || req.user.role === 'staff') {
            query = `
                SELECT a.*, u.first_name, u.last_name, u.email, u.phone
                FROM appointments a
                JOIN users u ON a.user_id = u.user_id
                WHERE a.appointment_date >= CURDATE()
                ORDER BY a.appointment_date ASC
            `;
            params = [];
        } else {
            query = `
                SELECT a.*, u.first_name, u.last_name
                FROM appointments a
                JOIN users u ON a.user_id = u.user_id
                WHERE a.user_id = ? AND a.appointment_date >= CURDATE()
                ORDER BY a.appointment_date ASC
            `;
            params = [req.user.userId];
        }

        const [appointments] = await pool.query(query, params);
        res.json(appointments);
    } catch (error) {
        console.error('Get appointments error:', error);
        res.status(500).json({ error: 'Failed to fetch appointments' });
    }
});

// Schedule appointment
app.post('/api/appointments', authenticateToken, [
    body('appointmentType').notEmpty(),
    body('appointmentDate').isISO8601(),
    body('location').notEmpty()
], async (req, res) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const { appointmentType, appointmentDate, location, assignedDoctor, notes } = req.body;

        const [result] = await pool.query(
            'CALL schedule_appointment(?, ?, ?, ?, ?, ?)',
            [req.user.userId, appointmentType, appointmentDate, location, assignedDoctor || null, notes || null]
        );

        res.status(201).json({
            message: 'Appointment scheduled successfully',
            appointment: result[0][0]
        });
    } catch (error) {
        console.error('Schedule appointment error:', error);
        res.status(500).json({ error: 'Failed to schedule appointment' });
    }
});

// ============================================
// CAMPAIGN ROUTES
// ============================================

// Get active campaigns
// Get active campaigns
app.get('/api/campaigns', async (req, res) => {
    try {
        const [campaigns] = await pool.query(`
            SELECT * FROM donation_campaigns
            WHERE campaign_status IN ('active', 'planned')
            ORDER BY start_date ASC
        `);
        res.json(campaigns);
    } catch (error) {
        console.error('Get campaigns error:', error);
        res.status(500).json({ error: 'Failed to fetch campaigns' });
    }
});

// ============================================
// SERVER STARTUP
// ============================================

app.listen(PORT, () => {
    console.log(`🚀 Blood & Organ Donation API Server running on port ${PORT}`);
    console.log(`📊 Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log(`🔗 API URL: http://localhost:${PORT}`);
});

// Graceful shutdown
process.on('SIGTERM', async () => {
    console.log('SIGTERM signal received: closing HTTP server');
    await pool.end();
    process.exit(0);
});
