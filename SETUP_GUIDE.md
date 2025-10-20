# Ares Library Management System - Complete Setup Guide

## 🚀 Project Overview

The Ares Library Management System is a comprehensive, cloud-native solution for managing library access with real-time analytics. The system consists of four main components:

1. **Firebase Backend** - Cloud database and functions
2. **Student PWA** - Progressive Web App for students
3. **ESP32 Hardware** - Physical scanner and door control
4. **Faculty Dashboard** - Analytics and monitoring interface

## 📋 Prerequisites

### Software Requirements
- Node.js 18+ and npm
- Arduino IDE 2.0+
- Firebase CLI
- Git

### Hardware Requirements
- ESP32 Dev Board
- Barcode Scanner (USB or Serial)
- HC-SR04 Ultrasonic Sensor
- Buzzer
- LED Status Indicator
- Push Button
- Door Sensor (optional)

### Firebase Account
- Google account with Firebase access
- Firebase project with Blaze plan (for Cloud Functions)

## 🔧 Phase 1: Firebase Backend Setup

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `ares-library-management`
4. Enable Google Analytics (optional)
5. Create project

### Step 2: Enable Required Services

1. **Realtime Database**
   - Go to "Realtime Database" in Firebase Console
   - Click "Create Database"
   - Choose "Start in test mode"
   - Select a location (choose closest to your region)

2. **Authentication**
   - Go to "Authentication" > "Sign-in method"
   - Enable "Custom" provider

3. **Cloud Functions**
   - Go to "Functions" in Firebase Console
   - Click "Get started"
   - Follow the setup instructions

### Step 3: Configure Firebase CLI

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize project
firebase init
```

Select the following options:
- ✅ Realtime Database
- ✅ Functions
- ✅ Hosting (optional)

### Step 4: Deploy Database Rules

```bash
# Copy the database rules
cp backend/database-rules.json firebase-database-rules.json

# Deploy rules
firebase deploy --only database
```

### Step 5: Deploy Cloud Functions

```bash
# Navigate to functions directory
cd backend/functions

# Install dependencies
npm install

# Deploy functions
firebase deploy --only functions
```

## 📱 Phase 2: Student PWA Setup

### Step 1: Configure Firebase

1. In Firebase Console, go to Project Settings
2. Add a web app
3. Copy the Firebase configuration
4. Update `student-app/index.html` with your config:

```javascript
const firebaseConfig = {
  apiKey: "your-actual-api-key",
  authDomain: "your-project.firebaseapp.com",
  databaseURL: "https://your-project-default-rtdb.firebaseio.com",
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "your-app-id"
};
```

### Step 2: Configure FCM

1. In Firebase Console, go to Project Settings > Cloud Messaging
2. Generate a Web Push certificate
3. Copy the VAPID key
4. Update `student-app/assets/app.js`:

```javascript
this.fcmToken = await window.firebase.getToken(window.firebase.messaging, {
    vapidKey: 'your-vapid-key-here'
});
```

### Step 3: Deploy PWA

```bash
# Option 1: Firebase Hosting
firebase deploy --only hosting

# Option 2: Any web server
# Copy student-app/ contents to your web server
```

## 🔌 Phase 3: ESP32 Hardware Setup

### Step 1: Install Arduino Libraries

Open Arduino IDE and install these libraries via Library Manager:

1. **Firebase ESP32 Client** by Mobizt
2. **ArduinoJson** by Benoit Blanchon
3. **NewPing** by Tim Eckel (optional)

### Step 2: Configure ESP32 Code

1. Open `esp32/ares_scanner.ino`
2. Update WiFi credentials:

```cpp
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";
```

3. Update Firebase configuration:

```cpp
#define FIREBASE_HOST "your-project-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "your-firebase-auth-token"
```

### Step 3: Hardware Connections

| Component | ESP32 Pin | Notes |
|-----------|-----------|-------|
| Scanner RX | GPIO 16 | SoftwareSerial |
| Scanner TX | GPIO 17 | SoftwareSerial |
| Ultrasonic Trig | GPIO 18 | HC-SR04 |
| Ultrasonic Echo | GPIO 19 | HC-SR04 |
| Buzzer | GPIO 21 | Active buzzer |
| Status LED | GPIO 22 | RGB or single LED |
| Sync Button | GPIO 23 | With pullup |
| Door Sensor | GPIO 25 | Optional |

### Step 4: Upload Code

1. Select Board: "ESP32 Dev Module"
2. Set Upload Speed: 115200
3. Set CPU Frequency: 240MHz
4. Upload the code

## 📊 Phase 4: Faculty Dashboard Setup

### Step 1: Configure Firebase

1. Use the same Firebase configuration as the PWA
2. Update `faculty-dashboard/index.html` with your config

### Step 2: Deploy Dashboard

```bash
# Copy faculty-dashboard/ to your web server
# Or use Firebase Hosting
firebase deploy --only hosting
```

### Step 3: Configure Faculty Access

1. Update Cloud Functions with valid faculty credentials
2. Modify `backend/functions/index.js`:

```javascript
const validFaculty = {
    'faculty_001': 'your-secure-password',
    'faculty_002': 'another-secure-password'
};
```

## 🔐 Security Configuration

### Step 1: Update Database Rules

1. Go to Firebase Console > Realtime Database > Rules
2. Replace with the rules from `backend/database-rules.json`
3. Customize based on your security requirements

### Step 2: Configure Authentication

1. Set up proper authentication tokens for ESP32
2. Implement faculty authentication
3. Configure CORS for web applications

### Step 3: Environment Variables

Create a `.env` file for sensitive data:

```env
FIREBASE_API_KEY=your-api-key
FIREBASE_AUTH_DOMAIN=your-domain
FIREBASE_DATABASE_URL=your-database-url
FIREBASE_PROJECT_ID=your-project-id
ESP32_DEVICE_SECRET=your-device-secret
FACULTY_PASSWORD=your-faculty-password
```

## 🧪 Testing the System

### Step 1: Test Firebase Connection

1. Check Firebase Console for data
2. Verify Cloud Functions are deployed
3. Test database rules

### Step 2: Test Student PWA

1. Open PWA in browser
2. Login with test student ID
3. Check Firebase for student data
4. Test offline functionality

### Step 3: Test ESP32

1. Upload code to ESP32
2. Check serial monitor for connection status
3. Test barcode scanning
4. Verify Firebase data updates

### Step 4: Test Faculty Dashboard

1. Login with faculty credentials
2. Verify real-time data updates
3. Check analytics charts
4. Test all dashboard features

## 🚀 Deployment Checklist

### Firebase Backend
- [ ] Firebase project created
- [ ] Realtime Database configured
- [ ] Cloud Functions deployed
- [ ] Database rules applied
- [ ] Authentication configured

### Student PWA
- [ ] Firebase config updated
- [ ] FCM configured
- [ ] PWA deployed
- [ ] Offline functionality tested
- [ ] Push notifications working

### ESP32 Hardware
- [ ] Libraries installed
- [ ] WiFi credentials set
- [ ] Firebase config updated
- [ ] Hardware connected
- [ ] Code uploaded
- [ ] Offline queue working

### Faculty Dashboard
- [ ] Firebase config updated
- [ ] Dashboard deployed
- [ ] Authentication working
- [ ] Real-time updates working
- [ ] Analytics displaying correctly

## 🔧 Troubleshooting

### Common Issues

1. **WiFi Connection Failed**
   - Check SSID and password
   - Verify signal strength
   - Check ESP32 WiFi antenna

2. **Firebase Connection Failed**
   - Verify Firebase host URL
   - Check authentication token
   - Ensure database rules allow access

3. **PWA Not Working**
   - Check Firebase configuration
   - Verify service worker registration
   - Check browser console for errors

4. **Push Notifications Not Working**
   - Verify VAPID key
   - Check notification permissions
   - Ensure FCM token is generated

5. **ESP32 Offline Queue Issues**
   - Check SPIFFS partition
   - Verify queue size limits
   - Check serial monitor for errors

### Debug Tips

1. Enable serial output at 115200 baud
2. Check Firebase Console for data
3. Use browser developer tools
4. Monitor network requests
5. Check Firebase Functions logs

## 📈 Performance Optimization

### Database Optimization
- Implement proper indexing
- Use pagination for large datasets
- Optimize query patterns
- Monitor database usage

### PWA Optimization
- Implement service worker caching
- Optimize bundle sizes
- Use lazy loading
- Implement offline-first design

### ESP32 Optimization
- Optimize memory usage
- Implement efficient queue management
- Use FreeRTOS tasks
- Monitor stack usage

## 🔄 Maintenance

### Regular Tasks
- Monitor Firebase usage and costs
- Update dependencies
- Check hardware status
- Review security logs
- Backup database

### Updates
- Keep Firebase SDK updated
- Update ESP32 libraries
- Monitor security patches
- Test new features

## 📞 Support

For issues and questions:
1. Check this documentation
2. Review Firebase documentation
3. Check ESP32 forums
4. Create GitHub issues

## 🎉 Success!

Once all components are deployed and tested, you'll have a fully functional Smart Library Access System with:

- ✅ Real-time library occupancy tracking
- ✅ Student mobile app with push notifications
- ✅ Offline-capable hardware scanner
- ✅ Faculty analytics dashboard
- ✅ Automated notifications
- ✅ Comprehensive logging and analytics

The system is now ready for production use!
