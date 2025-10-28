import 'package:flutter/material.dart';

import '../pages/all_products_page.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryFixed, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset("assets/images/ad_banner.png"),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'دسترسی در سریع ترین زمان ممکن',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  'تأمین تخصصی مواد دارویی و آزمایشگاهی با نگین‌طب.',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white70),
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AllProductsPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.brown.shade800,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: Text("همه محصولات")),
                SizedBox(
                  height: 8,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
