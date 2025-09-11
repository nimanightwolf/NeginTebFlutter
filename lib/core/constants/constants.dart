import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:neginteb/features/home/data/models/homepage_data.dart';

class AppConstants {
  static const String baseUrlImage = "https://shimetebnegin.ir/api/photo/";
  static const String hotelsData = "assets/data/hotels.json";
}

class AppColors {
  static const Color primary = Color(0xFF63a002);

  // Light Theme Colors
  static const Color lightText = Colors.black;
  static const Color lightHint = Colors.grey;
  static const Color lightInputFill = Color(0xFFF5F5F5);
  static const Color lightBorder = Colors.grey;
  static const Color lightFocusedBorder = Colors.brown;

  // Dark Theme Colors
  static const Color darkText = Colors.white;
  static const Color darkHint = Colors.grey;
  static const Color darkInputFill = Color(0xFF303030);
  static const Color darkBorder = Color(0xFF707070);
  static const Color darkFocusedBorder = Colors.brown;
  static const Color darkButton = Color(0xFF364f17);
}

class HomePageDataConstants {
  static const List<String> _favoriteHotelIds = ["1", "3", "5", "7"];
  static const List<String> _discountedHotelIds = ["2", "4", "6", "8"];
  static const List<String> _recentlyViewedHotelIds = ["1", "4", "9"];
  static const List<String> _popularHotelIds = ["3", "6", "9", "10"];
  static const List<String> _specialOfferHotelIds = ["5", "7", "10"];
  static const List<String> _newestHotelIds = ["8", "9", "10"];

  static HomePageData get homePageData => HomePageData(
        favotires: _favoriteHotelIds,
        discounted: _discountedHotelIds,
        recentlyViewed: _recentlyViewedHotelIds,
        popular: _popularHotelIds,
        specialOffers: _specialOfferHotelIds,
        newest: _newestHotelIds,
      );
}
