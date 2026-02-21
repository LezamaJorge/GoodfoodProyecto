// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/wallet_transaction_model.dart';
import 'package:restaurant/app/models/withdraw_model.dart';
import 'package:restaurant/app/modules/add_bank/views/add_bank_view.dart';
import 'package:restaurant/app/modules/my_wallet/views/widgets/withdrawal_view.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/extension/date_time_extension.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/common_ui.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

import '../controllers/my_wallet_controller.dart';
import 'widgets/add_money_view.dart';

class MyWalletView extends StatelessWidget {
  const MyWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: MyWalletController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackground : AppThemeData.grey50,
            appBar: UiInterface.customAppBar(
              backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackground : AppThemeData.grey50,
              context,
              themeChange,
              "",
            ),
            body: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    title: "My Wallet".tr,
                    fontSize: 28,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                    fontFamily: FontFamily.bold,
                    textAlign: TextAlign.start,
                  ),
                  spaceH(height: 2),
                  TextCustom(
                    title: "Manage your earnings and transactions in one place.".tr,
                    fontSize: 16,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                    fontFamily: FontFamily.regular,
                    textAlign: TextAlign.start,
                  ),
                  spaceH(height: 32),
                  Container(
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10), image: const DecorationImage(image: AssetImage("assets/images/wallet_card.png"), fit: BoxFit.fill)),
                    child: Column(
                      children: [
                        Padding(
                          padding: paddingEdgeInsets(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              spaceH(height: 8),
                              TextCustom(
                                title: 'Total Amount'.tr,
                                color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                                fontSize: 12,
                                fontFamily: FontFamily.light,
                              ),
                              TextCustom(
                                title: Constant.amountShow(amount: controller.ownerModel.value.walletAmount ?? '0.0'),
                                color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                                fontSize: 32,
                                fontFamily: FontFamily.medium,
                              ),
                              spaceH(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RoundShapeButton(
                                    title: 'Withdraw'.tr,
                                    buttonColor: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                    buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                                    onTap: () async {
                                      await controller.getBankDetails();
                                      if (controller.bankDetailsList.isNotEmpty) {
                                        Get.to(() => WithdrawalView());
                                      } else {
                                        ShowToastDialog.toast("Your bank details is not available.Please add bank details".tr);
                                        Get.to(() => AddBankView());
                                        controller.getPayments();
                                      }
                                    },
                                    size: Size(157.w, 50.h),
                                  ),
                                  RoundShapeButton(
                                    title: 'Add Money'.tr,
                                    buttonColor: AppThemeData.primary300,
                                    buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                                    onTap: () {
                                      Get.to(() => AddMoneyView());
                                    },
                                    size: Size(157.w, 50.h),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50, borderRadius: BorderRadius.circular(60)),
                            child: TabBar(
                              dividerColor: Colors.transparent,
                              onTap: (value) {
                                controller.selectedTabIndex.value = value;
                              },
                              labelStyle: TextStyle(
                                fontFamily: FontFamily.regular,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontFamily: FontFamily.regular,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              labelColor: AppThemeData.primaryWhite,
                              unselectedLabelColor: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                              indicator: BoxDecoration(borderRadius: BorderRadius.circular(60), color: AppThemeData.secondary300),
                              indicatorSize: TabBarIndicatorSize.tab,
                              tabs: [
                                Tab(
                                  text: "Transaction History".tr,
                                ),
                                Tab(
                                  text: "Withdrawal History".tr,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(children: [
                              Obx(
                                    () =>
                                controller.walletTransactionList.isEmpty
                                    ? Center(
                                  child: Text("No Data View".tr),
                                )
                                    : ListView.builder(
                                  itemCount: controller.walletTransactionList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    WalletTransactionModel walletTransactionModel = controller.walletTransactionList[index];
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 44.w,
                                          height: 44.h,
                                          margin: const EdgeInsets.only(right: 16),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: (walletTransactionModel.isCredit ?? false)
                                                  ? themeChange.isDarkTheme()
                                                  ? AppThemeData.success600
                                                  : AppThemeData.success50
                                                  : themeChange.isDarkTheme()
                                                  ? AppThemeData.danger600
                                                  : AppThemeData.danger50),
                                          child: Center(
                                              child: (walletTransactionModel.isCredit ?? false)
                                                  ? SvgPicture.asset(
                                                "assets/icons/ic_arrow_down_line.svg",
                                                color: AppThemeData.success300,
                                              )
                                                  : SvgPicture.asset(
                                                "assets/icons/ic_arrow_up_line.svg",
                                                color: AppThemeData.danger300,
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  width: 1,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.grey100,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        walletTransactionModel.note ?? '',
                                                        style: TextStyle(
                                                          fontFamily: FontFamily.regular,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      Constant.amountShow(amount: walletTransactionModel.amount ?? ''),
                                                      textAlign: TextAlign.right,
                                                      style: TextStyle(
                                                        fontFamily: FontFamily.regular,
                                                        color: (walletTransactionModel.isCredit ?? false) ? AppThemeData.success300 : AppThemeData.danger300,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            (walletTransactionModel.createdDate ?? Timestamp.now()).toDate().dateMonthYear(),
                                                            style: TextStyle(
                                                              fontFamily: FontFamily.regular,
                                                              color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey500,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Container(
                                                            height: 16,
                                                            decoration: ShapeDecoration(
                                                              shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                  width: 1,
                                                                  strokeAlign: BorderSide.strokeAlignCenter,
                                                                  color: themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.grey100,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Text(
                                                            (walletTransactionModel.createdDate ?? Timestamp.now()).toDate().time(),
                                                            style: TextStyle(
                                                              fontFamily: FontFamily.regular,
                                                              color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey500,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              FutureBuilder<List<WithdrawModel>?>(
                                  future: FireStoreUtils.getWithDrawRequest(),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Constant.loader();
                                      case ConnectionState.done:
                                        if (snapshot.hasError) {
                                          return Text(snapshot.error.toString());
                                        } else {
                                          return snapshot.data!.isEmpty
                                              ? Center(
                                            child: TextCustom(title: "No Data View".tr),
                                          )
                                              : ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              WithdrawModel walletTransactionModel = snapshot.data![index];
                                              return Container(
                                                width: 358,
                                                height: 80,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: const BoxDecoration(),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 44,
                                                      height: 44,
                                                      margin: const EdgeInsets.only(right: 16),
                                                      decoration: ShapeDecoration(
                                                        color: (walletTransactionModel.paymentStatus == "Complete")
                                                            ? themeChange.isDarkTheme()
                                                            ? AppThemeData.success600
                                                            : AppThemeData.success50
                                                            : themeChange.isDarkTheme()
                                                            ? AppThemeData.accent500
                                                            : AppThemeData.accent50,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(100),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                          "assets/icons/ic_my_wallet.svg",
                                                          colorFilter: ColorFilter.mode(
                                                              (walletTransactionModel.paymentStatus == "Complete") ? AppThemeData.success300 : AppThemeData.danger300,
                                                              BlendMode.srcIn),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                                        decoration: BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              width: 1,
                                                              color: themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.grey100,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    walletTransactionModel.note ?? '',
                                                                    style: TextStyle(
                                                                      fontFamily: FontFamily.regular,
                                                                      color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w400,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 12),
                                                                Text(
                                                                  Constant.amountShow(amount: walletTransactionModel.amount ?? ''),
                                                                  textAlign: TextAlign.right,
                                                                  style: TextStyle(
                                                                    fontFamily: FontFamily.regular,
                                                                    color: (walletTransactionModel.paymentStatus == "Complete")
                                                                        ? AppThemeData.success300
                                                                        : AppThemeData.danger300,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 2),
                                                            Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Expanded(
                                                                  child: Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        (walletTransactionModel.createdDate ?? Timestamp.now()).toDate().dateMonthYear(),
                                                                        style: TextStyle(
                                                                          fontFamily: FontFamily.regular,
                                                                          color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey500,
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(width: 8),
                                                                      Container(
                                                                        height: 16,
                                                                        decoration: ShapeDecoration(
                                                                          shape: RoundedRectangleBorder(
                                                                            side: BorderSide(
                                                                              width: 1,
                                                                              strokeAlign: BorderSide.strokeAlignCenter,
                                                                              color: themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.grey100,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(width: 8),
                                                                      Text(
                                                                        (walletTransactionModel.createdDate ?? Timestamp.now()).toDate().time(),
                                                                        style: TextStyle(
                                                                          fontFamily: FontFamily.regular,
                                                                          color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey500,
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      default:
                                        return Text('Error'.tr);
                                    }
                                  })
                            ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
