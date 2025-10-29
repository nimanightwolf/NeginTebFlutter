// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:neginteb/core/utils/network.dart';
import 'package:neginteb/core/utils/price_formatter.dart';
import 'package:neginteb/data/models/product.dart';
import 'package:neginteb/features/hotel_detail/presentation/full_screen_image_shower.dart';
import 'package:neginteb/features/hotel_detail/presentation/full_screen_generated_image.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:neginteb/shared/services/api/api_service.dart';
import 'package:neginteb/features/home/presentation/provider/product_provider.dart';
import 'package:neginteb/features/home/presentation/provider/profile_provider.dart';

import '../../../shared/widgets/generated_chemical_image.dart';

// ========== صفحه دیتیل ==========
class ProductDetailPage extends StatelessWidget {
  final String hotelId;
  const ProductDetailPage({super.key, required this.hotelId});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductProvider>();
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<Product>(
      future: provider.getProductsFromDatabaseById(hotelId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final product = snapshot.data!;
        final images = <String>[
          if (GeneratedChemicalImage.shouldUse(product)) '__generated__',
          product.image1, product.image2, product.image3,
        ].where((e) => e != null && e.trim().isNotEmpty).toList();

        final infoRaw = [
          {'label': 'نام لاتین', 'value': product.nameLatin, 'icon': Icons.science_outlined, 'ltr': true},
          {'label': 'گروه بندی', 'value': product.categoryTitle, 'icon': Icons.category_outlined, 'ltr': false},
          {'label': 'تاریخ انقضا', 'value': product.dateEx, 'icon': Icons.calendar_month_outlined, 'ltr': true},
          {'label': 'کشور سازنده', 'value': product.country, 'icon': Icons.location_on_outlined, 'ltr': true},
        ];
        final infoItems = infoRaw.where((m) => !_isBlank(m['value'] as String?)).toList();

        // ثبت مشاهده اخیر و لود محصولات پروفایل
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<ProfileProvider>().addRecentlyViewed(product.id);
        });




        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: false,
                expandedHeight: 300,
                elevation: 8,
                leading: IconButton(
                  onPressed: () => PersistentNavBarNavigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: GeneratedChemicalImage.shouldUse(product)
                      ? GeneratedChemicalImage.fromProduct(
                    product,
                    width: double.infinity,
                    height: double.infinity,
                    fontSize: 16,   // بزرگ‌تر برای هدر
                    lineSpacing: 6,
                  )
                      : GestureDetector(
                    onLongPress: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: FullScreenImageShower(myImageUrl: product.image1),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },
                    child: Image.network(networkUrl(product.image1), fit: BoxFit.cover),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                        child: Text(product.title, style: textTheme.headlineMedium, textDirection: TextDirection.rtl),
                      ),
                      SizedBox(height: 12),
                      Center(
                        child: Text(
                          "قیمت هر ${product.unit} ${formatPrice(int.tryParse(product.priceVazn) ?? 0)} ریال",
                          style: textTheme.headlineSmall,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(color: Colors.black, height: 1),

                      // گالری
                      SizedBox(height: 16),
                      Text("گالری تصاویر", style: textTheme.headlineSmall, textDirection: TextDirection.rtl),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            final img = images[index];
                            if (img == '__generated__') {
                              return Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: GestureDetector(
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: FullScreenGeneratedImage(product: product),
                                      withNavBar: false,
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: GeneratedChemicalImage.fromProduct(
                                      product,
                                      width: 140,
                                      height: 120,
                                      fontSize: 4, // مناسب thumbnail
                                      lineSpacing: 1,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: FullScreenImageShower(myImageUrl: img),
                                      withNavBar: false,
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        networkUrl(img),
                                        width: 120,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                if (index != images.length - 1) const SizedBox(width: 8),
                              ],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (infoItems.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFF2E7D32), width: 2),
                              bottom: BorderSide(color: Color(0xFF2E7D32), width: 2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (var i = 0; i < infoItems.length; i++) ...[
                                _InfoRow(
                                  label: infoItems[i]['label'] as String,
                                  value: (infoItems[i]['value'] as String).trim(),
                                  icon: infoItems[i]['icon'] as IconData,
                                  textTheme: textTheme,
                                  valueIsLTR: (infoItems[i]['ltr'] as bool?) ?? false,
                                  iconColor: const Color(0xFF2E7D32),
                                ),
                                if (i != infoItems.length - 1) const SizedBox(height: 16),
                              ],
                            ],
                          ),
                        ),

                      SizedBox(height: 16),
                      Text("توضیحات", style: textTheme.headlineSmall, textDirection: TextDirection.rtl),
                      SizedBox(height: 8),
                      Text(
                        product.description,
                        style: textTheme.bodyMedium!.copyWith(height: 1.5),
                        textDirection: TextDirection.rtl,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 8,
                      ),

                      // بخش محاسبه قیمت/بسته/تعداد/افزودن به سبد
                      _PricingSection(hotel: product),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ========== Info Row ==========
bool _isBlank(String? s) => s == null || s.trim().isEmpty;

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final TextTheme textTheme;
  final Color? iconColor;
  final bool valueIsLTR;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.textTheme,
    this.iconColor,
    this.valueIsLTR = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            value,
            style: textTheme.titleMedium,
            textAlign: TextAlign.left,
            textDirection: valueIsLTR ? TextDirection.ltr : TextDirection.rtl,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(width: 8),
            Icon(icon, size: 20, color: color),
          ],
        ),
      ],
    );
  }
}

// ========== Helpers ==========
double asDouble(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  if (v is String) {
    final s = v.replaceAll(',', '').trim();
    return double.tryParse(s) ?? 0;
  }
  return 0;
}

int _asInt(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toInt();
  final s = v.toString().replaceAll(',', '').trim();
  return int.tryParse(s) ?? 0;
}

String _toLatinDigits(String s) {
  const fa = ['۰','۱','۲','۳','۴','۵','۶','۷','۸','۹','٬','،'];
  const en = ['0','1','2','3','4','5','6','7','8','9',',',','];
  for (var i = 0; i < fa.length; i++) {
    s = s.replaceAll(fa[i], en[i]);
  }
  return s;
}

/// parsing JSON packing → لیست وزن‌ها
List<double> packingsFromString(String? packingJson) {
  if (packingJson == null || packingJson.trim().isEmpty) return [];
  try {
    final raw = _toLatinDigits(packingJson.trim());
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded.map<double>((e) => asDouble(e['vazn'])).where((v) => v > 0).toList();
    }
    if (decoded is Map) {
      final v = asDouble(decoded['vazn']);
      return v > 0 ? [v] : [];
    }
  } catch (_) {}
  return [];
}

/// موجودی برای وزن انتخابی
int checkMojodePack({required String? packingJson, required double selectedPacking}) {
  if (packingJson == null || packingJson.trim().isEmpty) return 0;
  try {
    final raw = _toLatinDigits(packingJson.trim());
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      for (final e in decoded) {
        if (e is Map) {
          final v = asDouble(e['vazn']);
          if ((v - selectedPacking).abs() < 1e-6) return _asInt(e['number']);
        }
      }
    } else if (decoded is Map) {
      final v = asDouble(decoded['vazn']);
      if ((v - selectedPacking).abs() < 1e-6) return _asInt(decoded['number']);
    }
  } catch (_) {}
  return 0;
}

void _showSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg, textDirection: TextDirection.rtl)));
}

// ========== Pricing Section ==========
enum PaymentType { nonCash, cashWithOffer }

class _PricingSection extends StatefulWidget {
  final Product hotel;
  const _PricingSection({required this.hotel});

  @override
  State<_PricingSection> createState() => _PricingSectionState();
}

class _PricingSectionState extends State<_PricingSection> {
  late double selectedPacking;
  int qty = 1;
  PaymentType paymentType = PaymentType.nonCash;

  @override
  void initState() {
    super.initState();
    final packs = packingsFromString(widget.hotel.packing);
    selectedPacking = packs.isNotEmpty ? packs.first : 0;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    final double pricePerUnit = asDouble(widget.hotel.priceVazn);
    final List<double> packings = packingsFromString(widget.hotel.packing);

    final double offerPercent = paymentType == PaymentType.nonCash
        ? asDouble(widget.hotel.offer)
        : asDouble(widget.hotel.offerTwo);

    final double pricePerSelectedPack = pricePerUnit * selectedPacking;
    final double priceAll = pricePerSelectedPack * qty;
    final int priceOfferAccrued = (priceAll * offerPercent / 100).round();
    final int priceAllWithOffer = (priceAll - priceOfferAccrued).round();

    Widget line() => Container(height: 2, color: const Color(0xFF2E7D32), margin: const EdgeInsets.symmetric(vertical: 10));

    Widget rowPrice({required String label, required int value, Color? valueColor, TextStyle? labelStyle}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(' ${formatPrice(value)} ریال', style: t.bodyMedium?.copyWith(color: valueColor ?? Colors.black87, fontWeight: FontWeight.w600), textDirection: TextDirection.rtl),
            Text(label, style: labelStyle ?? t.titleMedium, textDirection: TextDirection.rtl),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          line(),
          rowPrice(label: 'قیمت هر بسته انتخاب‌شده', value: pricePerSelectedPack.round(), valueColor: Colors.blue),
          rowPrice(label: 'قیمت هر بسته × تعداد', value: priceAll.round(), valueColor: Colors.blue, labelStyle: t.bodyMedium),
          rowPrice(label: 'مبلغ افر شما', value: priceOfferAccrued, valueColor: Colors.red),
          rowPrice(label: 'مبلغ قابل پرداخت پس از افر', value: priceAllWithOffer, valueColor: Colors.red),
          line(),

          Center(child: Text('انتخاب بسته‌بندی', style: t.headlineSmall, textDirection: TextDirection.rtl)),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('گرمی', style: t.titleMedium, textDirection: TextDirection.rtl),
              const SizedBox(width: 12),
              DropdownButton<double>(
                value: selectedPacking,
                items: packings.map((g) => DropdownMenuItem(
                  value: g,
                  child: Text(g % 1 == 0 ? g.toStringAsFixed(0) : g.toString(), textDirection: TextDirection.ltr),
                )).toList(),
                onChanged: (v) => setState(() => selectedPacking = v ?? selectedPacking),
              ),
              const SizedBox(width: 12),
              Text('بستهٔ', style: t.titleMedium, textDirection: TextDirection.rtl),
            ],
          ),

          const SizedBox(height: 16),

          Center(child: Text('تعداد', style: t.headlineSmall, textDirection: TextDirection.rtl)),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => setState(() => qty = qty > 1 ? qty - 1 : 1),
                child: Container(
                  width: 64, height: 48, alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                  child: const Icon(Icons.remove, size: 28, color: Colors.red),
                ),
              ),
              const SizedBox(width: 24),
              Text('$qty', style: t.headlineMedium),
              const SizedBox(width: 24),
              InkWell(
                onTap: () {
                  final available = checkMojodePack(packingJson: widget.hotel.packing, selectedPacking: selectedPacking);
                  if (available <= 0) return _showSnack(context, 'موجودی این بسته صفر است');
                  if (qty < available) setState(() => qty++);
                  else _showSnack(context, 'حداکثر تعداد مجاز: $available');
                },
                child: Container(
                  width: 64, height: 48, alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                  child: const Icon(Icons.add, size: 28, color: Color(0xFF2E7D32)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              '$qty بسته‌ی ${selectedPacking.toStringAsFixed(selectedPacking % 1 == 0 ? 0 : 2)} گرمی = ${(selectedPacking * qty).round()} گرم',
              style: t.titleLarge?.copyWith(color: Colors.red),
              textDirection: TextDirection.rtl,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                Radio<PaymentType>(
                  value: PaymentType.nonCash,
                  groupValue: paymentType,
                  onChanged: (v) => setState(() => paymentType = v!),
                  activeColor: const Color(0xFF2E7D32),
                ),
                Text('غیر نقدی', style: t.titleMedium, textDirection: TextDirection.rtl),
              ]),
              const SizedBox(width: 28),
              Row(children: [
                Radio<PaymentType>(
                  value: PaymentType.cashWithOffer,
                  groupValue: paymentType,
                  onChanged: (v) => setState(() => paymentType = v!),
                  activeColor: const Color(0xFF2E7D32),
                ),
                Text('نقدی (همراه با افر)', style: t.titleMedium, textDirection: TextDirection.rtl),
              ]),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43A047),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () async {
                final available = checkMojodePack(packingJson: widget.hotel.packing, selectedPacking: selectedPacking);
                if (available <= 0) return _showSnack(context, 'این بسته موجود نیست');
                //if (qty > available) return _showSnack(context, 'حداکثر موجودی این بسته: $available');

                final minLimit = _asInt(widget.hotel.minNumber);
                final maxLimit = _asInt(widget.hotel.maxNumber);
                // if (minLimit > 0 && qty < minLimit) return _showSnack(context, 'حداقل تعداد مجاز: $minLimit');
                if (maxLimit > 0 && qty > maxLimit) return _showSnack(context, 'حداکثر تعداد مجاز: $maxLimit');

                final int offerPercent = (paymentType == PaymentType.nonCash
                    ? asDouble(widget.hotel.offer)
                    : asDouble(widget.hotel.offerTwo)).round();

                final double pricePerUnit = asDouble(widget.hotel.priceVazn);
                final int priceAllWithOffer = (pricePerUnit * selectedPacking * qty * (100 - offerPercent) / 100).round();

                final data = {
                  'naghdi': paymentType == PaymentType.cashWithOffer ? "1" : "0",
                  'number': qty.toString(),
                  'price': priceAllWithOffer.toString(),
                  'packing': selectedPacking,
                  'id_packing_holo': widget.hotel.idHolo,
                  'ad_id': widget.hotel.id,
                  'status': widget.hotel.status,
                };

                final response = await ApiService.post('temp_product_new', data: data);
                if (response is Map && response['status'] == 'ok') {
                  _showSnack(context, "✅ محصول با موفقیت به سبد اضافه شد");
                  Navigator.pop(context);
                } else if (response == "ok") {
                  _showSnack(context, "✅ محصول با موفقیت به سبد اضافه شد");
                  Navigator.pop(context);
                } else if (response == "a" || response == "not_enough") {
                  _showSnack(context, "❌ موجودی این محصول کافی نیست");
                } else {
                  _showSnack(context, "⚠️ خطا در دریافت اطلاعات از سرور");
                }
              },
              child: Text('افزودن به سبد خرید', style: t.titleLarge?.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
