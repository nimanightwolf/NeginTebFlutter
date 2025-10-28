import 'package:flutter/material.dart';
import 'package:neginteb/core/utils/price_formatter.dart';

import '../../data/models/history_item.dart';

class HistoryCard extends StatelessWidget {
  final HistoryItem item;
  final bool selectMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onTouchToPay; // «برای پرداخت لمس کنید»

  const HistoryCard({
    super.key,
    required this.item,
    required this.selectMode,
    required this.onTap,
    required this.onLongPress,
    required this.onTouchToPay,
  });

  Color _statusColor(String s) {
    switch (s) {
      case '0':
      case '1':
        return Colors.red.withOpacity(0.08);      // بررسی نشده
      case '2':
        return Colors.yellow.withOpacity(0.12);   // درحال انجام
      case '3':
      case '4':
        return Colors.blue.withOpacity(0.08);     // درحال ارسال/ارسال شده
      case '5':
        return Colors.green.withOpacity(0.08);    // تکمیل شده
      default:
        return Colors.grey.withOpacity(0.06);
    }
  }

  String _timeAgo(int? epochSec) {
    if (epochSec == null) return '';
    final diff = DateTime.now().millisecondsSinceEpoch ~/ 1000 - epochSec;
    if (diff < 60) return 'چند ثانیه پیش';
    if (diff < 3600) return '${diff ~/ 60} دقیقه پیش';
    if (diff < 86400) return '${diff ~/ 3600} ساعت پیش';
    if (diff < 2629743) return '${diff ~/ 86400} روز پیش';
    if (diff < 31556926) return '${diff ~/ 2629743} ماه پیش';
    return '${diff ~/ 31556926} سال پیش';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settled = item.tasfieh == 'تسويه شده';

    final priceStr = item.price != null ? '${formatPrice(item.price!)} ریال' : null;
    final payWithOffer = (item.price != null && item.priceOffer != null)
        ? '${formatPrice(item.price! - item.priceOffer!)} ریال'
        : null;
    final offerStr = (item.priceOffer != null && item.priceOffer! > 0)
        ? '${formatPrice(item.priceOffer!)} ریال'
        : null;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            color: _statusColor(item.status),
            border: Border.all(color: Colors.blue.shade200, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ردیف تاریخ و "چند روز پیش"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_timeAgo(item.dateEpoch), style: theme.textTheme.titleMedium),
                  Text('تاریخ: ${item.dateShow}', style: theme.textTheme.titleMedium),
                ],
              ),

              const SizedBox(height: 12),

              // وضعیت
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text('وضعیت:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _statusFa(item.status),
                      style: theme.textTheme.titleMedium,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              if (item.destName != null) ...[
                Center(
                  child: Text(
                    'نام مقصد: ${item.destName!}',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(height: 8),
              ],

              if (item.factor != null) ...[
                Center(
                  child: Text(
                    'شماره فاکتور: ${item.factor!}',
                    style: theme.textTheme.titleLarge,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(height: 8),
              ],

              if (priceStr != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('قیمت: $priceStr',
                      style: theme.textTheme.titleMedium, textDirection: TextDirection.rtl),
                ),

              if (!settled) ...[
                if (item.mandeh != null && item.mandeh! > 0 && offerStr != null && payWithOffer != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'مهلت پرداخت ${item.mandeh} روز با احتساب افر نقدی',
                        style: theme.textTheme.bodyLarge,
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 6),
                      Text('افر پرداخت نقدی: $offerStr',
                          style: theme.textTheme.titleMedium?.copyWith(color: Colors.red),
                          textDirection: TextDirection.rtl),
                      const SizedBox(height: 6),
                      Text('مبلغ قابل پرداخت: $payWithOffer',
                          style: theme.textTheme.titleMedium?.copyWith(color: Colors.red),
                          textDirection: TextDirection.rtl),
                    ],
                  )
                else if (item.mandehAll != null && item.mandehAll! > 0)
                  Text('مهلت تسویه‌ی مبلغ باقی‌مانده ${item.mandehAll} روز می‌باشد.',
                      style: theme.textTheme.titleMedium, textDirection: TextDirection.rtl),
                const SizedBox(height: 12),
                // دکمه سبز «برای پرداخت لمس کنید»
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: onTouchToPay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF43A047),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('برای پرداخت لمس کنید', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ] else
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.verified, color: Colors.green),
                    const SizedBox(width: 8),
                    Text('تسویه شده', style: theme.textTheme.titleMedium),
                  ],
                ),

              if (selectMode) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(value: item.selected, onChanged: (_) => onTap()),
                    const SizedBox(width: 6),
                    Text('انتخاب برای پرداخت', style: theme.textTheme.bodyLarge),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _statusFa(String s) {
    switch (s) {
      case '0':
      case '1':
        return 'بررسی نشده';
      case '2':
        return 'درحال انجام';
      case '3':
        return 'در حال ارسال';
      case '4':
        return 'ارسال شده';
      case '5':
        return 'تکمیل شده';
      default:
        return 'نامشخص';
    }
  }
}
