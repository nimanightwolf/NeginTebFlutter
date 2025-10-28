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

  // ----------------------------------------------------------------------
  // init: اضافه‌کردن اینترسپتور برای Authorization
  // ----------------------------------------------------------------------
  static Future<void> init() async {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
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

  // ----------------------------------------------------------------------
  // Token / UserId cache helpers
  // ----------------------------------------------------------------------
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

  // ----------------------------------------------------------------------
  // helpers: اطمینان از int بودن user_id و تزریق در body/query
  // ----------------------------------------------------------------------
  static int? _asIntOrNull(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v.trim());
    if (v is num) return v.toInt();
    return null;
  }

  /// تضمین می‌کند user_id داخل body وجود داشته باشد و نوعش int باشد.
  /// اگر user_id ست نشده باشد، چیزی تزریق نمی‌شود.
  static Future<dynamic> _withUserIdInBody(dynamic data) async {
    final uid = await _getUserId();
    if (uid == null || uid <= 0) {
      // user_id ست نشده → تزریق نکن
      return data;
    }

    if (data == null) {
      return <String, dynamic>{'user_id': uid};
    }

    // هر نوع Map را قبول کن
    if (data is Map) {
      final map = Map<String, dynamic>.from(data as Map);
      // اگر قبلاً وجود داشت به int تبدیل کن؛ وگرنه اضافه کن
      map['user_id'] = _asIntOrNull(map['user_id']) ?? uid;
      return map;
    }

    if (data is FormData) {
      data.fields.removeWhere((f) => f.key == 'user_id');
      data.fields.add(MapEntry('user_id', uid.toString())); // multipart → رشته
      return data;
    }

    return data; // انواع دیگر دست‌نخورده
  }

  // ----------------------------------------------------------------------
  // public API: POST / GET (JSON-Base)
  // ----------------------------------------------------------------------
  /// اگر [skipUserId] = true باشد، user_id تزریق نمی‌شود.
  static Future<dynamic> post(
      String endpoint, {
        dynamic data,
        bool skipUserId = false,
        Options? options,
      }) async {
    try {
      final body = skipUserId ? data : await _withUserIdInBody(data);

      // print("POST $endpoint -> $body");

      final response = await _dio.post(
        endpoint,
        data: body,
        options: options ?? Options(contentType: Headers.jsonContentType),
      );

      final dynamic payload =
      response.data is String ? jsonDecode(response.data as String) : response.data;

      if (payload is List || payload is Map) return payload;
      return [];
    } catch (e) {
      // print('Request error (POST $endpoint): $e');
      return [];
    }
  }

  static Future<dynamic> get(
      String endpoint, {
        Map<String, dynamic>? query,
        bool skipUserId = true,
        Options? options,
      }) async {
    try {
      Map<String, dynamic>? qp = query;
      if (!skipUserId) {
        final uid = await _getUserId();
        if (uid != null && uid > 0) {
          qp = Map<String, dynamic>.from(query ?? const {});
          qp['user_id'] = uid; // تضمین int
        }
      }

      final response = await _dio.get(
        endpoint,
        queryParameters: qp,
        options: options,
      );

      final dynamic payload =
      response.data is String ? jsonDecode(response.data as String) : response.data;

      return (payload is List || payload is Map) ? payload : [];
    } catch (e) {
      // print('Request error (GET $endpoint): $e');
      return [];
    }
  }

  // ----------------------------------------------------------------------
  // LEGACY helper: سازگار با سرور قدیمی (myjson + <ghafas> ... </ghafas>)
  // ----------------------------------------------------------------------
  /// ارسال POST به آدرس کامل (خارج از baseUrl) با فرم‌فیلد `myjson`
  /// و حذف تگ‌های `<ghafas>` از پاسخ. اگر `ensureUserId` = true باشد،
  /// در صورت نبودن `user_id` داخل payload و ست بودن در SharedPrefs، آن را تزریق می‌کند.
  static Future<dynamic> postLegacyMyJson({
    required String fullUrl,                   // مثال: http://shimetebnegin.ir/api/appnew/command.php
    required Map<String, dynamic> payload,     // {"command":"read_message","user_id":...}
    bool ensureUserId = true,
  }) async {
    try {
      Map<String, dynamic> body = Map<String, dynamic>.from(payload);

      if (ensureUserId && !body.containsKey('user_id')) {
        final uid = await _getUserId();
        if (uid != null && uid > 0) {
          body['user_id'] = uid;
        }
      } else if (body.containsKey('user_id')) {
        final coerced = _asIntOrNull(body['user_id']);
        if (coerced != null) body['user_id'] = coerced;
      }

      final form = FormData.fromMap({'myjson': jsonEncode(body)});

      final res = await _dio.post(
        fullUrl,
        data: form,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      String raw = res.data?.toString() ?? '';
      if (raw.startsWith('<ghafas>') && raw.endsWith('</ghafas>')) {
        raw = raw.replaceAll('<ghafas>', '').replaceAll('</ghafas>', '');
      }

      final decoded = jsonDecode(raw);
      if (decoded is List || decoded is Map) return decoded;
      return [];
    } catch (e) {
      // print('legacy myjson error: $e');
      return [];
    }
  }
}
