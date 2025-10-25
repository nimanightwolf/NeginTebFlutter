// categories_page.dart
import 'package:flutter/material.dart';
import 'package:neginteb/core/constants/constants.dart';
import 'package:neginteb/features/category/presentation/widgets/category_provider.dart';
import 'package:provider/provider.dart';

import '../data/models/hexagon_clipper.dart';


class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool _inited = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inited) return;
    _inited = true;

    final p = context.read<CategoriesProvider>();
    // باز کردن Hive و لود از کش؛ اگر خالی بود از API
    p.openDatabase().then((_) {
      final cached = p.getCategoriesFromDatabase();
      if (cached.isEmpty) {
        print("get from api ");
        p.fetchCategories();
      } else {
        print("get from database ");
        print(cached.length);
        // با این کار UI بلافاصله نشان داده می‌شود؛ همزمان می‌توانی تازه‌سازی هم بفرستی
        // p.fetchCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF8EEF3); // پس‌زمینه‌ی نزدیک به اسکرین‌شات

    return Scaffold(

      appBar: AppBar(
        title: Text('دسته‌بندی‌ها', style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,

        foregroundColor: Colors.white,
      ),
      body: Consumer<CategoriesProvider>(
        builder: (context, p, _) {
          final ui = p.getUiCategories(); // خروجی آماده برای UI

          if (p.isLoading && ui.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => p.fetchCategories(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // هدر وسط شبیه عکس (لوگو ساده + تیتر «همه محصولات»)
                  _AllProductsHeader(onTap: () {
                    // TODO: ناوبری به همه محصولات
                  }),
                  const SizedBox(height: 8),
                  Text('همه محصولات',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),

                  // گرید 2 ستونه
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      itemCount: ui.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 28,
                        crossAxisSpacing: 12,
                        childAspectRatio: .95,
                      ),
                      itemBuilder: (_, i) {
                        final c = ui[i];
                        return HexagonTile(
                          title: c.title,
                          image: c.image,
                          isNetwork: c.isNetwork,
                          onTap: () {
                            // TODO: رفتن به لیست محصولات این دسته با c.id
                            // Navigator.push(...);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
      // ناوبار پایین فقط آیکن‌ها مثل عکس

    );
  }
}

class _AllProductsHeader extends StatelessWidget {
  final VoidCallback? onTap;
  const _AllProductsHeader({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 170, height: 120,
              child: ClipPath(
                clipper: _HeaderHexagon(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(Icons.all_inclusive, size: 56, color: Colors.teal),
                  ),
                ),
              ),
            ),
            Positioned(left: 40, child: _dot(color: Colors.purple)),
            Positioned(right: 40, child: _dot(color: Colors.blue)),
          ],
        ),
      ),
    );
  }

  Widget _dot({required Color color}) => Container(
    width: 10, height: 10,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _HeaderHexagon extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    final w = s.width, h = s.height;
    return Path()
      ..moveTo(w * .25, 0)
      ..lineTo(w * .75, 0)
      ..lineTo(w, h * .5)
      ..lineTo(w * .75, h)
      ..lineTo(w * .25, h)
      ..lineTo(0, h * .5)
      ..close();
  }
  @override
  bool shouldReclip(_) => false;
}
