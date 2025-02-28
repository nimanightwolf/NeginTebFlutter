import 'package:flutter/material.dart';
import 'package:hotelino/features/home/homePage.dart';
import 'package:hotelino/features/onboarding/presentation/onboarding_page.dart';

class AppRoute {
  static const String home = '/';
  static const String hotelDetail = '/hotel-detail';
  static const String bookingForm = '/booking-form';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String onboarding = '/onboarding';

  static final Map<String, WidgetBuilder> routes = {
    onboarding: (ctx) => const OnboardingPage(),
    home: (ctx) => const Homepage()
  };
}
