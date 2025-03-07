import 'package:flutter/material.dart';
import 'package:hotelino/core/constants/constants.dart';
import 'package:hotelino/features/home/data/models/homepage_data.dart';
import 'package:hotelino/features/home/data/models/hotel.dart';
import 'package:hotelino/features/home/data/repositories/hotel_repository.dart';

class HomeProvider extends ChangeNotifier {
  final HotelRepository _hotelRepository;

  HomeProvider(this._hotelRepository) {
    fetchHotels();
  }

  List<Hotel> _hotels = [];
  List<Hotel> get hotels => _hotels;

  final HomePageData _homePageData = HomePageDataConstants.homePageData;
  HomePageData get homePageData => _homePageData;

  fetchHotels() async {
    _hotels = await _hotelRepository.fetchHotels();
    notifyListeners();
  }
}
