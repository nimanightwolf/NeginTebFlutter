import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';


class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final TextEditingController codeController = TextEditingController();

  bool codeSent = false;
  String? mobile;
  String? error;

  void sendSmsCode(String phone, BuildContext context) async {
    try {
      error = null;
      await _authService.sendSms(phone);
      mobile = phone;
      codeSent = true;
      notifyListeners();
    } catch (e) {
      error = 'خطا در ارسال کد';
      notifyListeners();
    }
  }

  void verifyCode(BuildContext context) async {
    try {
      error = null;
      final result = await _authService.verify(
        mobile: mobile!,
        code: codeController.text,
        pushId: 'push_123',
        androidId: 'android_123',
        deviceName: 'Samsung Galaxy',
        deviceModel: 'SM-G950F',
        androidVersion: '11',
      );

      if (result['success']) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', result['token']);
        await prefs.setString('user_id', result['user_id']);
        // Navigator.pushReplacementNamed(context, AppRoute.home);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      } else {
        error = 'کد نادرست است';
      }
    } catch (e) {
      error = 'خطا در تأیید کد';
    }
    notifyListeners();
  }
}
