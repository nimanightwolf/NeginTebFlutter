import 'package:flutter/material.dart';
import 'package:hotelino/features/home/data/models/hotel.dart';
import 'package:hotelino/features/home/presentation/widgets/hotel_card_vertical.dart';

class HotelVerticalList extends StatelessWidget {
  final String title;
  final List<Hotel> hotels;

  const HotelVerticalList({super.key, required this.title, required this.hotels});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: HotelCardVertical(hotel: hotels[index]),
            );
          },
        )
      ],
    );
  }
}
