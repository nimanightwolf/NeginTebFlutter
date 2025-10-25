import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';

import '../../../../shared/services/api/api_service.dart';
import '../data/models/category_model.dart';


/// اگر در UI از کلاس ساده‌ی Category (برای ویجت شش‌ضلعی) استفاده می‌کنی
/// می‌تونیم یک DTO سبک هم تعریف کنیم:
class UiCategory {
  final String id;
  final String title;
  final String image;   // asset یا url
  final bool isNetwork;

  UiCategory({
    required this.id,
    required this.title,
    required this.image,
    required this.isNetwork,
  });
}

class CategoryProvider with ChangeNotifier {
  final Dio _dio = Dio();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  late Box<CategoryModel> _categoryBox;
  late Box _metaBox; // برای نگهداری چیزهای ساده مثل لیست آیدی‌های ویژه، زمان به‌روزرسانی، ...

  /// باز کردن باکس‌ها
  Future<void> openDatabase() async {
    _categoryBox = await Hive.openBox<CategoryModel>('categories');
    _metaBox = await Hive.openBox('categories_meta'); // generic box
  }

  /// تبدیل CategoryModel به UiCategory (برای ویجت)
  UiCategory toUi(CategoryModel c) => UiCategory(
    id: c.idcat,
    title: c.title,
    image: c.image,
    isNetwork: !c.is_image, // طبق مدل تو: اگر is_image=true یعنی asset؛ وگرنه url
  );

  /// کش‌کردن لیست آیدی‌های «محبوب/پیشنهادی/…» (اختیاری)
  Future<void> saveFeaturedCategoryIds(List<String> ids) async {
    await _metaBox.put('featured_category_ids', ids);
  }

  List<String> getFeaturedCategoryIds() {
    final v = _metaBox.get('featured_category_ids');
    if (v is List) {
      return v.map((e) => e.toString()).toList();
    }
    return [];
  }

  /// لود از API و ذخیره در Hive
  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      // اگر API آماده‌ست، آدرسِ درست خودت رو جایگزین کن
      // نمونه با POST شبیه الگوی خودت:
      final response = await ApiService.post(
        'get_category_list', // endpoint نمونه
        data: {
          // هر پارامتر لازم
        },
      );

      if (response is List && response.isNotEmpty) {
        // پاکسازی قبلی و نوشتن جدید
        await _categoryBox.clear();

        _categories = response.map<CategoryModel>((item) {
          return CategoryModel(
            idcat: (item['idcat'] ?? item['id'] ?? '').toString(),
            title: item['title']?.toString() ?? '',
            key_category: item['key_category']?.toString() ?? '',
            image: item['image']?.toString() ?? '',
            // اگر API فیلد باینری/بولین دیگری می‌دهد، به is_image نگاشت کن
            is_image: (item['is_image'] is bool)
                ? item['is_image'] as bool
                : (item['is_image']?.toString() == '1'),
          );
        }).toList();

        // ذخیره در Hive با کلید idcat
        for (final c in _categories) {
          await _categoryBox.put(c.idcat, c);
        }

        // نمونه: ساخت Featured از اولین 6 تا
        final featuredIds = _categories
            .map((e) => e.idcat)
            .where((id) => id.isNotEmpty)
            .take(6)
            .toList();
        await saveFeaturedCategoryIds(featuredIds);

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// گرفتن همه‌ی دسته‌ها از Hive (و در صورت خالی بودن، درخواست API)
  List<CategoryModel> getCategoriesFromDatabase() {
    if (_categoryBox.isEmpty) {
      // non-blocking: بگذار پس‌زمینه پر شود و صفحه فعلی با خالی نمایش بده
      fetchCategories();
      return [];
    }
    _categories = _categoryBox.values.toList();
    return _categories;
  }

  /// گرفتن یک دسته بر اساس id
  CategoryModel? getCategoryById(String idcat) {
    return _categoryBox.get(idcat);
  }

  /// تبدیل خروجی دیتابیس به مدل مناسب UI
  List<UiCategory> getUiCategories() {
    final list = _categoryBox.values.toList();
    return list.map(toUi).toList();
  }

  /// فقط دسته‌های ویژه (بر اساس آیدی‌های ذخیره‌شده)
  List<UiCategory> getFeaturedUiCategories() {
    final ids = getFeaturedCategoryIds();
    if (ids.isEmpty) return [];
    final list = ids
        .map((id) => _categoryBox.get(id))
        .whereType<CategoryModel>()
        .map(toUi)
        .toList();
    return list;
  }

  /// جست‌وجو در دسته‌ها
  List<UiCategory> search(String query) {
    final q = query.trim();
    if (q.isEmpty) return getUiCategories();
    final list = _categoryBox.values.where((c) {
      return c.title.contains(q) ||
          c.key_category.contains(q) ||
          c.idcat == q;
    }).map(toUi).toList();
    return list;
  }

  /// ریفرش دستی (کش پاک و API دوباره)
  Future<void> refresh() async {
    await _categoryBox.clear();
    await fetchCategories();
  }
}
