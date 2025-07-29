import 'package:flutter/material.dart';
import 'package:neginteb/features/login/presentation/provider/storage_helper.dart';

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

  void verifyCode() async {
    final response = await ApiService.post(
      'apply_activation_key',
      data: {
        'mobile': mobileController.text,
        'activation_key': codeController.text,
        'push_id': 'push_123',
        'android_id': 'android_123',
        'device_name': 'Samsung Galaxy',
        'device_model': 'SM-G950F',
        'android_version': '11',
      },
    );
    if (response['success'] == true) {
      await StorageHelper.saveToken(response['token']);
      await StorageHelper.saveUserId(response['user_id']);
      // رفتن به صفحه خانه
     // navigatorKey.currentState?.pushReplacementNamed(AppRoute.home);
    }
  }
}
