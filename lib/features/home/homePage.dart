// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hotelino/features/home/presentation/provider/home_provider.dart';
import 'package:hotelino/features/home/presentation/widgets/ad_banner.dart';
import 'package:hotelino/features/home/presentation/widgets/home_appbar.dart';
import 'package:hotelino/features/home/presentation/widgets/hotel_list_section.dart';
import 'package:hotelino/features/home/presentation/widgets/hotel_vertical_list.dart';
import 'package:hotelino/features/home/presentation/widgets/search_bar.dart';
import 'package:hotelino/features/home/presentation/widgets/story_carousel.dart';
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
            Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {
                return HotelListSection(
                  title: "محبوب‌ترین هتل‌ها",
                  hotels: homeProvider.getPopularHotels(),
                  onSeeAllPressed: () {},
                );
              },
            ),
            Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {
                return HotelListSection(
                  title: "پیشنهاد ویژه امروز",
                  hotels: homeProvider.getSpecialOffersHotels(),
                  onSeeAllPressed: () {},
                );
              },
            ),
            const SizedBox(height: 16),
            Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {
                return StoryCarousel(images: homeProvider.getStoryImages(), titles: homeProvider.storyTitles);
              },
            ),
            Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {
                return HotelVerticalList(title: "جدیدترین هتل‌ها", hotels: homeProvider.getNewestHotels());
              },
            ),
          ],
        ),
      ),
    );
  }
}
