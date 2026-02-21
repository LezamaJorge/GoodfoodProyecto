import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/modules/add_menu_item_screen/views/add_menu_item_screen_view.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../themes/screen_size.dart';
import 'round_shape_button.dart';

class NoMenuItemsView extends StatelessWidget {
  final double? height;

  const NoMenuItemsView({
    super.key,
    required this.themeChange,
    this.height,
  });

  final DarkThemeProvider themeChange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.transparent,
        height: height ?? Responsive.height(75, context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/images/no_menu_items.png",
                height: 140.0,
                width: 140.0,
              ),
            ),
            TextCustom(
              title: "No Menu Items Yet".tr,
              fontSize: 18,
              fontFamily: FontFamily.bold,
              color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
            ),
            spaceH(height: 4),
            Padding(
              padding: paddingEdgeInsets(horizontal: 53.w, vertical: 0),
              child: TextCustom(
                title: "You haven’t added any menu items. Start by adding your first item now.".tr,
                maxLine: 3,
                fontSize: 14,
                fontFamily: FontFamily.regular,
                color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
              ),
            ),
            spaceH(height: 24),
            Center(
              child: RoundShapeButton(
                  size: Size(358.w, ScreenSize.height(6, context)),
                  title: "Add Menu Items".tr,
                  buttonColor: AppThemeData.primary300,
                  buttonTextColor: AppThemeData.primaryWhite,
                  onTap: () {
                    if (Constant.ownerModel!.vendorId != null && Constant.ownerModel!.vendorId!.isNotEmpty) {
                      Get.to(() => AddMenuItemsScreenView());
                    } else {
                      ShowToastDialog.toast('First Add your restaurant to change Option.'.tr);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
