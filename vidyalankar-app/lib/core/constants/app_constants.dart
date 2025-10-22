// App Constants for Vidyalankar Library Management System

class AppConstants {
  // App Information
  static const String appName = 'Vidyalankar Library';
  static const String appDescription = 'Smart Library Management System';
  static const String appVersion = '1.0.0';
  static const String trustName = 'Vidyalankar Dhyanpeeth Trust';

  // College Codes
  static const String vsitCode = 'VSIT';
  static const String vitCode = 'VIT';
  static const String vpCode = 'VP';

  // College Names
  static const String vsitName = 'Vidyalankar School of Information Technology';
  static const String vitName = 'Vidyalankar Institute of Technology';
  static const String vpName = 'Vidyalankar Polytechnic';

  // College Colors
  static const Map<String, int> collegeColors = {
    vsitCode: 0xFF2563EB, // Blue
    vitCode: 0xFF059669, // Green
    vpCode: 0xFFD97706, // Orange
  };

  // Validation Constants
  static const int minStudentIdLength = 6;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int maxUsernameLength = 50;

  // UI Constants
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // API Constants
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;

  // Library Constants
  static const int maxBooksPerStudent = 5;
  static const int defaultBorrowDays = 14;
  static const int maxRenewalDays = 7;
  static const int maxRenewalCount = 2;

  // Notification Constants
  static const Duration notificationDelay = Duration(hours: 24);
  static const int maxNotificationRetries = 3;

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String collegeDataKey = 'college_data';
  static const String themeKey = 'theme_mode';
  static const String biometricKey = 'biometric_enabled';
  static const String lastSyncKey = 'last_sync';

  // Error Messages
  static const String networkError =
      'Network connection error. Please check your internet connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String authError = 'Authentication failed. Please login again.';
  static const String validationError =
      'Please check your input and try again.';
  static const String unknownError =
      'An unexpected error occurred. Please try again.';

  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String logoutSuccess = 'Logged out successfully!';
  static const String bookBorrowedSuccess = 'Book borrowed successfully!';
  static const String bookReturnedSuccess = 'Book returned successfully!';
  static const String bookRenewedSuccess = 'Book renewed successfully!';
  static const String profileUpdatedSuccess = 'Profile updated successfully!';

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // File Constants
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = [
    'pdf',
    'doc',
    'docx',
    'txt'
  ];

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Search Constants
  static const int minSearchLength = 2;
  static const Duration searchDebounce = Duration(milliseconds: 500);

  // Cache Constants
  static const Duration cacheExpiry = Duration(hours: 1);
  static const int maxCacheSize = 100;

  // Biometric Constants
  static const String biometricReason =
      'Authenticate to access your library account';
  static const String biometricTitle = 'Biometric Authentication';
  static const String biometricSubtitle =
      'Use your biometric to login securely';

  // Library Status
  static const String libraryOpen = 'OPEN';
  static const String libraryClosed = 'CLOSED';
  static const String libraryMaintenance = 'MAINTENANCE';

  // Book Status
  static const String bookAvailable = 'AVAILABLE';
  static const String bookBorrowed = 'BORROWED';
  static const String bookReserved = 'RESERVED';
  static const String bookMaintenance = 'MAINTENANCE';

  // User Types
  static const String userTypeStudent = 'student';
  static const String userTypeStaff = 'staff';
  static const String userTypeFaculty = 'faculty';
  static const String userTypeAdmin = 'admin';
  static const String userTypeTrustAdmin = 'trust_admin';

  // Library Features
  static const List<String> availableFeatures = [
    'book_borrowing',
    'book_reservation',
    'digital_resources',
    'study_rooms',
    'printing_services',
    'research_assistance',
    'inter_library_loan',
  ];

  // Notification Types
  static const String notificationTypeBookDue = 'book_due';
  static const String notificationTypeBookOverdue = 'book_overdue';
  static const String notificationTypeBookAvailable = 'book_available';
  static const String notificationTypeLibraryUpdate = 'library_update';
  static const String notificationTypeSystemMaintenance = 'system_maintenance';

  // Analytics Constants
  static const Duration analyticsInterval = Duration(minutes: 5);
  static const int maxAnalyticsRetention = 365; // days

  // Security Constants
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  static const Duration sessionTimeout = Duration(hours: 8);

  // Performance Constants
  static const Duration imageLoadTimeout = Duration(seconds: 10);
  static const int maxConcurrentRequests = 5;
  static const Duration requestTimeout = Duration(seconds: 15);
}
