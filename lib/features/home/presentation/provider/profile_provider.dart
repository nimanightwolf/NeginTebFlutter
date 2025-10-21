import 'package:flutter/material.dart';
import 'package:neginteb/data/models/product.dart';
import 'package:neginteb/features/home/data/models/hotel.dart';
import 'package:neginteb/features/home/data/models/profile.dart';
import 'package:neginteb/features/home/data/repositories/hotel_repository.dart';
import 'package:neginteb/features/home/data/repositories/profile_repository.dart';
import 'package:neginteb/features/home/presentation/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _profileRepository;
  final HotelRepository _hotelRepository;

  Profile? _profile;
  Profile? get profile => _profile;

  List<Product> _product = [];
  List<Product> get profileProducts => _product;
  void loadProfileProducts(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    _product = productProvider.getProductsFromDatabase();
    notifyListeners();
  }

  ProfileProvider(this._profileRepository, this._hotelRepository) {
    //loadProfileProducts(contex);
    loadUserProfile();

  }



  loadUserProfile() async {
    _profile = await _profileRepository.fetchUserProfile();
    notifyListeners();
  }

  // Recently Viewed Hotels ---------------------------------------------------------------

  final List<String> _recentlyViewedProduct = [];

  List<Product> get recentlyViewedProducts {

    return _product.where((product) => _recentlyViewedProduct.contains(product.id)).toList();
  }


  void addRecentlyViewed(String productId) {
    print("addRecentlyViewed$productId");
    _recentlyViewedProduct.remove(productId);
    _recentlyViewedProduct.add(productId);

    const maxItems = 20;
    if (_recentlyViewedProduct.length > maxItems) {
      _recentlyViewedProduct.removeRange(0, _recentlyViewedProduct.length - maxItems);
    }

    notifyListeners();
  }
}
