import 'package:flutter/foundation.dart';

class CartItem {
  final String idT;            // id_t
  final String idProduct;      // id_product
  final String idHolo;         // id_holo
  final String title;          // title
  final String unit;           // unit
  final String vazn;           // وزن بسته
  final int number;            // تعداد
  final int priceNaghdi;       // price_naghdi
  final int priceAdi;          // price_adi (غیرنقدی)
  final int naghdiN;           // 1=نقدی انتخاب شده
  final int naghdiAll;         // 1=فقط نقدی
  final String nameLatin;      // name_latin

  CartItem({
    required this.idT,
    required this.idProduct,
    required this.idHolo,
    required this.title,
    required this.unit,
    required this.vazn,
    required this.number,
    required this.priceNaghdi,
    required this.priceAdi,
    required this.naghdiN,
    required this.naghdiAll,
    required this.nameLatin,
  });

  factory CartItem.fromJson(Map<String, dynamic> j){
    return CartItem(
      idT: (j['id_t'] ?? '').toString(),
      idProduct: (j['id_product'] ?? '').toString(),
      idHolo: (j['id_holo'] ?? j['idho'] ?? '').toString(),
      title: (j['title'] ?? '').toString(),
      unit: (j['unit'] ?? '').toString(),
      vazn: (j['vazn'] ?? '').toString(),
      number: int.tryParse(j['number']?.toString() ?? '0') ?? 0,
      priceNaghdi: (j['price_naghdi'] is int)
          ? j['price_naghdi']
          : int.tryParse(j['price_naghdi']?.toString() ?? '0') ?? 0,
      priceAdi: (j['price_adi'] is int)
          ? j['price_adi']
          : int.tryParse(j['price_adi']?.toString() ?? '0') ?? 0,
      naghdiN: int.tryParse(j['naghdi_n']?.toString() ?? '0') ?? 0,
      naghdiAll: int.tryParse(j['naghdi_all']?.toString() ?? '0') ?? 0,
      nameLatin: (j['name_latin'] ?? '').toString(),
    );
  }
}

class CartSummary {
  final int total;        // مبلغ کل
  final int discountAll;  // مجموع تخفیف‌ها
  final int payable;      // قابل پرداخت

  CartSummary({required this.total, required this.discountAll, required this.payable});
}
