import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../data/models/product.dart';


Future<void> sendBuyRequest({
  required BuildContext context,
  required Product hotel,
  required double selectedPacking,
  required int qty,
  required int userId,
  required String naghdi, // "0" یا "1"
  required double priceAllWithOffer,
}) async {
  try {
    // نمایش لودینگ ساده
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // داده‌هایی که جاوا در JSONObject می‌ساخت
    final Map<String, dynamic> body = {
      "command": "temp_product_new",
      "user_id": userId,
      "naghdi": naghdi,
      "number": qty.toString(),
      "price": priceAllWithOffer.toStringAsFixed(0),
      "packing": selectedPacking.toString(),
      "id_packing_holo": hotel.idHolo.toString(),
      "ad_id": hotel.id.toString(),
      "status": hotel.status.toString(),
    };

    final String jsonBody = jsonEncode({"myjson": jsonEncode(body)});

    // ارسال POST
    final dio = Dio();
    final response = await dio.post(
      "https://shimetebnegin.ir/api/appnew/command.php",
      data: FormData.fromMap({"myjson": jsonEncode(body)}),
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.plain,
      ),
    );

 // بستن CircularProgressIndicator

    if (response.data is String) {
      String res = response.data.toString().trim();

      if (res.startsWith("<ghafas>") && res.endsWith("</ghafas>")) {
        res = res.replaceAll("<ghafas>", "").replaceAll("</ghafas>", "");

        if (res == "ok") {
          _showSnack(context, "✅ محصول با موفقیت به سبد اضافه شد");
          Navigator.pop(context);
        } else if (res == "a") {
          _showSnack(context, "⚠️ موجودی کافی نیست، بعداً مجدد بررسی کنید");
        } else if (res == "not_enough") {
          _showSnack(context, "❌ موجودی این محصول کافی نیست");
        } else {
          _showSnack(context, "⚠️ خطا در دریافت اطلاعات از سرور");
        }
      } else {
        _showSnack(context, "⚠️ پاسخ سرور معتبر نیست");
      }
    }
  } catch (e) {
    Navigator.pop(context); // بستن لودینگ اگر خطا داد
    print("Error sending buy request: $e");
    _showSnack(context, "❌ خطا در ارسال اطلاعات به سرور");
  }

}
void _showSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg, textDirection: TextDirection.rtl)),
  );
}

