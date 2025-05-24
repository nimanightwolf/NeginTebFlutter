import 'package:flutter/material.dart';
import 'package:hotelino/core/utils/network.dart';
import 'package:hotelino/features/home/data/models/hotel.dart';
import 'package:hotelino/features/home/data/repositories/hotel_repository.dart';
import 'package:hotelino/shared/services/json_data_service.dart';

class HotelDetailPage extends StatelessWidget {
  const HotelDetailPage({super.key, required this.hotelId});
  final String hotelId;

  @override
  Widget build(BuildContext context) {
    final hotelRepository = HotelRepository(jsonDataService: JsonDataService());
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<Hotel>(
      future: hotelRepository.getHotelById(hotelId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final hotel = snapshot.data!;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: GestureDetector(
                    onLongPress: () {},
                    child: Image.network(fit: BoxFit.cover, networkUrl(hotel.images.first)),
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
