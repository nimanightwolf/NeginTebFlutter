// lib/features/common/widgets/generated_chemical_image.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:neginteb/data/models/product.dart';

/// ویجت تصویرِ ساخته‌شونده برای محصولات شیمی.
/// شرط نمایش پیشنهادی: [GeneratedChemicalImage.shouldUse(product)]
/// یعنی: product.isShowImage4 == '1' && product.category == 'shimi'
class GeneratedChemicalImage extends StatelessWidget {
  /// نام لاتین محصول (سمت راست بالا)
  final String nameLatin;

  /// واحد فارسی: "گرم" | "سی سی" | "لیتر" | ...
  final String unitFa;

  /// آخرین وزن از packing (مثلاً 25)
  final String lastVazn;

  /// نام کشور (لاتین یا هرچی لازم داری)
  final String countryLatin;

  /// تاریخ انقضا (مثلاً "2026.04")
  final String dateEx;

  /// اندازه‌ها و سبک‌ها
  final double width;
  final double? height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final bool showOuterBorder;
  final double fontSize;      // سایز متن‌ها
  final double lineSpacing;   // فاصله خطوط

  /// رنگ‌ها (قابل سفارشی‌سازی)
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Color nameColor;      // رنگ nameLatin
  final Color textColor;      // رنگ سایر متن‌ها

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
  });

  /// سازندهٔ راحت از روی [Product]
  /// می‌تونی اندازهٔ فونت و فاصله خطوط را برای دیتیل بزرگ‌تر بدهی.
  factory GeneratedChemicalImage.fromProduct(
      Product p, {
        double width = 120,
        double? height,
        double fontSize = 12,
        double lineSpacing = 4,
        Color backgroundColor = Colors.white,
        Color borderColor = Colors.black87,
        double borderWidth = 1,
        Color nameColor = Colors.red,
        Color textColor = Colors.black,
        EdgeInsets margin = const EdgeInsets.all(10),
        EdgeInsets padding = const EdgeInsets.all(8),
        bool showOuterBorder = true,
      }) {
    final lastVazn = _lastVaznFromPacking(p.packing);
    return GeneratedChemicalImage(
      nameLatin: p.nameLatin,
      unitFa: p.unit,
      lastVazn: lastVazn,
      countryLatin: p.country, // اگر فیلد country_latin داری، جایگزین کن
      dateEx: p.dateEx,
      width: width,
      height: height,
      fontSize: fontSize,
      lineSpacing: lineSpacing,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      nameColor: nameColor,
      textColor: textColor,
      margin: margin,
      padding: padding,
      showOuterBorder: showOuterBorder,
    );
  }

  /// آیا برای این محصول باید تصویر ساخته شود؟
  static bool shouldUse(Product p) =>
      p.isShowImage4 == '1' && p.category == 'shimi';

  /// استخراج آخرین وزن از packing (که در مدل به‌صورت JSON رشته‌ای ذخیره شده).
  static String _lastVaznFromPacking(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List && decoded.isNotEmpty) {
        final last = decoded.last;
        if (last is Map && last['vazn'] != null) {
          return last['vazn'].toString();
        }
      }
    } catch (_) {}
    return '';
  }

  /// نگاشت واحد فارسی به پسوند لاتین
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

  /// محاسبه تاریخ تولید (P.D) از روی تاریخ انقضا (E.D) با کسر ۴ سال
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
            ? BoxDecoration(
          border: Border.all(color: borderColor, width: borderWidth),
        )
            : null,
        child: Stack(
          children: [
            // متن‌ها (بدون خط داخلی)
            Positioned(
              right: 6,
              top: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    nameLatin,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: nameColor,
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize,
                    ),
                  ),
                  SizedBox(height: lineSpacing),
                  Text(
                    'Net.w: $lastVazn$suffix',
                    style: TextStyle(fontSize: fontSize, color: textColor),
                  ),
                  Text(
                    'P.D: $pd',
                    style: TextStyle(fontSize: fontSize, color: textColor),
                  ),
                  Text(
                    'E.D: $dateEx',
                    style: TextStyle(fontSize: fontSize, color: textColor),
                  ),
                  Text(
                    countryLatin,
                    style: TextStyle(fontSize: fontSize, color: textColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
