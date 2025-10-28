import 'package:flutter/material.dart';
import 'package:neginteb/features/history/presentation/history_provider.dart';
import 'package:neginteb/features/history/presentation/widget/history_card.dart';
import 'package:provider/provider.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().fetch();
    });
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri, mode: LaunchMode.externalApplication);
    // } else {
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('امکان بازکردن درگاه وجود ندارد')),
    //     );
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<HistoryProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تاریخچه خرید', textDirection: TextDirection.rtl),
        centerTitle: true,
        actions: [
          if (p.items.isNotEmpty)
            IconButton(
              tooltip: p.selectMode ? 'خروج از حالت انتخاب' : 'انتخاب چندتایی',
              onPressed: () => p.toggleSelectMode(),
              icon: Icon(p.selectMode ? Icons.check_circle : Icons.select_all),
            )
        ],
      ),
      body: Column(
        children: [
          if (p.isLoading) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: RefreshIndicator(
              onRefresh: p.fetch,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 90),
                itemCount: p.items.length,
                itemBuilder: (context, i) {
                  final it = p.items[i];
                  return HistoryCard(
                    item: it,
                    selectMode: p.selectMode,
                    onTap: () {
                      if (p.selectMode) p.toggleOne(it.id);
                    },
                    onLongPress: () => p.toggleSelectMode(true),
                    onTouchToPay: () {
                      // ورود به حالت انتخاب و تیک‌زدن این مورد
                      if (!p.selectMode) p.toggleSelectMode(true);
                      p.toggleOne(it.id);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // Bottom bar پرداخت انتخاب‌ها
      bottomNavigationBar: p.selectMode
          ? SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  p.selectedIds.isEmpty
                      ? 'هیچ موردی انتخاب نشده'
                      : '${p.selectedIds.length} مورد انتخاب شده',
                  textDirection: TextDirection.rtl,
                ),
              ),
              FilledButton.icon(
                onPressed: p.selectedIds.isEmpty
                    ? null
                    : () async {
                  final url = await p.paySelected();
                  if (url == null) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('لینک درگاه دریافت نشد')),
                      );
                    }
                  } else {
                    _openUrl(url);
                  }
                },
                icon: const Icon(Icons.payment),
                label: const Text('پرداخت انتخاب‌ها'),
              ),
            ],
          ),
        ),
      )
          : null,
    );
  }
}
