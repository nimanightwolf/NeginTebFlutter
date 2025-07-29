import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://shimetebnegin.ir/api/new_app_api/api+"));

  Future<void> sendSms(String mobile) async {
    await _dio.post('/mobile_sms', data: {"mobile": mobile});
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
