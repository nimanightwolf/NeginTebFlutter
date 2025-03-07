import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hotelino/core/constants/constants.dart';
import 'package:hotelino/features/home/data/models/hotel.dart';

class JsonDataService {
  Future<List<Hotel>> loadHotels() async {
    final String response = await rootBundle.loadString(AppConstants.hotelsData);
    final Map<String, dynamic> jsonData = json.decode(response);

    final List<dynamic> hotelsList = jsonData["hotels"];

    return hotelsList
        .map(
          (hotel) => Hotel.fromJson(hotel as Map<String, dynamic>),
        )
        .toList();
  }
}
