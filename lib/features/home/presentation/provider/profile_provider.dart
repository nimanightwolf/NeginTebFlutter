import 'package:flutter/material.dart';
import 'package:hotelino/features/home/data/models/hotel.dart';
import 'package:hotelino/features/home/data/models/profile.dart';
import 'package:hotelino/features/home/data/repositories/hotel_repository.dart';
import 'package:hotelino/features/home/data/repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _profileRepository;
  final HotelRepository _hotelRepository;

  Profile? _profile;
  Profile? get profile => _profile;

  List<Hotel> _hotels = [];

  ProfileProvider(this._profileRepository, this._hotelRepository) {
    fetchHotels();
    loadUserProfile();
  }

  fetchHotels() async {
    _hotels = await _hotelRepository.fetchHotels();
  }

  loadUserProfile() async {
    _profile = await _profileRepository.fetchUserProfile();
  }

  // Recently Viewed Hotels ---------------------------------------------------------------

  final List<String> _recentlyViewedHotels = [];

  List<Hotel> get recentlyViewedHotels =>
      _hotels.where((hotel) => _recentlyViewedHotels.contains(hotel.id)).toList();

  void addRecentlyViewed(String hotelId) {
    if (!recentlyViewedHotels.contains(hotelId)) {
      _recentlyViewedHotels.add(hotelId);
      notifyListeners();
    } else {
      _recentlyViewedHotels.remove(hotelId);
      _recentlyViewedHotels.add(hotelId);
      notifyListeners();
    }
  }
}
