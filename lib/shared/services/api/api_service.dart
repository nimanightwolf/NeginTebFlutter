import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://shimetebnegin.ir/api/new_app_api/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  static const String _kAuthTokenKey = 'auth_token';
  static const String _kUserIdKey    = 'user_id';
  static const bool _useBearerPrefix = false;

  static String? _cachedToken;
  static int? _cachedUserId;

  static Future<void> init() async {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Authorization header فقط
        final token = await _getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] =
          _useBearerPrefix ? 'Bearer $token' : token;
        } else {
          options.headers.remove('Authorization');
        }
        handler.next(options);
      },
    ));
  }

  static Future<void> updateToken(String? token) async {
    final sp = await SharedPreferences.getInstance();
    if (token == null || token.isEmpty) {
      await sp.remove(_kAuthTokenKey);
      _cachedToken = null;
    } else {
      await sp.setString(_kAuthTokenKey, token);
      _cachedToken = token;
    }
  }

  static Future<void> updateUserId(int? userId) async {
    final sp = await SharedPreferences.getInstance();
    if (userId == null || userId <= 0) {
      await sp.remove(_kUserIdKey);
      _cachedUserId = null;
    } else {
      await sp.setInt(_kUserIdKey, userId);
      _cachedUserId = userId;
    }
  }

  static Future<String?> _getToken() async {
    if (_cachedToken != null) return _cachedToken;
    final sp = await SharedPreferences.getInstance();
    _cachedToken = sp.getString(_kAuthTokenKey);
    return _cachedToken;
  }

  static Future<int?> _getUserId() async {
    if (_cachedUserId != null) return _cachedUserId;
    final sp = await SharedPreferences.getInstance();
    _cachedUserId = sp.getInt(_kUserIdKey);
    return _cachedUserId;
  }

  // ————— helpers —————
  static Future<dynamic> _withUserIdInBody(dynamic data) async {
    final uid = await _getUserId();
    if (uid == null || uid <= 0) return data ?? {'user_id': null};

    if (data == null) return {'user_id': uid};

    if (data is Map<String, dynamic>) {
      return {...data, 'user_id': uid};
    }
    if (data is FormData) {
      data.fields.removeWhere((f) => f.key == 'user_id');
      data.fields.add(MapEntry('user_id', uid.toString()));
      return data;
    }
    return data; // فرمت‌های دیگر را دست نمی‌زنیم
  }

  // ————— public API —————
  /// اگر [skipUserId] برابر true باشه، user_id به body تزریق نمی‌شه.
  static Future<dynamic> post(String endpoint, {
    dynamic data,
    bool skipUserId = false,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      print(response);
      final decoded = jsonDecode(response.data);

      // اگر پاسخ از نوع لیست باشد، آن را برمی‌گردانیم
      if (decoded is List) {
        return decoded;  // اگر داده‌ها یک لیست باشند، همان لیست را باز می‌گردانیم
      }

      // در غیر این صورت، فرض می‌کنیم که داده‌ها یک نقشه (Map) هستند
      if (decoded is Map) {
        return decoded;  // اگر داده‌ها یک نقشه باشند، همان نقشه را باز می‌گردانیم
      }

      // اگر هیچ‌کدام از این‌ها نباشد، آرایه خالی برمی‌گردانیم
      return [];

    } catch (e) {
      print('Request error: $e');
      return [];
    }
  }

  static Future<dynamic> get(String endpoint, {
    Map<String, dynamic>? query,
    bool skipUserId = true, // GET اصولاً body ندارد؛ پیش‌فرض: عدم تزریق
  }) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: query);
      final dynamic payload =
      response.data is String ? jsonDecode(response.data as String) : response.data;
      return (payload is List || payload is Map) ? payload : [];
    } catch (e) {
      print('Request error (GET $endpoint): $e');
      return [];
    }
  }
}
