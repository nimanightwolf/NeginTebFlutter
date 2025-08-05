// lib/database/app_database.dart

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../data/models/product.dart';


class AppDatabase {
  late Box<Product> productBox;

  // باز کردن دیتابیس
  Future<void> openDatabase() async {
    await Hive.initFlutter();
    productBox = await Hive.openBox<Product>('products');  // باز کردن باکس محصولات
  }

  // ذخیره محصول جدید
  Future<void> addProduct(Product product) async {
    await productBox.put(product.id, product);  // ذخیره محصول در باکس
  }

  // دریافت تمامی محصولات
  List<Product> getAllProducts() {
    return productBox.values.toList();  // دریافت تمام محصولات
  }

  // دریافت محصول با شناسه خاص
  Product? getProductById(String id) {
    return productBox.get(id);  // دریافت محصول با شناسه
  }

  // بستن دیتابیس
  Future<void> closeDatabase() async {
    await productBox.close();  // بستن باکس دیتابیس
  }
}
