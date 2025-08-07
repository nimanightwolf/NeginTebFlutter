import 'package:flutter/material.dart';
import 'package:neginteb/data/models/product.dart';

import 'hotel_card_vertical.dart';

class ProductVerticalList extends StatelessWidget {
  final String title;
  final List<Product> product;

  const ProductVerticalList({super.key, required this.title, required this.product});

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
          itemCount: product.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: ProductCardVertical(product: product[index]),
            );
          },
        )
      ],
    );
  }
}
