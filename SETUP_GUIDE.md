# 🚀 Quick Setup Guide - Blood & Organ Donation DBMS

Get your system running in under 10 minutes!

## Prerequisites Checklist

- [ ] MySQL 8.0+ or MariaDB 10.5+ installed
- [ ] Node.js 16+ installed
- [ ] Text editor (VS Code, Notepad++, etc.)
- [ ] Web browser (Chrome, Firefox, Edge)

## Step 1: Database Setup (3 minutes)

### Option A: Command Line
```bash
# Navigate to project directory
cd path/to/project

# Import schema
mysql -u root -p < 01_schema.sql

# Import procedures
mysql -u root -p blood_organ_donation < 02_procedures.sql

# Import sample data
mysql -u root -p blood_organ_donation < 03_sample_data.sql
```

### Option B: MySQL Workbench
1. Open MySQL Workbench
2. Connect to your MySQL server
3. File → Open SQL Script → Select `01_schema.sql`
4. Click Execute (⚡)
5. Repeat for `02_procedures.sql` and `03_sample_data.sql`

### Verify Database
```sql
USE blood_organ_donation;
SHOW TABLES;
-- Should show 15 tables
```

## Step 2: Backend Setup (3 minutes)

### Configure Environment
1. Copy `05_env_example.txt` to `.env`
2. Edit `.env` with your database credentials:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=YOUR_MYSQL_PASSWORD_HERE
DB_NAME=blood_organ_donation
DB_PORT=3306
JWT_SECRET=your_random_secret_key_12345
PORT=3000
```

### Install Dependencies
```bash
npm install
```

### Start Server
```bash
npm start
```

You should see:
```
🚀 Blood & Organ Donation API Server running on port 3000
📊 Environment: development
🔗 API URL: http://localhost:3000
```

## Step 3: Frontend Setup (1 minute)

### Option A: Direct Open
Simply open `08_index.html` in your web browser

### Option B: Local Server (Recommended)
```bash
# If you have Python installed:
python -m http.server 5500

# OR using npx:
npx http-server -p 5500

# OR using VS Code:
# Right-click on 08_index.html → "Open with Live Server"
```

Then open: `http://localhost:5500/08_index.html`

## Step 4: Test the System (2 minutes)

### Test 1: View Statistics
- The homepage should show animated statistics
- Should see: Active Donors, Blood Units, Organs Available

### Test 2: View Blood Inventory
- Scroll down to see blood inventory cards
- Each card shows blood type, units available, and status

### Test 3: View Campaigns
- Active campaigns should be displayed
- Progress bars should show campaign status

### Test 4: Test Login (Optional)
```
Email: admin@bloodbank.com
Password: password123
```

## Troubleshooting

### Database Connection Failed
**Problem**: Backend can't connect to MySQL

**Solutions**:
1. Verify MySQL is running: `mysql -u root -p`
2. Check credentials in `.env` file
3. Ensure database name is correct: `blood_organ_donation`
4. Check MySQL port (default 3306)

### Frontend Not Loading Data
**Problem**: Statistics show 0 or inventory is empty

**Solutions**:
1. Ensure backend server is running (`npm start`)
2. Check browser console for errors (F12)
3. Verify API URL in `09_app.js` (should be `http://localhost:3000/api`)
4. Test API directly: `http://localhost:3000/api/dashboard/stats`

### CORS Error
**Problem**: "Access blocked by CORS policy"

**Solutions**:
1. Add your frontend URL to `.env`:
   ```
   CORS_ORIGIN=http://localhost:5500
   ```
2. Restart backend server
3. Alternatively, open frontend via same origin as backend

### Stored Procedures Not Found
**Problem**: Error calling procedures

**Solutions**:
1. Ensure `02_procedures.sql` was imported
2. Check procedures exist:
   ```sql
   SHOW PROCEDURE STATUS WHERE Db = 'blood_organ_donation';
   ```
3. Re-import if needed

## File Organization

After setup, organize your files:

```
your-project-folder/
├── database/
│   ├── 01_schema.sql
│   ├── 02_procedures.sql
│   └── 03_sample_data.sql
├── backend/
│   ├── package.json (renamed from 04_package.json)
│   ├── .env (created from 05_env_example.txt)
│   ├── server.js (renamed from 06_server.js)
│   └── node_modules/ (created by npm install)
└── frontend/
    ├── styles.css (renamed from 07_styles.css)
    ├── index.html (renamed from 08_index.html)
    └── app.js (renamed from 09_app.js)
```

## Next Steps

### For Development
1. Start backend: `npm start`
2. Start frontend: Open `index.html` or use live server
3. Make changes and refresh browser

### For Testing
1. Login with demo accounts (see README.md)
2. Test donor registration
3. View dashboard statistics
4. Check blood inventory
5. Schedule appointments

### For Production
1. Change JWT_SECRET to strong random string
2. Update CORS_ORIGIN to your domain
3. Use environment variables for sensitive data
4. Enable HTTPS
5. Set up proper database backups

## Demo Accounts

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@bloodbank.com | password123 |
| Doctor | dr.smith@hospital.com | password123 |
| Donor | donor1@email.com | password123 |
| Patient | patient1@email.com | password123 |

## Success Checklist

- [ ] Database has 15 tables
- [ ] Sample data loaded (4 donors, 3 patients, etc.)
- [ ] Backend server starts without errors
- [ ] Frontend displays statistics
- [ ] Blood inventory cards visible
- [ ] Campaigns showing
- [ ] Forms can be submitted

## Getting Help

1. Check the main README.md for detailed documentation
2. Review walkthrough.md for feature explanations
3. Examine browser console (F12) for JavaScript errors
4. Check backend terminal for server errors
5. Verify database connections and queries

---

**🎉 Congratulations! Your Blood & Organ Donation Management System is ready!**
