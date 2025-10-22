/*
 * Ares Library Management System - ESP32 Scanner
 * 
 * Hardware Components:
 * - ESP32 Dev Board
 * - Barcode Scanner (USB or Serial)
 * - Ultrasonic Sensor (HC-SR04)
 * - Buzzer
 * - LED Status Indicator
 * - Push Button (for manual sync)
 * 
 * Features:
 * - Offline-first operation with local queue
 * - Firebase Realtime Database integration
 * - Door monitoring with grace period
 * - Automatic sync when online
 * - Manual sync button
 * - Status LED indicators
 */

#include <WiFi.h>
#include <FirebaseESP32.h>
#include <ArduinoJson.h>
#include <SPIFFS.h>
#include <Preferences.h>

// WiFi Configuration
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

// Firebase Configuration
#define FIREBASE_HOST "ares-library-management-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "YOUR_FIREBASE_AUTH_TOKEN"

// Hardware Pin Definitions
#define SCANNER_RX_PIN 16
#define SCANNER_TX_PIN 17
#define ULTRASONIC_TRIG_PIN 18
#define ULTRASONIC_ECHO_PIN 19
#define BUZZER_PIN 21
#define STATUS_LED_PIN 22
#define SYNC_BUTTON_PIN 23
#define DOOR_SENSOR_PIN 25

// Constants
const unsigned long GRACE_PERIOD_MS = 10000; // 10 seconds grace period
const unsigned long SYNC_INTERVAL_MS = 300000; // 5 minutes sync interval
const unsigned long DOOR_CHECK_INTERVAL_MS = 1000; // 1 second door check
const int MAX_QUEUE_SIZE = 50;
const int DOOR_THRESHOLD_CM = 50; // Door open threshold

// Global Variables
FirebaseData firebaseData;
FirebaseJson json;
Preferences preferences;

struct ScanEntry {
  String studentId;
  unsigned long timestamp;
  String status;
  bool synced;
};

ScanEntry scanQueue[MAX_QUEUE_SIZE];
int queueHead = 0;
int queueTail = 0;
int queueSize = 0;

unsigned long lastSyncTime = 0;
unsigned long lastDoorCheck = 0;
unsigned long gracePeriodStart = 0;
bool inGracePeriod = false;
bool doorOpen = false;
bool wifiConnected = false;

// Device Configuration
const String DEVICE_ID = "esp32_scanner_001";
const String DEVICE_SECRET = "ares_device_secret_2024";

void setup() {
  Serial.begin(115200);
  Serial.println("Ares Library Scanner Starting...");
  
  // Initialize hardware pins
  initializePins();
  
  // Initialize SPIFFS for offline storage
  if (!SPIFFS.begin(true)) {
    Serial.println("SPIFFS Mount Failed");
    return;
  }
  
  // Initialize preferences for settings
  preferences.begin("ares_scanner", false);
  
  // Load offline queue from storage
  loadOfflineQueue();
  
  // Connect to WiFi
  connectToWiFi();
  
  // Initialize Firebase
  initializeFirebase();
  
  // Start background tasks
  startBackgroundTasks();
  
  Serial.println("Ares Library Scanner Ready!");
  setStatusLED(true, false, false); // Green - Ready
}

void loop() {
  // Handle barcode scanning
  handleBarcodeScan();
  
  // Handle manual sync button
  handleSyncButton();
  
  // Monitor door status
  monitorDoor();
  
  // Periodic sync
  if (millis() - lastSyncTime > SYNC_INTERVAL_MS) {
    syncOfflineQueue();
    lastSyncTime = millis();
  }
  
  // Check WiFi connection
  if (WiFi.status() != WL_CONNECTED && wifiConnected) {
    wifiConnected = false;
    setStatusLED(false, true, false); // Red - No WiFi
    Serial.println("WiFi disconnected");
  } else if (WiFi.status() == WL_CONNECTED && !wifiConnected) {
    wifiConnected = true;
    setStatusLED(true, false, false); // Green - Connected
    Serial.println("WiFi reconnected");
    syncOfflineQueue();
  }
  
  delay(100); // Small delay to prevent overwhelming the system
}

void initializePins() {
  // Initialize scanner (SoftwareSerial)
  pinMode(SCANNER_RX_PIN, INPUT);
  pinMode(SCANNER_TX_PIN, OUTPUT);
  
  // Initialize ultrasonic sensor
  pinMode(ULTRASONIC_TRIG_PIN, OUTPUT);
  pinMode(ULTRASONIC_ECHO_PIN, INPUT);
  
  // Initialize buzzer
  pinMode(BUZZER_PIN, OUTPUT);
  digitalWrite(BUZZER_PIN, LOW);
  
  // Initialize status LED (RGB)
  pinMode(STATUS_LED_PIN, OUTPUT);
  
  // Initialize sync button
  pinMode(SYNC_BUTTON_PIN, INPUT_PULLUP);
  
  // Initialize door sensor
  pinMode(DOOR_SENSOR_PIN, INPUT_PULLUP);
  
  Serial.println("Hardware pins initialized");
}

void connectToWiFi() {
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");
  
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 20) {
    delay(500);
    Serial.print(".");
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    wifiConnected = true;
    Serial.println();
    Serial.println("WiFi connected!");
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());
    setStatusLED(true, false, false); // Green - Connected
  } else {
    wifiConnected = false;
    Serial.println();
    Serial.println("WiFi connection failed");
    setStatusLED(false, true, false); // Red - No WiFi
  }
}

void initializeFirebase() {
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);
  
  // Set timeout
  Firebase.setReadTimeout(firebaseData, 1000 * 60);
  Firebase.setwriteTimeout(firebaseData, 1000 * 60);
  
  Serial.println("Firebase initialized");
}

void handleBarcodeScan() {
  // Check if scanner has data (this would depend on your specific scanner)
  // For this example, we'll simulate a scan with a button press
  static unsigned long lastScanTime = 0;
  static bool scanButtonPressed = false;
  
  // Simulate scanner input (replace with actual scanner code)
  if (Serial.available()) {
    String scannedData = Serial.readStringUntil('\n');
    scannedData.trim();
    
    if (scannedData.length() > 0 && scannedData.length() < 20) {
      processScan(scannedData);
    }
  }
}

void processScan(String studentId) {
  Serial.println("Processing scan for student: " + studentId);
  
  // Create scan entry
  ScanEntry entry;
  entry.studentId = studentId;
  entry.timestamp = millis();
  entry.status = "IN"; // Default to IN, could be determined by logic
  entry.synced = false;
  
  // Add to queue
  if (addToQueue(entry)) {
    Serial.println("Scan added to queue");
    
    // Try to sync immediately if online
    if (wifiConnected) {
      if (syncSingleEntry(entry)) {
        Serial.println("Scan synced immediately");
        removeFromQueue();
      }
    }
    
    // Start grace period
    startGracePeriod();
    
    // Visual/audio feedback
    setStatusLED(false, false, true); // Blue - Processing
    playBuzzer(200); // Short beep
    delay(100);
    setStatusLED(true, false, false); // Green - Ready
    
  } else {
    Serial.println("Queue full! Scan not recorded.");
    playBuzzer(1000); // Long beep for error
  }
}

void startGracePeriod() {
  gracePeriodStart = millis();
  inGracePeriod = true;
  Serial.println("Grace period started");
}

void monitorDoor() {
  if (millis() - lastDoorCheck < DOOR_CHECK_INTERVAL_MS) {
    return;
  }
  lastDoorCheck = millis();
  
  // Read ultrasonic sensor
  digitalWrite(ULTRASONIC_TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(ULTRASONIC_TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(ULTRASONIC_TRIG_PIN, LOW);
  
  long duration = pulseIn(ULTRASONIC_ECHO_PIN, HIGH);
  int distance = duration * 0.034 / 2;
  
  bool currentDoorState = distance > DOOR_THRESHOLD_CM;
  
  // Check if door state changed
  if (currentDoorState != doorOpen) {
    doorOpen = currentDoorState;
    
    if (doorOpen) {
      Serial.println("Door opened - Distance: " + String(distance) + "cm");
      
      // Check if we're in grace period
      if (inGracePeriod && (millis() - gracePeriodStart) < GRACE_PERIOD_MS) {
        Serial.println("Door opened during grace period - OK");
      } else {
        Serial.println("Door opened outside grace period - ALARM!");
        triggerAlarm();
      }
    } else {
      Serial.println("Door closed - Distance: " + String(distance) + "cm");
    }
  }
  
  // End grace period
  if (inGracePeriod && (millis() - gracePeriodStart) > GRACE_PERIOD_MS) {
    inGracePeriod = false;
    Serial.println("Grace period ended");
  }
}

void triggerAlarm() {
  Serial.println("ALARM: Unauthorized door access!");
  
  // Flash LED red
  for (int i = 0; i < 10; i++) {
    setStatusLED(false, true, false); // Red
    delay(100);
    setStatusLED(false, false, false); // Off
    delay(100);
  }
  
  // Sound buzzer
  playBuzzer(2000); // Long alarm
  
  // Log alarm event (could send to Firebase if online)
  logAlarmEvent();
}

void logAlarmEvent() {
  // Create alarm log entry
  ScanEntry alarmEntry;
  alarmEntry.studentId = "ALARM";
  alarmEntry.timestamp = millis();
  alarmEntry.status = "ALARM";
  alarmEntry.synced = false;
  
  addToQueue(alarmEntry);
}

void handleSyncButton() {
  static unsigned long lastButtonPress = 0;
  static bool buttonPressed = false;
  
  bool buttonState = digitalRead(SYNC_BUTTON_PIN) == LOW;
  
  if (buttonState && !buttonPressed && (millis() - lastButtonPress) > 500) {
    buttonPressed = true;
    lastButtonPress = millis();
    
    Serial.println("Manual sync requested");
    syncOfflineQueue();
    
    // Visual feedback
    setStatusLED(false, false, true); // Blue - Syncing
    delay(500);
    setStatusLED(true, false, false); // Green - Ready
  }
  
  if (!buttonState) {
    buttonPressed = false;
  }
}

bool addToQueue(ScanEntry entry) {
  if (queueSize >= MAX_QUEUE_SIZE) {
    return false;
  }
  
  scanQueue[queueTail] = entry;
  queueTail = (queueTail + 1) % MAX_QUEUE_SIZE;
  queueSize++;
  
  // Save to SPIFFS
  saveOfflineQueue();
  
  return true;
}

void removeFromQueue() {
  if (queueSize > 0) {
    queueHead = (queueHead + 1) % MAX_QUEUE_SIZE;
    queueSize--;
    saveOfflineQueue();
  }
}

void syncOfflineQueue() {
  if (!wifiConnected || queueSize == 0) {
    return;
  }
  
  Serial.println("Syncing offline queue...");
  setStatusLED(false, false, true); // Blue - Syncing
  
  int syncedCount = 0;
  int originalSize = queueSize;
  
  for (int i = 0; i < originalSize; i++) {
    ScanEntry entry = scanQueue[queueHead];
    
    if (syncSingleEntry(entry)) {
      removeFromQueue();
      syncedCount++;
    } else {
      break; // Stop on first failure
    }
  }
  
  Serial.println("Synced " + String(syncedCount) + " entries");
  setStatusLED(true, false, false); // Green - Ready
}

bool syncSingleEntry(ScanEntry entry) {
  if (!wifiConnected) {
    return false;
  }
  
  try {
    // Generate unique log ID
    String logId = "log_" + String(entry.timestamp) + "_" + String(random(1000, 9999));
    
    // Create Firebase path
    String path = "/library_logs/" + logId;
    
    // Prepare JSON data
    json.clear();
    json.set("studentID", entry.studentId);
    json.set("status", entry.status);
    json.set("inTime", entry.timestamp);
    json.set("deviceId", DEVICE_ID);
    
    if (entry.status == "OUT") {
      json.set("outTime", entry.timestamp);
    }
    
    // Send to Firebase
    if (Firebase.setJSON(firebaseData, path, json)) {
      Serial.println("Entry synced: " + logId);
      return true;
    } else {
      Serial.println("Firebase sync failed: " + firebaseData.errorReason());
      return false;
    }
    
  } catch (const char* error) {
    Serial.println("Sync error: " + String(error));
    return false;
  }
}

void loadOfflineQueue() {
  File file = SPIFFS.open("/scan_queue.json", "r");
  if (!file) {
    Serial.println("No offline queue file found");
    return;
  }
  
  String content = file.readString();
  file.close();
  
  DynamicJsonDocument doc(2048);
  deserializeJson(doc, content);
  
  JsonArray array = doc.as<JsonArray>();
  queueSize = 0;
  
  for (JsonObject obj : array) {
    if (queueSize < MAX_QUEUE_SIZE) {
      scanQueue[queueSize].studentId = obj["studentId"].as<String>();
      scanQueue[queueSize].timestamp = obj["timestamp"];
      scanQueue[queueSize].status = obj["status"].as<String>();
      scanQueue[queueSize].synced = obj["synced"];
      queueSize++;
    }
  }
  
  queueHead = 0;
  queueTail = queueSize;
  
  Serial.println("Loaded " + String(queueSize) + " entries from offline queue");
}

void saveOfflineQueue() {
  DynamicJsonDocument doc(2048);
  JsonArray array = doc.to<JsonArray>();
  
  for (int i = 0; i < queueSize; i++) {
    int index = (queueHead + i) % MAX_QUEUE_SIZE;
    JsonObject obj = array.createNestedObject();
    obj["studentId"] = scanQueue[index].studentId;
    obj["timestamp"] = scanQueue[index].timestamp;
    obj["status"] = scanQueue[index].status;
    obj["synced"] = scanQueue[index].synced;
  }
  
  File file = SPIFFS.open("/scan_queue.json", "w");
  if (file) {
    serializeJson(doc, file);
    file.close();
  }
}

void playBuzzer(int duration) {
  digitalWrite(BUZZER_PIN, HIGH);
  delay(duration);
  digitalWrite(BUZZER_PIN, LOW);
}

void setStatusLED(bool red, bool green, bool blue) {
  // This is a simplified LED control
  // In practice, you'd use an RGB LED or multiple LEDs
  if (red) {
    digitalWrite(STATUS_LED_PIN, HIGH);
  } else if (green) {
    digitalWrite(STATUS_LED_PIN, HIGH);
  } else if (blue) {
    digitalWrite(STATUS_LED_PIN, HIGH);
  } else {
    digitalWrite(STATUS_LED_PIN, LOW);
  }
}

void startBackgroundTasks() {
  // This would start FreeRTOS tasks for background operations
  // For now, we'll handle everything in the main loop
  Serial.println("Background tasks started");
}
