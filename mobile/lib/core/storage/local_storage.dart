import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const String _storesBox = 'stores';
  static const String _appointmentsBox = 'appointments';
  static const String _documentsBox = 'documents';
  static const String _userBox = 'user';

  static Future<void> initialize() async {
    await Hive.initFlutter();

    await Future.wait([
      Hive.openBox(_storesBox),
      Hive.openBox(_appointmentsBox),
      Hive.openBox(_documentsBox),
      Hive.openBox(_userBox),
    ]);
  }

  // Stores
  static Future<void> saveStores(List<Map<String, dynamic>> stores) async {
    final box = Hive.box(_storesBox);
    await box.put('all_stores', stores);
  }

  static Future<List<Map<String, dynamic>>> getStores() async {
    final box = Hive.box(_storesBox);
    final stores = box.get('all_stores', defaultValue: <Map<String, dynamic>>[]);
    return List<Map<String, dynamic>>.from(stores);
  }

  static Future<void> saveStore(String id, Map<String, dynamic> store) async {
    final box = Hive.box(_storesBox);
    await box.put(id, store);
  }

  static Future<Map<String, dynamic>?> getStore(String id) async {
    final box = Hive.box(_storesBox);
    return box.get(id);
  }

  // Appointments
  static Future<void> saveAppointments(List<Map<String, dynamic>> appointments) async {
    final box = Hive.box(_appointmentsBox);
    await box.put('user_appointments', appointments);
  }

  static Future<List<Map<String, dynamic>>> getAppointments() async {
    final box = Hive.box(_appointmentsBox);
    final appointments = box.get('user_appointments', defaultValue: <Map<String, dynamic>>[]);
    return List<Map<String, dynamic>>.from(appointments);
  }

  // Documents
  static Future<void> saveDocuments(List<Map<String, dynamic>> documents) async {
    final box = Hive.box(_documentsBox);
    await box.put('user_documents', documents);
  }

  static Future<List<Map<String, dynamic>>> getDocuments() async {
    final box = Hive.box(_documentsBox);
    final documents = box.get('user_documents', defaultValue: <Map<String, dynamic>>[]);
    return List<Map<String, dynamic>>.from(documents);
  }

  // User data
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final box = Hive.box(_userBox);
    await box.put('current_user', user);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final box = Hive.box(_userBox);
    return box.get('current_user');
  }

  static Future<void> clearUser() async {
    final box = Hive.box(_userBox);
    await box.clear();
  }

  // Clear all data
  static Future<void> clearAll() async {
    await Future.wait([
      Hive.box(_storesBox).clear(),
      Hive.box(_appointmentsBox).clear(),
      Hive.box(_documentsBox).clear(),
      Hive.box(_userBox).clear(),
    ]);
  }
}
