import 'package:hive/hive.dart';

part 'product.g.dart';  // برای تولید کدهای Hive

@HiveType(typeId: 0)  // تعیین ID منحصر به‌فرد برای مدل
class Product {
  @HiveField(0)
  final String id; // شناسه محصول

  @HiveField(1)
  final String? userId; // شناسه کاربر

  @HiveField(2)
  final String title; // عنوان محصول

  @HiveField(3)
  final String nameHolo; // نام هولوگرافی

  @HiveField(4)
  final String nameLatin; // نام لاتین

  @HiveField(5)
  final String country; // کشور سازنده

  @HiveField(6)
  final String dateEx; // تاریخ انقضا

  @HiveField(7)
  final String datePd; // تاریخ تولید

  @HiveField(8)
  final String price; // قیمت

  @HiveField(9)
  final String priceType; // نوع قیمت

  @HiveField(10)
  final String description; // توضیحات

  @HiveField(11)
  final String keyWord; // کلمات کلیدی

  @HiveField(12)
  final String furmol; // فرمول

  @HiveField(13)
  final String category; // دسته‌بندی

  @HiveField(14)
  final String date; // تاریخ

  @HiveField(15)
  final String status; // وضعیت

  @HiveField(16)
  final String image1; // تصویر اول

  @HiveField(17)
  final String image2; // تصویر دوم

  @HiveField(18)
  final String image3; // تصویر سوم

  @HiveField(19)
  final String isShowImage4; // نمایش تصویر چهارم

  @HiveField(20)
  final String stiker; // استیکر

  @HiveField(21)
  final String packing; // بسته‌بندی

  @HiveField(22)
  final String priceVazn; // قیمت بر اساس وزن

  @HiveField(23)
  final String priceH; // قیمت

  @HiveField(24)
  final String priceVaznH; // قیمت وزن

  @HiveField(25)
  final String unit; // واحد

  @HiveField(26)
  final String mojodiAll; // موجودی کل

  @HiveField(27)
  final String wast; // ضایعات

  @HiveField(28)
  final String linkPdf; // لینک فایل PDF

  @HiveField(29)
  final String priceShopUs; // قیمت فروشگاه

  @HiveField(30)
  final String? sort; // مرتب‌سازی

  @HiveField(31)
  final String categoryTitle; // عنوان دسته‌بندی

  @HiveField(32)
  final String relate; // محصول مرتبط

  @HiveField(33)
  final String offer; // پیشنهاد

  @HiveField(34)
  final String linkVideo; // لینک ویدیو

  @HiveField(35)
  final String naghdi; // نقدی

  @HiveField(36)
  final String delet; // حذف

  @HiveField(37)
  final String offerTwo; // پیشنهاد دوم

  @HiveField(38)
  final String idHolo; // شناسه هولوگرافی

  @HiveField(39)
  final String artNo; // شماره قطعه

  @HiveField(40)
  final String fourmulOne; // فرمول اول

  @HiveField(41)
  final String fourmulTwo; // فرمول دوم

  @HiveField(42)
  final String minNumber; // حداقل تعداد

  @HiveField(43)
  final String maxNumber; // حداکثر تعداد

  @HiveField(44)
  final String darsadVisitor; // درصد بازدید

  Product({
    required this.id,
    required this.userId,
    required this.title,
    required this.nameHolo,
    required this.nameLatin,
    required this.country,
    required this.dateEx,
    required this.datePd,
    required this.price,
    required this.priceType,
    required this.description,
    required this.keyWord,
    required this.furmol,
    required this.category,
    required this.date,
    required this.status,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.isShowImage4,
    required this.stiker,
    required this.packing,
    required this.priceVazn,
    required this.priceH,
    required this.priceVaznH,
    required this.unit,
    required this.mojodiAll,
    required this.wast,
    required this.linkPdf,
    required this.priceShopUs,
    required this.sort,
    required this.categoryTitle,
    required this.relate,
    required this.offer,
    required this.linkVideo,
    required this.naghdi,
    required this.delet,
    required this.offerTwo,
    required this.idHolo,
    required this.artNo,
    required this.fourmulOne,
    required this.fourmulTwo,
    required this.minNumber,
    required this.maxNumber,
    required this.darsadVisitor,
  });
}
