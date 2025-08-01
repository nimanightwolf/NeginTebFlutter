// ignore_for_file: prefer_const_constructors


import 'package:flutter/material.dart';
import 'package:neginteb/bootstrap.dart';
import 'package:neginteb/core/theme/app_theme.dart';
import 'package:neginteb/core/theme/theme_provider.dart';
import 'package:neginteb/features/booking/presentation/booking_provider.dart';
import 'package:neginteb/features/home/data/repositories/hotel_repository.dart';
import 'package:neginteb/features/home/data/repositories/profile_repository.dart';
import 'package:neginteb/features/home/presentation/provider/favorite_item_provider.dart';
import 'package:neginteb/features/home/presentation/provider/home_provider.dart';
import 'package:neginteb/features/home/presentation/provider/profile_provider.dart';
import 'package:neginteb/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:neginteb/features/onboarding/presentation/onboarding_provider.dart';
import 'package:neginteb/routes/app_route.dart';
import 'package:neginteb/shared/services/json_data_service.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'features/login/presentation/provider/auth_provider.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await lazyBootstrap();
  FlutterNativeSplash.remove();

  final hotelRepository = HotelRepository(jsonDataService: JsonDataService());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => ThemeProvider(
              WidgetsBinding.instance.platformDispatcher.platformBrightness)),
      ChangeNotifierProvider(
          create: (_) => OnboardingProvider(OnboardingRepository())),
      ChangeNotifierProvider(create: (_) => BookingProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider(hotelRepository)),
      ChangeNotifierProvider(
          create: (_) => ProfileProvider(ProfileRepository(), hotelRepository)),
      ChangeNotifierProvider(
          create: (_) => FavotireItemProvider(hotelRepository)),
      ChangeNotifierProvider(create: (_) => LoginProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    Provider.of<ThemeProvider>(context, listen: false)
        .updateBrightness(brightness);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeModeProvider, child) {
        return MaterialApp(
          title: 'NeginTeb',
          locale: const Locale("fa", "IR"),
          supportedLocales: const [Locale("fa", "IR"), Locale("en", "US")],
          localizationsDelegates: const [
            PersianMaterialLocalizations.delegate,
            PersianCupertinoLocalizations.delegate
          ],
          debugShowCheckedModeBanner: false,
          theme: themeModeProvider.brightness == Brightness.light
              ? AppTheme.lightTheme
              : AppTheme.darkTheme,
          routes: AppRoute.routes,
          initialRoute: AppRoute.splash,
        );
      },
    );
  }
}
