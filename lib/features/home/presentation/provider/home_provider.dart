import 'package:flutter/material.dart';
import 'package:neginteb/core/constants/constants.dart';
import 'package:neginteb/features/home/data/models/homepage_data.dart';
import 'package:neginteb/features/home/data/models/hotel.dart';
import 'package:neginteb/features/home/data/repositories/hotel_repository.dart';

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

  // Filter Methods ----------------------------------------------------------------------------------------------

  List<Hotel> getPopularHotels() {
    return _hotels.where((hotel) => _homePageData.popular.contains(hotel.id)).toList();
  }

  List<Hotel> getSpecialOffersHotels() {
    return _hotels.where((hotel) => _homePageData.specialOffers.contains(hotel.id)).toList();
  }

  List<Hotel> getNewestHotels() {
    return _hotels.where((hotel) => _homePageData.newest.contains(hotel.id)).toList();
  }

  // Story Section ------------------------------------------------------------------------------------------------

  List<String> getStoryImages() {
    final shuffledHotels = List<Hotel>.from(_hotels)..shuffle();
    return shuffledHotels.take(3).map((hotel) => hotel.images[0]).toList();
  }

  final List<String> _storyTitles = ["تضمین اصالت و خلوص محصولات", "پوشش کامل نیازهای دارویی و آزمایشگاهی", "محصولات تأییدشده و خالص"];

  List<String> get storyTitles => _storyTitles;
}
