import 'dart:convert';

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v.replaceAll(',', '').trim());
  return null;
}

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v.replaceAll(',', '').trim());
  return null;
}

String _asStr(dynamic v) => (v ?? '').toString();

class CommissionRecord {
  final String idP;   // id_p
  final String date;  // "99/11/04"
  final int? price;   // int
  final String des;   // توضیح

  CommissionRecord({
    required this.idP,
    required this.date,
    required this.price,
    required this.des,
  });

  factory CommissionRecord.fromJson(Map<String, dynamic> j) => CommissionRecord(
    idP: _asStr(j['id_p']),
    date: _asStr(j['date']),
    price: _asInt(j['price']),
    des: _asStr(j['des']),
  );

  Map<String, dynamic> toJson() => {
    'id_p': idP,
    'date': date,
    'price': price,
    'des': des,
  };
}

class ProfileData {
  // ------ فیلدهای مهم «one» ------
  final String id;
  final String name;
  final String mobile;
  final String? email;

  final String permissions;     // متن فارسی دسترسی‌ها
  final String notShowPrice;    // اسلاگ‌های عدم نمایش قیمت
  final String hamkar;          // اسلاگ‌های همکار

  final String des;
  final String showPrice;
  final String priceHamkar;

  final int? updatedAtEpoch;
  final String address;

  final String moaref;
  final String dateMoaref;

  final String lastSeenJalali;  // lats_seen
  final int? lastSeenEpoch;     // last_seen_time

  final String idCompany;
  final String comionRate;
  final int? comion;            // پورسانت باقی‌مانده (ممکنه منفی/مثبت)
  final int? rate;
  final String textRate;
  final String status;          // "2"
  final String activity;        // "مشکوک"

  final double? lat;
  final double? lan;

  final String description;
  final String visitorAva;
  final String version;
  final String meli;
  final String semat;
  final String dateInstall;
  final int? updateNew;
  final String model;
  final String pushId;
  final String newUserApp;
  final String androidId;
  final String deviceName;
  final String deviceModel;
  final String androidVersion;
  final String vi;
  final String deleteFlag;
  final String dateTemp;
  final String token;
  final String tokenExpires;
  final int? priceAll;

  // لیست‌ها
  final List<String> categories;           // «two» فقط name
  final List<CommissionRecord> commissions; // «three»

  ProfileData({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.permissions,
    required this.notShowPrice,
    required this.hamkar,
    required this.des,
    required this.showPrice,
    required this.priceHamkar,
    required this.updatedAtEpoch,
    required this.address,
    required this.moaref,
    required this.dateMoaref,
    required this.lastSeenJalali,
    required this.lastSeenEpoch,
    required this.idCompany,
    required this.comionRate,
    required this.comion,
    required this.rate,
    required this.textRate,
    required this.status,
    required this.activity,
    required this.lat,
    required this.lan,
    required this.description,
    required this.visitorAva,
    required this.version,
    required this.meli,
    required this.semat,
    required this.dateInstall,
    required this.updateNew,
    required this.model,
    required this.pushId,
    required this.newUserApp,
    required this.androidId,
    required this.deviceName,
    required this.deviceModel,
    required this.androidVersion,
    required this.vi,
    required this.deleteFlag,
    required this.dateTemp,
    required this.token,
    required this.tokenExpires,
    required this.priceAll,
    required this.categories,
    required this.commissions,
  });

  factory ProfileData.fromApi(Map<String, dynamic> root) {
    final one = Map<String, dynamic>.from(root['one'] ?? {});
    final twoList = (root['two'] is List) ? List.from(root['two']) : const [];
    final threeList = (root['three'] is List) ? List.from(root['three']) : const [];

    final categories = <String>[
      for (final e in twoList)
        _asStr((e as Map)['name']).replaceAll('\r', '').replaceAll('\n', '').trim()
    ];

    final commissions = <CommissionRecord>[
      for (final e in threeList) CommissionRecord.fromJson(Map<String, dynamic>.from(e))
    ];

    return ProfileData(
      id: _asStr(one['id']),
      name: _asStr(one['name']),
      mobile: _asStr(one['mobile']),
      email: one['email'] == null ? null : _asStr(one['email']),
      permissions: _asStr(one['permissions']),
      notShowPrice: _asStr(one['not_show_price']),
      hamkar: _asStr(one['hamkar']),
      des: _asStr(one['des']),
      showPrice: _asStr(one['show_price']),
      priceHamkar: _asStr(one['price_hamkar']),
      updatedAtEpoch: _asInt(one['updated_at']),
      address: _asStr(one['adress']),
      moaref: _asStr(one['moaref']),
      dateMoaref: _asStr(one['date_moaref']),
      lastSeenJalali: _asStr(one['lats_seen']),
      lastSeenEpoch: _asInt(one['last_seen_time']),
      idCompany: _asStr(one['id_company']),
      comionRate: _asStr(one['comion_rate']),
      comion: _asInt(one['comion']),
      rate: _asInt(one['rate']),
      textRate: _asStr(one['text_rate']),
      status: _asStr(one['status']),
      activity: _asStr(one['activity']),
      lat: _asDouble(one['lat']),
      lan: _asDouble(one['lan']),
      description: _asStr(one['description']),
      visitorAva: _asStr(one['visitor_ava']),
      version: _asStr(one['version']),
      meli: _asStr(one['meli']),
      semat: _asStr(one['semat']),
      dateInstall: _asStr(one['date_install']),
      updateNew: _asInt(one['update_new']),
      model: _asStr(one['model']),
      pushId: _asStr(one['push_id']),
      newUserApp: _asStr(one['new_user_app']),
      androidId: _asStr(one['android_id']),
      deviceName: _asStr(one['dvice_name']),
      deviceModel: _asStr(one['dvice_model']),
      androidVersion: _asStr(one['android_version']),
      vi: _asStr(one['vi']),
      deleteFlag: _asStr(one['delete']),
      dateTemp: _asStr(one['date_temp']),
      token: _asStr(one['token']),
      tokenExpires: _asStr(one['token_expires']),
      priceAll: _asInt(one['price_all']),
      categories: categories,
      commissions: commissions,
    );
  }

  Map<String, dynamic> toJson() => {
    'one': {
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'permissions': permissions,
      'not_show_price': notShowPrice,
      'hamkar': hamkar,
      'des': des,
      'show_price': showPrice,
      'price_hamkar': priceHamkar,
      'updated_at': updatedAtEpoch,
      'adress': address,
      'moaref': moaref,
      'date_moaref': dateMoaref,
      'lats_seen': lastSeenJalali,
      'last_seen_time': lastSeenEpoch,
      'id_company': idCompany,
      'comion_rate': comionRate,
      'comion': comion,
      'rate': rate,
      'text_rate': textRate,
      'status': status,
      'activity': activity,
      'lat': lat,
      'lan': lan,
      'description': description,
      'visitor_ava': visitorAva,
      'version': version,
      'meli': meli,
      'semat': semat,
      'date_install': dateInstall,
      'update_new': updateNew,
      'model': model,
      'push_id': pushId,
      'new_user_app': newUserApp,
      'android_id': androidId,
      'dvice_name': deviceName,
      'dvice_model': deviceModel,
      'android_version': androidVersion,
      'vi': vi,
      'delete': deleteFlag,
      'date_temp': dateTemp,
      'token': token,
      'token_expires': tokenExpires,
      'price_all': priceAll,
    },
    'two': categories.map((e) => {'name': e}).toList(),
    'three': commissions.map((e) => e.toJson()).toList(),
  };

  String toJsonString() => jsonEncode(toJson());
  factory ProfileData.fromJsonString(String s) =>
      ProfileData.fromApi(jsonDecode(s) as Map<String, dynamic>);
}
