// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:neginteb/features/home/presentation/provider/home_provider.dart';
import 'package:neginteb/features/home/presentation/provider/product_provider.dart';
import 'package:neginteb/features/home/presentation/provider/profile_provider.dart';
import 'package:neginteb/features/home/presentation/widgets/ad_banner.dart';
import 'package:neginteb/features/home/presentation/widgets/home_appbar.dart';
import 'package:neginteb/features/home/presentation/widgets/hotel_vertical_list.dart';
import 'package:neginteb/features/home/presentation/widgets/product_list_section.dart';
import 'package:neginteb/features/home/presentation/widgets/search_bar.dart';
import 'package:neginteb/features/home/presentation/widgets/story_carousel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 16,
            ),
            SearchBarWidget(),
            SizedBox(
              height: 16,
            ),
            AdBanner(),
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return ProductListSection(
                  title: "محبوب‌ترین محصولات",
                  product: productProvider.getPopularProductsFromDatabase(),
                  onSeeAllPressed: () {},
                );
              },
            ),
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return ProductListSection(
                  title: "پیشنهاد ویژه امروز",
                  product: productProvider.getPopularProductsFromDatabase(),
                  onSeeAllPressed: () {},
                );
              },
            ),
            const SizedBox(height: 16),
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return StoryCarousel(images: productProvider.getStoryImages(), titles: productProvider.storyTitles);
              },
            ),
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return ProductVerticalList(title: "جدیدترین محصولات", product: productProvider.getPopularProductsFromDatabase());
              },
            ),
            Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                if (profileProvider.recentlyViewedProducts.isNotEmpty) {
                  return ProductListSection(
                      title: "بازدید های اخیر", product: profileProvider.recentlyViewedProducts);
                } else {
                  return SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
