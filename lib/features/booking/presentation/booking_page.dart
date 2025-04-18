// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hotelino/features/booking/presentation/booking_provider.dart';
import 'package:hotelino/features/booking/presentation/widgets/booking_form_field.dart';
import 'package:hotelino/features/booking/presentation/widgets/date_picker_field.dart';
import 'package:hotelino/features/booking/presentation/widgets/number_text_field.dart';
import 'package:provider/provider.dart';

class BookingPage extends StatefulWidget {
  static final GlobalKey<BookingPageState> bookingPageKey = GlobalKey<BookingPageState>();

  BookingPage({Key? key}) : super(key: bookingPageKey);

  @override
  State<BookingPage> createState() => BookingPageState();
}

class BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();

  void resetForm() {
    Future.delayed(
      Duration(milliseconds: 100),
      () {
        _formKey.currentState?.reset();
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('فرم رزرو هتل', style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Consumer<BookingProvider>(
            builder: (context, bookingProvider, child) {
              return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BookingFormField(
                        title: 'نام و نام خانوادگی',
                        hint: 'نام و نام خانوادگی خود را وارد کنید...',
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا نام خود را کامل بنویسید';
                          }

                          return null;
                        },
                        initialValue: bookingProvider.booking.fullName,
                        onSaved: (newValue) {
                          if (newValue != null) {
                            bookingProvider.setName(newValue);
                          }
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      BookingFormField(
                        title: 'مقصد',
                        hint: 'مقصد خود را وارد کنید...',
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا مقصد خود را مشخص کنید';
                          }

                          return null;
                        },
                        initialValue: bookingProvider.booking.destination,
                        onSaved: (newValue) {
                          if (newValue != null) {
                            bookingProvider.setDestination(newValue);
                          }
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      DatePickerField(
                        title: 'تاریخ اقامت',
                        hint: 'بازه زمانی اقامت را مشخص کنید',
                        initialValue: bookingProvider.booking.cehckInOutRangeDate,
                        validator: (value) {
                          if (value == null) {
                            return 'لطفاً بازه‌ی زمانی را انتخاب کنید';
                          }

                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue != null) {
                            bookingProvider.setRangeDate(newValue);
                          }
                        },
                      ),
                      SizedBox(height: 8),
                      BookingFormField(
                        title: 'تعداد نفرات',
                        hint: 'تعداد نفرات خود را وارد کنید...',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا تعداد نفرات را مشخص کنید';
                          }

                          return null;
                        },
                        initialValue: bookingProvider.booking.numberOfGuests,
                        onSaved: (newValue) {
                          if (newValue != null) {
                            bookingProvider.setNumberOfGuest(newValue);
                          }
                        },
                      ),
                      SizedBox(height: 8),
                      NumberFormField(
                        initialValue: bookingProvider.booking.phoneNumber,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا شماره را به درستی وارد کنید';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue != null) {
                            bookingProvider.setPhoneNumber(newValue);
                          }
                        },
                      ),
                    ],
                  ));
            },
          ),
        ),
      ),
    );
  }
}
