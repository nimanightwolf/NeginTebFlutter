import 'dart:convert';

import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://shimetebnegin.ir/api/new_app_api/api/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Accept': 'application/json',
      'Authorization': '23504bb829f431745923e172423126591bd9822e6679efeb4ad71022167c4e17',},
  ));

  static Future<dynamic> post(String endpoint, {Map<String, dynamic>? data}) async {
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
}
