import 'package:admin_panel/app/modules/restaurant_details/controllers/restaurant_details_controller.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../widget/common_ui.dart';
import '../../../../../widget/global_widgets.dart';
import '../../../../../widget/text_widget.dart';
import '../../../../constant/constants.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_them_data.dart';
import '../../../../utils/dark_theme_provider.dart';
import '../../../../utils/responsive.dart';

class RestaurantWalletScreen extends StatelessWidget {
  const RestaurantWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: RestaurantDetailsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
            body: SingleChildScrollView(
              child: ContainerCustom(
                color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                TextCustom(title: controller.transactionTitle.value, fontSize: 20, fontFamily: FontFamily.bold),
                                spaceH(height: 2),
                                Row(children: [
                                  InkWell(
                                      onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                      child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                  const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                  TextCustom(title: ' ${controller.transactionTitle.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                ])
                              ]),
                            ],
                          ),
                          spaceH(height: 16),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              spaceH(height: 16),
                              Obx(
                                    () => controller.walletTransactionList.isEmpty
                                    ? Center(
                                  child: TextCustom(
                                    title: "No Transaction Found".tr,
                                  ),
                                )
                                    : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: DataTable(
                                        horizontalMargin: 20,
                                        columnSpacing: 30,
                                        dataRowMaxHeight: 80,
                                        headingRowHeight: 65,
                                        border: TableBorder.all(
                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                        columns: [
                                          CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: 150),
                                          CommonUI.dataColumnWidget(context,
                                              columnTitle: "note".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                          CommonUI.dataColumnWidget(context,
                                              columnTitle: "amount".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.10),
                                          CommonUI.dataColumnWidget(context,
                                              columnTitle: "Payment Type".tr, width: ResponsiveWidget.isMobile(context) ? 200 : MediaQuery.of(context).size.width * 0.10),
                                          CommonUI.dataColumnWidget(context,
                                              columnTitle: "created Date".tr, width: ResponsiveWidget.isMobile(context) ? 200 : MediaQuery.of(context).size.width * 0.14),
                                        ],
                                        rows: controller.walletTransactionList
                                            .map(
                                              (transaction) => DataRow(
                                            cells: [
                                              DataCell(TextCustom(title: "# ${transaction.id!.substring(0, 6)}")),
                                              DataCell(TextCustom(
                                                title: transaction.note.toString(),
                                              )),
                                              DataCell(TextCustom(
                                                title: Constant.amountShow(amount: transaction.amount.toString()),
                                                color: transaction.isCredit == true ? AppThemeData.success300 : AppThemeData.danger300,
                                              )),
                                              DataCell(TextCustom(
                                                title: transaction.paymentType.toString(),
                                              )),
                                              DataCell(TextCustom(
                                                title: Constant.timestampToDateTime(transaction.createdDate!),
                                              ))
                                            ],
                                          ),
                                        )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
