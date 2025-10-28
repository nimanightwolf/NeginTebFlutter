import 'package:flutter/material.dart';
import 'package:neginteb/shared/services/api/api_service.dart';

import '../data/models/history_item.dart';

class HistoryProvider with ChangeNotifier {
  static const _epList   = 'history_shop';
  static const _epPayMul = 'pardakht_multi';

  final List<HistoryItem> _items = [];
  bool _loading = false;
  String? _error;
  bool _selectMode = false;

  List<HistoryItem> get items => List.unmodifiable(_items);
  bool get isLoading => _loading;
  bool get selectMode => _selectMode;
  String? get error => _error;

  Future<void> fetch() async {
    _loading = true;
    _error = null;
    _items.clear();
    notifyListeners();

    try {
      final res = await ApiService.post(_epList);
      if (res is List) {
        for (final r in res) {
          _items.add(HistoryItem.fromJson(Map<String, dynamic>.from(r as Map)));
        }
      } else {
        _error = 'پاسخ نامعتبر است';
      }
    } catch (_) {
      _error = 'دریافت لیست با خطا مواجه شد';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void toggleSelectMode([bool? on]) {
    _selectMode = on ?? !_selectMode;
    if (!_selectMode) {
      for (final it in _items) it.selected = false;
    }
    notifyListeners();
  }

  void toggleOne(String id) {
    final i = _items.indexWhere((e) => e.id == id);
    if (i >= 0) {
      _items[i].selected = !_items[i].selected;
      notifyListeners();
    }
  }

  List<String> get selectedIds =>
      _items.where((e) => e.selected).map((e) => e.id).toList();

  /// سرور انتظار دارد shop_id را به صورت "id1-id2-id3-" بگیرد (طبق کد قدیم)
  Future<String?> paySelected() async {
    final ids = selectedIds;
    if (ids.isEmpty) return null;

    final shopId = ids.join('-') + '-';
    final res = await ApiService.post(_epPayMul, data: {'shop_id': shopId});

    // طبق منطق جاوا: پاسخ مستقیماً URL درگاه بود.
    if (res is String) return res;
    if (res is Map && res['url'] is String) return res['url'] as String;
    if (res is List && res.isNotEmpty && res.first is String) return res.first as String;

    return null;
  }
}
