// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:neginteb/core/utils/network.dart';
import 'package:neginteb/data/models/product.dart';

import 'package:neginteb/features/hotel_detail/presentation/full_screen_image_shower.dart';

import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../home/presentation/provider/product_provider.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.hotelId});

  final String hotelId;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
   // final hotelRepository = HotelRepository(jsonDataService: JsonDataService());
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<Product>(
      future: provider.getProductsFromDatabaseById(hotelId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final hotel = snapshot.data!;
        final images = [
          hotel.image1,
          hotel.image2,
          hotel.image3,
        ].where((e) => e != null && e.trim().isNotEmpty).toList();
// آیتم‌های اطلاعاتی (فقط مقدار را از مدل خودت بگذار)
        final _rawInfoItems = [
          {
            'label': 'نام لاتین',
            'value': hotel.nameLatin,
            'icon': Icons.science_outlined,
            'ltr': true, // متن لاتین LTR
          },
          {
            'label': 'گروه بندی',
            'value': hotel.categoryTitle,
            'icon': Icons.category_outlined,
            'ltr': false,
          },
          {
            'label': 'تاریخ انقضا',
            'value': hotel.dateEx, // مثل 04.2026
            'icon': Icons.calendar_month_outlined,
            'ltr': true, // تاریخ نقطه‌دار بهتره LTR باشه
          },{
            'label': 'کشور سازنده',
            'value': hotel.country, // مثل 04.2026
            'icon': Icons.location_on_outlined,
            'ltr': true, // تاریخ نقطه‌دار بهتره LTR باشه
          },
        ];

// فقط موارد پُر را نگه می‌داریم
        final _visibleInfoItems = _rawInfoItems
            .where((m) => !_isBlank(m['value'] as String?))
            .toList();
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: GestureDetector(
                    onLongPress: () {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen:
                              FullScreenImageShower(myImageUrl: hotel.image1),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino);
                    },
                    child: Image.network(
                        fit: BoxFit.cover, networkUrl(hotel.image1)),
                  ),
                ),
                elevation: 8,
                expandedHeight: 300,
                leading: IconButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                        child: Text(
                          hotel.title,
                          style: textTheme.headlineMedium,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Center(
                        child: Text(
                          " قیمت هر${hotel.unit}  ${hotel.priceVazn}ریال ",
                          style: textTheme.headlineSmall,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      Center(
                        child: Text(
                          " قیمت هر${hotel.unit} در صورت پرداخت نقدی ${hotel.priceVazn}ریال ",
                          style: textTheme.headlineSmall,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      Container(
                        height: 1,                   // ضخامت خط
                        color: Colors.black,         // رنگ خط
                        margin: EdgeInsets.symmetric(vertical: 8), // فاصله بالا و پایین
                      ),

                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "گالری تصاویر",
                        style: textTheme.headlineSmall,
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            final img = images[index];
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: FullScreenImageShower(myImageUrl: img),
                                      withNavBar: false,
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        networkUrl(img),
                                        width: 120,
                                        height: 100,
                                        fit: BoxFit.cover,

                                      ),
                                    ),
                                  ),
                                ),
                                if (index != images.length - 1) const SizedBox(width: 8),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (_visibleInfoItems.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: const BoxDecoration(

                            border: Border(
                              top: BorderSide(color: Color(0xFF2E7D32), width: 2),
                              bottom: BorderSide(color: Color(0xFF2E7D32), width: 2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (var i = 0; i < _visibleInfoItems.length; i++) ...[
                                _InfoRow(
                                  label: _visibleInfoItems[i]['label'] as String,
                                  value: (_visibleInfoItems[i]['value'] as String).trim(),
                                  icon: _visibleInfoItems[i]['icon'] as IconData,
                                  textTheme: textTheme,
                                  valueIsLTR: (_visibleInfoItems[i]['ltr'] as bool?) ?? false,
                                  iconColor: const Color(0xFF2E7D32),
                                ),
                                if (i != _visibleInfoItems.length - 1) const SizedBox(height: 16),
                              ],
                            ],
                          ),
                        ),


                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "توضیحات",
                        style: textTheme.headlineSmall,
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      _PricingSection(hotel: hotel),
                      Text(
                        hotel.description,
                        style: textTheme.bodyMedium!.copyWith(height: 1.5),
                        textDirection: TextDirection.rtl,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                // PersistentNavBarNavigator.pushNewScreen(context,
                                //     // screen: FullScreenMapPage(
                                //     //     latitude: hotel.country.latitude,
                                //     //     longitude: hotel.location.longitude,
                                //     //     hotelName: hotel.name),
                                //     withNavBar: false,
                                //     pageTransitionAnimation: PageTransitionAnimation.cupertino);
                              },
                              child: Text(
                                "تمام صفحه",
                                textDirection: TextDirection.rtl,
                              )),
                          Text(
                            "موقعیت مکانی هتل روی نقشه",
                            style: textTheme.headlineSmall,
                            textDirection: TextDirection.rtl,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: FlutterMap(
                            options: MapOptions(
                              initialZoom: 15.0,
                              // initialCenter: LatLng(hotel.location.latitude, hotel.location.longitude),
                              interactionOptions: InteractionOptions(
                                flags: InteractiveFlag.all &
                                    ~InteractiveFlag.rotate,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'ir.dunijet.neginteb',
                              ),
                              MarkerLayer(
                                markers: [
                                  // Marker(
                                  //     point: LatLng(hotel.location.latitude, hotel.location.longitude),
                                  //     width: 80,
                                  //     height: 80,
                                  //     child: Column(
                                  //       children: [
                                  //         Icon(
                                  //           Icons.location_pin,
                                  //           color: Colors.red,
                                  //           size: 40,
                                  //         ),
                                  //         Container(
                                  //           padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  //           color: Colors.white.withOpacity(0.8),
                                  //           child: Text(
                                  //             hotel.name,
                                  //             style: textTheme.bodySmall!.copyWith(color: Colors.black),
                                  //             textDirection: TextDirection.rtl,
                                  //             textAlign: TextAlign.center,
                                  //             maxLines: 1,
                                  //             overflow: TextOverflow.ellipsis,
                                  //           ),
                                  //
                                  //       ],
                                  //     )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

enum PaymentType { nonCash, cashWithOffer }

class _PricingSection extends StatefulWidget {
  final Product hotel;

  const _PricingSection({required this.hotel});

  @override
  State<_PricingSection> createState() => _PricingSectionState();
}

class _PricingSectionState extends State<_PricingSection> {
  // لیست گزینه‌های بسته‌بندی (گرم) — اگر در مدل داری، جایگزین کن
  final List<double> packings = [60, 100, 250, 500, 1000];

  late double selectedPacking; // گرم
  int qty = 1;
  PaymentType paymentType = PaymentType.nonCash;



  @override
  void initState() {
    super.initState();
    selectedPacking = packings.first;

  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    // ===== داده‌های محصول =====
    // قیمت به ازای هر "گرم" (یا واحد پایه). اگر اسم فیلد متفاوته، اینجا عوضش کن.
    final double pricePerGram = asDouble(widget.hotel.priceVazn ?? 0);

    // درصد افر مطابق منطق جاوا:
    // if (str_naghde_or_ade == "0") => offer
    // else => offer_two
    final double offerPercent = paymentType == PaymentType.nonCash
        ? asDouble(widget.hotel.offer ?? 0)
        : asDouble(widget.hotel.offerTwo ?? 0);

    // ===== محاسبات =====
    // قیمت هر بسته انتخاب‌شده (یک عدد بسته)
    final double pricePerSelectedPack = pricePerGram * selectedPacking;

    // قیمت کل (قیمت هر بسته × تعداد)
    final double priceAll = pricePerSelectedPack * qty;

    // مبلغ افر (price_all * offer / 100)
    final int priceOfferAccrued = (priceAll * offerPercent / 100).round();

    // مبلغ قابل پرداخت با کسر افر
    final int priceAllWithOffer = (priceAll - priceOfferAccrued).round();
    print("hhhh" +widget.hotel.packing.toString());
    Widget line() => Container(
      height: 2,
      color: const Color(0xFF2E7D32),
      margin: const EdgeInsets.symmetric(vertical: 10),
    );

    Widget rowPrice({
      required String label,
      required String value,
      Color? valueColor,
      TextStyle? labelStyle,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // مبلغ در سمت چپ
            Text(
                ' ${value} ریال',
                style: t.bodyMedium?.copyWith(
                  color: valueColor ?? Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                textDirection: TextDirection.rtl
            ),
            // برچسب در سمت راست
            Text(
              label,
              style: labelStyle ?? t.titleMedium,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      );
    }

    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          line(),
          rowPrice(
            label: 'قیمت هر بسته انتخاب شده',
            value:pricePerSelectedPack.round().toString(),
            valueColor: Colors.lightBlue,
          ),
          rowPrice(
            label: 'قیمت هر بسته انتخاب‌شده ضرب در تعداد',
            value: priceAll.round().toString(),
            valueColor: Colors.lightBlue,
            labelStyle: t.bodyMedium,
          ),
          rowPrice(
            label: 'مبلغ افر شما',
            value: (priceOfferAccrued).toString(),
            valueColor: Colors.red,
          ),
          rowPrice(
            label: 'مبلغ قابل پرداخت با کسر افر',
            value: (priceAllWithOffer).toString(),
            valueColor: Colors.red,
          ),
          line(),

          // انتخاب بسته‌بندی
          Center(
            child: Text('انتخاب بسته بندی', style: t.headlineSmall, textDirection: TextDirection.rtl),
          ),
          const SizedBox(height: 12),

          // Dropdown بسته (گرم)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('گرمی', style: t.titleMedium, textDirection: TextDirection.rtl),
              const SizedBox(width: 12),
              DropdownButton<double>(
                value: selectedPacking,
                underline: Container(height: 1, color: Colors.black54),
                items: packings
                    .map((g) => DropdownMenuItem(
                  value: g,
                  child: Text((g).toString(), textDirection: TextDirection.ltr),
                ))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => selectedPacking = v);
                },
              ),
              const SizedBox(width: 12),
              Text('بسته‌ی', style: t.titleMedium, textDirection: TextDirection.rtl),
            ],
          ),

          const SizedBox(height: 16),

          // تعداد
          Center(child: Text('تعداد', style: t.headlineSmall, textDirection: TextDirection.rtl)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // منفی
              InkWell(
                onTap: () => setState(() => qty = qty > 1 ? qty - 1 : 1),
                child: Container(
                  width: 64,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: const Icon(Icons.remove, size: 28, color: Colors.red),
                ),
              ),
              const SizedBox(width: 24),
              Text('$qty', style: t.headlineMedium),
              const SizedBox(width: 24),
              // مثبت
              InkWell(
                onTap: () => setState(() => qty++),
                child: Container(
                  width: 64,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: const Icon(Icons.add, size: 28, color: Color(0xFF2E7D32)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // نمایش جمله: "۱ بسته‌ی ۶۰ گرمی معادل ۶۰ گرم"
          Center(
            child: Text(
              '${(qty)} بسته‌ی ${(selectedPacking)} گرمی معادل ${((selectedPacking * qty).round())} گرم',
              style: t.titleLarge?.copyWith(color: Colors.red),
              textDirection: TextDirection.rtl,
            ),
          ),

          const SizedBox(height: 16),

          // انتخاب نوع پرداخت (برای انتخاب درصد افر)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // غیرنقدی
              Row(
                children: [
                  Radio<PaymentType>(
                    value: PaymentType.nonCash,
                    groupValue: paymentType,
                    onChanged: (v) => setState(() => paymentType = v!),
                    activeColor: const Color(0xFF2E7D32),
                  ),
                  Text('غیر نقدی', style: t.titleMedium, textDirection: TextDirection.rtl),
                ],
              ),
              const SizedBox(width: 28),
              // نقدی (همراه با افر)
              Row(
                children: [
                  Radio<PaymentType>(
                    value: PaymentType.cashWithOffer,
                    groupValue: paymentType,
                    onChanged: (v) => setState(() => paymentType = v!),
                    activeColor: const Color(0xFF2E7D32),
                  ),
                  Text('نقدی (همراه با افر)', style: t.titleMedium, textDirection: TextDirection.rtl),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // دکمه افزودن به سبد
          SizedBox(
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43A047),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                // TODO: افزودن به سبد خرید
                // priceAllWithOffer عدد نهایی قابل پرداخت است.
              },
              child: Text('افزودن به سبد خرید', style: t.titleLarge?.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
double asDouble(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  if (v is String) {
    // اگر رقم‌ها جداکننده هزارگان دارند، حذفش کن
    final s = v.replaceAll(',', '').trim();
    return double.tryParse(s) ?? 0;
  }
  return 0;
}
bool _isBlank(String? s) => s == null || s.trim().isEmpty;

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final TextTheme textTheme;
  final Color? iconColor;
  final bool valueIsLTR;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.textTheme,
    this.iconColor,
    this.valueIsLTR = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // مقدار در چپ
        Expanded(
          child: Text(
            value,
            style: textTheme.titleMedium,
            textAlign: TextAlign.left,
            textDirection: valueIsLTR ? TextDirection.ltr : TextDirection.rtl,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 12),
        // برچسب + آیکون در راست
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(width: 8),
            Icon(icon, size: 20, color: color),
          ],
        ),
      ],
    );
  }
}


