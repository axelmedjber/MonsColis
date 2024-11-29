import 'package:dio/dio.dart';
import 'package:flutter_secure_storage.dart';

class ApiClient {
  static const String baseUrl = 'http://localhost:3000/api';
  static ApiClient? _instance;
  final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiClient._()
      : _dio = Dio(BaseOptions(baseUrl: baseUrl)),
        _storage = const FlutterSecureStorage() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token expired or invalid
      await _storage.delete(key: 'auth_token');
      // TODO: Navigate to login screen
    }
    return handler.next(err);
  }

  // Auth endpoints
  Future<Map<String, dynamic>> sendVerificationCode(String phoneNumber) async {
    final response = await _dio.post('/auth/send-code', data: {
      'phone_number': phoneNumber,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> verifyPhoneNumber(
    String phoneNumber,
    String code,
  ) async {
    final response = await _dio.post('/auth/verify', data: {
      'phone_number': phoneNumber,
      'verification_code': code,
    });
    
    final token = response.data['token'];
    await _storage.write(key: 'auth_token', value: token);
    
    return response.data;
  }

  // Store endpoints
  Future<List<Map<String, dynamic>>> getStores() async {
    final response = await _dio.get('/stores');
    return List<Map<String, dynamic>>.from(response.data['stores']);
  }

  Future<Map<String, dynamic>> getStore(String id) async {
    final response = await _dio.get('/stores/$id');
    return response.data['store'];
  }

  Future<Map<String, dynamic>> getStoreAvailability(
    String id,
    DateTime date,
  ) async {
    final response = await _dio.get(
      '/stores/$id/availability',
      queryParameters: {'date': date.toIso8601String().split('T')[0]},
    );
    return response.data['availability'];
  }

  // Appointment endpoints
  Future<List<Map<String, dynamic>>> getAppointments({
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final response = await _dio.get(
      '/appointments',
      queryParameters: {
        if (status != null) 'status': status,
        if (fromDate != null) 'from_date': fromDate.toIso8601String(),
        if (toDate != null) 'to_date': toDate.toIso8601String(),
      },
    );
    return List<Map<String, dynamic>>.from(response.data['appointments']);
  }

  Future<Map<String, dynamic>> createAppointment(
    String storeId,
    DateTime appointmentTime,
  ) async {
    final response = await _dio.post('/appointments', data: {
      'store_id': storeId,
      'appointment_time': appointmentTime.toIso8601String(),
    });
    return response.data['appointment'];
  }

  Future<Map<String, dynamic>> cancelAppointment(String id) async {
    final response = await _dio.post('/appointments/$id/cancel');
    return response.data['appointment'];
  }

  // Document endpoints
  Future<List<Map<String, dynamic>>> getDocuments() async {
    final response = await _dio.get('/documents');
    return List<Map<String, dynamic>>.from(response.data['documents']);
  }

  Future<Map<String, dynamic>> uploadDocument(
    String documentType,
    List<int> fileBytes,
    String fileName,
  ) async {
    final formData = FormData.fromMap({
      'document_type': documentType,
      'file': MultipartFile.fromBytes(
        fileBytes,
        filename: fileName,
      ),
    });

    final response = await _dio.post('/documents', data: formData);
    return response.data['document'];
  }

  Future<String> getDocumentUrl(String id) async {
    final response = await _dio.get('/documents/$id/url');
    return response.data['url'];
  }
}
