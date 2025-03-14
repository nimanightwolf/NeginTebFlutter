import 'package:flutter/material.dart';
import 'package:hotelino/features/home/data/models/hotel.dart';
import 'package:hotelino/features/home/data/repositories/hotel_repository.dart';

class FavotireItemProvider extends ChangeNotifier {
  final HotelRepository _hotelRepository;

  FavotireItemProvider(this._hotelRepository) {
    fetchHotels();
  }

  final List<String> _favoriteHotelIds = [];
  List<Hotel> get favoriteHotelList =>
      _hotels.where((hotel) => _favoriteHotelIds.contains(hotel.id)).toList();

  List<Hotel> _hotels = [];

  fetchHotels() async {
    _hotels = await _hotelRepository.fetchHotels();
    notifyListeners();
  }

  bool isFavorite(String hotelId) {
    return _favoriteHotelIds.contains(hotelId);
  }

  void toggleFavorite(String hotelId) {
    if (_favoriteHotelIds.contains(hotelId)) {
      _favoriteHotelIds.remove(hotelId);
    } else {
      _favoriteHotelIds.add(hotelId);
    }

    notifyListeners();
  }
}
