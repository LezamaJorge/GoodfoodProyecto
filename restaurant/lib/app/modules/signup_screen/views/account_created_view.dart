import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/dashboard_screen/views/dashboard_screen_view.dart';
import 'package:restaurant/app/modules/login_screen/controllers/login_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/screen_size.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

class AccountCreatedView extends StatelessWidget {
  const AccountCreatedView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: LoginScreenController(),
        builder: (controller) {
          return Container(
            height: ScreenSize.height(100, context),
            width: ScreenSize.width(100, context),
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xff3232AA), Color(0xff4A4AF2), Color(0xff3232AA)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Column(
              children: [
                spaceH(height: 240.h),
                SizedBox(
                  height: 140.h,
                  width: 140.w,
                  child: Image.asset(
                    "assets/images/account_successfully_created.png",
                  ),
                ),
                spaceH(height: 42.h),
                Padding(
                  padding: paddingEdgeInsets(horizontal: 39, vertical: 0),
                  child: TextCustom(
                    title: "Account Created Successfully".tr,
                    maxLine: 2,
                    color: AppThemeData.grey50,
                    fontSize: 28,
                    fontFamily: FontFamily.bold,
                  ),
                ),
                Padding(
                  padding: paddingEdgeInsets(horizontal: 50, vertical: 0),
                  child: TextCustom(
                    title: "Congratulations! Your account has been successfully created. Start exploring now!".tr,
                    maxLine: 3,
                    color: AppThemeData.secondary100,
                    fontSize: 16,
                    fontFamily: FontFamily.regular,
                  ),
                ),
                spaceH(height: 52),
                RoundShapeButton(
                    size: Size(259.w, ScreenSize.height(6, context)),
                    title: "Set up Restaurant".tr,
                    buttonColor: AppThemeData.primary300,
                    buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100,
                    onTap: () {
                      Get.offAll(DashboardScreenView());
                    }),
              ],
            ),
          );
        });
  }
}
