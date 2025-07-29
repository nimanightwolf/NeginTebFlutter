class Product {
  final String id;
  final String? userId;
  final String title;
  final String nameHolo;
  final String nameLatin;
  final String country;
  final String dateEx;
  final String datePd;
  final String price;
  final String priceType;
  final String description;
  final String keyWord;
  final String furmol;
  final String category;
  final String date;
  final String status;
  final String image1;
  final String image2;
  final String image3;
  final String isShowImage4;
  final String stiker;
  final String packing;
  final int priceVazn;
  final String priceH;
  final String priceVaznH;
  final String unit;
  final String mojodiAll;
  final String wast;
  final String linkPdf;
  final String priceShopUs;
  final String? sort;
  final String categoryTitle;
  final String relate;
  final String offer;
  final String linkVideo;
  final String naghdi;
  final String delet;
  final String offerTwo;
  final String idHolo;
  final String artNo;
  final String fourmulOne;
  final String fourmulTwo;
  final String minNumber;
  final String maxNumber;
  final String darsadVisitor;

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

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    nameHolo: json["name_holo"],
    nameLatin: json["name_latin"],
    country: json["country"],
    dateEx: json["date_ex"],
    datePd: json["date_pd"],
    price: json["price"],
    priceType: json["price_type"],
    description: json["description"],
    keyWord: json["key_word"],
    furmol: json["furmol"],
    category: json["category"],
    date: json["date"],
    status: json["status"],
    image1: json["image1"],
    image2: json["image2"],
    image3: json["image3"],
    isShowImage4: json["is_show_image4"],
    stiker: json["stiker"],
    packing: json["packing"],
    priceVazn: json["pricevazn"] ?? 0,
    priceH: json["priceh"],
    priceVaznH: json["pricevaznh"],
    unit: json["unit"],
    mojodiAll: json["mojodi_all"],
    wast: json["wast"],
    linkPdf: json["link_pdf"],
    priceShopUs: json["price_shop_us"],
    sort: json["sort"],
    categoryTitle: json["category_title"],
    relate: json["relate"],
    offer: json["offer"],
    linkVideo: json["link_video"],
    naghdi: json["naghdi"],
    delet: json["delet"],
    offerTwo: json["offer_two"],
    idHolo: json["id_holo"],
    artNo: json["art_no"],
    fourmulOne: json["fourmul_one"],
    fourmulTwo: json["fourmul_two"],
    minNumber: json["min_number"],
    maxNumber: json["max_number"],
    darsadVisitor: json["darsad_visitor"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "name_holo": nameHolo,
    "name_latin": nameLatin,
    "country": country,
    "date_ex": dateEx,
    "date_pd": datePd,
    "price": price,
    "price_type": priceType,
    "description": description,
    "key_word": keyWord,
    "furmol": furmol,
    "category": category,
    "date": date,
    "status": status,
    "image1": image1,
    "image2": image2,
    "image3": image3,
    "is_show_image4": isShowImage4,
    "stiker": stiker,
    "packing": packing,
    "pricevazn": priceVazn,
    "priceh": priceH,
    "pricevaznh": priceVaznH,
    "unit": unit,
    "mojodi_all": mojodiAll,
    "wast": wast,
    "link_pdf": linkPdf,
    "price_shop_us": priceShopUs,
    "sort": sort,
    "category_title": categoryTitle,
    "relate": relate,
    "offer": offer,
    "link_video": linkVideo,
    "naghdi": naghdi,
    "delet": delet,
    "offer_two": offerTwo,
    "id_holo": idHolo,
    "art_no": artNo,
    "fourmul_one": fourmulOne,
    "fourmul_two": fourmulTwo,
    "min_number": minNumber,
    "max_number": maxNumber,
    "darsad_visitor": darsadVisitor,
  };
}
