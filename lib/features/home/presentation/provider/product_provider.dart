import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';

import '../../../../data/models/product.dart';
import '../../../../shared/services/api/api_service.dart';


class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  final Dio _dio = Dio();

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  late Box<Product> _productBox;

  // باز کردن دیتابیس Hive
  Future<void> openDatabase() async {
    _productBox = await Hive.openBox<Product>('products');
  }

  // درخواست API برای دریافت محصولات
  Future<void> fetchProducts() async {
    print("fetchProducts nima");
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post(
          'get_ad_list_offline_new',
          data: {
            "category_filter": 0,
            "location_filter": 0,
            "last_ad_id": "0",
            "user_id": "1095",
            "search_key": ""
          }
      );

      if (response.isNotEmpty) {
        print(response);
        final List<dynamic> data = response as List;
        // ایجاد لیستی از محصولات به صورت مستقیم
        _products = data.map((item) {
          return Product(
            id: item['id'],
            title: item['title'],
            description: item['description'],
            price: item['price'],
            userId: '',
            nameHolo: '',
            nameLatin: '',
            country: '',
            dateEx: '',
            datePd: '',
            priceType: '',
            keyWord: '',
            furmol: '',
            category: '',
            date: '',
            status: '',
            image1: '',
            image2: '',
            image3: '',
            isShowImage4: '',
            stiker: '',
            packing: '',
            priceVazn: 324,
            priceH: '',
            priceVaznH: '',
            unit: '',
            mojodiAll: '',
            wast: '',
            linkPdf: '',
            priceShopUs: '',
            sort: '',
            categoryTitle: '',
            relate: '',
            offer: '',
            linkVideo: '',
            naghdi: '',
            delet: '',
            offerTwo: '',
            idHolo: '',
            artNo: '',
            fourmulOne: '',
            fourmulTwo: '',
            minNumber: '',
            maxNumber: '',
            darsadVisitor: '',
            // سایر فیلدها
          );
        }).toList();

        // ذخیره محصولات در Hive
        await _productBox.clear(); // پاک‌سازی محصولات قبلی
        for (var product in _products) {
          await _productBox.put(product.id, product); // ذخیره محصول در Hive
        }
      } else {
        print("No data received");
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // دریافت محصولات از دیتابیس Hive
  List<Product> getProductsFromDatabase() {
    return _productBox.values.toList(); // دریافت تمام محصولات از Hive
  }
}
