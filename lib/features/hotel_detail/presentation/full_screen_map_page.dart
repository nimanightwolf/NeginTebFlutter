import 'package:flutter/material.dart';

class FullScreenMapPage extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String hotelName;

  const FullScreenMapPage(
      {super.key, required this.latitude, required this.longitude, required this.hotelName});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
