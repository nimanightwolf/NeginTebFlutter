import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://shimetebnegin.ir/api/new_app_api/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<void> sendSms(String mobile) async {
    try {
      print(mobile);
      final response = await _dio.post('/mobile_sms', data: {"mobile": mobile});
      print(response.data);
      if (response.data["status"] == "ok") {
        print(response.data);
      }
    } catch (e) {
      print('💥 خطای ریکوئست ارسال کد: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verify({
    required String mobile,
    required String code,
    required String pushId,
    required String androidId,
    required String deviceName,
    required String deviceModel,
    required String androidVersion,
  }) async {
    final response = await _dio.post('/apply_activation_key', data: {
      "mobile": mobile,
      "activation_key": code,
      "push_id": pushId,
      "android_id": androidId,
      "device_name": deviceName,
      "device_model": deviceModel,
      "android_version": androidVersion,
    });

    return response.data;
  }
}
