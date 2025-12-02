// API Configuration
const API_URL = 'http://localhost:3000/api';
let authToken = localStorage.getItem('authToken');
let currentUser = JSON.parse(localStorage.getItem('currentUser'));

// Utility Functions
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed; top: 20px; right: 20px; padding: 1rem 1.5rem;
        background: var(--gradient-primary); color: white; border-radius: var(--radius-md);
        box-shadow: var(--shadow-lg); z-index: 10000;
    `;
    document.body.appendChild(notification);
    setTimeout(() => notification.remove(), 3000);
}

function animateCounter(element, target) {
    let current = 0;
    const increment = target / 50;
    const timer = setInterval(() => {
        current += increment;
        if (current >= target) {
            element.textContent = Math.round(target);
            clearInterval(timer);
        } else {
            element.textContent = Math.round(current);
        }
    }, 20);
}

async function apiCall(endpoint, method = 'GET', data = null) {
    const options = {
        method,
        headers: { 'Content-Type': 'application/json' }
    };
    if (authToken) options.headers['Authorization'] = `Bearer ${authToken}`;
    if (data) options.body = JSON.stringify(data);

    try {
        const response = await fetch(`${API_URL}${endpoint}`, options);
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        return await response.json();
    } catch (error) {
        console.warn('API call failed, using demo mode:', error);
        return null;
    }
}

async function loadDashboardStats() {
    const activeDonorsEl = document.getElementById('activeDonors');
    if (!activeDonorsEl) return;
    const stats = await apiCall('/dashboard/stats');
    if (stats) {
        animateCounter(activeDonorsEl, stats.active_donors || 0);
        animateCounter(document.getElementById('bloodUnits'), stats.total_blood_units || 0);
        animateCounter(document.getElementById('availableOrgans'), stats.available_organs || 0);
    } else {
        animateCounter(activeDonorsEl, 1245);
        animateCounter(document.getElementById('bloodUnits'), 3890);
        animateCounter(document.getElementById('availableOrgans'), 47);
    }
}

async function loadBloodInventory() {
    const grid = document.getElementById('bloodInventoryGrid');
    if (!grid) return;
    const inventory = await apiCall('/blood-inventory');
    if (!inventory || inventory.length === 0) {
        const demoInventory = [
            { blood_type: 'O+', component_type: 'Whole Blood', units_available: 60, units_reserved: 8, minimum_threshold: 30 },
            { blood_type: 'A+', component_type: 'Whole Blood', units_available: 45, units_reserved: 5, minimum_threshold: 20 },
            { blood_type: 'B+', component_type: 'Whole Blood', units_available: 35, units_reserved: 3, minimum_threshold: 20 },
            { blood_type: 'O-', component_type: 'RBC', units_available: 45, units_reserved: 8, minimum_threshold: 25 },
            { blood_type: 'AB+', component_type: 'Plasma', units_available: 30, units_reserved: 2, minimum_threshold: 15 },
            { blood_type: 'A+', component_type: 'Platelets', units_available: 25, units_reserved: 3, minimum_threshold: 15 }
        ];
        renderInventoryCards(demoInventory, grid);
    } else {
        renderInventoryCards(inventory, grid);
    }
}

function renderInventoryCards(inventory, grid) {
    grid.innerHTML = inventory.map(item => {
        const percentage = (item.units_available / item.minimum_threshold) * 100;
        const progressBarWidth = Math.min(percentage, 100); // Only cap progress bar at 100%
        const statusClass = percentage > 100 ? 'success' : percentage > 50 ? 'warning' : 'danger';
        const statusText = percentage > 100 ? 'Well Stocked' : percentage > 50 ? 'Adequate' : 'Critical';
        return `
            <div class="card">
                <h3 style="color: var(--primary-red); margin-bottom: 1rem;">${item.blood_type} - ${item.component_type}</h3>
                <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                    <span>Available:</span>
                    <strong style="color: var(--text-primary);">${item.units_available} units</strong>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                    <span>Reserved:</span>
                    <span>${item.units_reserved} units</span>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 1rem;">
                    <span>Threshold:</span>
                    <span>${item.minimum_threshold} units</span>
                </div>
                <div class="progress-bar" style="background: rgba(255,255,255,0.1); height: 8px; border-radius: 4px; overflow: hidden;">
                    <div style="width: ${progressBarWidth}%; height: 100%; background: var(--gradient-${statusClass === 'success' ? 'secondary' : 'primary'}); transition: width 0.5s ease;"></div>
                </div>
                <span class="badge badge-${statusClass}" style="margin-top: 1rem;">${statusText} - ${Math.round(percentage)}%</span>
            </div>
        `;
    }).join('');
}

async function loadCampaigns() {
    const grid = document.getElementById('campaignsGrid');
    if (!grid) return;
    const campaigns = await apiCall('/campaigns');
    if (!campaigns || campaigns.length === 0) {
        const demoCampaigns = [
            { campaign_name: 'Winter Blood Drive 2024', campaign_type: 'Blood Drive', start_date: new Date().toISOString(), end_date: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(), location: 'Community Center', target_units: 500, collected_units: 125, description: 'Annual winter blood donation campaign' },
            { campaign_name: 'Emergency O Negative Appeal', campaign_type: 'Emergency Appeal', start_date: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString(), end_date: new Date(Date.now() + 10 * 24 * 60 * 60 * 1000).toISOString(), location: 'Main Blood Bank', target_units: 100, collected_units: 45, description: 'Critical shortage of O negative blood' },
            { campaign_name: 'Organ Donor Awareness Week', campaign_type: 'Awareness Campaign', start_date: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000).toISOString(), end_date: new Date(Date.now() + 9 * 24 * 60 * 60 * 1000).toISOString(), location: 'City Hospital', target_units: 200, collected_units: 78, description: 'Educating community about organ donation' },
            { campaign_name: 'Platelet Donation Drive', campaign_type: 'Platelet Drive', start_date: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString(), end_date: new Date(Date.now() + 12 * 24 * 60 * 60 * 1000).toISOString(), location: 'North Branch Blood Bank', target_units: 150, collected_units: 92, description: 'Special drive for cancer patients needing platelets' },
            { campaign_name: 'Corporate Blood Donation Day', campaign_type: 'Corporate Drive', start_date: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(), end_date: new Date(Date.now() + 8 * 24 * 60 * 60 * 1000).toISOString(), location: 'Tech Park Business Center', target_units: 80, collected_units: 15, description: 'Corporate companies coming together to save lives' },
            { campaign_name: 'Campus Blood Drive', campaign_type: 'Youth Drive', start_date: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString(), end_date: new Date(Date.now() + 20 * 24 * 60 * 60 * 1000).toISOString(), location: 'University Sports Complex', target_units: 300, collected_units: 180, description: 'Students making a difference through blood donation' }
        ];
        renderCampaignCards(demoCampaigns, grid);
    } else {
        renderCampaignCards(campaigns, grid);
    }
}

function renderCampaignCards(campaigns, grid) {
    grid.innerHTML = campaigns.map(campaign => {
        const progress = (campaign.collected_units / campaign.target_units) * 100;
        const startDate = new Date(campaign.start_date).toLocaleDateString();
        const endDate = new Date(campaign.end_date).toLocaleDateString();
        return `
            <div class="card">
                <span class="badge badge-info">${campaign.campaign_type}</span>
                <h3 style="margin: 1rem 0; color: var(--text-primary);">${campaign.campaign_name}</h3>
                <p style="color: var(--text-secondary); margin-bottom: 1rem;">${campaign.description}</p>
                <div style="margin-bottom: 1rem;">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                        <span>Progress:</span>
                        <strong>${campaign.collected_units} / ${campaign.target_units} units</strong>
                    </div>
                    <div class="progress-bar" style="background: rgba(255,255,255,0.1); height: 10px; border-radius: 5px; overflow: hidden;">
                        <div style="width: ${Math.min(progress, 100)}%; height: 100%; background: var(--gradient-primary); transition: width 0.5s ease;"></div>
                    </div>
                </div>
                <div style="display: flex; justify-content: space-between; color: var(--text-secondary); font-size: 0.9rem;">
                    <span>📍 ${campaign.location}</span>
                    <span>📅 ${startDate} - ${endDate}</span>
                </div>
            </div>
        `;
    }).join('');
}

const donorForm = document.getElementById('donorForm');
if (donorForm) {
    donorForm.addEventListener('submit', async (e) => {
        e.preventDefault();

        // Collect form data
        const formData = {
            firstName: document.getElementById('donorFirstName').value,
            lastName: document.getElementById('donorLastName').value,
            email: document.getElementById('donorEmail').value,
            phone: document.getElementById('donorPhone').value,
            password: 'donor' + document.getElementById('donorNationalId').value.slice(-4), // Default password
            role: 'donor'
        };

        try {
            // Register user
            const response = await fetch(`${API_URL}/auth/register`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(formData)
            });

            const data = await response.json();

            if (response.ok) {
                showNotification('✅ Registration successful! Welcome to LifeSaver. Check your email for login details.', 'success');
                donorForm.reset();
                setTimeout(() => window.location.href = 'login.html', 2500);
            } else {
                showNotification(data.error || '❌ Registration failed. Please try again.', 'error');
            }
        } catch (error) {
            console.error('Registration error:', error);
            showNotification('⚠️ Server connection failed. Please try again later.', 'error');
        }
    });
}


const requestForm = document.getElementById('requestForm');
if (requestForm) {
    requestForm.addEventListener('submit', async (e) => {
        e.preventDefault();

        const formData = {
            patientName: document.getElementById('reqPatientName').value,
            hospitalName: document.getElementById('reqHospitalName').value,
            email: document.getElementById('reqEmail').value,
            phone: document.getElementById('reqPhone').value,
            requestType: document.getElementById('reqType').value,
            bloodType: document.getElementById('reqBloodType')?.value || '',
            organType: document.getElementById('reqOrganType')?.value || '',
            urgencyLevel: document.getElementById('reqUrgency').value,
            medicalReason: document.getElementById('reqReason').value
        };

        try {
            // TODO: Connect to backend /api/transplant-requests or /api/blood-requests endpoint
            // For now, show success message
            await new Promise(resolve => setTimeout(resolve, 1000));
            showNotification('✅ Request submitted successfully! We will contact you soon.', 'success');
            requestForm.reset();
            setTimeout(() => window.location.href = 'index.html', 2000);
        } catch (error) {
            console.error('Request submission error:', error);
            showNotification('⚠️ Failed to submit request. Please try again.', 'error');
        }
    });
}

document.addEventListener('DOMContentLoaded', () => {
    try {
        loadDashboardStats();
        loadBloodInventory();
        loadCampaigns();

        const loginBtn = document.getElementById('loginBtn');
        const registerBtn = document.getElementById('registerBtn');
        const logoutBtn = document.getElementById('logoutBtn');

        if (authToken && currentUser) {
            if (loginBtn) loginBtn.classList.add('hidden');
            if (registerBtn) registerBtn.classList.add('hidden');
            if (logoutBtn) {
                logoutBtn.classList.remove('hidden');
                logoutBtn.addEventListener('click', () => {
                    localStorage.removeItem('authToken');
                    localStorage.removeItem('currentUser');
                    window.location.href = 'index.html';
                });
            }
        } else {
            if (loginBtn) loginBtn.classList.remove('hidden');
            if (registerBtn) registerBtn.classList.remove('hidden');
            if (logoutBtn) logoutBtn.classList.add('hidden');
        }

        const heroDonateBtn = document.getElementById('heroDonateBtn');
        const heroRequestBtn = document.getElementById('heroRequestBtn');
        if (heroDonateBtn) heroDonateBtn.addEventListener('click', () => window.location.href = 'donate.html');
        if (heroRequestBtn) heroRequestBtn.addEventListener('click', () => window.location.href = 'request.html');
    } catch (error) {
        console.error('App initialization error:', error);
    }
});
