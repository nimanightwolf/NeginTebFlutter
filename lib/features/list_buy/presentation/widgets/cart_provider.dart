import 'package:flutter/material.dart';
import '../../../../shared/services/api/api_service.dart';
import '../../data/models/cart_item.dart';

String f3(int x) {
  final s = x.toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final p = s.length - i;
    b.write(s[i]);
    if (p > 1 && p % 3 == 1) b.write(',');
  }
  return b.toString();
}

class CartProvider with ChangeNotifier {
  // آدرس‌ها را با بک‌اندت هماهنگ کن
  static const _listEndpoint    = 'temp_product_list';
  static const _summaryEndpoint = 'get_total';
  static const _toggleItemPay   = 'change_naghdi_or_not_naghdi';
  static const _toggleAllPay    = 'change_naghdi_or_not_naghdi_list_id_t';
  static const _deleteEndpoint  = 'delete_temp';
  static const _submitEndpoint  = 'send_final_v13';

  bool _loading = false;
  bool get loading => _loading;

  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  CartSummary _summary = CartSummary(total: 0, discountAll: 0, payable: 0);
  CartSummary get summary => _summary;

  int _p(dynamic v) => int.tryParse(v?.toString() ?? '0') ?? 0;

  Future<void> load() async {
    _loading = true; notifyListeners();

    // 1) لیست آیتم‌ها
    final resList = await ApiService.post('temp_product_list', data: {'last_ad_id': 0});
    _items.clear();
    if (resList is List) {
      for (final m in resList) {
        _items.add(CartItem.fromJson(Map<String, dynamic>.from(m)));
      }
    }

    // 2) جمع‌های سرور
    final resSum = await ApiService.post('get_total', data: {});
    int _p(dynamic v) => int.tryParse(v?.toString() ?? '0') ?? 0;

    // طبق سرور: pricet = قابل پرداخت (مبنای محاسبه تخفیف)
    final int payableFromServer = (resSum is Map) ? _p(resSum['pricet']) : 0;
    print("payableFromServer"+payableFromServer.toString());

    // 3) مبلغ کل دینامیک بر اساس انتخاب فعلی آیتم‌ها
    int selectedTotal = 0;
    for (final it in _items) {
      final unitPrice = (it.naghdiAll == 1 || it.naghdiN == 1) ? it.priceNaghdi : it.priceAdi;
      selectedTotal += it.priceAdi;
    }

    // 4) اگر سرور pricet داد، تخفیف = selectedTotal - pricet و قابل پرداخت = pricet
    //    در غیر این صورت، تخفیف = 0 و قابل پرداخت = selectedTotal
    int discountAll, payable;
    if (payableFromServer > 0) {
      discountAll = (selectedTotal - payableFromServer);
      if (discountAll < 0) discountAll = 0; // محافظت
      payable     = payableFromServer;
    } else {
      discountAll = 0;
      payable     = selectedTotal;
    }

    _summary = CartSummary(
      total: selectedTotal,     // مثل عکس اول: 3,965,000
      discountAll: discountAll, // مثل عکس اول: 7,200
      payable: payable,         // مثل عکس اول: 3,957,800 (همان pricet)
    );

    _loading = false; notifyListeners();
  }


  Future<void> toggleItemNaghdi(CartItem it, {required bool naghdi}) async {
    await ApiService.post(_toggleItemPay, data: {
      'id_t': it.idT.toString(),
      'naghdi': naghdi ? 1 : 0,
      'id_holo_new': it.idHolo.toString(),
    });
    await load();
  }

  Future<void> toggleAll(bool naghdi) async {
    await ApiService.post(_toggleAllPay, data: {
      'naghdi': naghdi ? 1 : 0,
      'id_t': "0",
      'id_holo_new': "0",
    });
    await load();
  }

  Future<void> deleteItem(String idT) async {
    await ApiService.post(_deleteEndpoint, data: {'ad_id': idT, 'status': 1});
    await load();
  }

  Future<void> submitOrder({bool forceSendWithoutGateway=false}) async {
    await ApiService.post(_submitEndpoint, data: {
      'des': '',
      'number_vaziat_pardakht': forceSendWithoutGateway ? 2 : 1,
      'number_vaziat_magmoeh': '1',
    });
    await load();
  }
}
