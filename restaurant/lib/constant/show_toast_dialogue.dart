import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

class ShowToastDialog {
  static void showLoader(String message) {
    try {
      EasyLoading.show(status: message);
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log("Error Show Loader:", error: e, stackTrace: stack);
      }
    }
  }

  static void closeLoader() {
    try {
      EasyLoading.dismiss();
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log("Error Close Loader:", error: e, stackTrace: stack);
      }
    }
  }

  static void toast(
    String? value, {
    ToastGravity gravity = ToastGravity.TOP,
    length = Toast.LENGTH_SHORT,
    Color? bgColor,
    Color? textColor,
    bool log = false,
  }) {
    try {
      if (value == null || value.isEmpty) {
        if (kDebugMode) {
          developer.log("Toast message is null or empty");
        }
      } else {
        Fluttertoast.showToast(
          msg: value,
          gravity: gravity,
          toastLength: length,
          backgroundColor: bgColor,
          textColor: textColor,
        );
        if (log && kDebugMode) {
          developer.log("Toast message: $value");
        }
      }
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log("Error Show Toast:", error: e, stackTrace: stack);
      }
    }
  }
}
