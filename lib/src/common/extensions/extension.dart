import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension BuildContextX on BuildContext {
  void showErrorSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: duration ?? const Duration(seconds: 2),
        ),
      );
  }

  void showSuccessSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: duration ?? const Duration(seconds: 2),
        ),
      );
  }

  Future<CountryCode?> showCountryPicker() async {
    final FlCountryCodePicker codePicker = FlCountryCodePicker(
      countryTextStyle: TextStyle(
        fontSize: 16.sp,
      ),
      dialCodeTextStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
      ),
    );

    final code = await codePicker.showPicker(
      context: this,
      scrollToDeviceLocale: true,
    );

    return code;
  }
}
