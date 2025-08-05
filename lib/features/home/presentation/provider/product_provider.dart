import 'package:flutter/material.dart';
import 'package:neginteb/data/repositories/product_repository.dart';

import '../../../../data/models/product.dart';


class ProductProvider extends ChangeNotifier {
  final ProductRepository productRepository;

  ProductProvider({required this.productRepository});

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  /// گرفتن و ذخیره محصولات از سرور
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await productRepository.fetchAndStoreProducts();
      // _products = await productRepository.getLocalProducts();
    } catch (e) {
      _error = 'خطا در دریافت محصولات';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// فقط گرفتن از دیتابیس لوکال
  Future<void> loadFromLocal() async {
    // _products = await productRepository.getLocalProducts();
    notifyListeners();
  }
}
