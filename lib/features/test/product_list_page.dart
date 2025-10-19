// lib/screens/product_list_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/presentation/provider/product_provider.dart';

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('داروها')),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          // if (productProvider.isLoading) {
          //   return Center(child: CircularProgressIndicator()); // در حال بارگذاری
          // } else {
            final products = productProvider.getProductsFromDatabase();
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text(product.packing.toString()),
                  trailing: Text('${product.packing}'),
                );
              },
            );
          }
        // },
      ),
    );
  }
}