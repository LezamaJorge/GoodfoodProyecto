import 'package:admin_panel/app/modules/app_settings/views/app_settings_view.dart';
import 'package:admin_panel/app/modules/app_theme/views/app_theme_view.dart';
import 'package:admin_panel/app/modules/cancelling_reason/views/cancelling_reason_view.dart';
import 'package:admin_panel/app/modules/contact_us/views/contact_us_view.dart';
import 'package:admin_panel/app/modules/driver_cancelling_reason/views/driver_cancelling_reason_view.dart';
import 'package:admin_panel/app/modules/general_setting/views/general_setting_view.dart';
import 'package:admin_panel/app/modules/item_tages_screen/views/item_tags_view.dart';
import 'package:admin_panel/app/modules/language/views/language_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreenController extends GetxController {
  RxString title = "Settings".obs;
  final GlobalKey<ScaffoldState> scaffoldKeysDrawer = GlobalKey<ScaffoldState>();

  Rx<SettingsItem> selectSettingWidget =
      SettingsItem(title: ['General Settings'.tr], icon: "assets/icons/ic_general_setting.svg", widget: [const GeneralSettingView()], selectIndex: 0).obs;
  final settingsAllPage = [
    SettingsItem(title: ['General Settings'.tr], icon: "assets/icons/ic_general_setting.svg", widget: [const GeneralSettingView()], selectIndex: 0),
    SettingsItem(title: ['App Settings'.tr], icon: "assets/icons/ic_settings.svg", widget: [const AppSettingsView()], selectIndex: 0),
    SettingsItem(title: ['App Theme'.tr], icon: "assets/icons/ic_settings.svg", widget: [const AppThemeView()], selectIndex: 0),
    SettingsItem(title: ['Languages'.tr], icon: "assets/icons/ic_earth.svg", widget: [const LanguageView()], selectIndex: 0),
    SettingsItem(title: ['Cancelling Reason'.tr], icon: "assets/icons/ic_user_round.svg", widget: [const CancellingReasonView()], selectIndex: 0),
    SettingsItem(title: ['Driver Reason'.tr], icon: "assets/icons/ic_user_round.svg", widget: [const DriverCancellingReasonView()], selectIndex: 0),
    SettingsItem(title: ['Item Tags'.tr], icon: "assets/icons/ic_tag.svg", widget: [const ItemTagsView()], selectIndex: 0),
    // SettingsItem(title: ['About App'], icon: "assets/icons/ic_reported_user.svg", widget: [AboutAppView()], selectIndex: 0),
    // SettingsItem(title: ['Privacy Policy'], icon: "assets/icons/ic_privacy_policy.svg", widget: [PrivacyPolicyView()], selectIndex: 0),
    // SettingsItem(title: ['Terms & Condition'], icon: "assets/icons/ic_terms_&_condition.svg", widget: [TermsConditionsView()], selectIndex: 0),
    SettingsItem(title: ['Contact us'.tr], icon: "assets/icons/ic_contacts.svg", widget: [const ContactUsView()], selectIndex: 0),

  ];
}

class SettingsItem {
  List<String>? title;
  String? icon;
  List<Widget>? widget;
  int? selectIndex;

  SettingsItem({this.title, this.icon, this.widget, this.selectIndex});
}
