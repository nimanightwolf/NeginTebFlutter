import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 1) // یکتا
class CategoryModel extends HiveObject {
  @HiveField(0)
  String idcat;

  @HiveField(1)
  String title;

  @HiveField(2)
  String key_category;

  @HiveField(3)
  String image;

  @HiveField(4)
  bool is_image;

  CategoryModel({
    required this.idcat,
    required this.title,
    required this.key_category,
    required this.image,
    required this.is_image,
  });
}
