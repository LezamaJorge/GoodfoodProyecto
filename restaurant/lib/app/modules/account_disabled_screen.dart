// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/screen_size.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'login_screen/views/login_screen_view.dart';

class AccountDisabledScreen extends StatelessWidget {
  const AccountDisabledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 42),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/icons/ic_account_disabled.svg"),
             SizedBox(height: 28.h,),
            Text(
              "Your Account Has Been Disabled",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontFamily: FontFamily.medium, color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite :AppThemeData.primaryBlack),
            ),
             SizedBox(height: 12.h,),
            Text(
              "Access to your account has been disabled. please contact to the admin.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontFamily: FontFamily.regular, color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite :AppThemeData.primaryBlack),
            ),
             SizedBox(height: 24.h,),
            RoundShapeButton(
              title: "Log out".tr,
              buttonColor: AppThemeData.primary300,
              buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Constant.ownerModel = null;
                Constant.vendorModel = null;
                if (context.mounted) {
                  Navigator.pop(context);
                }
                Get.offAll(LoginScreenView());
              },
              size: Size(358.w, ScreenSize.height(6, context)),
            )
          ],
        ),
      ),
    );
  }
}
