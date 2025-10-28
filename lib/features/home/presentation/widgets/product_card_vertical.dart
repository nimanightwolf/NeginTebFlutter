import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../../core/utils/network.dart';
import '../../../../core/utils/pricing_helper.dart';
import '../../../../data/models/product.dart';
import '../../../../shared/widgets/generated_chemical_image.dart';
import '../../../hotel_detail/presentation/product_detail_page.dart';

class ProductCardVertical extends StatelessWidget {
  final Product product;
  const ProductCardVertical({super.key, required this.product});

  bool _notBlank(String? s) =>
      s != null && s.trim().isNotEmpty && s.trim().toLowerCase() != 'null';

  @override
  Widget build(BuildContext context) {
    final pricing = buildPricingInfo(product);

    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          withNavBar: true,
          screen: ProductDetailPage(hotelId: product.id),
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (Theme.of(context).brightness == Brightness.light)
              BoxShadow(color: Colors.grey.shade300, blurRadius: 6, spreadRadius: 2)
            else
              BoxShadow(color: Theme.of(context).colorScheme.surfaceContainerHigh.withValues(alpha: 1), blurRadius: 6, spreadRadius: 2),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // دکمه خرید
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 12),
              child: ElevatedButton(
                onPressed: pricing.available ? () {} : null,
                child: const Text("خرید", style: TextStyle(color: Colors.white)),
              ),
            ),

            // متن‌ها
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 4),
                    Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),

                    // قیمت اصلی
                    Text(
                      pricing.mainLineText,
                      style: TextStyle(fontWeight: FontWeight.w700, color: pricing.mainLineColor),
                      textDirection: TextDirection.rtl,
                    ),

                    // خط قیمت اولیه (اگر افر داشت)
                    if (pricing.showOriginalLine) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            pricing.originalLineValue ?? '',
                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            pricing.originalLineLabel ?? '',
                            style: const TextStyle(color: Colors.grey),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ],

                    const Spacer(),

                    // دسته/کشور (دلخواه)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(product.categoryTitle, textDirection: TextDirection.rtl),
                        const SizedBox(width: 5),
                        Icon(Icons.category, color: Theme.of(context).colorScheme.primary, size: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // تصویر + روبان‌ها
            ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
              child: SizedBox(
                width: 120,
                height: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // تصویر
                    Positioned.fill(
                      child: GeneratedChemicalImage.shouldUse(product)
                          ? GeneratedChemicalImage.fromProduct(product, width: 120, height: double.infinity, fontSize: 8, lineSpacing: 4)
                          : (_notBlank(product.image1)
                          ? Image.network(networkUrl(product.image1), width: 120, height: double.infinity, fit: BoxFit.cover)
                          : Image.asset('assets/images/ad_banner.png', width: 120, height: double.infinity, fit: BoxFit.cover)),
                    ),

                    // روبان افر غیرنقدی
                    if (pricing.showOfferRibbon)
                      Positioned(
                        top: 14,
                        right: -40,
                        child: Transform.rotate(
                          angle: -0.75,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 24,
                            width: 220,
                            color: Colors.red,
                            alignment: Alignment.center,
                            child: Text(
                              pricing.offerRibbonText,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                          ),
                        ),
                      ),

                    // روبان افر نقدی
                    if (pricing.showCashOfferRibbon)
                      Positioned(
                        top: 20,
                        right: -20,
                        child: Transform.rotate(
                          angle: -0.85,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 20,
                            width: 220,
                            color: Colors.red.shade700,
                            alignment: Alignment.center,
                            child: Text(
                              pricing.cashOfferRibbonText,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
