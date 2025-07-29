import 'package:flutter/material.dart';
import 'package:neginteb/features/login/login_page.dart';
import 'package:neginteb/features/onboarding/presentation/onboarding_page.dart';
import 'package:neginteb/routes/main_bottom_nav.dart';

import '../features/splash/splash_page.dart';

class AppRoute {
  static const String home = '/';
  static const String hotelDetail = '/hotel-detail';
  static const String bookingForm = '/booking-form';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String splash = '/splash';

  static final Map<String, WidgetBuilder> routes = {
    onboarding: (ctx) => const OnboardingPage(),
    home: (ctx) => const MainButtomNav(),
    login:(ctx)=> const LoginPage(),
    splash: (ctx) => const SplashPage(),
  };
}
