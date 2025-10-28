import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/product.dart';
import '../provider/product_provider.dart';
import '../widgets/product_card_vertical.dart';

class AllProductsPage extends StatefulWidget {
  final String? keyCategory; // فیلتر اختیاری برای دسته‌بندی خاص

  const AllProductsPage({super.key, this.keyCategory});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  late ProductProvider _productProvider;
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _productProvider = context.read<ProductProvider>();

      // اطمینان از باز بودن دیتابیس
      await _productProvider.openDatabase();

      final allProducts = _productProvider.getProductsFromDatabase();

      setState(() {
        _filteredProducts = _filterProducts(allProducts, widget.keyCategory);
      });
    });
  }

  List<Product> _filterProducts(List<Product> products, String? keyCategory) {
    if (keyCategory == null || keyCategory.isEmpty) {
      return products;
    }
    return products
        .where((p) =>
    p.category.toLowerCase() == keyCategory.toLowerCase() ||
        p.categoryTitle.toLowerCase() == keyCategory.toLowerCase() ||
        p.keyWord.toLowerCase().contains(keyCategory.toLowerCase()))
        .toList();
  }

  Future<void> _refresh() async {
    await _productProvider.fetchProducts();
    final refreshed = _productProvider.getProductsFromDatabase();
    setState(() {
      _filteredProducts = _filterProducts(refreshed, widget.keyCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ProductProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.keyCategory == null
              ? 'همه محصولات'
              : 'محصولات دسته ${widget.keyCategory}',
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _refresh,
        child: _filteredProducts.isEmpty
            ? const Center(
          child: Text(
            'محصولی یافت نشد',
            style: TextStyle(fontSize: 16),
          ),
        )
            : GridView.builder(
          padding: const EdgeInsets.all(2),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2.9,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            final product = _filteredProducts[index];
             return ProductCardVertical(product: product);

          },
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: برو به صفحه جزئیات محصول
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(productId: product.id)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // تصویر
            Expanded(
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(18)),
                child: product.image1.isNotEmpty
                    ? Image.network(
                  product.image1,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                )
                    : Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            // عنوان و قیمت
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.title,
                textDirection: TextDirection.rtl,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                product.price.isNotEmpty
                    ? '${product.price} ریال'
                    : 'قیمت ندارد',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
