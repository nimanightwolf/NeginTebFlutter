import 'package:hive/hive.dart';

part 'product_ids.g.dart';

@HiveType(typeId: 1)
class ProductIds {
  @HiveField(0)
  final List<String> popularProductIds; // لیست محصولات محبوب

  @HiveField(1)
  final List<String> specialOfferProductIds; // لیست محصولات پیشنهادات ویژه

  @HiveField(2)
  final List<String> newProductIds; // لیست محصولات جدیدترین

  ProductIds({
    required this.popularProductIds,
    required this.specialOfferProductIds,
    required this.newProductIds,
  });
}
