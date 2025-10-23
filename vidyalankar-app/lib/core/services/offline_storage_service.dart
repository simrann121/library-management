// Offline Storage Service for Vidyalankar Library Management System

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/error/exceptions.dart' as app_exceptions;

class OfflineStorageService {
  static const String _databaseName = 'vidyalankar_library.db';
  static const int _databaseVersion = 1;

  static Database? _database;
  static SharedPreferences? _prefs;

  // Initialize offline storage
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _database = await _initDatabase();
  }

  // Initialize SQLite database
  static Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create database tables
  static Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        collegeId TEXT NOT NULL,
        role TEXT NOT NULL,
        isActive INTEGER NOT NULL,
        lastLogin TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        synced INTEGER DEFAULT 0
      )
    ''');

    // Books table
    await db.execute('''
      CREATE TABLE books (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        isbn TEXT NOT NULL,
        genre TEXT NOT NULL,
        imageUrl TEXT,
        totalCopies INTEGER NOT NULL,
        availableCopies INTEGER NOT NULL,
        description TEXT,
        collegeId TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        synced INTEGER DEFAULT 0
      )
    ''');

    // Borrowed books table
    await db.execute('''
      CREATE TABLE borrowed_books (
        id TEXT PRIMARY KEY,
        bookId TEXT NOT NULL,
        userId TEXT NOT NULL,
        borrowDate TEXT NOT NULL,
        returnDate TEXT NOT NULL,
        actualReturnDate TEXT,
        isOverdue INTEGER DEFAULT 0,
        collegeId TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (bookId) REFERENCES books (id),
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Library logs table
    await db.execute('''
      CREATE TABLE library_logs (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        userName TEXT NOT NULL,
        collegeId TEXT NOT NULL,
        libraryId TEXT NOT NULL,
        action TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        bookId TEXT,
        bookTitle TEXT,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Offline queue table
    await db.execute('''
      CREATE TABLE offline_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action TEXT NOT NULL,
        tableName TEXT NOT NULL,
        recordId TEXT NOT NULL,
        data TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        retryCount INTEGER DEFAULT 0,
        status TEXT DEFAULT 'pending'
      )
    ''');

    // Sync status table
    await db.execute('''
      CREATE TABLE sync_status (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tableName TEXT NOT NULL,
        lastSyncTime TEXT NOT NULL,
        syncToken TEXT
      )
    ''');
  }

  // Database upgrade
  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }

  // Get database instance
  static Database get database {
    if (_database == null) {
      throw const app_exceptions.DatabaseException('Database not initialized');
    }
    return _database!;
  }

  // Get shared preferences instance
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw const app_exceptions.StorageException(
          'SharedPreferences not initialized');
    }
    return _prefs!;
  }

  // User operations
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await database.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, dynamic>?> getUser(String userId) async {
    final result = await database.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await database.query('users');
  }

  static Future<void> deleteUser(String userId) async {
    await database.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Book operations
  static Future<void> saveBook(Map<String, dynamic> book) async {
    await database.insert(
      'books',
      book,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, dynamic>?> getBook(String bookId) async {
    final result = await database.query(
      'books',
      where: 'id = ?',
      whereArgs: [bookId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<List<Map<String, dynamic>>> getAllBooks() async {
    return await database.query('books');
  }

  static Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    return await database.query(
      'books',
      where: 'title LIKE ? OR author LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
  }

  static Future<void> deleteBook(String bookId) async {
    await database.delete(
      'books',
      where: 'id = ?',
      whereArgs: [bookId],
    );
  }

  // Borrowed books operations
  static Future<void> saveBorrowedBook(
      Map<String, dynamic> borrowedBook) async {
    await database.insert(
      'borrowed_books',
      borrowedBook,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getBorrowedBooks(
      String userId) async {
    return await database.query(
      'borrowed_books',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  static Future<void> returnBook(String borrowedBookId) async {
    await database.update(
      'borrowed_books',
      {'actualReturnDate': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [borrowedBookId],
    );
  }

  // Library logs operations
  static Future<void> saveLibraryLog(Map<String, dynamic> log) async {
    await database.insert(
      'library_logs',
      log,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getLibraryLogs(
      String collegeId) async {
    return await database.query(
      'library_logs',
      where: 'collegeId = ?',
      whereArgs: [collegeId],
      orderBy: 'timestamp DESC',
    );
  }

  // Offline queue operations
  static Future<void> addToOfflineQueue({
    required String action,
    required String tableName,
    required String recordId,
    required Map<String, dynamic> data,
  }) async {
    await database.insert('offline_queue', {
      'action': action,
      'tableName': tableName,
      'recordId': recordId,
      'data': jsonEncode(data),
      'timestamp': DateTime.now().toIso8601String(),
      'retryCount': 0,
      'status': 'pending',
    });
  }

  static Future<List<Map<String, dynamic>>> getOfflineQueue() async {
    return await database.query(
      'offline_queue',
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'timestamp ASC',
    );
  }

  static Future<void> updateOfflineQueueStatus(int id, String status) async {
    await database.update(
      'offline_queue',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> incrementRetryCount(int id) async {
    await database.rawUpdate(
      'UPDATE offline_queue SET retryCount = retryCount + 1 WHERE id = ?',
      [id],
    );
  }

  static Future<void> removeFromOfflineQueue(int id) async {
    await database.delete(
      'offline_queue',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Sync status operations
  static Future<void> updateSyncStatus(String tableName, String lastSyncTime,
      {String? syncToken}) async {
    await database.insert(
      'sync_status',
      {
        'tableName': tableName,
        'lastSyncTime': lastSyncTime,
        'syncToken': syncToken,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, dynamic>?> getSyncStatus(String tableName) async {
    final result = await database.query(
      'sync_status',
      where: 'tableName = ?',
      whereArgs: [tableName],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Cache operations
  static Future<void> setCache(String key, Map<String, dynamic> data) async {
    await prefs.setString(key, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> getCache(String key) async {
    final data = prefs.getString(key);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<void> removeCache(String key) async {
    await prefs.remove(key);
  }

  static Future<void> clearCache() async {
    await prefs.clear();
  }

  // Utility methods
  static Future<bool> isOnline() async {
    // This would typically check network connectivity
    // For now, we'll use a simple implementation
    return true; // Placeholder
  }

  static Future<void> clearAllData() async {
    await database.delete('users');
    await database.delete('books');
    await database.delete('borrowed_books');
    await database.delete('library_logs');
    await database.delete('offline_queue');
    await database.delete('sync_status');
    await clearCache();
  }

  static Future<void> close() async {
    await _database?.close();
  }
}
