import 'package:flutter/material.dart';
import 'package:neginteb/core/utils/network.dart';
import 'package:neginteb/core/utils/price_formatter.dart';
import 'package:neginteb/data/models/product.dart';
import 'package:neginteb/features/hotel_detail/presentation/hotel_detail_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class ProductCardVertical extends StatelessWidget {
  final Product product;

  const ProductCardVertical({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          withNavBar: true,
          screen: HotelDetailPage(hotelId: product.id),
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
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                spreadRadius: 2,
              )
            else
              BoxShadow(
                color: Theme.of(context).colorScheme.surfaceContainerHigh.withValues(alpha: 1),
                blurRadius: 6,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 12),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("خرید", style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 4),
                    Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${product.country}, ${product.country}",
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary, size: 18),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Text("${hotel.bedType.count} ${hotel.bedType.type}"),
                        Text(
                          product.category,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.bed, color: Theme.of(context).colorScheme.primary, size: 18),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text("از ${formatPrice(int.parse(product.priceVazn ))} تومن ",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: product.image1.isNotEmpty
                  ? Image.network(
                networkUrl(product.image1),  // بارگذاری تصویر از URL
                width: 120,
                height: double.infinity,
                fit: BoxFit.cover,
              )
                  : Image.asset(  // تصویر پیش‌فرض محلی در صورت خالی بودن image1
                'assets/images/ad_banner.png',  // مسیر تصویر ثابت
                width: 100,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
