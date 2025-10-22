// Faculty Dashboard Application Logic

class FacultyDashboard {
    constructor() {
        this.isAuthenticated = false;
        this.charts = {};
        this.data = {
            currentOccupancy: 0,
            totalVisitsToday: 0,
            avgDuration: 0,
            peakHour: '--:--',
            visitors: [],
            activity: [],
            hourlyData: {},
            reasonsData: {},
            trendsData: {}
        };
        
        this.init();
    }
    
    async init() {
        // Check for existing authentication
        this.checkExistingAuth();
        
        // Set up event listeners
        this.setupEventListeners();
        
        // Initialize charts
        this.initializeCharts();
        
        // Start data updates
        this.startDataUpdates();
    }
    
    checkExistingAuth() {
        const savedAuth = localStorage.getItem('ares_faculty_auth');
        if (savedAuth) {
            try {
                const authData = JSON.parse(savedAuth);
                if (authData.token && authData.expires > Date.now()) {
                    this.authenticateWithToken(authData.token);
                } else {
                    localStorage.removeItem('ares_faculty_auth');
                }
            } catch (error) {
                console.error('Error parsing saved auth:', error);
                localStorage.removeItem('ares_faculty_auth');
            }
        }
    }
    
    setupEventListeners() {
        // Login form
        document.getElementById('faculty-login-form').addEventListener('submit', (e) => {
            e.preventDefault();
            this.handleLogin();
        });
        
        // Logout button
        document.getElementById('logout-btn').addEventListener('click', () => {
            this.handleLogout();
        });
        
        // Refresh button
        document.getElementById('refresh-btn').addEventListener('click', () => {
            this.refreshData();
        });
    }
    
    async handleLogin() {
        const form = document.getElementById('faculty-login-form');
        const formData = new FormData(form);
        
        const facultyId = formData.get('facultyId').trim();
        const password = formData.get('password').trim();
        
        if (!facultyId || !password) {
            this.showToast('Please fill in all fields', 'error');
            return;
        }
        
        // Show loading state
        const submitBtn = form.querySelector('button[type="submit"]');
        submitBtn.classList.add('loading');
        
        try {
            // Call Firebase function to generate faculty token
            const response = await fetch('https://us-central1-ares-library-management.cloudfunctions.net/generateFacultyToken', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    facultyId: facultyId,
                    password: password
                })
            });
            
            const result = await response.json();
            
            if (result.success && result.token) {
                await this.authenticateWithToken(result.token);
                this.showToast('Login successful!', 'success');
            } else {
                throw new Error('Invalid credentials');
            }
            
        } catch (error) {
            console.error('Login error:', error);
            this.showToast('Login failed. Please check your credentials.', 'error');
        } finally {
            submitBtn.classList.remove('loading');
        }
    }
    
    async authenticateWithToken(token) {
        try {
            await window.firebase.signInWithCustomToken(window.firebase.auth, token);
            this.isAuthenticated = true;
            
            // Save auth data
            const authData = {
                token: token,
                expires: Date.now() + (24 * 60 * 60 * 1000) // 24 hours
            };
            localStorage.setItem('ares_faculty_auth', JSON.stringify(authData));
            
            // Show dashboard
            this.showDashboard();
            
        } catch (error) {
            console.error('Authentication error:', error);
            this.showToast('Authentication failed', 'error');
        }
    }
    
    showDashboard() {
        document.getElementById('login-modal').style.display = 'none';
        document.getElementById('dashboard').style.display = 'block';
        
        // Start real-time data updates
        this.startRealTimeUpdates();
    }
    
    handleLogout() {
        if (confirm('Are you sure you want to logout?')) {
            localStorage.removeItem('ares_faculty_auth');
            this.isAuthenticated = false;
            
            document.getElementById('dashboard').style.display = 'none';
            document.getElementById('login-modal').style.display = 'flex';
            
            this.showToast('Logged out successfully', 'success');
        }
    }
    
    initializeCharts() {
        // Hourly Occupancy Chart
        const occupancyCtx = document.getElementById('occupancy-chart').getContext('2d');
        this.charts.occupancy = new Chart(occupancyCtx, {
            type: 'line',
            data: {
                labels: Array.from({length: 24}, (_, i) => `${i}:00`),
                datasets: [{
                    label: 'Occupancy',
                    data: Array(24).fill(0),
                    borderColor: '#2563eb',
                    backgroundColor: 'rgba(37, 99, 235, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                }
            }
        });
        
        // Visit Reasons Chart
        const reasonsCtx = document.getElementById('reasons-chart').getContext('2d');
        this.charts.reasons = new Chart(reasonsCtx, {
            type: 'doughnut',
            data: {
                labels: [],
                datasets: [{
                    data: [],
                    backgroundColor: [
                        '#2563eb',
                        '#059669',
                        '#d97706',
                        '#dc2626',
                        '#0891b2',
                        '#7c3aed',
                        '#ea580c'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
        
        // Daily Trends Chart
        const trendsCtx = document.getElementById('trends-chart').getContext('2d');
        this.charts.trends = new Chart(trendsCtx, {
            type: 'bar',
            data: {
                labels: [],
                datasets: [{
                    label: 'Visits',
                    data: [],
                    backgroundColor: '#2563eb',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
        
        // Student Activity Chart
        const activityCtx = document.getElementById('activity-chart').getContext('2d');
        this.charts.activity = new Chart(activityCtx, {
            type: 'line',
            data: {
                labels: [],
                datasets: [{
                    label: 'Entries',
                    data: [],
                    borderColor: '#059669',
                    backgroundColor: 'rgba(5, 150, 105, 0.1)',
                    tension: 0.4
                }, {
                    label: 'Exits',
                    data: [],
                    borderColor: '#dc2626',
                    backgroundColor: 'rgba(220, 38, 38, 0.1)',
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }
    
    startRealTimeUpdates() {
        // Listen to live stats
        const statsRef = window.firebase.ref(window.firebase.database, 'live_stats');
        window.firebase.onValue(statsRef, (snapshot) => {
            if (snapshot.exists()) {
                const stats = snapshot.val();
                this.updateLiveStats(stats);
            }
        });
        
        // Listen to library logs
        const logsRef = window.firebase.ref(window.firebase.database, 'library_logs');
        window.firebase.onValue(logsRef, (snapshot) => {
            if (snapshot.exists()) {
                const logs = snapshot.val();
                this.processLogsData(logs);
            }
        });
        
        // Listen to students data
        const studentsRef = window.firebase.ref(window.firebase.database, 'students');
        window.firebase.onValue(studentsRef, (snapshot) => {
            if (snapshot.exists()) {
                const students = snapshot.val();
                this.processStudentsData(students);
            }
        });
    }
    
    updateLiveStats(stats) {
        this.data.currentOccupancy = stats.currentOccupancy || 0;
        document.getElementById('current-occupancy').textContent = this.data.currentOccupancy;
        
        // Update occupancy change
        const changeElement = document.getElementById('occupancy-change');
        const previousOccupancy = parseInt(changeElement.dataset.previous || '0');
        const change = this.data.currentOccupancy - previousOccupancy;
        
        if (change > 0) {
            changeElement.textContent = `+${change}`;
            changeElement.className = 'stat-change positive';
        } else if (change < 0) {
            changeElement.textContent = change.toString();
            changeElement.className = 'stat-change negative';
        } else {
            changeElement.textContent = '+0';
            changeElement.className = 'stat-change neutral';
        }
        
        changeElement.dataset.previous = this.data.currentOccupancy;
    }
    
    processLogsData(logs) {
        const logsArray = Object.values(logs);
        const today = new Date().toDateString();
        
        // Calculate total visits today
        const todayLogs = logsArray.filter(log => {
            const logDate = new Date(log.inTime).toDateString();
            return logDate === today;
        });
        
        this.data.totalVisitsToday = todayLogs.length;
        document.getElementById('total-visits-today').textContent = this.data.totalVisitsToday;
        
        // Calculate average duration
        const completedVisits = todayLogs.filter(log => log.outTime && log.status === 'OUT');
        if (completedVisits.length > 0) {
            const totalDuration = completedVisits.reduce((sum, log) => {
                return sum + (log.outTime - log.inTime);
            }, 0);
            const avgDurationMs = totalDuration / completedVisits.length;
            const avgDurationMin = Math.round(avgDurationMs / (1000 * 60));
            
            this.data.avgDuration = avgDurationMin;
            document.getElementById('avg-duration').textContent = `${avgDurationMin}m`;
        }
        
        // Calculate peak hour
        const hourlyCounts = {};
        todayLogs.forEach(log => {
            const hour = new Date(log.inTime).getHours();
            hourlyCounts[hour] = (hourlyCounts[hour] || 0) + 1;
        });
        
        const peakHour = Object.keys(hourlyCounts).reduce((a, b) => 
            hourlyCounts[a] > hourlyCounts[b] ? a : b
        );
        
        if (peakHour) {
            this.data.peakHour = `${peakHour}:00`;
            document.getElementById('peak-hour').textContent = this.data.peakHour;
        }
        
        // Update hourly occupancy chart
        this.updateHourlyChart(hourlyCounts);
        
        // Process reasons data
        this.processReasonsData(todayLogs);
        
        // Update current visitors
        this.updateCurrentVisitors(logsArray);
        
        // Update recent activity
        this.updateRecentActivity(logsArray);
        
        // Update trends chart
        this.updateTrendsChart(logsArray);
        
        // Update activity chart
        this.updateActivityChart(logsArray);
    }
    
    processStudentsData(students) {
        // This could be used for additional student analytics
        console.log('Students data updated:', Object.keys(students).length);
    }
    
    updateHourlyChart(hourlyCounts) {
        const data = Array.from({length: 24}, (_, i) => hourlyCounts[i] || 0);
        this.charts.occupancy.data.datasets[0].data = data;
        this.charts.occupancy.update();
    }
    
    processReasonsData(logs) {
        const reasonsCount = {};
        logs.forEach(log => {
            if (log.reason) {
                reasonsCount[log.reason] = (reasonsCount[log.reason] || 0) + 1;
            }
        });
        
        const labels = Object.keys(reasonsCount);
        const data = Object.values(reasonsCount);
        
        this.charts.reasons.data.labels = labels;
        this.charts.reasons.data.datasets[0].data = data;
        this.charts.reasons.update();
    }
    
    updateCurrentVisitors(logs) {
        const currentVisitors = logs.filter(log => 
            log.status === 'IN' && !log.outTime
        );
        
        this.data.visitors = currentVisitors;
        
        const visitorsList = document.getElementById('visitors-list');
        visitorsList.innerHTML = '';
        
        if (currentVisitors.length === 0) {
            visitorsList.innerHTML = '<div class="loading">No current visitors</div>';
            return;
        }
        
        currentVisitors.forEach(visitor => {
            const visitorItem = document.createElement('div');
            visitorItem.className = 'visitor-item';
            
            const entryTime = new Date(visitor.inTime);
            const duration = Math.floor((Date.now() - visitor.inTime) / (1000 * 60));
            
            visitorItem.innerHTML = `
                <div class="visitor-info">
                    <h4>Student ${visitor.studentID}</h4>
                    <p>Entered at ${entryTime.toLocaleTimeString()}</p>
                </div>
                <div class="visitor-status">
                    <div class="status-dot"></div>
                    <span>${duration}m</span>
                </div>
            `;
            
            visitorsList.appendChild(visitorItem);
        });
    }
    
    updateRecentActivity(logs) {
        // Get recent logs (last 20)
        const recentLogs = logs
            .sort((a, b) => b.inTime - a.inTime)
            .slice(0, 20);
        
        this.data.activity = recentLogs;
        
        const activityList = document.getElementById('activity-list');
        activityList.innerHTML = '';
        
        recentLogs.forEach(log => {
            const activityItem = document.createElement('div');
            activityItem.className = 'activity-item';
            
            const isEntry = log.status === 'IN';
            const isAlarm = log.studentID === 'ALARM';
            
            let iconClass = 'entry';
            let iconText = '📚';
            let title = `Student ${log.studentID}`;
            let description = isEntry ? 'Entered library' : 'Left library';
            
            if (isAlarm) {
                iconClass = 'alarm';
                iconText = '🚨';
                title = 'Security Alert';
                description = 'Unauthorized door access detected';
            } else if (!isEntry) {
                iconClass = 'exit';
                iconText = '🚪';
            }
            
            const time = new Date(log.inTime);
            
            activityItem.innerHTML = `
                <div class="activity-icon ${iconClass}">${iconText}</div>
                <div class="activity-content">
                    <h4>${title}</h4>
                    <p>${description}</p>
                </div>
                <div class="activity-time">${time.toLocaleTimeString()}</div>
            `;
            
            activityList.appendChild(activityItem);
        });
    }
    
    updateTrendsChart(logs) {
        // Group logs by date for the last 7 days
        const last7Days = [];
        const today = new Date();
        
        for (let i = 6; i >= 0; i--) {
            const date = new Date(today);
            date.setDate(date.getDate() - i);
            last7Days.push(date.toDateString());
        }
        
        const dailyCounts = {};
        last7Days.forEach(date => {
            dailyCounts[date] = 0;
        });
        
        logs.forEach(log => {
            const logDate = new Date(log.inTime).toDateString();
            if (dailyCounts.hasOwnProperty(logDate)) {
                dailyCounts[logDate]++;
            }
        });
        
        const labels = last7Days.map(date => {
            const d = new Date(date);
            return `${d.getMonth() + 1}/${d.getDate()}`;
        });
        const data = last7Days.map(date => dailyCounts[date]);
        
        this.charts.trends.data.labels = labels;
        this.charts.trends.data.datasets[0].data = data;
        this.charts.trends.update();
    }
    
    updateActivityChart(logs) {
        // Group logs by hour for today
        const hourlyEntries = Array(24).fill(0);
        const hourlyExits = Array(24).fill(0);
        
        const today = new Date().toDateString();
        logs.forEach(log => {
            const logDate = new Date(log.inTime).toDateString();
            if (logDate === today) {
                const hour = new Date(log.inTime).getHours();
                if (log.status === 'IN') {
                    hourlyEntries[hour]++;
                } else if (log.status === 'OUT') {
                    hourlyExits[hour]++;
                }
            }
        });
        
        const labels = Array.from({length: 24}, (_, i) => `${i}:00`);
        
        this.charts.activity.data.labels = labels;
        this.charts.activity.data.datasets[0].data = hourlyEntries;
        this.charts.activity.data.datasets[1].data = hourlyExits;
        this.charts.activity.update();
    }
    
    refreshData() {
        this.showToast('Refreshing data...', 'info');
        // Data will be refreshed automatically through Firebase listeners
    }
    
    startDataUpdates() {
        // Refresh data every 30 seconds
        setInterval(() => {
            if (this.isAuthenticated) {
                this.refreshData();
            }
        }, 30000);
    }
    
    showToast(message, type = 'info') {
        const toastContainer = document.getElementById('toast-container');
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        toast.textContent = message;
        
        toastContainer.appendChild(toast);
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 5000);
        
        // Click to dismiss
        toast.addEventListener('click', () => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        });
    }
}

// Initialize the dashboard when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new FacultyDashboard();
});
