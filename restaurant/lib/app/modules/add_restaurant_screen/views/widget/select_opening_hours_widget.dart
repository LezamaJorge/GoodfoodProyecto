// ignore_for_file: must_be_immutable, deprecated_member_use, depend_on_referenced_packages, use_super_parameters, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/add_restaurant_screen/controllers/add_restaurant_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_field_widget.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import '../../../../../constant_widgets/round_shape_button.dart';
import '../../../../../themes/screen_size.dart';

class SelectOpeningHoursWidget extends GetView<AddRestaurantScreenController> {
  SelectOpeningHoursWidget({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: AddRestaurantScreenController(),
      builder: (controller) {
        controller.validateOpeningHours();
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: paddingEdgeInsets(),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      title: "Select Opening Hours".tr,
                      fontSize: 28,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                      fontFamily: FontFamily.bold,
                      textAlign: TextAlign.start,
                    ),
                    2.height,
                    TextCustom(
                      title: "Choose the days and times your restaurant is open for business.".tr,
                      fontSize: 16,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                      fontFamily: FontFamily.regular,
                      textAlign: TextAlign.start,
                    ),
                    spaceH(height: 32),
                    ListView.builder(
                      itemCount: 7,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextCustom(
                                  title: controller.getWeekDay(index),
                                  fontSize: 16,
                                  fontFamily: FontFamily.medium,
                                ),
                                Obx(
                                  () => SizedBox(
                                    height: 26.h,
                                    child: FittedBox(
                                      child: CupertinoSwitch(
                                        activeTrackColor: AppThemeData.primary300,
                                        value: controller.daySwitches[index].value,
                                        onChanged: (value) {
                                          controller.toggleDaySwitch(index);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Obx(
                              () => Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (controller.daySwitches[index].value) {
                                          await controller.selectOpeningHour(index);
                                          controller.openingHoursController[index].text = controller.openingHours[index].value.format(context).toString();
                                        } else {
                                          ShowToastDialog.toast("Please on the switch for pick time".tr);
                                        }
                                      },
                                      child: TextFieldWidget(
                                        validator: (value) => controller.daySwitches[index].value
                                            ? value != null && value.isNotEmpty
                                                ? null
                                                : 'This field required'.tr
                                            : null,
                                        title: "Opening Hours".tr,
                                        hintText: '00:00:00'.tr,
                                        enable: false,
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                                        controller: controller.openingHoursController[index],
                                        onPress: () {},
                                        suffix: SvgPicture.asset(
                                          "assets/icons/ic_clock.svg",
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  spaceW(width: 16),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (controller.daySwitches[index].value) {
                                          await controller.selectClosingHour(index);
                                          controller.closingHoursController[index].text = controller.closingHours[index].value.format(context).toString();
                                        } else {
                                          ShowToastDialog.toast("Please on the switch for pick time".tr);
                                        }
                                      },
                                      child: TextFieldWidget(
                                        validator: (value) => controller.daySwitches[index].value
                                            ? value != null && value.isNotEmpty
                                                ? null
                                                : 'This field required'.tr
                                            : null,
                                        title: "Closing Hours".tr,
                                        hintText: '00:00:00'.tr,
                                        enable: false,
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                                        controller: controller.closingHoursController[index],
                                        onPress: () {},
                                        suffix: SvgPicture.asset(
                                          "assets/icons/ic_clock.svg",
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            spaceH(),
                            Row(
                              children: [
                                Expanded(child: Divider(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400)),
                              ],
                            ),
                            spaceH(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: paddingEdgeInsets(vertical: 8),
            child: Obx(() {
              return RoundShapeButton(
                title: "Next".tr,
                buttonColor: controller.isAllOpeningHoursSelected.value ? AppThemeData.primary300 : (themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.grey200),
                buttonTextColor: controller.isAllOpeningHoursSelected.value ? AppThemeData.grey50 : AppThemeData.grey500,
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    controller.validateOpeningHours();
                    if (!controller.isAllOpeningHoursSelected.value) {
                      ShowToastDialog.toast('Please select at least one valid opening and closing hour.'.tr);
                      return;
                    }
                    await controller.openingHoursEntries();
                    controller.saveData();
                    controller.editPage.value = "";
                  }
                },
                size: Size(358.w, ScreenSize.height(6, context)),
              );
            }),
          ),
        );
      },
    );
  }
}
