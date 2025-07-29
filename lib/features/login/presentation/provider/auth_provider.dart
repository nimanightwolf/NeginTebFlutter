

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../routes/app_route.dart';
import '../../../../shared/services/api/api_service.dart';

class LoginProvider extends ChangeNotifier {
  final mobileController = TextEditingController();
  final codeController = TextEditingController();
  bool isCodeSent = false;

  void sendMobile() async {
    final mobile = mobileController.text;
    final response = await ApiService.post(
      'mobile_sms',
      data: {'mobile': mobile},
    );
    if (response['status'] == 'ok') {
      isCodeSent = true;
      notifyListeners();
    }
  }

  void verifyCode(BuildContext context) async {
    final response = await ApiService.post(
      'apply_activation_key',
      data: {
        'mobile': mobileController.text,
        'activation_key': codeController.text,
        'push_id': '',
        'android_id': '',
        'device_name': '',
        'device_model': '',
        'android_version': '',
      },
    );

    print(response.toString());
    if (response['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);
      await prefs.setString('user_id', response['user_id']);

      final token = prefs.getString('token');
      print(token);
      Navigator.pushReplacementNamed(context, AppRoute.home);
      // رفتن به صفحه خانه
      // navigatorKey.currentState?.pushReplacementNamed(AppRoute.home);
    }
  }
}
