import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';


import '../../../../data/models/banner_data.dart';
import '../../../../data/models/product_ids.dart';
import '../../../../data/models/product.dart';
import '../../../../shared/services/api/api_service.dart';
import 'dart:convert'; // برای jsonEncode/jsonDecode


class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  final Dio _dio = Dio();

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  late Box<Product> _productBox;
  late Box<ProductIds> _productIdsBox;
  late Box<BannerData> _bannerDataBox;
  // باز کردن دیتابیس Hive
  Future<void> openDatabase() async {
    _productBox = await Hive.openBox<Product>('products');
    _productIdsBox = await Hive.openBox<ProductIds>('product_ids');
    _bannerDataBox = await Hive.openBox<BannerData>('banner_data');
  }
  Future<void> savePopularProducts(List<String> productIds) async {
    final productIdsData = ProductIds(
      popularProductIds: productIds,
      specialOfferProductIds: [],
      newProductIds: [],
    );
    await _productIdsBox.put('popular_products', productIdsData);
  }
  // ذخیره لیست پیشنهادات ویژه امروز
  Future<void> saveSpecialOfferProducts(List<String> productIds) async {
    final productIdsData = ProductIds(
      popularProductIds: [],
      specialOfferProductIds: productIds,
      newProductIds: [],
    );
    await _productIdsBox.put('special_offer_products', productIdsData);
  }

  // ذخیره لیست جدیدترین محصولات
  Future<void> saveNewProducts(List<String> productIds) async {
    final productIdsData = ProductIds(
      popularProductIds: [],
      specialOfferProductIds: [],
      newProductIds: productIds,
    );
    await _productIdsBox.put('new_products', productIdsData);
  }
  // ذخیره بنرها
  Future<void> saveBanners(List<BannerData> banners) async {
    await _bannerDataBox.clear();  // پاک‌سازی بنرهای قبلی
    for (var banner in banners) {
      await _bannerDataBox.add(banner);  // ذخیره بنر در Hive
    }
  }

  // دریافت لیست محصولات محبوب
  List<String> getPopularProductIds() {
    final productIds = _productIdsBox.get('popular_products');
    return productIds != null ? productIds.popularProductIds : [];
  }

  // دریافت لیست پیشنهادات ویژه امروز
  List<String> getSpecialOfferProductIds() {
    final productIds = _productIdsBox.get('special_offer_products');
    return productIds != null ? productIds.specialOfferProductIds : [];
  }

  // دریافت لیست جدیدترین محصولات
  List<String> getNewProductIds() {
    final productIds = _productIdsBox.get('new_products');
    return productIds != null ? productIds.newProductIds : [];
  }

  // دریافت بنرها
  List<BannerData> getBanners() {
    return _bannerDataBox.values.toList();  // تمام بنرها
  }

  // درخواست API برای دریافت محصولات
  Future<void> fetchProducts() async {
    print("fetchProducts nimaa");
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
            packing: _normalizePacking(item['packing']),
           // packing: item['packing'].toString() ?? '',
            //packing:'',

            priceVazn: item['pricevazn'] ?? "0",  // فرض کنید که مقدار عددی است
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
        List<String> productIds = [
          "195",
          "720",
          "721",
          "722"
        ];
        final top5Ids = _products
            .where(_hasAnyImage)                 // فقط با حداقل یک عکس
            .map((p) => (p.id).toString())
            .where((id) => id.isNotEmpty)        // آی‌دی خالی حذف
            .toSet()                              // یکتا؛ ترتیب اولین وقوع حفظ می‌شود
            .take(5)
            .toList();
        // ProductIds productIds2=ProductIds(popularProductIds:productIds, specialOfferProductIds: productIds, newProductIds: productIds);
        // await _productIdsBox.put('popular_products', productIds2);
        savePopularProducts(top5Ids);
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
  bool _notBlank(String? s) =>
      s != null && s.trim().isNotEmpty && s.trim().toLowerCase() != 'null';

  bool _hasAnyImage(Product p) =>
      _notBlank(p.image1) || _notBlank(p.image2) || _notBlank(p.image3);

  // دریافت محصولات از دیتابیس Hive
  List<Product> getProductsFromDatabase() {
    print("getProductsFromDatabase");
    print(_productBox.values.length);
    if(_productBox.values.isEmpty){
      fetchProducts();
    }
    return _productBox.values.toList(); // دریافت تمام محصولات از Hive
  }
  Future<Product> getProductsFromDatabaseById(String id) async {
    print("getProductsFromDatabaseById");
    print(_productBox.get(id)?.id.toString());
   // return _productBox.get(id); // دریافت  محصول از Hive
    try {
      // شبیه‌سازی تاخیر کوتاه اگر لازم باشه
      await Future.delayed(Duration(milliseconds: 50));

      final product = _productBox.get(id); // مستقیم از Hive با key
      return product!;
    } catch (e) {
      print("Error getting product by ID: $e");
      return Product(id: '', userId: '', title: '', nameHolo: '', nameLatin: '', country: '', dateEx: '', datePd: '', price: '', priceType: '', description: '', keyWord: '', furmol: '', category: '', date: '', status: '', image1: '', image2: '', image3: '', isShowImage4: '', stiker: '', packing: '', priceVazn: '', priceH: '', priceVaznH: '', unit: '', mojodiAll: '', wast: '', linkPdf: '', priceShopUs: '', sort: '', categoryTitle: '', relate: '', offer: '', linkVideo: '', naghdi: '', delet: '', offerTwo: '', idHolo: '', artNo: '', fourmulOne: '', fourmulTwo: '', minNumber: '', maxNumber: '', darsadVisitor: '');
    }
  }

  List<Product> getPopularProductsFromDatabase() {
    // دریافت idهای محبوب از دیتابیس
    List<String> popularProductIds = getPopularProductIds();

    // فیلتر کردن محصولات بر اساس idهای موجود در popularProductIds
    List<Product> filteredProducts = _productBox.values.where((product) {
      return popularProductIds.contains(product.id);  // بررسی اینکه id محصول در لیست popularProductIds باشد
    }).toList();
    print("${filteredProducts.length}getPopularProductsFromDatabase");

    return filteredProducts;
  }

  List<String> getStoryImages() {
    final shuffledHotels = List<Product>.from(_products)..shuffle();
    return shuffledHotels.where((product) => product.image1.isNotEmpty).take(3).map((hotel) => hotel.image1).toList();
  }

  final List<String> _storyTitles = ["تضمین اصالت و خلوص محصولات", "پوشش کامل نیازهای دارویی و آزمایشگاهی", "محصولات تأییدشده و خالص"];

  List<String> get storyTitles => _storyTitles;
}
String _normalizePacking(dynamic raw) {
  // خروجی: یک رشته‌ی JSON معتبر
  // ورودی ممکن است: null | String | List | Map (مثل نمونه‌ای که دادی)
  if (raw == null) return '[]';

  if (raw is String) {
    // اگر خودِ سرور رشته برگردونده: سعی کن ببینی JSON هست یا CSV ساده
    final s = raw.trim();
    if (s.isEmpty) return '[]';

    // اگر رشته با [ یا { شروع می‌شود، احتمالاً JSON است → همان را ذخیره کن
    if (s.startsWith('[') || s.startsWith('{')) {
      return s;
    }

    // در غیر این صورت: CSV مثل "60,100,250"
    final parts = s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
    final list = parts
        .map((e) => double.tryParse(e) ?? 0)
        .where((v) => v > 0)
        .toList();
    return jsonEncode(list.map((v) => {'vazn': v}).toList());
  }

  if (raw is List) {
    // نمونه‌ای که دادی: [{id_product_holo: 505170, number: 1425, vazn: 25, id: 505170}]
    // مستقیم JSON کن
    return jsonEncode(raw);
  }

  if (raw is Map) {
    // اگر به‌جای لیست، یک شیء واحد آمد
    return jsonEncode([raw]);
  }

  // هر چیز ناشناخته‌ای → آرایه‌ی خالی
  return '[]';
}
