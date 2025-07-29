// splash_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neginteb/routes/app_route.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('user_id');
    print(token);
    print(userId);



    if (token != null && token.isNotEmpty && userId != null) {
      Navigator.pushReplacementNamed(context, AppRoute.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoute.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
