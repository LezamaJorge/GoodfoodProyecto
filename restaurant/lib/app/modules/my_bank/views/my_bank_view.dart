
// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/bank_detail_model.dart';
import 'package:restaurant/app/modules/add_bank/views/add_bank_view.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant_widgets/container_custom.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/common_ui.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import '../controllers/my_bank_controller.dart';

class MyBankView extends GetView<MyBankController> {
  const MyBankView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<MyBankController>(
      init: MyBankController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackground : AppThemeData.grey50,
            appBar: UiInterface.customAppBar(
              backgroundColor:  themeChange.isDarkTheme() ? AppThemeData.darkBackground : AppThemeData.grey50,
              context,
              themeChange,
              "".tr,
            ),
            body: Padding(
              padding: paddingEdgeInsets(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    title: "My Banks".tr,
                    fontSize: 28,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                    fontFamily: FontFamily.bold,
                    textAlign: TextAlign.start,
                  ),
                  spaceH(height: 2),
                  TextCustom(
                    title: "View and manage your linked bank accounts for withdrawals and transactions.".tr,
                    fontSize: 16,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                    fontFamily: FontFamily.regular,
                    textAlign: TextAlign.start,
                  ),
                  spaceH(height: 32),
                 ContainerCustom(

                   child: Column(
                     children: [
                       GestureDetector(
                         onTap: () {
                           Get.to(()=> AddBankView());
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
                                           Get.to(()=> AddBankView());
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
                 ),
                ],
              ),
            ));
      },
    );
  }
}
