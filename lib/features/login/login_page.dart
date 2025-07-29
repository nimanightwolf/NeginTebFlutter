import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _codeSent = false;
  bool _loading = false;

  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://shimetebnegin.ir/api/new_app_api/api'));


  Future<void> sendCode() async {
    setState(() => _loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final user_id = prefs.getString('user_id');
      print(token);
      print(user_id);

      final response = await _dio.post(
        '/mobile_sms',
        data: {"mobile": _mobileController.text},
      );
      print(response.data.toString());
      final decoded = jsonDecode(response.data);
      print(decoded['status']);
      if (decoded['status'] == 'ok') {
        setState(() => _codeSent = true);
      } else {
        showSnackbar('ارسال کد ناموفق بود');
      }
    } catch (e) {
      showSnackbar('خطا در ارسال کد');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> verifyCode() async {
    setState(() => _loading = true);
    try {
      final response = await _dio.post(
        '/apply_activation_key',
        data: {
          "mobile": _mobileController.text,
          "activation_key": _codeController.text,
          "push_id": "",
          "android_id": "",
          "device_name": "",
          "device_model": "",
          "android_version": "",
        },

      );
      print(response.data.toString());
      final decoded = jsonDecode(response.data);
      print(decoded['status']);
      if (decoded["success"] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token",decoded["token"]);
        await prefs.setString("user_id", decoded["user_id"]);
        showSnackbar(decoded["message"]);
        // می‌توانید به صفحه خانه روت کنید
      } else {
        showSnackbar("کد وارد شده صحیح نیست");
      }
    } catch (e) {
      showSnackbar('خطا در تأیید کد');
    } finally {
      setState(() => _loading = false);
    }
  }

  void showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ورود'), centerTitle: true),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_codeSent) ...[
                TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'شماره موبایل'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loading ? null : sendCode,
                  child: Text('ارسال کد'),
                ),
              ] else ...[
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'کد تایید'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loading ? null : verifyCode,
                  child: Text('تایید و ورود'),
                ),
              ],
              if (_loading) const Padding(
                padding: EdgeInsets.only(top: 16),
                child: CircularProgressIndicator(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
