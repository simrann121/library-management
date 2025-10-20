// Ares Library Student PWA - Main Application Logic

class AresLibraryApp {
    constructor() {
        this.currentStudent = null;
        this.fcmToken = null;
        this.isOnline = navigator.onLine;
        
        this.init();
    }
    
    async init() {
        // Register service worker
        if ('serviceWorker' in navigator) {
            try {
                await navigator.serviceWorker.register('/sw.js');
                console.log('Service Worker registered successfully');
            } catch (error) {
                console.error('Service Worker registration failed:', error);
            }
        }
        
        // Check if student is already logged in
        this.checkExistingLogin();
        
        // Set up event listeners
        this.setupEventListeners();
        
        // Set up Firebase messaging
        await this.setupFirebaseMessaging();
        
        // Set up online/offline detection
        this.setupOnlineDetection();
        
        // Handle URL parameters
        this.handleURLParameters();
    }
    
    checkExistingLogin() {
        const savedStudent = localStorage.getItem('ares_student');
        if (savedStudent) {
            try {
                this.currentStudent = JSON.parse(savedStudent);
                this.showDashboard();
                this.loadStudentData();
            } catch (error) {
                console.error('Error parsing saved student data:', error);
                localStorage.removeItem('ares_student');
            }
        }
    }
    
    setupEventListeners() {
        // Login form
        document.getElementById('login-form').addEventListener('submit', (e) => {
            e.preventDefault();
            this.handleLogin();
        });
        
        // Logout button
        document.getElementById('logout-btn').addEventListener('click', () => {
            this.handleLogout();
        });
        
        // Check status button
        document.getElementById('check-status-btn').addEventListener('click', () => {
            this.checkLibraryStatus();
        });
        
        // Submit reason button
        document.getElementById('submit-reason-btn').addEventListener('click', () => {
            this.showReasonForm();
        });
        
        // Reason form
        document.getElementById('reason-form').addEventListener('submit', (e) => {
            e.preventDefault();
            this.submitReason();
        });
        
        // Cancel reason button
        document.getElementById('cancel-reason-btn').addEventListener('click', () => {
            this.hideReasonForm();
        });
        
        // Visit reason dropdown change
        document.getElementById('visit-reason').addEventListener('change', (e) => {
            const otherGroup = document.getElementById('other-reason-group');
            if (e.target.value === 'Other') {
                otherGroup.style.display = 'block';
            } else {
                otherGroup.style.display = 'none';
            }
        });
    }
    
    async setupFirebaseMessaging() {
        if (!window.firebase || !window.firebase.messaging) {
            console.warn('Firebase messaging not available');
            return;
        }
        
        try {
            // Request notification permission
            const permission = await Notification.requestPermission();
            if (permission === 'granted') {
                // Get FCM token
                this.fcmToken = await window.firebase.getToken(window.firebase.messaging, {
                    vapidKey: 'your-vapid-key-here' // Replace with your VAPID key
                });
                
                console.log('FCM Token:', this.fcmToken);
                
                // Save token to Firebase if student is logged in
                if (this.currentStudent) {
                    await this.updateFCMToken();
                }
                
                // Listen for foreground messages
                window.firebase.onMessage(window.firebase.messaging, (payload) => {
                    console.log('Message received:', payload);
                    this.handleNotification(payload);
                });
            } else {
                console.log('Notification permission denied');
            }
        } catch (error) {
            console.error('Error setting up Firebase messaging:', error);
        }
    }
    
    setupOnlineDetection() {
        window.addEventListener('online', () => {
            this.isOnline = true;
            this.showToast('Connection restored', 'success');
            this.syncOfflineData();
        });
        
        window.addEventListener('offline', () => {
            this.isOnline = false;
            this.showToast('You are offline. Some features may be limited.', 'warning');
        });
    }
    
    handleURLParameters() {
        const urlParams = new URLSearchParams(window.location.search);
        const action = urlParams.get('action');
        const logId = urlParams.get('logId');
        
        if (action === 'reason' && logId) {
            this.showReasonForm(logId);
        } else if (action === 'status') {
            this.checkLibraryStatus();
        }
    }
    
    async handleLogin() {
        const form = document.getElementById('login-form');
        const formData = new FormData(form);
        
        const studentId = formData.get('studentId').trim();
        const studentName = formData.get('studentName').trim();
        
        if (!studentId || !studentName) {
            this.showToast('Please fill in all fields', 'error');
            return;
        }
        
        // Show loading state
        const submitBtn = form.querySelector('button[type="submit"]');
        submitBtn.classList.add('loading');
        
        try {
            // Save student data locally
            this.currentStudent = {
                id: studentId,
                name: studentName,
                loginTime: Date.now()
            };
            
            localStorage.setItem('ares_student', JSON.stringify(this.currentStudent));
            
            // Update Firebase with student data
            await this.updateStudentData();
            
            // Update FCM token
            if (this.fcmToken) {
                await this.updateFCMToken();
            }
            
            this.showDashboard();
            this.showToast(`Welcome, ${studentName}!`, 'success');
            
        } catch (error) {
            console.error('Login error:', error);
            this.showToast('Login failed. Please try again.', 'error');
        } finally {
            submitBtn.classList.remove('loading');
        }
    }
    
    async updateStudentData() {
        if (!this.currentStudent || !this.isOnline) return;
        
        try {
            const studentRef = window.firebase.ref(window.firebase.database, `students/${this.currentStudent.id}`);
            await window.firebase.set(studentRef, {
                name: this.currentStudent.name,
                lastLogin: Date.now(),
                fcmToken: this.fcmToken || null
            });
        } catch (error) {
            console.error('Error updating student data:', error);
        }
    }
    
    async updateFCMToken() {
        if (!this.currentStudent || !this.fcmToken || !this.isOnline) return;
        
        try {
            const studentRef = window.firebase.ref(window.firebase.database, `students/${this.currentStudent.id}/fcmToken`);
            await window.firebase.set(studentRef, this.fcmToken);
        } catch (error) {
            console.error('Error updating FCM token:', error);
        }
    }
    
    showDashboard() {
        document.getElementById('login-section').style.display = 'none';
        document.getElementById('dashboard-section').style.display = 'block';
        document.getElementById('student-name-display').textContent = this.currentStudent.name;
        
        this.loadStudentData();
    }
    
    async loadStudentData() {
        if (!this.currentStudent || !this.isOnline) return;
        
        try {
            // Load student's visit history
            const logsRef = window.firebase.ref(window.firebase.database, 'library_logs');
            const snapshot = await window.firebase.get(logsRef);
            
            if (snapshot.exists()) {
                const logs = snapshot.val();
                const studentLogs = Object.values(logs).filter(log => 
                    log.studentID === this.currentStudent.id
                );
                
                // Update total visits
                document.getElementById('total-visits').textContent = studentLogs.length;
                
                // Check current status
                const currentLog = studentLogs.find(log => log.status === 'IN' && !log.outTime);
                if (currentLog) {
                    document.getElementById('current-status').textContent = 'Inside';
                    document.getElementById('current-status').className = 'status-badge inside';
                    document.getElementById('status-message').textContent = 'You are currently in the library';
                    document.getElementById('submit-reason-btn').style.display = 'inline-block';
                } else {
                    document.getElementById('current-status').textContent = 'Outside';
                    document.getElementById('current-status').className = 'status-badge outside';
                    document.getElementById('status-message').textContent = 'You are not currently in the library';
                    document.getElementById('submit-reason-btn').style.display = 'none';
                }
            }
            
            // Load current occupancy
            this.loadCurrentOccupancy();
            
        } catch (error) {
            console.error('Error loading student data:', error);
        }
    }
    
    async loadCurrentOccupancy() {
        if (!this.isOnline) return;
        
        try {
            const statsRef = window.firebase.ref(window.firebase.database, 'live_stats/currentOccupancy');
            window.firebase.onValue(statsRef, (snapshot) => {
                if (snapshot.exists()) {
                    document.getElementById('current-occupancy').textContent = snapshot.val();
                }
            });
        } catch (error) {
            console.error('Error loading occupancy:', error);
        }
    }
    
    async checkLibraryStatus() {
        if (!this.isOnline) {
            this.showToast('Please check your internet connection', 'error');
            return;
        }
        
        await this.loadStudentData();
        this.showToast('Library status updated', 'success');
    }
    
    showReasonForm(logId = null) {
        document.getElementById('dashboard-section').style.display = 'none';
        document.getElementById('notification-section').style.display = 'block';
        
        if (logId) {
            // Store logId for submission
            document.getElementById('reason-form').dataset.logId = logId;
        }
    }
    
    hideReasonForm() {
        document.getElementById('notification-section').style.display = 'none';
        document.getElementById('dashboard-section').style.display = 'block';
        
        // Reset form
        document.getElementById('reason-form').reset();
        document.getElementById('other-reason-group').style.display = 'none';
    }
    
    async submitReason() {
        const form = document.getElementById('reason-form');
        const formData = new FormData(form);
        const reason = formData.get('reason');
        const otherReason = formData.get('otherReason');
        const logId = form.dataset.logId;
        
        if (!reason) {
            this.showToast('Please select a reason for your visit', 'error');
            return;
        }
        
        const finalReason = reason === 'Other' ? otherReason : reason;
        
        if (!finalReason) {
            this.showToast('Please specify your reason', 'error');
            return;
        }
        
        try {
            if (this.isOnline) {
                // Update Firebase directly
                const logRef = window.firebase.ref(window.firebase.database, `library_logs/${logId}/reason`);
                await window.firebase.set(logRef, finalReason);
                
                this.showToast('Reason submitted successfully!', 'success');
            } else {
                // Store offline for later sync
                this.storeOfflineReason(logId, finalReason);
                this.showToast('Reason saved offline. Will sync when online.', 'warning');
            }
            
            this.hideReasonForm();
            
        } catch (error) {
            console.error('Error submitting reason:', error);
            this.showToast('Failed to submit reason. Please try again.', 'error');
        }
    }
    
    storeOfflineReason(logId, reason) {
        const offlineData = JSON.parse(localStorage.getItem('ares_offline') || '{}');
        offlineData.reasons = offlineData.reasons || [];
        offlineData.reasons.push({ logId, reason, timestamp: Date.now() });
        localStorage.setItem('ares_offline', JSON.stringify(offlineData));
    }
    
    async syncOfflineData() {
        const offlineData = JSON.parse(localStorage.getItem('ares_offline') || '{}');
        
        if (offlineData.reasons && offlineData.reasons.length > 0) {
            try {
                for (const item of offlineData.reasons) {
                    const logRef = window.firebase.ref(window.firebase.database, `library_logs/${item.logId}/reason`);
                    await window.firebase.set(logRef, item.reason);
                }
                
                // Clear synced data
                offlineData.reasons = [];
                localStorage.setItem('ares_offline', JSON.stringify(offlineData));
                
                this.showToast('Offline data synced successfully', 'success');
            } catch (error) {
                console.error('Error syncing offline data:', error);
            }
        }
    }
    
    handleNotification(payload) {
        console.log('Handling notification:', payload);
        
        if (payload.data && payload.data.action === 'submit_reason') {
            this.showReasonForm(payload.data.logId);
        }
    }
    
    handleLogout() {
        if (confirm('Are you sure you want to logout?')) {
            localStorage.removeItem('ares_student');
            this.currentStudent = null;
            
            document.getElementById('dashboard-section').style.display = 'none';
            document.getElementById('login-section').style.display = 'block';
            
            this.showToast('Logged out successfully', 'success');
        }
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

// Initialize the app when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new AresLibraryApp();
});
