// ignore_for_file: deprecated_member_use, must_be_immutable, depend_on_referenced_packages, use_build_context_synchronously, use_super_parameters

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/addons_model.dart';
import 'package:restaurant/app/modules/add_menu_item_screen/controllers/add_menu_item_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_field_widget.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../../../../../constant_widgets/round_shape_button.dart';
import '../../../../../themes/screen_size.dart';

class AddonsDetailWidget extends GetView<AddMenuItemsScreenController> {
  const AddonsDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<AddMenuItemsScreenController>(
      init: AddMenuItemsScreenController(),
      builder: (controller) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: paddingEdgeInsets(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    title: "Add Addons Details".tr,
                    fontSize: 28,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                    fontFamily: FontFamily.bold,
                    textAlign: TextAlign.start,
                  ),
                  2.height,
                  TextCustom(
                    title: "Provide the details of the new menu item you want to add.".tr,
                    fontSize: 16,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                    fontFamily: FontFamily.regular,
                    textAlign: TextAlign.start,
                  ),
                  spaceH(height: 32),
                  if (controller.addonsList.isNotEmpty) ...{
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.addonsList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: paddingEdgeInsets(),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.surface1000 : AppThemeData.surface50, borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                    title: controller.addonsList[index].name.toString(),
                                    fontSize: 16,
                                    fontFamily: FontFamily.medium,
                                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                                  ),
                                  TextCustom(
                                    title: Constant.amountShow(amount: controller.addonsList[index].price.toString()),
                                    fontSize: 16,
                                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                  ),
                                  Row(
                                    children: [
                                      TextCustom(
                                        title: "In Stock".tr,
                                        fontSize: 16,
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey300 : AppThemeData.grey700,
                                      ),
                                      spaceW(),
                                      Obx(
                                        () => SizedBox(
                                          height: 26.h,
                                          child: FittedBox(
                                            child: CupertinoSwitch(
                                              activeColor: AppThemeData.primary300,
                                              value: controller.addonsList[index].inStock!,
                                              onChanged: (value) {},
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              spaceW(),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.addonsNameController.value.text = controller.addonsList[index].name.toString();
                                      controller.addonsPriceController.value.text = controller.addonsList[index].price.toString();
                                      controller.addonsInStock.value = controller.addonsList[index].inStock!;
                                      controller.addonsList.remove(controller.addonsList[index]);
                                      controller.update();
                                    },
                                    child: Container(
                                      height: 38.h,
                                      width: 38.w,
                                      padding: paddingEdgeInsets(horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.secondary600 : AppThemeData.secondary50, shape: BoxShape.circle),
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_edit_2.svg",
                                        color: AppThemeData.secondary300,
                                      ),
                                    ),
                                  ),
                                  spaceW(),
                                  GestureDetector(
                                    onTap: () {
                                      controller.addonsList.remove(controller.addonsList[index]);
                                    },
                                    child: Container(
                                      height: 38.h,
                                      width: 38.w,
                                      padding: paddingEdgeInsets(horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.danger600 : AppThemeData.danger50, shape: BoxShape.circle),
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_delete.svg",
                                        color: AppThemeData.danger300,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    )
                  },
                  TextCustom(
                    title: "Addons Details".tr,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                    fontFamily: FontFamily.medium,
                  ),
                  spaceH(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextCustom(
                        title: "In Stock".tr,
                        color: themeChange.isDarkTheme() ? AppThemeData.grey300 : AppThemeData.grey700,
                        fontSize: 16,
                      ),
                      Obx(
                        () => SizedBox(
                          height: 26.h,
                          child: FittedBox(
                            child: CupertinoSwitch(
                              activeColor: AppThemeData.primary300,
                              value: controller.addonsInStock.value,
                              onChanged: (value) {
                                controller.addonsInStock.value = value;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextFieldWidget(
                          color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                          title: "Name".tr,
                          hintText: "Enter Name".tr,
                          controller: controller.addonsNameController.value,
                          onPress: () {},
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextFieldWidget(
                          color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                          title: "Price".tr,
                          hintText: "Enter Price".tr,
                          controller: controller.addonsPriceController.value,
                          textInputType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onPress: () {},
                        ),
                      ),
                    ],
                  ),
                  spaceH(),
                  GestureDetector(
                    onTap: () {
                      controller.addonsList.add(AddonsModel(
                          inStock: controller.addonsInStock.value, name: controller.addonsNameController.value.text, price: controller.addonsPriceController.value.text));
                      controller.update();

                      controller.addonsNameController.value.clear();
                      controller.addonsPriceController.value.clear();
                      controller.addonsInStock.value = true;
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: AppThemeData.primary300,
                        ),
                        spaceW(),
                        TextCustom(
                          title: "Add Another Addons".tr,
                          color: AppThemeData.primary300,
                          fontSize: 16,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: paddingEdgeInsets(vertical: 8),
            child: RoundShapeButton(
              title: "Next".tr,
              buttonColor: AppThemeData.primary300,
              buttonTextColor: AppThemeData.grey50,
              onTap: () async {
                if (controller.addonsNameController.value.text.isNotEmpty && controller.addonsPriceController.value.text.isNotEmpty) {
                  controller.addonsList.add(
                      AddonsModel(inStock: controller.addonsInStock.value, name: controller.addonsNameController.value.text, price: controller.addonsPriceController.value.text));
                  controller.update();
                  controller.nextStep();
                } else {
                  controller.nextStep();
                }
              },
              size: Size(358.w, ScreenSize.height(6, context)),
            ),
          ),
        );
      },
    );
  }
}
