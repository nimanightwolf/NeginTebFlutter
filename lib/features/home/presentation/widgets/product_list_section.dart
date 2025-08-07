import 'package:flutter/material.dart';
import 'package:neginteb/data/models/product.dart';
import 'package:neginteb/features/home/presentation/widgets/product_card.dart';

class ProductListSection extends StatelessWidget {
  final String title;
  final List<Product> product;
  final VoidCallback? onSeeAllPressed;

  const ProductListSection({super.key, required this.title, required this.product, this.onSeeAllPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {},
                  child: Text(
                    "مشاهده همه",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  )),
              Text(
                title,
                style: Theme.of(context).textTheme.displayMedium,
              )
            ],
          ),
        ),
        SizedBox(
          height: 360,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 16),
            reverse: true,
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: product.length,
            itemBuilder: (context, index) {
              return Padding(padding: EdgeInsets.only(left: 16), child: ProductCard(product: product[index]));
            },
          ),
        ),
      ],
    );
  }
}
