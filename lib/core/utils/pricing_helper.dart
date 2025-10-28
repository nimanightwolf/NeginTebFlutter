import 'package:flutter/material.dart';
import 'package:neginteb/core/utils/price_formatter.dart';
import 'package:neginteb/data/models/product.dart';

class PricingInfo {
  final String mainLineText;
  final Color mainLineColor;

  final bool showOriginalLine;
  final String? originalLineLabel;
  final String? originalLineValue;

  final bool showOfferRibbon;        // افر غیرنقدی (offer)
  final String offerRibbonText;

  final bool showCashOfferRibbon;    // افر نقدی (offer_two)
  final String cashOfferRibbonText;

  final bool available;

  const PricingInfo({
    required this.mainLineText,
    required this.mainLineColor,
    required this.showOriginalLine,
    this.originalLineLabel,
    this.originalLineValue,
    required this.showOfferRibbon,
    required this.offerRibbonText,
    required this.showCashOfferRibbon,
    required this.cashOfferRibbonText,
    required this.available,
  });
}

int _asInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  final s = v.toString().replaceAll(',', '').trim();
  return int.tryParse(s) ?? 0;
}

String _asString(dynamic v) => (v ?? '').toString().trim();

PricingInfo buildPricingInfo(Product p) {
  // توجه: همه چیز رو امن می‌خونیم
  final int priceType = _asInt(p.priceType);        // "0" یا "1"
  final int priceVazn = _asInt(p.priceVazn);
  final String unit    = _asString(p.unit);
  final String price   = _asString(p.price);        // ممکنه خالی باشه
  final int offer      = _asInt(p.offer);           // درصد افر غیرنقدی
  final int offerTwo   = _asInt(p.offerTwo);        // درصد افر نقدی

  // حالت ناموجود
  if (priceType == 0) {
    return const PricingInfo(
      mainLineText: 'نا موجود',
      mainLineColor: Colors.red,
      showOriginalLine: false,
      originalLineLabel: null,
      originalLineValue: null,
      showOfferRibbon: false,
      offerRibbonText: '',
      showCashOfferRibbon: false,
      cashOfferRibbonText: '',
      available: false,
    );
  }

  // price_type == 1:
  final String basePriceNumber = formatPrice(priceVazn);
  final String baseLine = 'قیمت هر $unit $basePriceNumber ریال';

  // اگر فیلد price خالی بود → نمایش قیمتِ واحد و افر احتمالی
  if (price.isEmpty) {
    if (offer != 0) {
      final int pOffer = (priceVazn - ((priceVazn * offer) ~/ 100));
      final String pOfferStr = formatPrice(pOffer);
      final String offerLine = 'قیمت هر $unit با تخفیف $pOfferStr ریال';

      return PricingInfo(
        mainLineText: offerLine,
        mainLineColor: Colors.red,
        showOriginalLine: true,
        originalLineLabel: 'قیمت هر $unit',
        originalLineValue: '$basePriceNumber ریال',
        showOfferRibbon: true,
        offerRibbonText: '$offer% افر',
        showCashOfferRibbon: offerTwo != 0,
        cashOfferRibbonText: offerTwo != 0 ? '$offerTwo% افر نقدی' : '',
        available: true,
      );
    } else {
      return PricingInfo(
        mainLineText: baseLine,
        mainLineColor: const Color(0xFF1E88E5), // رنگ قبلی شما برای قیمت عادی
        showOriginalLine: false,
        originalLineLabel: null,
        originalLineValue: null,
        showOfferRibbon: false,
        offerRibbonText: '',
        showCashOfferRibbon: offerTwo != 0,
        cashOfferRibbonText: offerTwo != 0 ? '$offerTwo% افر نقدی' : '',
        available: true,
      );
    }
  }

  // اگر price خالی نبود → همان را (قرمز) نشان بده و روبان افر معمولی را مخفی کن
  return PricingInfo(
    mainLineText: price,
    mainLineColor: Colors.red,
    showOriginalLine: false,
    originalLineLabel: null,
    originalLineValue: null,
    showOfferRibbon: false,
    offerRibbonText: '',
    showCashOfferRibbon: offerTwo != 0,
    cashOfferRibbonText: offerTwo != 0 ? '$offerTwo% افر نقدی' : '',
    available: true,
  );
}
