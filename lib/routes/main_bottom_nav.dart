// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotelino/core/constants/constants.dart';
import 'package:hotelino/routes/test.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainButtomNav extends StatefulWidget {
  const MainButtomNav({super.key});

  @override
  State<MainButtomNav> createState() => _MainButtomNavState();
}

class _MainButtomNavState extends State<MainButtomNav> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PersistentTabController(initialIndex: 0);
  }

  _buildScreens() {
    return [HomePage(), FavoritePage(), BookingPage(), ProfilePage()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: SvgPicture.asset(
            "assets/images/nav_home.svg",
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          activeColorPrimary: AppColors.primary,
          inactiveIcon: SvgPicture.asset(
            "assets/images/nav_home.svg",
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          )),
      PersistentBottomNavBarItem(
          icon: SvgPicture.asset(
            "assets/images/nav_favorite.svg",
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          activeColorPrimary: AppColors.primary,
          inactiveIcon: SvgPicture.asset(
            "assets/images/nav_favorite.svg",
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          )),
      PersistentBottomNavBarItem(
          icon: SvgPicture.asset(
            "assets/images/nav_booking.svg",
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          activeColorPrimary: AppColors.primary,
          inactiveIcon: SvgPicture.asset(
            "assets/images/nav_booking.svg",
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          )),
      PersistentBottomNavBarItem(
          icon: SvgPicture.asset(
            "assets/images/nav_profile.svg",
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          activeColorPrimary: AppColors.primary,
          inactiveIcon: SvgPicture.asset(
            "assets/images/nav_profile.svg",
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
