// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:hotelino/core/utils/network.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageShower extends StatefulWidget {
  final String myImageUrl;

  FullScreenImageShower({super.key, required this.myImageUrl});

  @override
  State<FullScreenImageShower> createState() => _FullScreenImageShowerState();
}

class _FullScreenImageShowerState extends State<FullScreenImageShower> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: PhotoView(
            enableRotation: false,
            initialScale: PhotoViewComputedScale.contained * 1,
            backgroundDecoration: BoxDecoration(color: Colors.black),
            imageProvider: NetworkImage(networkUrl(widget.myImageUrl))),
      ),
    );
  }
}
