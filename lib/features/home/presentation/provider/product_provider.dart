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
            id: item['id'] ?? '',  // اگر 'id' وجود نداشت، مقدار پیش‌فرض ' ' خواهد بود
            title: item['title'] ?? '',  // مقدار پیش‌فرض ' '
            description: item['description'] ?? '',
            price: item['price'] ?? '',
            userId: item['user_id'] ?? '',  // برای داده‌هایی که ممکن است خالی باشند
            nameHolo: item['name_holo'] ?? '',
            nameLatin: item['name_latin'] ?? '',
            country: item['country'] ?? '',
            dateEx: item['date_ex'] ?? '',
            datePd: item['date_pd'] ?? '',
            priceType: item['price_type'] ?? '',
            keyWord: item['key_word'] ?? '',
            furmol: item['furmol'] ?? '',
            category: item['category'] ?? '',
            date: item['date'] ?? '',
            status: item['status'] ?? '',
            image1: item['image1'] ?? '',
            image2: item['image2'] ?? '',
            image3: item['image3'] ?? '',
            isShowImage4: item['is_show_image4'] ?? '',
            stiker: item['stiker'] ?? '',
            packing: item['packing'] ?? '',
            priceVazn: item['pricevazn'] ?? 0,  // فرض کنید که مقدار عددی است
            priceH: item['priceh'] ?? '',
            priceVaznH: item['pricevaznh'] ?? '',
            unit: item['unit'] ?? '',
            mojodiAll: item['mojodi_all'] ?? '',
            wast: item['wast'] ?? '',
            linkPdf: item['link_pdf'] ?? '',
            priceShopUs: item['price_shop_us'] ?? '',
            sort: item['sort'] ?? '',
            categoryTitle: item['category_title'] ?? '',
            relate: item['relate'] ?? '',
            offer: item['offer'] ?? '',
            linkVideo: item['link_video'] ?? '',
            naghdi: item['naghdi'] ?? '',
            delet: item['delet'] ?? '',
            offerTwo: item['offer_two'] ?? '',
            idHolo: item['id_holo'] ?? '',
            artNo: item['art_no'] ?? '',
            fourmulOne: item['fourmul_one'] ?? '',
            fourmulTwo: item['fourmul_two'] ?? '',
            minNumber: item['min_number'] ?? '',
            maxNumber: item['max_number'] ?? '',
            darsadVisitor: item['darsad_visitor'] ?? '',
          );
        }).toList();

        // ذخیره محصولات در Hive
        await _productBox.clear(); // پاک‌سازی محصولات قبلی
        for (var product in _products) {
          await _productBox.put(product.id, product); // ذخیره محصول در Hive
        }
        notifyListeners();
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
