import 'dart:convert';

import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  /// ارسال کد تأیید به شماره موبایل
  Future<void> sendCode(String mobile) async {
    final response = await _dio.post(
      'https://shimetebnegin.ir/api/new_app_api/api/mobile_sms',
      data: {'mobile': mobile},
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
   ;
    print(response.data.toString());
    if (response.statusCode == 200 && response.data['status']=="ok") {
      return;
    } else {
      throw Exception('ارسال کد با خطا مواجه شد');
    }
  }

/// چون شما در حال حاضر صرفاً کد می‌فرستید و پاسخ تأیید ندارید، تابع verify فعلاً نیاز نیست
}
