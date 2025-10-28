class HistoryItem {
  final String id;              // number_shop یا id
  final String dateShow;        // "04/07/14"
  final int? dateEpoch;         // برای محاسبه «چند روز پیش»
  final String status;          // "0".."5"
  final String? destName;       // daroo_h
  final int? price;             // مبلغ فاکتور
  final String? factor;         // شماره فاکتور
  final String tasfieh;         // "تسويه شده" یا ...
  final int? mandeh;            // مهلت پرداخت با افر
  final int? mandehAll;         // مهلت تسویه کلی
  final int? priceOffer;        // مقدار افر نقدی
  bool selected;                // برای پرداخت چندتایی

  HistoryItem({
    required this.id,
    required this.dateShow,
    required this.status,
    required this.tasfieh,
    this.dateEpoch,
    this.destName,
    this.price,
    this.factor,
    this.mandeh,
    this.mandehAll,
    this.priceOffer,
    this.selected = false,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> j) {
    String s(dynamic v) => (v ?? '').toString().trim();
    int? asInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      final t = s(v).replaceAll(',', '');
      return int.tryParse(t);
    }

    return HistoryItem(
      id: s(j['number_shop'].toString().isNotEmpty ? j['number_shop'] : j['id']),
      dateShow: s(j['date_show']),
      dateEpoch: asInt(j['date']),
      status: s(j['status']),
      destName: s(j['daroo_h']).isEmpty ? null : s(j['daroo_h']),
      price: asInt(j['price']),
      factor: s(j['factor']).isEmpty || s(j['factor']) == 'null' ? null : s(j['factor']),
      tasfieh: s(j['tasfieh']).isEmpty ? 'نامشخص' : s(j['tasfieh']),
      mandeh: asInt(j['mandeh']),
      mandehAll: asInt(j['mandeh_all']),
      priceOffer: asInt(j['price_offer']),
      selected: false,
    );
  }
}
