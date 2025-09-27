// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables



import 'package:flutter/material.dart';
import 'package:neginteb/core/utils/network.dart';
import 'package:neginteb/core/utils/price_formatter.dart';
import 'package:neginteb/features/home/presentation/provider/favorite_item_provider.dart';
import 'package:neginteb/features/home/presentation/widgets/animated_favorite_button.dart';
import 'package:neginteb/features/hotel_detail/presentation/product_detail_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/product.dart';

class ProductCard extends StatelessWidget {
  Product product;

  ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavotireItemProvider>(context);
    final isFavorite = favoriteProvider.isFavorite(product.id);

    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          withNavBar: true,
          screen: ProductDetailPage(hotelId: product.id),
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: SizedBox(
        width: 280,
        child: Card(
          elevation: 4,
          margin: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                    child: product.image1.isNotEmpty
                        ? Image.network(
                      networkUrl(product.image1),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    )
                        : Image.asset( // تصویر پیش‌فرض محلی در صورت خالی بودن image1
                      'assets/images/default_image.png', // مسیر تصویر ثابت
                      width: 100,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // اضافه کردن خط قرمز مورب و درصد تخفیف
                  if (int.tryParse(product.offer) != null && int.parse(product.offer) == 0)
                    Positioned(
                      top:33,
                      left: -25,
                      right: 155,
                      child: Transform.rotate(
                        angle: -0.75, // چرخش خط برای مورب شدن
                        child: Container(
                          height: 20, // باریک‌تر کردن خط
                          width: 5, // طول کامل خط
                          color: Colors.red,
                          alignment: Alignment.center,
                          child: Text(
                            '-${product.offer}% تخفیف', // نمایش درصد تخفیف
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: AnimatedFavoriteButton(
                      isFavorite: isFavorite,
                      onTap: () {
                        favoriteProvider.toggleFavorite(product.id);
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Spacer(),
                        Text(
                          product.title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8)
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 8),
                        Text(
                          "${product.country}, ${product.country}",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        ),
                        SizedBox(width: 8)
                      ],
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text(
                        "از ${formatPrice(int.parse(product.priceVazn))} تومن",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.only(right: 8, left: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              "مشاهده و خرید",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                    SizedBox(height: 8)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

