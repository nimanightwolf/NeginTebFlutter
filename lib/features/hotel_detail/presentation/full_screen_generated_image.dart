import 'package:flutter/material.dart';
import 'package:neginteb/data/models/product.dart';

import '../../../shared/widgets/generated_chemical_image.dart';

/// نمایش فول‌اسکرینِ تصویر ساخته‌شده + زوم/پَن
class FullScreenGeneratedImage extends StatelessWidget {
  final Product product;
  const FullScreenGeneratedImage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.8,
          maxScale: 5.0,
          child: GeneratedChemicalImage.fromProduct(
            product,
            width: size.width * 0.9,
            height: null,
            fontSize: 18,     // بزرگ و خوانا در فول‌اسکرین
            lineSpacing: 8,
            showOuterBorder: true,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
