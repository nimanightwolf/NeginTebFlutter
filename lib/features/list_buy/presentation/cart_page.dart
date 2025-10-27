import 'package:flutter/material.dart';
import 'package:neginteb/features/list_buy/presentation/widgets/cart_provider.dart';
import 'package:provider/provider.dart';

import '../data/models/cart_item.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CartProvider>();
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('لیست خرید', style: t.titleLarge),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<CartProvider>().load(),
        child: Stack(
          children: [
            ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 170),
              children: [
                Row(
                  children: [
                    Expanded(child: _topButton(
                      label: 'نمایش همه به صورت غیر نقدی',
                      onTap: () => p.toggleAll(false),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _topButton(
                      label: 'نمایش همه به صورت نقدی',
                      onTap: () => p.toggleAll(true),
                      green: true,
                    )),
                  ],
                ),
                const SizedBox(height: 12),

                if (p.loading && p.items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: CircularProgressIndicator()),
                  ),

                ...p.items.map((it) => _CartCard(item: it)).toList(),
              ],
            ),

            Positioned(
              left: 0, right: 0, bottom: 0,
              child: _SummaryBar(
                total: f3(p.summary.total),
                discount: f3(p.summary.discountAll),
                payable: f3(p.summary.payable),
                onSubmit: () => p.submitOrder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topButton({required String label, required VoidCallback onTap, bool green=false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: green ? const Color(0xFF43A047) : const Color(0xFF6FBF73),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _CartCard extends StatelessWidget {
  const _CartCard({required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final p = context.read<CartProvider>();
    final t = Theme.of(context).textTheme;
    final isCashOnly = item.naghdiAll == 1;
    final isCashSelected = item.naghdiN == 1;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Center(child: Text(item.title, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('بسته بندی ${item.vazn}${_suffixUnit(item.unit)}', style: t.bodyMedium),
              Text('تعداد: ${item.number}', style: t.bodyMedium),
            ],
          ),
          const SizedBox(height: 10),

          if (isCashOnly)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: const Color(0xFFE53935), borderRadius: BorderRadius.circular(6)),
              child: const Center(child: Text('این محصول فقط نقدی است!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
            ),
          if (isCashOnly) const SizedBox(height: 10),

          if (!isCashOnly) ...[
            _priceRow(
              titleOnRight: 'غیر نقدی',
              selected: !isCashSelected,
              price: item.priceAdi,
              onTap: () => p.toggleItemNaghdi(item, naghdi: false),
            ),
            const SizedBox(height: 8),
          ],
          _priceRow(
            titleOnRight: 'نقدی',
            selected: isCashSelected,
            price: item.priceNaghdi,
            onTap: () {
              if (!isCashSelected) p.toggleItemNaghdi(item, naghdi: true);
            },
          ),

          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.delete_outline, size: 28),
              onPressed: () => p.deleteItem(item.idT),
              tooltip: 'حذف از سبد',
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow({
    required String titleOnRight,
    required bool selected,
    required int price,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: selected ? const Color(0xFF2E7D32) : Colors.grey.shade400),
            ),
            child: Row(
              children: [
                Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: selected ? const Color(0xFF2E7D32) : Colors.grey),
                const SizedBox(width: 6),
                Text('ریال ${f3(price)}',
                    style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
              ],
            ),
          ),
        ),
        const Spacer(),
        Text(titleOnRight, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  String _suffixUnit(String unit) {
    final u = unit.trim();
    if (u == 'سی سی' || u == 'سي سي') return u;
    return '$uی';
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({
    required this.total,
    required this.discount,
    required this.payable,
    required this.onSubmit,
  });

  final String total;
  final String discount;
  final String payable;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F0F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _row('مبلغ کل :', 'ریال $total', t),
          const SizedBox(height: 6),
          _row('مجموع تخفیفات :', 'ریال $discount', t),
          const SizedBox(height: 6),
          _row('مبلغ قابل پرداخت :', 'ریال $payable', t, bold: true),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43A047),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: onSubmit,
              child: Text('ارسال نهایی سفارشات', style: t.titleMedium?.copyWith(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget _row(String r, String l, TextTheme t, {bool bold=false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: t.titleMedium?.copyWith(color: Colors.black87, fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
        Text(r, style: t.titleMedium),
      ],
    );
  }
}
