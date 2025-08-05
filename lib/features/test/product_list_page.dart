// lib/screens/product_list_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/presentation/provider/product_provider.dart';

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('محصولات دارویی')),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final products = productProvider.products;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.title),
                subtitle: Text(product.description),
                trailing: Text('${product.price} تومان'),
              );
            },
          );
        },
      ),
    );
  }
}
