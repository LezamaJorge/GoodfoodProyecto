// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/modules/driver_cancelling_reason/controllers/driver_cancelling_reason_controller.dart';
import 'package:admin_panel/app/routes/app_pages.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DriverCancellingReasonView extends GetView {
  const DriverCancellingReasonView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<DriverCancellingReasonController>(
        init: DriverCancellingReasonController(),
        builder: (controller) {
          return Obx(() => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContainerCustom(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ResponsiveWidget.isDesktop(context)
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          InkWell(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(
                                                  title: 'Dashboard'.tr,
                                                  fontSize: 14,
                                                  fontFamily: FontFamily.medium,
                                                  color: AppThemeData.lynch500)),
                                          const TextCustom(
                                              title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(
                                              title: 'Settings'.tr,
                                              fontSize: 14,
                                              fontFamily: FontFamily.medium,
                                              color: AppThemeData.lynch500),
                                          const TextCustom(
                                              title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(
                                              title: ' ${controller.title.value} ',
                                              fontSize: 14,
                                              fontFamily: FontFamily.medium,
                                              color: AppThemeData.primary500)
                                        ])
                                      ],
                                    )
                                  : TextCustom(
                                      title: ' ${controller.title.value} ',
                                      fontSize: 14,
                                      fontFamily: FontFamily.medium,
                                      color: AppThemeData.primaryBlack),
                              CustomButtonWidget(
                                padding: const EdgeInsets.symmetric(horizontal: 22),
                                title: "+ Add Reason".tr,
                                onPress: () {
                                  controller.setDefaultData();
                                  showDialog(context: context, builder: (context) => const ReasonDialog());
                                },
                              ),
                            ],
                          ),
                          spaceH(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: controller.isLoading.value
                                  ? Padding(
                                      padding: paddingEdgeInsets(),
                                      child: Constant.loader(),
                                    )
                                  : controller.driverCancellingReasonList.isEmpty
                                      ? TextCustom(title: "No Data available".tr)
                                      : DataTable(
                                          horizontalMargin: 20,
                                          columnSpacing: 30,
                                          dataRowMaxHeight: 65,
                                          headingRowHeight: 65,
                                          border: TableBorder.all(
                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          headingRowColor: WidgetStateColor.resolveWith(
                                              (states) => themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                                          columns: [
                                            CommonUI.dataColumnWidget(context,
                                                columnTitle: "Id".tr,
                                                width: ResponsiveWidget.isMobile(context) ? 15 : MediaQuery.of(context).size.width * 0.07),
                                            CommonUI.dataColumnWidget(context,
                                                columnTitle: "Reason".tr,
                                                width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.40),
                                            CommonUI.dataColumnWidget(context,
                                                columnTitle: "Actions".tr,
                                                width: ResponsiveWidget.isMobile(context) ? 70 : MediaQuery.of(context).size.width * 0.15),
                                          ],
                                          rows: controller.driverCancellingReasonList
                                              .map((reasonModel) => DataRow(cells: [
                                                    DataCell(TextCustom(
                                                        title:
                                                            "${controller.driverCancellingReasonList.indexWhere((element) => element == reasonModel) + 1}")),
                                                    DataCell(TextCustom(title: reasonModel.toString())),
                                                    DataCell(
                                                      Container(
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                controller.isEditing.value = true;
                                                                controller.editingValue.value = reasonModel.toString();
                                                                controller.reasonController.value.text = reasonModel.toString();
                                                                showDialog(context: context, builder: (context) => const ReasonDialog());
                                                              },
                                                              child: SvgPicture.asset(
                                                                "assets/icons/ic_edit.svg",
                                                                color: AppThemeData.lynch400,
                                                                height: 16,
                                                                width: 16,
                                                              ),
                                                            ),
                                                            spaceW(width: 20),
                                                            InkWell(
                                                              onTap: () {
                                                                if (Constant.isDemo) {
                                                                  DialogBox.demoDialogBox();
                                                                } else {
                                                                  controller.removeReason(reasonModel);
                                                                  controller.getData();
                                                                }
                                                              },
                                                              child: SvgPicture.asset(
                                                                "assets/icons/ic_delete.svg",
                                                                //color: AppThemeData.lynch400,
                                                                height: 16,
                                                                width: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ]))
                                              .toList()),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}

class ReasonDialog extends StatelessWidget {
  const ReasonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<DriverCancellingReasonController>(
      init: DriverCancellingReasonController(),
      builder: (controller) {
        return CustomDialog(
          title: controller.title.value,
          widgetList: [
            Row(
              children: [
                Expanded(
                    child: CustomTextFormField(
                        hintText: 'Enter Reason'.tr, controller: controller.reasonController.value, title: 'Reason *'.tr)),
              ],
            ),
          ],
          bottomWidgetList: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButtonWidget(
                  title: "Close".tr,
                  buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch400,
                  onPress: () {
                    controller.setDefaultData();
                    Navigator.pop(context);
                  },
                ),
                spaceW(),
                CustomButtonWidget(
                  title: "Save".tr,
                  onPress: () {
                    if (Constant.isDemo) {
                      DialogBox.demoDialogBox();
                    } else {
                      if (controller.reasonController.value.text != "") {
                        controller.isEditing.value ? controller.updateReason() : controller.addReason();
                        controller.setDefaultData();
                        Navigator.pop(context);
                      } else {
                        ShowToastDialog.errorToast("All fields are required.".tr);
                      }
                    }
                  },
                ),
              ],
            ),
          ],
          controller: controller,
        );
      },
    );
  }
}
