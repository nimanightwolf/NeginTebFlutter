import 'package:dio/dio.dart';




class ProductRepository {
  final Dio dio;
 // final AppDatabase database;

  ProductRepository({
    required this.dio,
  //  required this.database,
  });

  /// دریافت محصولات از API و ذخیره در دیتابیس
  Future<void> fetchAndStoreProducts() async {
    try {
      final response = await dio.post('https://shimetebnegin.ir/api/new_app_api/api/get_category_list',data: {
        "search_key": "",
        "category": "shimi",
        "last_ad_id": "",
        "user_id": "1095"
      }
      );

      if (response.statusCode == 200 && response.data is List) {
        List productsJson = response.data;

        for (var json in productsJson) {
          //final product = Product.fromJson(json);
        //  final companion = product.toCompanion();
        //   await database.insertOrUpdateProduct(companion);
        }
      } else {
        throw Exception('خطا در دریافت داده‌ها');
      }
    } catch (e) {
      print('❌ خطا در دریافت محصولات: $e');
      rethrow;
    }
  }

  /// دریافت محصولات از دیتابیس (برای نمایش در UI)
  // Future<List<Product>> getLocalProducts() async {
  //   final rows = await database.getAllProducts();
  //   return rows.map((e) => e.toProduct()).toList();
  // }
}
