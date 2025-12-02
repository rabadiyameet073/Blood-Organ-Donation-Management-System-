# 🩸 Blood & Organ Donation Management System

A comprehensive, production-ready database management system for blood and organ donation with a modern web interface, REST API backend, and advanced matching algorithms.

![Status](https://img.shields.io/badge/status-production--ready-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)

## ✨ Features

### 🏥 Core Functionality
- **Donor Management**: Complete registration, health screening, and eligibility tracking
- **Patient/Recipient Management**: Transplant requests with urgency-based prioritization
- **Blood Inventory**: Real-time tracking of blood components with automated alerts
- **Organ Inventory**: Comprehensive organ tracking with matching algorithms
- **Appointment Scheduling**: Automated scheduling system with reminders
- **Donation Campaigns**: Campaign management with progress tracking
- **Compliance & Audit**: Complete audit trail for regulatory compliance

### 🔬 Advanced Features
- **Intelligent Organ Matching**: Algorithm considering blood type, HLA compatibility, urgency, and waiting time
- **Blood Compatibility Checking**: Automated blood type compatibility verification
- **Low Inventory Alerts**: Real-time alerts when inventory falls below thresholds
- **Donor Eligibility Verification**: Automated health-based eligibility checking
- **Statistics Dashboard**: Real-time analytics and reporting

### 🎨 Modern UI/UX
- **Glassmorphism Design**: Premium, modern interface with blur effects
- **Smooth Animations**: Engaging micro-animations throughout
- **Dark Theme**: Eye-friendly design with vibrant red/blue accents
- **Responsive Layout**: Fully responsive for desktop, tablet, and mobile
- **Interactive Dashboards**: Real-time data visualization

## 🛠️ Technology Stack

### Database
- **MySQL**: Relational database with stored procedures and triggers
- **15 Normalized Tables**: Following 3NF for data integrity
- **Indexed Queries**: Optimized for performance

### Backend
- **Node.js**: Runtime environment
- **Express.js**: Web framework
- **JWT Authentication**: Secure token-based auth
- **bcrypt**: Password hashing
- **mysql2**: Database driver with promise support

### Frontend
- **HTML5**: Semantic markup
- **CSS3**: Modern styling with custom properties
- **Vanilla JavaScript**: No framework dependencies
- **Fetch API**: For server communication
- **Inter Font**: Professional typography

## 📋 Database Schema

The system includes 15 comprehensive tables:

1. **users** - Authentication and user management
2. **donors** - Donor profiles and information
3. **donor_health_records** - Health screening data
4. **patients** - Patient/recipient information
5. **doctors** - Medical staff profiles
6. **blood_inventory** - Blood component tracking
7. **blood_donations** - Donation records
8. **organ_inventory** - Organ availability tracking
9. **transplant_requests** - Transplant waiting list
10. **appointments** - Scheduling system
11. **donation_campaigns** - Campaign management
12. **matching_logs** - Organ matching algorithm logs
13. **compliance_logs** - Audit trail
14. **feedback** - User feedback system
15. **notifications** - Alert system

## 🚀 Quick Start

### Prerequisites
- **MySQL 8.0+** or **MariaDB 10.5+**
- **Node.js 16+** and **npm**
- Web browser (Chrome, Firefox, Safari, or Edge)

### Installation

1. **Import Database Schema**
   ```bash
   mysql -u root -p < 01_schema.sql
   mysql -u root -p blood_organ_donation < 02_procedures.sql
   mysql -u root -p blood_organ_donation < 03_sample_data.sql
   ```

2. **Configure Backend**
   ```bash
   # Copy environment file
   cp 05_env_example.txt .env
   
   # Edit .env with your database credentials
   # DB_HOST=localhost
   # DB_USER=root
   # DB_PASSWORD=your_password
   # DB_NAME=blood_organ_donation
   ```

3. **Install Dependencies**
   ```bash
   npm install
   ```

4. **Start Backend Server**
   ```bash
   npm start
   # Server runs on http://localhost:3000
   ```

5. **Open Frontend**
   - Open `08_index.html` in your web browser
   - Or use a local server: `npx http-server -p 5500`

## 🔐 Demo Credentials

The sample data includes these test accounts:

| Role | Email | Password | Purpose |
|------|-------|----------|---------|
| Admin | admin@bloodbank.com | password123 | Full system access |
| Doctor | dr.smith@hospital.com | password123 | Medical operations |
| Donor | donor1@email.com | password123 | Donor portal |
| Patient | patient1@email.com | password123 | Patient requests |

## 📡 API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration

### Donors
- `GET /api/donors` - List all donors
- `GET /api/donors/:id` - Get donor by ID
- `GET /api/donors/search` - Search donors
- `POST /api/donors` - Create donor profile

### Blood Management
- `GET /api/blood-inventory` - Get blood inventory
- `GET /api/blood-inventory/alerts` - Low inventory alerts
- `GET /api/blood-donations` - List donations
- `POST /api/blood-donations` - Register donation

### Organs
- `GET /api/organ-inventory` - Available organs
- `GET /api/transplant-requests` - Transplant waiting list

### General
- `GET /api/dashboard/stats` - Dashboard statistics
- `GET /api/appointments` - List appointments
- `POST /api/appointments` - Schedule appointment
- `GET /api/campaigns` - Active campaigns

## 📖 Usage Guide

### For Donors
1. Register using the "Register" button
2. Fill out donor profile with blood type and health info
3. Schedule blood donation appointments
4. Track donation history

### For Patients
1. Register as a patient
2. Submit transplant requests through your doctor
3. Track request status and waiting time
4. View matched organs

### For Administrators
1. Login with admin credentials
2. Access the Dashboard for system statistics
3. Monitor blood/organ inventory
4. View low inventory alerts
5. Manage campaigns and appointments

## 🔧 Configuration

### Database Connection
Edit `.env` file:
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=blood_organ_donation
DB_PORT=3306
```

### JWT Secret
Change the JWT secret in production:
```
JWT_SECRET=your_secure_random_string_here
```

### CORS Settings
Configure allowed origins:
```
CORS_ORIGIN=https://yourdomain.com
```

## 🧪 Testing

The system includes sample data for testing all features:
- 4 donors with different blood types
- 3 patients with various urgency levels
- Blood inventory with multiple components
- Organ inventory with kidneys, liver, and corneas
- Active campaigns
- Scheduled appointments

## 📊 Features in Detail

### Organ Matching Algorithm
The system uses a sophisticated scoring algorithm:
- **Blood Type Compatibility** (50 points)
- **Urgency Level** (5-40 points based on critical/urgent/normal/low)
- **Waiting Time** (up to 30 points, 1 point per 30 days)
- **Overall Score** determines transplant priority

### Blood Compatibility
Automated checking follows standard transfusion rules:
- O- is universal donor
- AB+ is universal recipient
- Type-specific compatibility enforced

### Inventory Management
- Real-time tracking of units available and reserved
- Automatic alerts when below minimum threshold
- Component-specific tracking (Whole Blood, RBC, Plasma, Platelets)
- Location-based inventory

## 🤝 Contributing

This is a complete database management system project suitable for:
- Academic projects
- Hospital management systems
- Blood bank operations
- Organ transplant coordination
- Healthcare training simulations

## 📄 License

MIT License - Feel free to use for academic or commercial purposes.

## 🆘 Support

For issues or questions:
1. Check the documentation in this README
2. Review the API endpoint documentation
3. Ensure MySQL and Node.js are properly installed
4. Verify database credentials in `.env`

## 🎓 Academic Use

This project is ideal for:
- **Database Management Systems** courses
- **Web Development** projects
- **Healthcare Information Systems** studies
- **Software Engineering** capstone projects

### Key Learning Areas
- Database design and normalization
- REST API development
- Authentication and authorization
- Frontend-backend integration
- SQL stored procedures and functions
- Healthcare domain modeling

---

**Built with ❤️ for saving lives through technology**
