// Firebase Cloud Functions for Ares Library Management System
// This file should be placed in the functions/ directory of your Firebase project

const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
admin.initializeApp();

const db = admin.database();

// Function to send push notification when student enters library
exports.sendEntryNotification = functions.database.ref('/library_logs/{logId}')
  .onCreate(async (snapshot, context) => {
    const logData = snapshot.val();
    const logId = context.params.logId;
    
    // Only send notification for "IN" status
    if (logData.status !== 'IN') {
      return null;
    }
    
    try {
      // Get student's FCM token
      const studentSnapshot = await db.ref(`/students/${logData.studentID}`).once('value');
      const studentData = studentSnapshot.val();
      
      if (!studentData || !studentData.fcmToken) {
        console.log(`No FCM token found for student ${logData.studentID}`);
        return null;
      }
      
      // Prepare notification payload
      const payload = {
        notification: {
          title: 'Welcome to the Library!',
          body: 'Please submit your reason for visiting.',
          icon: '/assets/icon-192x192.png',
          badge: '/assets/badge-72x72.png'
        },
        data: {
          logId: logId,
          studentID: logData.studentID,
          action: 'submit_reason'
        },
        token: studentData.fcmToken
      };
      
      // Send notification
      const response = await admin.messaging().send(payload);
      console.log('Successfully sent message:', response);
      
      return response;
    } catch (error) {
      console.error('Error sending notification:', error);
      return null;
    }
  });

// Function to update live occupancy stats
exports.updateOccupancyStats = functions.database.ref('/library_logs/{logId}')
  .onWrite(async (change, context) => {
    try {
      // Count current "IN" status logs
      const logsSnapshot = await db.ref('/library_logs').once('value');
      const logs = logsSnapshot.val();
      
      let currentOccupancy = 0;
      if (logs) {
        Object.values(logs).forEach(log => {
          if (log.status === 'IN') {
            currentOccupancy++;
          }
        });
      }
      
      // Update live stats
      await db.ref('/live_stats').update({
        currentOccupancy: currentOccupancy,
        lastUpdated: admin.database.ServerValue.TIMESTAMP
      });
      
      console.log(`Updated occupancy to ${currentOccupancy}`);
      return null;
    } catch (error) {
      console.error('Error updating occupancy stats:', error);
      return null;
    }
  });

// Function to handle ESP32 authentication
exports.authenticateESP32 = functions.https.onCall(async (data, context) => {
  const { deviceId, secretKey } = data;
  
  // Simple authentication - in production, use proper device certificates
  const validDevices = {
    'esp32_scanner_001': 'ares_device_secret_2024',
    'esp32_scanner_002': 'ares_device_secret_2024'
  };
  
  if (validDevices[deviceId] === secretKey) {
    // Generate custom token for ESP32
    const customToken = await admin.auth().createCustomToken(deviceId, {
      role: 'esp32'
    });
    
    return { success: true, token: customToken };
  } else {
    throw new functions.https.HttpsError('permission-denied', 'Invalid device credentials');
  }
});

// Function to generate faculty access tokens
exports.generateFacultyToken = functions.https.onCall(async (data, context) => {
  const { facultyId, password } = data;
  
  // Simple authentication - in production, use proper authentication
  const validFaculty = {
    'faculty_001': 'ares_faculty_2024',
    'faculty_002': 'ares_faculty_2024'
  };
  
  if (validFaculty[facultyId] === password) {
    const customToken = await admin.auth().createCustomToken(facultyId, {
      role: 'faculty'
    });
    
    return { success: true, token: customToken };
  } else {
    throw new functions.https.HttpsError('permission-denied', 'Invalid faculty credentials');
  }
});
