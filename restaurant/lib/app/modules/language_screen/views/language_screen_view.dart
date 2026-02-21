import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/language_model.dart';
import 'package:restaurant/app/modules/language_screen/controllers/language_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/network_image_widget.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/services/localization_service.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/common_ui.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/preferences.dart';

class LanguageScreenView extends GetView<LanguageScreenController> {
  const LanguageScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<LanguageScreenController>(
      init: LanguageScreenController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
            appBar: UiInterface.customAppBar(
              context,
              themeChange,
              "".tr,
            ),
            bottomNavigationBar: Padding(
              padding: paddingEdgeInsets(vertical: 8, horizontal: 16),
              child: RoundShapeButton(
                title: "Save".tr,
                buttonColor: AppThemeData.primary300,
                buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                onTap: () {
                  LocalizationService().changeLocale(controller.selectedLanguage.value.code.toString());
                  Preferences.setString(
                    Preferences.languageCodeKey,
                    jsonEncode(
                      controller.selectedLanguage.value,
                    ),
                  );
                  Get.back();
                },
                size: Size(Responsive.width(45, context), 52),
              ),
            ),
            body: Padding(
              padding: paddingEdgeInsets(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    title: "Select Language".tr,
                    fontSize: 28,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                    fontFamily: FontFamily.bold,
                    textAlign: TextAlign.start,
                  ),
                  spaceH(height: 2),
                  TextCustom(
                    title: "Choose your preferred language for the app interface.".tr,
                    fontSize: 16,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                    fontFamily: FontFamily.regular,
                    textAlign: TextAlign.start,
                  ),
                  spaceH(height: 32),
                  controller.isLoading.value
                      ? Constant.loader()
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 2.5),
                          itemCount: controller.languageList.length,
                          itemBuilder: (context, index) {
                            final bgColor =
                                themeChange.isDarkTheme() ? controller.darkModeColors[index % controller.darkModeColors.length] : controller.lightModeColors[index % controller.lightModeColors.length];
                            return Obx(
                              () => Container(
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                    child: RadioGroup<LanguageModel>(
                                  groupValue: controller.selectedLanguage.value,
                                  onChanged: (value) {
                                    controller.selectedLanguage.value = value!;
                                  },
                                  child: RadioListTile(
                                    dense: true,
                                    value: controller.languageList[index],
                                    contentPadding: EdgeInsets.zero,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    activeColor: controller.activeColor[index % controller.activeColor.length],
                                    title: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        NetworkImageWidget(
                                          imageUrl: controller.languageList[index].image.toString(),
                                          height: 40,
                                          width: 22,
                                          fit: BoxFit.contain,
                                          color: themeChange.isDarkTheme()
                                              ? controller.textColorDarkMode[index % controller.textColorDarkMode.length]
                                              : controller.textColorLightMode[index % controller.textColorLightMode.length],
                                        ),
                                        spaceW(width: 8),
                                        TextCustom(
                                          title: controller.languageList[index].name.toString(),
                                          fontSize: 16,
                                          color: themeChange.isDarkTheme()
                                              ? controller.textColorDarkMode[index % controller.textColorDarkMode.length]
                                              : controller.textColorLightMode[index % controller.textColorLightMode.length],
                                          fontFamily: FontFamily.medium,
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                              ),
                            );
                          })
                  /*ContainerCustom(

                   child: Column(
                     children: [
                       GestureDetector(
                         onTap: () {
                           Get.to(const AddBankView());
                         },
                         child: Row(
                           children: [
                             SizedBox(
                               height: 46.h,
                               width: 46.w,
                               child: Center(
                                 child: Icon(
                                   Icons.add,
                                   color: AppThemeData.primary300,
                                   size: 30,
                                 ),
                               ),
                             ),
                             spaceW(),
                             TextCustom(
                               title: "Add New Bank".tr,
                               color: AppThemeData.primary300,
                               fontSize: 16,
                               fontFamily: FontFamily.medium,
                             ),
                           ],
                         ),
                       ),
                       spaceH(height: 5),
                       Obx(
                             ()=> ListView.builder(
                           shrinkWrap: true,
                           itemCount: controller.bankDetailsList.length,
                           itemBuilder: (context, index) {
                             BankDetailsModel bankDetailsModel = controller.bankDetailsList[index];
                             return Padding(
                               padding: paddingEdgeInsets(horizontal: 0,vertical: 5),
                               child: Row(
                                 children: [
                                   Container(
                                     decoration: BoxDecoration(shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50),
                                     height: 46.h,
                                     width: 46.w,
                                     child: Center(
                                       child: SizedBox(
                                         height: 18.h,
                                         width: 18.w,
                                         child: SvgPicture.asset("assets/icons/ic_bank.svg"),
                                       ),
                                     ),
                                   ),
                                   spaceW(),
                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       TextCustom(
                                         title: bankDetailsModel.bankName.toString(),
                                         color: themeChange.isDarkTheme()?AppThemeData.grey100:AppThemeData.grey900,
                                         fontSize: 16,
                                         fontFamily: FontFamily.medium,
                                       ),
                                       TextCustom(
                                         title: "${bankDetailsModel.holderName.toString()} | ${bankDetailsModel.accountNumber.toString()}",
                                         color: themeChange.isDarkTheme()?AppThemeData.grey100:AppThemeData.grey600,
                                       ),
                                     ],
                                   ),
                                   const Spacer(),
                                   Align(
                                     alignment: Alignment.topRight,
                                     child: PopupMenuButton(
                                       itemBuilder: (BuildContext bc) {
                                         return [
                                           PopupMenuItem<String>(
                                             height: 30,
                                             value: "Edit".tr,
                                             child: Row(
                                               mainAxisAlignment: MainAxisAlignment.start,
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Text(
                                                   "Edit".tr,
                                                   style: TextStyle(
                                                     fontFamily: FontFamily.regular,
                                                     color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                     fontSize: 14,
                                                     fontWeight: FontWeight.w400,
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           ),
                                           PopupMenuItem<String>(
                                             height: 30,
                                             value: "Delete".tr,
                                             child: Row(
                                               mainAxisAlignment: MainAxisAlignment.start,
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Text(
                                                   "Delete".tr,
                                                   style: TextStyle(
                                                     fontFamily: FontFamily.regular,
                                                     color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                     fontSize: 14,
                                                     fontWeight: FontWeight.w400,
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           )
                                         ];
                                       },
                                       onSelected: (value) {
                                         if (value == "Edit") {
                                           controller.editingId.value = bankDetailsModel.id.toString();
                                           controller.bankHolderNameController.text = bankDetailsModel.holderName.toString();
                                           controller.bankAccountNumberController.text = bankDetailsModel.accountNumber.toString();
                                           controller.swiftCodeController.text = bankDetailsModel.swiftCode.toString();
                                           controller.ifscCodeController.text = bankDetailsModel.ifscCode.toString();
                                           controller.bankNameController.text = bankDetailsModel.bankName.toString();
                                           controller.bankBranchCityController.text = bankDetailsModel.branchCity.toString();
                                           controller.bankBranchCountryController.text = bankDetailsModel.branchCountry.toString();
                                           Get.to(const AddBankView());
                                         } else {
                                           controller.deleteBankDetails(controller.bankDetailsList[index]);
                                         }
                                       },
                                       child: SvgPicture.asset(
                                         "assets/icons/ic_three_dot.svg",
                                         color: themeChange.isDarkTheme()?AppThemeData.grey100:AppThemeData.grey900,
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             );
                           },
                         ),
                       ),
                     ],
                   ),
                 ),*/
                ],
              ),
            ));
      },
    );
  }
}
