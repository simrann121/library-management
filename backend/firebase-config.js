// Firebase Configuration for Ares Library Management System
// Replace these values with your actual Firebase project configuration

const firebaseConfig = {
  apiKey: "your-api-key-here",
  authDomain: "ares-library-management.firebaseapp.com",
  databaseURL: "https://ares-library-management-default-rtdb.firebaseio.com",
  projectId: "ares-library-management",
  storageBucket: "ares-library-management.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef1234567890abcdef"
};

// Initialize Firebase
import { initializeApp } from 'firebase/app';
import { getDatabase } from 'firebase/database';
import { getMessaging } from 'firebase/messaging';

const app = initializeApp(firebaseConfig);
const database = getDatabase(app);
const messaging = getMessaging(app);

export { database, messaging };
