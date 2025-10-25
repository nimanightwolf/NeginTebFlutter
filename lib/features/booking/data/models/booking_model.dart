import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class CategoryModel {
  String fullName;
  String destination;
  JalaliRange? cehckInOutRangeDate;

  String numberOfGuests;
  String phoneNumber;

  CategoryModel(
      {this.fullName = '',
      this.destination = '',
      this.cehckInOutRangeDate,
      this.numberOfGuests = '',
      this.phoneNumber = ''});
}
