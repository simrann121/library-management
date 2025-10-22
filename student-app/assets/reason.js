// Reason submission page logic
class ReasonSubmissionApp {
    constructor() {
        this.logId = null;
        this.isOnline = navigator.onLine;
        
        this.init();
    }
    
    init() {
        // Get logId from URL parameters
        const urlParams = new URLSearchParams(window.location.search);
        this.logId = urlParams.get('logId');
        
        if (!this.logId) {
            this.showToast('Invalid link. No log ID provided.', 'error');
            setTimeout(() => {
                window.location.href = '/';
            }, 3000);
            return;
        }
        
        this.setupEventListeners();
        this.setupOnlineDetection();
    }
    
    setupEventListeners() {
        // Reason form submission
        document.getElementById('reason-form').addEventListener('submit', (e) => {
            e.preventDefault();
            this.submitReason();
        });
        
        // Cancel button
        document.getElementById('cancel-reason-btn').addEventListener('click', () => {
            window.location.href = '/';
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
    
    setupOnlineDetection() {
        window.addEventListener('online', () => {
            this.isOnline = true;
            this.showToast('Connection restored', 'success');
        });
        
        window.addEventListener('offline', () => {
            this.isOnline = false;
            this.showToast('You are offline. Reason will be saved locally.', 'warning');
        });
    }
    
    async submitReason() {
        const form = document.getElementById('reason-form');
        const formData = new FormData(form);
        const reason = formData.get('reason');
        const otherReason = formData.get('otherReason');
        
        if (!reason) {
            this.showToast('Please select a reason for your visit', 'error');
            return;
        }
        
        const finalReason = reason === 'Other' ? otherReason : reason;
        
        if (!finalReason) {
            this.showToast('Please specify your reason', 'error');
            return;
        }
        
        // Show loading state
        const submitBtn = form.querySelector('button[type="submit"]');
        const originalText = submitBtn.textContent;
        submitBtn.textContent = 'Submitting...';
        submitBtn.disabled = true;
        
        try {
            if (this.isOnline) {
                // Update Firebase directly
                const logRef = window.firebase.ref(window.firebase.database, `library_logs/${this.logId}/reason`);
                await window.firebase.set(logRef, finalReason);
                
                this.showToast('Reason submitted successfully!', 'success');
                
                // Redirect to main app after success
                setTimeout(() => {
                    window.location.href = '/';
                }, 2000);
                
            } else {
                // Store offline for later sync
                this.storeOfflineReason(finalReason);
                this.showToast('Reason saved offline. Will sync when online.', 'warning');
                
                // Redirect to main app
                setTimeout(() => {
                    window.location.href = '/';
                }, 2000);
            }
            
        } catch (error) {
            console.error('Error submitting reason:', error);
            this.showToast('Failed to submit reason. Please try again.', 'error');
        } finally {
            submitBtn.textContent = originalText;
            submitBtn.disabled = false;
        }
    }
    
    storeOfflineReason(reason) {
        const offlineData = JSON.parse(localStorage.getItem('ares_offline') || '{}');
        offlineData.reasons = offlineData.reasons || [];
        offlineData.reasons.push({ 
            logId: this.logId, 
            reason, 
            timestamp: Date.now() 
        });
        localStorage.setItem('ares_offline', JSON.stringify(offlineData));
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
    new ReasonSubmissionApp();
});
