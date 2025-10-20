# Firebase Realtime Database Schema

## Overview
The Ares Library Management System uses Firebase Realtime Database to store student information, library logs, and live statistics.

## Database Structure

```json
{
  "students": {
    "student_id_12345": {
      "name": "Farhan Sayed",
      "fcmToken": "device_token_from_pwa",
      "lastLogin": 1678886400,
      "totalVisits": 42
    }
  },
  "library_logs": {
    "log_id_abcde": {
      "studentID": "student_id_12345",
      "status": "IN",
      "inTime": 1678886400,
      "outTime": null,
      "reason": "Studying",
      "deviceId": "esp32_scanner_001"
    }
  },
  "live_stats": {
    "currentOccupancy": 0,
    "lastUpdated": 1678886400,
    "peakHours": {
      "9": 15,
      "10": 23,
      "11": 28,
      "14": 31,
      "15": 27
    }
  },
  "faculty_access": {
    "faculty_001": {
      "name": "Dr. Smith",
      "lastAccess": 1678886400,
      "permissions": ["read_all", "analytics"]
    }
  }
}
```

## Data Validation Rules

### Students Collection
- **studentId**: Unique identifier (string)
- **name**: Student's full name (string, required)
- **fcmToken**: Firebase Cloud Messaging token (string, optional)
- **lastLogin**: Unix timestamp of last login (number)
- **totalVisits**: Total number of library visits (number)

### Library Logs Collection
- **logId**: Unique log identifier (string)
- **studentID**: Reference to student (string, required)
- **status**: Either "IN" or "OUT" (string, required)
- **inTime**: Unix timestamp when student entered (number, required)
- **outTime**: Unix timestamp when student left (number or null)
- **reason**: Reason for visit (string, optional)
- **deviceId**: ESP32 device that processed the scan (string)

### Live Stats Collection
- **currentOccupancy**: Current number of students in library (number)
- **lastUpdated**: Unix timestamp of last update (number)
- **peakHours**: Object with hour keys and occupancy values

## Security Rules

1. **Students**: Can only read/write their own data
2. **ESP32 Devices**: Can write library logs and read student data
3. **Faculty**: Can read all data but cannot write
4. **Cloud Functions**: Can read/write all data for system operations

## Indexing Strategy

For optimal performance, consider adding these indexes:
- `library_logs` by `studentID` and `status`
- `library_logs` by `inTime` for time-based queries
- `students` by `fcmToken` for notification lookups
