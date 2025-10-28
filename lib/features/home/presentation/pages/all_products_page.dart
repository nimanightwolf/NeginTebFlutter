// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:neginteb/data/models/product.dart';
import 'package:neginteb/features/home/presentation/provider/product_provider.dart';
import 'package:neginteb/features/home/presentation/widgets/product_card_vertical.dart';

import '../widgets/search_bar.dart';

class AllProductsPage extends StatefulWidget {
  /// اگر ست شود، فقط محصولاتی که این کلید را دارند نمایش داده می‌شوند
  final String? keyCategory;
  final String? titleCategory;

  const AllProductsPage({super.key, this.keyCategory, this.titleCategory});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  bool _firstBuildRefreshed = false;

  @override
  void initState() {
    super.initState();
    // رفرش خودکار پس از ورود به صفحه (یک‌بار)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted && !_firstBuildRefreshed) {
        _firstBuildRefreshed = true;
        await _refreshFromServer();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _refreshFromServer() async {
    final provider = context.read<ProductProvider>();
    try {
      await provider.fetchProducts(); // از سرور می‌گیرد و داخل Hive ذخیره می‌کند
      // بعد از fetch نیاز به setState نیست چون Provider notify می‌دهد
    } catch (_) {
      // هندل خطا درون provider انجام شده. اگر خواستی SnackBar اضافه کن.
    }
  }

  List<Product> _applyFilters(List<Product> source) {
    // 1) فیلتر بر اساس key_category (اگر ست شده)
    final keyCat = widget.keyCategory?.trim();
    Iterable<Product> list = source;

    if (keyCat != null && keyCat.isNotEmpty) {
      list = list.where((p) {
        // پوشش هر دو فیلد احتمالی
        final kc1 = (p.category).toString().trim().toLowerCase();
        // اگر فیلد دیگری مثل p.keyCategory داری، اضافه کن:
        // final kc2 = (p.keyCategory).toString().trim().toLowerCase();
        return kc1 == keyCat; // || kc2 == keyCat;
      });
    }

    // 2) فیلتر سرچ
    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((p) {
        bool hit(String? s) =>
            s != null && s.toLowerCase().contains(q);
        return hit(p.title) ||
            hit(p.nameLatin) ||
            hit(p.keyWord) ||
            hit(p.category) ||
            hit(p.country);
      });
    }

    // 3) می‌تونی سورت هم اعمال کنی (دلخواه)
    final out = list.toList();
    // نمونه: جدیدترین‌ها ابتدا (اگر فیلد date یا sort داری)
    // out.sort((a, b) => (b.sort).compareTo(a.sort));
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    // همیشه از دیتابیس بخون؛ اگر خالی بود provider خودش fetch می‌کند (طبق کدی که قبلاً ساختیم)
    final all = provider.getProductsFromDatabase();
    final filtered = _applyFilters(all);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.keyCategory == null
            ? 'همه محصولات'
            : 'دسته: ${widget.titleCategory}'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: SearchBarWidget(
            controller: _searchCtrl,
            onChanged: (q) => setState(() => _query = q),
            onSearchTap: () {
              setState(() => _query = _searchCtrl.text);
              FocusScope.of(context).unfocus();
            },
            onFilterTap: () {
              // اگر فیلترهای پیشرفته داری، اینجا BottomSheet باز کن
              // showModalBottomSheet(context: context, builder: (_) => YourFilterSheet());
            },
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _refreshFromServer,
        child: CustomScrollView(
          slivers: [
            // شمارش آیتم‌ها
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 18, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      '${filtered.length} کالا',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textDirection: TextDirection.rtl,
                    ),
                    const Spacer(),
                    if (provider.isLoading) ...[
                      SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text('در حال بروز‌رسانی...', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
            ),

            if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyState(
                  title: _query.isEmpty
                      ? 'محصولی برای این دسته موجود نیست'
                      : 'چیزی مطابق جستجو پیدا نشد',
                  subtitle: _query.isEmpty
                      ? 'با کشیدن صفحه به پایین، لیست را بروز کنید.'
                      : 'عبارت جستجو را تغییر بده یا پاک کن.',
                  onClear: _query.isNotEmpty ? () {
                    setState(() {
                      _query = '';
                      _searchCtrl.clear();
                    });
                  } : null,
                ),
              )
            else
            // لیست کارت‌ها
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                sliver: SliverList.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final p = filtered[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProductCardVertical(product: p),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onClear;

  const _EmptyState({
    required this.title,
    this.subtitle,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(title, style: t.titleMedium, textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!, style: t.bodySmall, textAlign: TextAlign.center),
            ],
            if (onClear != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onClear,
                icon: Icon(Icons.clear),
                label: Text('پاک کردن جستجو'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
