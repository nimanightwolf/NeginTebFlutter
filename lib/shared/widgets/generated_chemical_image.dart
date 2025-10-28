import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:neginteb/data/models/product.dart';

/// ویجت تصویرِ ساخته‌شونده برای محصولات شیمی.
/// شرط پیشنهادی: is_show_image4 == "1" و category == "shimi"
class GeneratedChemicalImage extends StatelessWidget {
  final String nameLatin;     // نام لاتین
  final String unitFa;        // "گرم" | "سی سی" | "لیتر" | ...
  final String lastVazn;      // آخرین وزن از packing
  final String countryLatin;  // کشور (در صورت نیاز latin)
  final String dateEx;        // مثل "2026.04"

  // استایل‌ها و اندازه‌ها
  final double width;
  final double? height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final bool showOuterBorder;
  final double fontSize;
  final double lineSpacing;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Color nameColor;
  final Color textColor;
  final bool centerText; // ➕ اضافه شد

  const GeneratedChemicalImage({
    super.key,
    required this.nameLatin,
    required this.unitFa,
    required this.lastVazn,
    required this.countryLatin,
    required this.dateEx,
    this.width = 120,
    this.height,
    this.margin = const EdgeInsets.all(10),
    this.padding = const EdgeInsets.all(8),
    this.showOuterBorder = true,
    this.fontSize = 12,
    this.lineSpacing = 4,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black87,
    this.borderWidth = 1,
    this.nameColor = Colors.red,
    this.textColor = Colors.black,
    this.centerText = false, // پیش‌فرض = چپ‌چین برای لیست‌ها
  });

  /// سازنده‌ی راحت از روی Product
  factory GeneratedChemicalImage.fromProduct(
      Product p, {
        double width = 120,
        double? height,
        double fontSize = 12,
        double lineSpacing = 4,
        EdgeInsets margin = const EdgeInsets.all(10),
        EdgeInsets padding = const EdgeInsets.all(8),
        bool showOuterBorder = true,
        Color backgroundColor = Colors.white,
        Color borderColor = Colors.black87,
        double borderWidth = 1,
        Color nameColor = Colors.red,
        Color textColor = Colors.black,
        bool centerText = false,
      }) {
    final lastVazn = _lastVaznFromPacking(p.packing);
    return GeneratedChemicalImage(
      nameLatin: p.nameLatin,
      unitFa: p.unit,
      lastVazn: lastVazn,
      countryLatin: p.country,
      dateEx: p.dateEx,
      width: width,
      height: height,
      fontSize: fontSize,
      lineSpacing: lineSpacing,
      showOuterBorder: showOuterBorder,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      nameColor: nameColor,
      textColor: textColor,
      centerText: centerText,
    );
  }

  static bool shouldUse(Product p) => p.isShowImage4 == '1' && p.category == 'shimi';

  static String _lastVaznFromPacking(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List && decoded.isNotEmpty) {
        final last = decoded.last;
        if (last is Map && last['vazn'] != null) return last['vazn'].toString();
      }
    } catch (_) {}
    return '';
  }

  static String _unitSuffix(String unitFa) {
    switch (unitFa.trim()) {
      case 'گرم':
        return ' g';
      case 'سی سی':
      case 'سي سي':
        return ' cc';
      case 'لیتر':
        return ' l';
      default:
        return '';
    }
  }

  static String _pdFromEd(String ed) {
    try {
      final parts = ed.split('.');
      if (parts.length >= 2) {
        final y = int.tryParse(parts[0]) ?? 0;
        final m = parts[1];
        return '${y - 4}.$m';
      }
      return ed;
    } catch (_) {
      return ed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final suffix = _unitSuffix(unitFa);
    final pd = _pdFromEd(dateEx);

    return Container(
      width: width,
      height: height ?? double.infinity,
      color: backgroundColor,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: showOuterBorder
            ? BoxDecoration(border: Border.all(color: borderColor, width: borderWidth))
            : null,
        child: Center( // 🔹 همه متن‌ها وسط‌چین شدند
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:  CrossAxisAlignment.center ,
            children: [
              Text(
                nameLatin,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center ,
                style: TextStyle(
                  color: nameColor,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize + 6, // 🔸 بزرگ‌تر برای جزئیات
                ),
              ),
              SizedBox(height: lineSpacing + 2),
              Text('Net.w: $lastVazn$suffix',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: fontSize + 4, color: textColor)),
              Text('P.D: $pd',
                  textAlign: TextAlign.center ,
                  style: TextStyle(fontSize: fontSize + 4, color: textColor)),
              Text('E.D: $dateEx',
                  textAlign:TextAlign.center,
                  style: TextStyle(fontSize: fontSize + 4, color: textColor)),
              Text(countryLatin,
                  textAlign: TextAlign.center ,
                  style: TextStyle(fontSize: fontSize + 4, color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}
