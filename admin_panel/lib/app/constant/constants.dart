// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, deprecated_member_use
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:admin_panel/app/constant/order_status.dart';
import 'package:admin_panel/app/models/admin_commission_model.dart';
import 'package:admin_panel/app/models/admin_model.dart';
import 'package:admin_panel/app/models/driver_user_model.dart';
import 'package:admin_panel/app/models/order_model.dart';
import 'package:admin_panel/app/models/constant_model.dart';
import 'package:admin_panel/app/models/currency_model.dart';
import 'package:admin_panel/app/models/language_model.dart';
import 'package:admin_panel/app/models/payment_method_model.dart';
import 'package:admin_panel/app/models/vendor_model.dart';
import 'package:admin_panel/app/models/tax_model.dart';
import 'package:admin_panel/app/models/user_model.dart';
import 'package:admin_panel/app/services/shared_preferences/app_preference.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/owner_model.dart';

enum Status { active, inactive }

class Constant {
  static bool isLogin = false;
  static String emailLoginType = 'email';
  static Position? currentLocation;

  static const userPlaceHolder = 'assets/image/user_placeholder.png';
  static List<String> numOfPageIemList = ['10', '20', '50', '100'];
  static bool isDemo = false;
  static ConstantModel? constantModel;
  static UserModel? userModel;
  static OwnerModel? ownerModel;
  static DriverUserModel? driverUserModel;
  static AdminModel? adminModel;
  static PaymentModel? paymentModel;
  static VendorModel? restaurantModel;
  static String restaurant = 'restaurant';
  static String owner = 'owner';
  static String user = 'user';
  static String driver = 'driver';
  static String mapAPIKey = "";
  static String? appColor;
  static String? appName = "Go 4 Food".tr;
  static String googleMapKey = "";
  static String distanceType = "KM";
  static String minimumAmountToDeposit = "100";
  static String minimumAmountToWithdrawal = "100";
  static String notificationServerKey = "";
  static AdminCommission? adminCommission;
  static CurrencyModel? currencyModel;
  static int? vehicleModelLength = 0;
  static int? vehicleBrandLength = 0;
  static int? usersLength = 0;
  static int? productLength = 0;
  static int? restaurantProductLength = 0;
  static int? restaurantReviewLength = 0;
  static int? restaurantTransactionLength = 0;
  static int? maleUserLength = 0;
  static int? femaleUserLength = 0;
  static int? orderLength = 0;
  static int? restaurantOrderLength = 0;
  static int? driverOrderLength = 0;
  static int? pendingOrderLength = 0;
  static int? completeOrderLength = 0;
  static int? rejectedOrderLength = 0;
  static int? userOrderLength = 0;
  static int? driverLength = 0;
  static int? ownerLength = 0;
  static int? unVerifiedOwner = 0;
  static int? restaurantLength = 0;
  static int? onlineUserLength = 0;
  static int? reportedUser = 0;
  static BoxShadow boxShadow = BoxShadow(offset: const Offset(2, 3), color: AppThemeData.textBlack.withOpacity(.2), blurRadius: .2, spreadRadius: .2);
  static BoxDecoration boxDecoration = BoxDecoration(
    color: AppThemeData.primaryWhite,
    borderRadius: BorderRadius.circular(10),
  );
  static BoxDecoration searchBoxDecoration = BoxDecoration(
    color: AppThemeData.lightGrey05,
    borderRadius: BorderRadius.circular(10),
  );

  static String statusPending = 'Pending';
  static String statusSubmitted = 'Submitted';
  static String statusApproved = 'Approved';
  static String statusDeclined = 'Declined';

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();

  static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  static TextStyle defaultTextStyle({double size = 24.00, Color color = Colors.black}) {
    return TextStyle(fontSize: size, color: color, fontWeight: FontWeight.w600, fontFamily: FontFamily.medium);
  }

  static void isDemoSet(AdminModel adminModel) {
    if (kDebugMode) {
      Constant.isDemo = false;
    } else {
      Constant.isDemo = adminModel.isDemo ?? false;
    }
  }

  static Widget loader() {
    return Center(
      child: Image.asset(
        'assets/animation/loader.gif',
        width: 80,
        height: 80,
      ),
      // child: CircularProgressIndicator(color:AppThemeData.primary500),
    );
  }

  static Widget circularProgressIndicatourLoader() {
    return const Center(
      child: CircularProgressIndicator(color: AppThemeData.primary500),
    );
  }

  static Future<String> uploadImageToFireStorage(dynamic image, String filePath, String fileName) async {
    Reference upload = FirebaseStorage.instance.ref().child('$filePath/$fileName');
    final metadata = SettableMetadata(contentType: 'image/png');
    UploadTask uploadTask;

    if (image is Uint8List) {
      uploadTask = upload.putData(image, metadata);
    } else if (image is File) {
      uploadTask = upload.putFile(image, metadata);
    } else {
      throw UnsupportedError('Unsupported image type');
    }

    var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static Future<String> uploadRestaurantImage(String image, String restaurantId) async {
    var imageUrl = uploadImageToFireStorage(File(image), "restaurantImages/$restaurantId", File(image).path.split("/").last);
    return imageUrl;
  }

  static Widget CustomDivider() {
    return Padding(
      padding: paddingEdgeInsets(horizontal: 0, vertical: 5),
      child: const SizedBox(
        height: 1,
        child: ContainerCustom(),
      ),
    );
  }

  static String maskEmailNotShow(String? email) {
    if (email == null || email.isEmpty) return "N/A";

    List<String> parts = email.split("@");
    if (parts.length != 2) return email; // Invalid email, return as is

    String username = parts[0];
    String domain = parts[1];

    if (username.length <= 2) {
      return "${"x".padRight(username.length, "x")}@$domain";
    }

    // Mask all but first and last character of username
    String maskedUsername = username[0] + "x" * (username.length - 2) + username[username.length - 1];

    return "$maskedUsername@$domain";
  }

  static String calculateReview({required String? reviewCount, required String? reviewSum}) {
    if (reviewCount == "0.0" && reviewSum == "0.0") {
      return "0.0";
    }
    return (double.parse(reviewSum.toString()) / double.parse(reviewCount.toString())).toStringAsFixed(1);
  }

  static double calculateAdminCommission({String? amount, AdminCommission? adminCommission}) {
    double commissionValue = 0.0;
    if (adminCommission != null && adminCommission.active == true) {
      if (adminCommission.isFix == true) {
        commissionValue = double.parse(adminCommission.value.toString());
      } else {
        commissionValue = (double.parse(amount.toString()) * double.parse(adminCommission.value!.toString())) / 100;
      }
    }
    return commissionValue;
  }

  static void waitingLoader() {
    Get.dialog(const Center(
      child: CircleAvatar(
          maxRadius: 25,
          backgroundColor: AppThemeData.lightGrey01,
          child: CircularProgressIndicator(
            color: AppThemeData.primary500,
          )),
    ));
  }

  static String getUuid() {
    return const Uuid().v4();
  }

  static String timestampToDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static Timestamp dateToTimestamp(String date) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final DateTime dateTime = formatter.parse(date);
    return Timestamp.fromDate(dateTime);
  }

  static String timestampToDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMMM yyyy hh:mm aa').format(dateTime);
  }

  static String extractNumber(String input) {
    RegExp regExp = RegExp(r'^\d+');
    Match? match = regExp.firstMatch(input);
    if (match != null) {
      return match.group(0)!;
    }
    return '';
  }

  static bool hasValidUrl(String value) {
    String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static double calculateFinalAmount(OrderModel bookingModel) {
    RxString taxAmount = "0.0".obs;
    for (var element in (bookingModel.taxList ?? [])) {
      taxAmount.value = (double.parse(taxAmount.value) +
              Constant.calculateTax(amount: ((double.parse(bookingModel.subTotal ?? '0.0')) - double.parse((bookingModel.discount ?? '0.0').toString())).toString(), taxModel: element))
          .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
    }
    return (double.parse(bookingModel.subTotal ?? '0.0') - double.parse((bookingModel.discount ?? '0.0').toString())) +
        double.parse(taxAmount.value) +
        double.parse(bookingModel.deliveryCharge ?? '0.0');
  }

  static double amountBeforeTax(OrderModel bookingModel) {
    return (double.parse(bookingModel.subTotal ?? '0.0') - double.parse((bookingModel.discount ?? '0.0').toString()));
  }

  static double calculateTax({String? amount, TaxModel? taxModel}) {
    double taxAmount = 0.0;
    if (taxModel != null && taxModel.active == true) {
      if (taxModel.isFix == true) {
        taxAmount = double.parse(taxModel.value.toString());
      } else {
        taxAmount = (double.parse(amount.toString()) * double.parse(taxModel.value!.toString())) / 100;
      }
    }
    return taxAmount;
  }

  static String? validateEmail(String? value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value ?? '')) {
      return 'Enter valid email';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty || value.length < 6) {
      return "Minimum password length should be 6";
    } else {
      return null;
    }
  }

  static String timestampToTime12Hour(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat.jm().format(dateTime);
  }

  static String maskMobileNumber({String? mobileNumber, String? countryCode}) {
    String maskedNumber = 'x' * (mobileNumber!.length - 2) + mobileNumber.substring(mobileNumber.length - 2);
    return Constant.isDemo ? "$countryCode $maskedNumber" : "$countryCode $mobileNumber";
  }

  static String calculateDistanceInKm(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
    double distanceInKm = distanceInMeters / 1000;
    return distanceInKm.toStringAsFixed(2);
  }

  static String maskEmail({String? email}) {
    if (email == null || !email.contains('@')) {
      throw ArgumentError("Invalid email address");
    }

    List<String> parts = email.split('@');
    if (parts.length != 2) {
      throw ArgumentError("Invalid email address");
    }

    String username = parts[0];
    String domain = parts[1];

    String maskedUsername;
    if (username.length <= 2) {
      maskedUsername = username[0] + 'x' * (username.length - 1);
    } else {
      maskedUsername = username.substring(0, 2) + 'x' * (username.length - 2);
    }

    return Constant.isDemo ? '$maskedUsername@$domain' : email;
  }

  static Future<void> getCurrencyData() async {
    await FireStoreUtils.getCurrency().then((value) {
      if (value != null) {
        Constant.currencyModel = value;
      } else {
        Constant.currencyModel = CurrencyModel(id: "", code: "USD", decimalDigits: 2, active: true, name: "US Dollar", symbol: "\$", symbolAtRight: false);
      }
    });
  }

  static String amountShow({required String? amount}) {
    if (amount == null || amount.isEmpty) {
      return "N/A";
    }

    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null) {
      return "Invalid Amount";
    }

    if (Constant.currencyModel != null) {
      if (Constant.currencyModel!.symbolAtRight == true) {
        return "${parsedAmount.toStringAsFixed(Constant.currencyModel!.decimalDigits!)} ${Constant.currencyModel!.symbol.toString()}";
      } else {
        return "${Constant.currencyModel!.symbol.toString()} ${parsedAmount.toStringAsFixed(Constant.currencyModel!.decimalDigits!)}";
      }
    }
    return '';
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  static String amountToShow({required String? amount}) {
    if (Constant.currencyModel!.symbolAtRight == true) {
      return "${double.parse(amount.toString()).toStringAsFixed(Constant.currencyModel!.decimalDigits!)}${Constant.currencyModel!.symbol.toString()}";
    } else {
      return "${Constant.currencyModel!.symbol.toString()} ${double.parse(amount.toString()).toStringAsFixed(Constant.currencyModel!.decimalDigits!)}";
    }
  }

  static Future<LanguageModel> getLanguageData() async {
    final String language = await AppSharedPreference.getString(AppSharedPreference.languageCodeKey);
    if (language.isEmpty) {
      await AppSharedPreference.setString(AppSharedPreference.languageCodeKey, json.encode({"active": true, "code": "en", "id": "Qyhgqgp4ApGYX0HQthks", "name": "English"}));
      return LanguageModel.fromJson({"active": true, "code": "en", "id": "Qyhgqgp4ApGYX0HQthks", "name": "English"});
    }
    Map<String, dynamic> languageMap = jsonDecode(language);
    return LanguageModel.fromJson(languageMap);
  }

  String? validateRequired(String? value, String type) {
    if (value!.isEmpty) {
      return '$type required';
    }
    return null;
  }

  static int calculateAge(Timestamp dob) {
    final DateTime birthDate = dob.toDate();
    final DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  static int convertHeight(String height, String unit) {
    if (unit == 'feet') {
      return (double.parse(height) * 30.48).toInt();
    } else {
      return double.parse(height).toInt();
    }
  }

  static String calculateDOB(int age) {
    final DateTime today = DateTime.now();
    final DateTime birthDate = DateTime(today.year - age, today.month, today.day);

    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(birthDate);
  }

  static String makeFullAddress({String? country, String? state, String? city}) {
    return "${city ?? ""} ,${state ?? ""} ,${country ?? ""}";
  }

  static String extractCountryName(String countryWithFlag) {
    final RegExp regExp = RegExp(r'[a-zA-Z\s]+$');
    final match = regExp.firstMatch(countryWithFlag);
    return match != null ? match.group(0)!.trim() : countryWithFlag;
  }

  static String timestampToTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('HH:mm aa').format(dateTime);
  }

  static TimeOfDay stringToTimeOfDay(String time) {
    try {
      final period = time.trim().split(' ').last.toUpperCase(); // AM/PM
      final parts = time.trim().split(' ').first.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  static InputDecoration DefaultInputDecoration(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InputDecoration(
        iconColor: AppThemeData.primary500,
        isDense: true,
        filled: true,
        fillColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
          ),
        ),
        hintText: "Select Brand",
        hintStyle: TextStyle(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100, fontWeight: FontWeight.w500, fontFamily: FontFamily.medium));
  }

  static InputDecoration DefaultInputDecorationForDrawerWidgets(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InputDecoration(
        iconColor: AppThemeData.primary500,
        isDense: true,
        filled: true,
        fillColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
          ),
        ),
        hintText: "Select Brand",
        hintStyle: TextStyle(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100, fontWeight: FontWeight.w500, fontFamily: FontFamily.medium));
  }

  static Container bookingStatusText(BuildContext context, String? status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: status == OrderStatus.orderAccepted
            ? AppThemeData.blue500.withOpacity(0.2)
            : status == OrderStatus.orderPending
                ? AppThemeData.blue500.withOpacity(0.2)
                : status == OrderStatus.orderOnReady
                    ? AppThemeData.yellow600.withOpacity(0.2)
                    : status == OrderStatus.orderComplete
                        ? AppThemeData.green500.withOpacity(0.2)
                        : status == OrderStatus.orderCancel
                            ? AppThemeData.red500.withOpacity(0.2)
                            : status == OrderStatus.orderRejected
                                ? AppThemeData.secondary500.withOpacity(0.2)
                                : status == OrderStatus.driverAssigned
                                    ? AppThemeData.secondary500.withOpacity(0.2)
                                    : status == OrderStatus.driverPickup
                                        ? AppThemeData.secondary500.withOpacity(0.2)
                                        : status == OrderStatus.driverAccepted
                                            ? AppThemeData.green500.withOpacity(0.2)
                                            : status == OrderStatus.driverRejected
                                                ? AppThemeData.secondary500.withOpacity(0.2)
                                                : AppThemeData.primary500.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status == OrderStatus.orderAccepted
            ? "Accepted"
            : status == OrderStatus.orderPending
                ? "Pending"
                : status == OrderStatus.orderOnReady
                    ? "Order On Ready"
                    : status == OrderStatus.orderComplete
                        ? "Completed"
                        : status == OrderStatus.orderRejected
                            ? "Rejected"
                            : status == OrderStatus.orderCancel
                                ? "Cancelled"
                                : status == OrderStatus.driverAssigned
                                    ? "Driver Assigned"
                                    : status == OrderStatus.driverPickup
                                        ? "Driver Picked"
                                        : status == OrderStatus.driverAccepted
                                            ? "Driver Accepted"
                                            : status == OrderStatus.driverRejected
                                                ? "Driver Rejected"
                                                : "Unknown Status",
        style: TextStyle(
          color: status == OrderStatus.orderPending
              ? AppThemeData.blue500
              : status == OrderStatus.orderAccepted
                  ? AppThemeData.blue500
                  : status == OrderStatus.orderOnReady
                      ? AppThemeData.yellow600
                      : status == OrderStatus.orderComplete
                          ? AppThemeData.green500
                          : status == OrderStatus.orderRejected
                              ? AppThemeData.secondary500
                              : status == OrderStatus.orderCancel
                                  ? AppThemeData.red500
                                  : status == OrderStatus.driverAccepted
                                      ? AppThemeData.green500
                                      : status == OrderStatus.driverAssigned
                                          ? AppThemeData.secondary500
                                          : status == OrderStatus.driverPickup
                                              ? AppThemeData.secondary500
                                              : status == OrderStatus.driverRejected
                                                  ? AppThemeData.secondary500
                                                  : AppThemeData.lynch800,
          fontFamily: FontFamily.medium,
          fontSize: 14,
        ),
      ),
    );
  }

  static Container paymentStatusText(BuildContext context, String? status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: status == 'Rejected'
            ? AppThemeData.danger300.withOpacity(0.2)
            : status == 'Complete'
                ? AppThemeData.blue500.withOpacity(0.2)
                : status == 'Pending'
                    ? AppThemeData.secondary500.withOpacity(0.2)
                    : AppThemeData.primary500.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status == 'Rejected'
            ? "Rejected"
            : status == 'Pending'
                ? "Pending"
                : status == 'Complete'
                    ? "Complete"
                    : "Unknown Status",
        style: TextStyle(
          color: status == 'Rejected'
              ? AppThemeData.danger300
              : status == 'Complete'
                  ? AppThemeData.blue500
                  : status == 'Pending'
                      ? AppThemeData.secondary500
                      : AppThemeData.lynch800,
          fontFamily: FontFamily.medium,
          fontSize: 14,
        ),
      ),
    );
  }
}

class StatusDetails {
  final String text;
  final Color textColor;
  final Color backgroundColor;

  StatusDetails({required this.text, required this.textColor, required this.backgroundColor});
}
