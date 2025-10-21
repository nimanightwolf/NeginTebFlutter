// splash_page.dart
import 'package:flutter/material.dart';
import 'package:neginteb/features/test/product_list_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neginteb/routes/app_route.dart';

import '../home/presentation/provider/product_provider.dart';

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
  //  final productProvider = Provider.of<ProductProvider>(context, listen: false);
    //productProvider.products();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts(); // بارگذاری داده‌ها از API
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => ProductListPage()), // هدایت به صفحه Home بعد از بارگذاری داده‌ها
    // );
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
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => ProductListPage()), // هدایت به صفحه Home بعد از بارگذاری داده‌ها
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
