import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:neginteb/features/home/presentation/provider/product_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neginteb/shared/services/api/api_service.dart';

import '../../../../data/models/product.dart';
import '../../../profile/data/models/profile_models.dart';


class ProfileProvider with ChangeNotifier {
  static const _spKey = 'profile_cache_json';
  ProfileData? _profile;
  bool _loading = false;
  String? _error;
  static const _kRecentlyViewedKey = 'recently_viewed_ids';
  static const _maxRecently = 20;

  // فقط آیدی‌ها را نگه می‌داریم، ترتیب: جدیدترین اول
  final List<String> _recentlyViewedIds = [];
  List<String> get recentlyViewedIds => List.unmodifiable(_recentlyViewedIds);

  ProfileData? get profile => _profile;
  bool get isLoading => _loading;
  String? get error => _error;

  ProfileProvider() {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // خواندن کش لوکال برای سرعت اولیه
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_spKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        _profile = ProfileData.fromJsonString(raw);
        notifyListeners();
      } catch (_) {}
    }
    // سپس تازه‌سازی آنلاین
    await refreshFromServer();
  }

  /// دریافت از `profile` و ذخیره در SharedPreferences
  Future<void> refreshFromServer() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await ApiService.post('profile'); // user_id به‌صورت خودکار تزریق می‌شود
      if (res is Map) {
        final data = ProfileData.fromApi(Map<String, dynamic>.from(res));
        _profile = data;

        final sp = await SharedPreferences.getInstance();
        await sp.setString(_spKey, data.toJsonString());
      } else {
        _error = 'پاسخ نامعتبر از سرور';
      }
    } catch (e) {
      _error = 'خطا در دریافت پروفایل';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// آپدیت‌های کوچک کلاینتی (مثلاً تغییر آدرس) و ذخیره محلی
  Future<void> updateLocal({
    String? name,
    String? address,
    String? description,
  }) async {
    if (_profile == null) return;
    final current = _profile!;
    _profile = ProfileData(
      id: current.id,
      name: name ?? current.name,
      mobile: current.mobile,
      email: current.email,
      permissions: current.permissions,
      notShowPrice: current.notShowPrice,
      hamkar: current.hamkar,
      des: description ?? current.des,
      showPrice: current.showPrice,
      priceHamkar: current.priceHamkar,
      updatedAtEpoch: current.updatedAtEpoch,
      address: address ?? current.address,
      moaref: current.moaref,
      dateMoaref: current.dateMoaref,
      lastSeenJalali: current.lastSeenJalali,
      lastSeenEpoch: current.lastSeenEpoch,
      idCompany: current.idCompany,
      comionRate: current.comionRate,
      comion: current.comion,
      rate: current.rate,
      textRate: current.textRate,
      status: current.status,
      activity: current.activity,
      lat: current.lat,
      lan: current.lan,
      description: description ?? current.description,
      visitorAva: current.visitorAva,
      version: current.version,
      meli: current.meli,
      semat: current.semat,
      dateInstall: current.dateInstall,
      updateNew: current.updateNew,
      model: current.model,
      pushId: current.pushId,
      newUserApp: current.newUserApp,
      androidId: current.androidId,
      deviceName: current.deviceName,
      deviceModel: current.deviceModel,
      androidVersion: current.androidVersion,
      vi: current.vi,
      deleteFlag: current.deleteFlag,
      dateTemp: current.dateTemp,
      token: current.token,
      tokenExpires: current.tokenExpires,
      priceAll: current.priceAll,
      categories: current.categories,
      commissions: current.commissions,
    );

    final sp = await SharedPreferences.getInstance();
    await sp.setString(_spKey, _profile!.toJsonString());
    notifyListeners();
  }

  /// پاک کردن کش محلی (مثلاً هنگام لاگ‌اوت)
  Future<void> clearLocal() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_spKey);
    _profile = null;
    notifyListeners();
  }
  Future<void> addRecentlyViewed(String productId) async {
    if (productId.isEmpty) return;
    _recentlyViewedIds.remove(productId);
    _recentlyViewedIds.insert(0, productId);
    if (_recentlyViewedIds.length > _maxRecently) {
      _recentlyViewedIds.removeRange(_maxRecently, _recentlyViewedIds.length);
    }
    await _persistRecentlyViewed();
    notifyListeners();
  }

  /// گرفتن لیست محصول‌ها بر اساس آیدی‌های ذخیره‌شده
  List<Product> recentlyViewedProducts(ProductProvider productProvider) {
    final map = {
      for (final p in productProvider.products) p.id: p
    };
    // فقط آنهایی که هنوز در دیتاست هستند
    return _recentlyViewedIds
        .map((id) => map[id])
        .where((p) => p != null)
        .cast<Product>()
        .toList();
  }

  // ---- Persistence ----
  Future<void> _loadRecentlyViewedFromStorage() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kRecentlyViewedKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final List<dynamic> arr = jsonDecode(raw);
        _recentlyViewedIds
          ..clear()
          ..addAll(arr.map((e) => e.toString()));
        notifyListeners();
      } catch (_) {/* نادیده بگیر */}
    }
  }

  Future<void> _persistRecentlyViewed() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kRecentlyViewedKey, jsonEncode(_recentlyViewedIds));
  }
}

