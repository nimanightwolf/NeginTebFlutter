import 'package:hive/hive.dart';

part 'banner_data.g.dart';

@HiveType(typeId: 2)
class BannerData {
  @HiveField(0)
  final String imageUrl;  // URL بنر

  @HiveField(1)
  final String text;  // متن بنر

  BannerData({
    required this.imageUrl,
    required this.text,
  });
}
