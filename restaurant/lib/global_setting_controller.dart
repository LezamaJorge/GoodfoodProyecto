// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/currency_model.dart';
import 'package:restaurant/app/models/language_model.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/services/localization_service.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:restaurant/utils/notification_service.dart';
import 'package:restaurant/utils/preferences.dart';

class GlobalSettingController extends GetxController {
  @override
  Future<void> onInit() async {
    await getSettingData();
    await getData();
    await notificationInit();
    await getCurrentCurrency();
    await getLanguage();
    super.onInit();
  }

  Future<void> getCurrentCurrency() async {
    try {
      final value = await FireStoreUtils().getCurrency();
      if (value != null) {
        Constant.currencyModel = value;
      } else {
        Constant.currencyModel = CurrencyModel(
          id: "",
          code: "USD",
          decimalDigits: 2,
          enable: true,
          name: "US Dollar",
          symbol: "\$",
          symbolAtRight: false,
        );
      }
      await FireStoreUtils().getAdminCommission();
      await FireStoreUtils().getPayment();
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error Current Currency:", error: e, stackTrace: stack);
      }
      Constant.currencyModel = CurrencyModel(
        id: "",
        code: "USD",
        decimalDigits: 2,
        enable: true,
        name: "US Dollar",
        symbol: "\$",
        symbolAtRight: false,
      );
    }
  }

  Future<void> getSettingData() async {
    try {
      await FireStoreUtils().getSettings();
      AppThemeData.primary300 = HexColor.fromHex(Constant.appColor.toString());
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error Setting Data:", error: e, stackTrace: stack);
      }
    }
  }

  Future<void> getData() async {
    try {
      final currentUid = FireStoreUtils.getCurrentUid();
      if (currentUid != null) {
        await FireStoreUtils.getOwnerProfile(currentUid);
        final vendorId = Constant.ownerModel?.vendorId;
        if (vendorId != null && vendorId.isNotEmpty) {
          Constant.vendorModel = await FireStoreUtils.getRestaurant(vendorId);
        }
      }
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error getting data:", error: e, stackTrace: stack);
      }
    }
  }

  final NotificationService notificationService = NotificationService();

  Future<void> notificationInit() async {
    try {
      await notificationService.initInfo();
      final token = await NotificationService.getToken();
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final owner = await FireStoreUtils.getOwnerProfile(FireStoreUtils.getCurrentUid()!);
        if (owner != null) {
          owner.fcmToken = token;
          await FireStoreUtils.updateOwner(owner);
        }
      }
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error Notification Init:", error: e, stackTrace: stack);
      }
    }
  }

  Future<void> getLanguage() async {
    try {
      final storedLang = Preferences.getString(Preferences.languageCodeKey);
      if (storedLang.isNotEmpty) {
        LanguageModel languageModel = Constant.getLanguage();
        LocalizationService().changeLocale(languageModel.code.toString());
      } else {
        LanguageModel languageModel = LanguageModel(
          id: "LzSABjMohyW3MA0CaxVH",
          name: "English",
          code: "en",
        );
        await Preferences.setString(Preferences.languageCodeKey, jsonEncode(languageModel.toJson()));
        LocalizationService().changeLocale(languageModel.code.toString());
      }
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error getting language:", error: e, stackTrace: stack);
      }
    }
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
