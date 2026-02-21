// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/admin_commission.dart';
import 'package:restaurant/app/models/currency_model.dart';
import 'package:restaurant/app/models/language_model.dart';
import 'package:restaurant/app/models/owner_model.dart';
import 'package:restaurant/app/models/payment_method_model.dart';
import 'package:restaurant/app/models/tax_model.dart';
import 'package:restaurant/app/models/vendor_model.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:restaurant/utils/preferences.dart';
import 'package:uuid/uuid.dart';

import '../app/models/order_model.dart';
import '../app/widget/text_widget.dart';

class Constant {
  static OwnerModel? ownerModel;
  static VendorModel? vendorModel;
  static CurrencyModel? currencyModel;
  static AdminCommission? adminCommission;
  static PaymentModel? paymentModel;

  static String googleLoginType = 'google';
  static String phoneLoginType = 'phone';
  static String appleLoginType = 'apple';
  static String emailLoginType = 'email';
  static String restaurant = 'restaurant';
  static String owner = 'owner';
  static String driver = 'driver';
  static String user = 'user';

  static RxString appName = "".obs;
  static String? appColor;
  static String senderId = "";
  static String jsonFileURL = "";
  static String minimumAmountToWithdrawal = "0";
  static String minimumAmountToDeposit = "100";
  static String radius = "0";
  static String googleMapKey = "";
  static String notificationServerKey = "";
  static String termsAndConditions = "";
  static String privacyPolicy = "";
  static String aboutApp = "";
  static String supportEmail = "";
  static String phoneNumber = "";
  static bool extraChargeGst = false;
  static bool? isDocumentVerificationEnable = true;
  static bool? isSelfDelivery = false;
  static bool isLogin = false;
  static const userPlaceHolder = "assets/images/user_place_holder.png";
  static const placeLogo = "assets/images/place_holder.png";
  static String paymentCallbackURL = 'https://elaynetech.com/callback';

  static String fullNameString(String? firstName, String? lastName) {
    try {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    } catch (e, stack) {
      developer.log("Error Full Name", error: e, stackTrace: stack);
      return '';
    }
  }

  static String getUuid() {
    try {
      return const Uuid().v4();
    } catch (e, stack) {
      developer.log("Error Uuid", error: e, stackTrace: stack);
      return "";
    }
  }

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();

  static String getRandomString(int length) {
    try {
      return String.fromCharCodes(
        Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))),
      );
    } catch (e, stack) {
      developer.log("Error Random String", error: e, stackTrace: stack);
      return "";
    }
  }

  static Widget loader() {
    try {
      return Center(
        child: CircularProgressIndicator(color: AppThemeData.primary300),
      );
    } catch (e, stack) {
      developer.log("Error Loader", error: e, stackTrace: stack);
      return const SizedBox();
    }
  }

  static String calculateReview({required String? reviewCount, required String? reviewSum}) {
    try {
      if (reviewCount == "0.0" && reviewSum == "0.0") {
        return "0.0";
      }
      double count = double.parse(reviewCount.toString());
      double sum = double.parse(reviewSum.toString());

      if (count == 0) return "0.0";

      return (sum / count).toStringAsFixed(1);
    } catch (e, stack) {
      developer.log("Error Uuid", error: e, stackTrace: stack);
      return "0.0";
    }
  }

  static String maskMobileNumber({String? mobileNumber, String? countryCode}) {
    try {
      if (mobileNumber == null || countryCode == null || mobileNumber.length < 4) {
        return "";
      }
      String firstTwoDigits = mobileNumber.substring(0, 2);
      String lastTwoDigits = mobileNumber.substring(mobileNumber.length - 2);
      String maskedNumber = firstTwoDigits + 'x' * (mobileNumber.length - 4) + lastTwoDigits;

      return "$countryCode $maskedNumber";
    } catch (e, stack) {
      developer.log("Error Mask Mobile Number:", error: e, stackTrace: stack);
      return "";
    }
  }

  static String maskEmail({String? email}) {
    try {
      if (email == null || !email.contains('@')) {
        throw ArgumentError("Invalid email address");
      }
      List<String> parts = email.split('@');
      if (parts.length != 2) {
        throw ArgumentError("Invalid email address");
      }
      String username = parts[0];
      String domain = parts[1];
      String maskedUsername = username.substring(0, 2) + 'x' * (username.length - 2);
      return '$maskedUsername@$domain';
    } catch (e, stack) {
      developer.log("Error Mask Email:", error: e, stackTrace: stack);
      return email ?? '';
    }
  }

  static Padding showFoodType({required String name}) {
    try {
      final themeChange = Provider.of<DarkThemeProvider>(Get.context!);

      return Padding(
        padding: paddingEdgeInsets(horizontal: 0, vertical: 8),
        child: Row(
          children: name == "Both"
              ? [
                  _buildFoodTypeIcon(true, themeChange),
                  spaceW(width: 4),
                  _buildFoodTypeLabel("Veg.".tr, true, themeChange),
                  spaceW(width: 4),
                  _buildFoodTypeIcon(false, themeChange),
                  spaceW(width: 4),
                  _buildFoodTypeLabel("Non veg".tr, false, themeChange),
                ]
              : [
                  _buildFoodTypeIcon(name == "Veg", themeChange),
                  spaceW(width: 4),
                  _buildFoodTypeLabel(name == "Veg" ? "Veg.".tr : "Non veg".tr, name == "Veg", themeChange),
                ],
        ),
      );
    } catch (e, stack) {
      developer.log("Error Show Food Type:", error: e, stackTrace: stack);
      return Padding(
        padding: paddingEdgeInsets(horizontal: 0, vertical: 8),
        child: Text(
          name,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }
  }

  static Widget _buildFoodTypeIcon(bool isVeg, DarkThemeProvider themeChange) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
      ),
      height: 16.h,
      width: 16.w,
      child: Center(
        child: Builder(
          builder: (_) {
            try {
              return SvgPicture.asset(
                "assets/icons/ic_food_type.svg",
                color: isVeg ? (themeChange.isDarkTheme() ? AppThemeData.success200 : AppThemeData.success400) : AppThemeData.danger300,
              );
            } catch (e, stack) {
              developer.log("Error Build Food Type Icon:", error: e, stackTrace: stack);
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  static Widget _buildFoodTypeLabel(String title, bool isVeg, DarkThemeProvider themeChange) {
    try {
      return TextCustom(
        title: title,
        fontSize: 16,
        fontFamily: FontFamily.medium,
        color: isVeg ? (themeChange.isDarkTheme() ? AppThemeData.success200 : AppThemeData.success400) : AppThemeData.danger300,
      );
    } catch (e, stack) {
      developer.log("Error Build Food Type Label:", error: e, stackTrace: stack);
      return const SizedBox.shrink();
    }
  }

  static LanguageModel getLanguage() {
    try {
      final String user = Preferences.getString(Preferences.languageCodeKey);
      Map<String, dynamic> userMap = jsonDecode(user);
      return LanguageModel.fromJson(userMap);
    } catch (e, stack) {
      developer.log("Error Get Language:", error: e, stackTrace: stack);
      return LanguageModel();
    }
  }

  static double calculateAdminCommission({String? amount, AdminCommission? adminCommission}) {
    try {
      double taxAmount = 0.0;
      if (adminCommission != null && adminCommission.active == true) {
        if (adminCommission.isFix == true) {
          taxAmount = double.parse(adminCommission.value.toString());
        } else {
          taxAmount = (double.parse(amount.toString()) * double.parse(adminCommission.value!.toString())) / 100;
        }
      }
      return taxAmount;
    } catch (e, stack) {
      developer.log("Error Calculate Admin Commission:", error: e, stackTrace: stack);
      return 0.0;
    }
  }

  static double amountBeforeTax(OrderModel bookingModel) {
    try {
      return (double.parse(bookingModel.subTotal ?? '0.0') - double.parse((bookingModel.discount ?? '0.0').toString()));
    } catch (e, stack) {
      developer.log("Error Amount Before Tax:", error: e, stackTrace: stack);
      return 0.0;
    }
  }

  static double calculateTax({String? amount, TaxModel? taxModel}) {
    try {
      double taxAmount = 0.0;
      if (taxModel != null && taxModel.active == true) {
        if (taxModel.isFix == true) {
          taxAmount = double.parse(taxModel.value.toString());
        } else {
          taxAmount = (double.parse(amount.toString()) * double.parse(taxModel.value!.toString())) / 100;
        }
      }
      return taxAmount;
    } catch (e, stack) {
      developer.log("Error Calculate Tax:", error: e, stackTrace: stack);
      return 0.0;
    }
  }

  static String? validateEmail(String? value) {
    try {
      String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);
      if (value == null || value.isEmpty) {
        return "Email is Required".tr;
      } else if (!regExp.hasMatch(value)) {
        return "Invalid Email".tr;
      } else {
        return null;
      }
    } catch (e, stack) {
      developer.log("Error Validate Email:", error: e, stackTrace: stack);
      return "Invalid Email".tr;
    }
  }

  static String? validatePassword(String? value) {
    try {
      if (value == null || value.isEmpty || value.length < 6) {
        return "Minimum password length should be 6".tr;
      } else {
        return null;
      }
    } catch (e, stack) {
      developer.log("Error Validate Password:", error: e, stackTrace: stack);
      return "Invalid Password".tr;
    }
  }

  static Widget showEmptyView(BuildContext context, {required String message}) {
    try {
      final themeChange = Provider.of<DarkThemeProvider>(context);
      return Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 18,
            color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
          ),
        ),
      );
    } catch (e, stack) {
      developer.log("Error Show Empty View:", error: e, stackTrace: stack);
      return const Center(
        child: Text(
          "Something went wrong",
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }
  }

  static Future<String> uploadImageToFireStorage(File image, String filePath, String fileName) async {
    try {
      Reference upload = FirebaseStorage.instance.ref().child('$filePath/$fileName');
      UploadTask uploadTask = upload.putFile(image);
      var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
      return downloadUrl.toString();
    } catch (e, stack) {
      developer.log("Error Upload Firebase Image:", error: e, stackTrace: stack);
      return '';
    }
  }

  static Future<List<String>> uploadProductImage(List<String> images, String restaurantId) async {
    try {
      var uid = FireStoreUtils.getCurrentUid();
      var imageUrls = await Future.wait(
        images.map(
          (image) => uploadImageToFireStorage(
            File(image),
            "productImages/$uid",
            File(image).path.split("/").last,
          ),
        ),
      );
      return imageUrls;
    } catch (e, stack) {
      developer.log("Error Upload Product Image:", error: e, stackTrace: stack);
      return [];
    }
  }

  static Future<String> uploadRestaurantImage(String image, String restaurantId) async {
    try {
      final file = File(image);
      final path = file.path.split("/").last;
      final imageUrl = await uploadImageToFireStorage(file, "restaurantImages/$restaurantId", path);
      return imageUrl;
    } catch (e, stack) {
      developer.log("Error Upload RestaurantImage:", error: e, stackTrace: stack);
      return '';
    }
  }

  static bool hasValidUrl(String value) {
    try {
      String pattern = r'(http|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?';
      RegExp regExp = RegExp(pattern);

      if (value.isEmpty) return false;
      return regExp.hasMatch(value);
    } catch (e, stack) {
      developer.log("Error HasValid Url:", error: e, stackTrace: stack);
      return false;
    }
  }

  static Future<DateTime?> selectDate(BuildContext context) async {
    try {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppThemeData.primary300,
                onPrimary: AppThemeData.grey500,
                onSurface: AppThemeData.grey500,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppThemeData.grey500,
                ),
              ),
            ),
            child: child!,
          );
        },
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2101),
      );
      return pickedDate;
    } catch (e, stack) {
      developer.log("Error Select Date:", error: e, stackTrace: stack);
      return null;
    }
  }

  static Future<TimeOfDay?> selectTime(BuildContext context) async {
    try {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.dial,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: Theme(
              data: Theme.of(context).copyWith(
                timePickerTheme: TimePickerThemeData(
                  dayPeriodColor: WidgetStateColor.resolveWith(
                    (states) => states.contains(WidgetState.selected) ? AppThemeData.primary300 : AppThemeData.primary300.withOpacity(0.4),
                  ),
                  dayPeriodShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  hourMinuteColor: WidgetStateColor.resolveWith(
                    (states) => states.contains(WidgetState.selected) ? AppThemeData.primary300 : AppThemeData.primary300.withOpacity(0.4),
                  ),
                ),
                colorScheme: ColorScheme.light(
                  primary: AppThemeData.primary300,
                  onPrimary: AppThemeData.grey500,
                  onSurface: AppThemeData.grey500,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: AppThemeData.grey500,
                  ),
                ),
              ),
              child: child!,
            ),
          );
        },
      );

      return pickedTime;
    } catch (e, stack) {
      developer.log("Error Select Time:", error: e, stackTrace: stack);
      return null;
    }
  }

  static Color getRatingBarColor(int rating) {
    try {
      if (rating == 1 || rating == 2) {
        return AppThemeData.primary300;
      } else if (rating == 3) {
        return const Color(0xFFff6200);
      } else if (rating == 4 || rating == 5) {
        return const Color(0xFF73CB92);
      } else {
        return AppThemeData.primary300;
      }
    } catch (e, stack) {
      developer.log("Error Get RatingBar Color:", error: e, stackTrace: stack);
      return AppThemeData.primary300;
    }
  }

  static String amountShow({required String? amount}) {
    try {
      double parsedAmount = double.parse(amount.toString());
      int decimals = Constant.currencyModel?.decimalDigits ?? 2;
      String symbol = Constant.currencyModel?.symbol ?? '';

      if (Constant.currencyModel?.symbolAtRight == true) {
        return "${parsedAmount.toStringAsFixed(decimals)} $symbol";
      } else {
        return "$symbol ${parsedAmount.toStringAsFixed(decimals)}";
      }
    } catch (e, stack) {
      developer.log("Error Amount Show:", error: e, stackTrace: stack);
      return "N/A";
    }
  }

  static String timestampToDate(Timestamp timestamp) {
    try {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('dd MMMM yyyy').format(dateTime);
    } catch (e, stack) {
      developer.log("Error Timestamp To Date:", error: e, stackTrace: stack);
      return '';
    }
  }

  static String timestampToTime(Timestamp timestamp) {
    try {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e, stack) {
      developer.log("Error Timestamp To Time:", error: e, stackTrace: stack);
      return '';
    }
  }

  static String timestampToTime12Hour(Timestamp timestamp) {
    try {
      DateTime dateTime = timestamp.toDate();
      return DateFormat.jm().format(dateTime);
    } catch (e, stack) {
      developer.log("Error TimeStamp To Time 12 Hour:", error: e, stackTrace: stack);
      return '';
    }
  }

  static String timestampToDateWithTime(Timestamp timestamp) {
    try {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('d MMMM y \'at\' hh:mm a').format(dateTime);
    } catch (e, stack) {
      developer.log("Error TimeStamp To Date With Time:", error: e, stackTrace: stack);
      return '';
    }
  }

  static String showId(String id) {
    try {
      if (id.length >= 5) {
        return '#${id.substring(0, 5)}';
      } else {
        return '#$id';
      }
    } catch (e, stack) {
      developer.log("Error Show Id:", error: e, stackTrace: stack);
      return '#-----';
    }
  }

  static String formatTimeOfDayTo12Hour(TimeOfDay tod) {
    try {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
      return DateFormat.jm().format(dt);
    } catch (e, stack) {
      developer.log("Error Format Time Of DayTo 12 Hour:", error: e, stackTrace: stack);
      return '';
    }
  }

  static TimeOfDay stringToTimeOfDay(String time) {
    try {
      final period = time.trim().split(' ').last.toUpperCase();
      final parts = time.trim().split(' ').first.split(':');

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e, stack) {
      developer.log("Error String To Time Of Day:", error: e, stackTrace: stack);
      return TimeOfDay.now();
    }
  }

  static String timeAgo(Timestamp timestamp) {
    try {
      Duration diff = DateTime.now().difference(timestamp.toDate());

      if (diff.inDays > 365) {
        int years = (diff.inDays / 365).floor();
        return "$years ${years == 1 ? "year" : "years"} ago";
      }
      if (diff.inDays > 30) {
        int months = (diff.inDays / 30).floor();
        return "$months ${months == 1 ? "month" : "months"} ago";
      }
      if (diff.inDays > 7) {
        int weeks = (diff.inDays / 7).floor();
        return "$weeks ${weeks == 1 ? "week" : "weeks"} ago";
      }
      if (diff.inDays > 0) {
        return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
      }
      if (diff.inHours > 0) {
        return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
      }
      if (diff.inMinutes > 0) {
        return "${diff.inMinutes} ${diff.inMinutes == 1 ? "min" : "mins"} ago";
      }

      return "just now";
    } catch (e, stack) {
      developer.log("Error Time Ago:", error: e, stackTrace: stack);
      return "some time ago";
    }
  }

  static InputDecoration defaultInputDecoration(BuildContext context) {
    try {
      final themeChange = Provider.of<DarkThemeProvider>(context);

      return InputDecoration(
        iconColor: AppThemeData.primary500,
        isDense: true,
        filled: true,
        fillColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
          ),
        ),
        hintText: "Select time",
        hintStyle: TextStyle(
          fontSize: 16,
          color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
          fontWeight: FontWeight.w500,
        ),
      );
    } catch (e, stack) {
      developer.log("Error Default Input Decoration:", error: e, stackTrace: stack);
      return const InputDecoration(
        hintText: "Select time",
        border: OutlineInputBorder(),
      );
    }
  }
}
