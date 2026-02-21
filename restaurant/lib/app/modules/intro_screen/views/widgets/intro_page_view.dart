import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/intro_screen/controllers/intro_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/preferences.dart';
import '../../../../../themes/responsive.dart';
import '../../../../../themes/screen_size.dart';
import '../../../../routes/app_pages.dart';

class IntroScreenPage extends StatelessWidget {
  final String title;
  final String body;
  final Color textColor;
  final String image;
  final String imageDarkMode;

  const IntroScreenPage({
    super.key,
    required this.title,
    required this.body,
    required this.textColor,
    required this.image,
    required this.imageDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: IntroScreenController(),
        builder: (controller) {
          int index = controller.currentPage.value;
          return Container(
            width: Responsive.width(100, context),
            height: Responsive.height(100, context),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
                gradient: index == 0
                    ? LinearGradient(
                        colors: themeChange.isDarkTheme()
                            ? [const Color(0xff180202), const Color(0xff09090B)]
                            : [const Color(0xffFDE7E7), const Color(0xffFAFAFA)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)
                    : index == 1
                        ? LinearGradient(
                            colors: themeChange.isDarkTheme()
                                ? [const Color(0xff04150E), const Color(0xff09090B)]
                                : [const Color(0xffEAFBF3), const Color(0xffFAFAFA)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)
                        : index == 2
                            ? LinearGradient(
                                colors: themeChange.isDarkTheme()
                                    ? [const Color(0xff00171A), const Color(0xff09090B)]
                                    : [const Color(0xffE5FCFF), const Color(0xffFAFAFA)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)
                            : LinearGradient(
                                colors: themeChange.isDarkTheme()
                                    ? [const Color(0xff180202), const Color(0xff09090B)]
                                    : [const Color(0xffFDE7E7), const Color(0xffFAFAFA)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index != 0
                    ? Padding(
                        padding: paddingEdgeInsets(horizontal: 0, vertical: 20),
                        child: GestureDetector(
                          onTap: () {
                            index = index - 1;
                            controller.pageController.jumpToPage(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_sharp,
                                size: 20,
                                color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: paddingEdgeInsets(horizontal: 0, vertical: 34),
                        child: SizedBox(),
                      ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 28, fontFamily: FontFamily.bold, color: textColor)),
                      const SizedBox(height: 7),
                      Text(
                        body,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: FontFamily.light,
                          fontSize: 16,
                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                        ),
                      ),
                      spaceH(height: 52),
                      Center(
                        child: CachedNetworkImage(
                          imageUrl: themeChange.isDarkTheme() ? imageDarkMode : image,
                          height: 330.h,
                          width: 330.w,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Constant.loader(),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundShapeButton(
                              size: Size(166.w, ScreenSize.height(6, context)),
                              title: "Skip".tr,
                              buttonColor: themeChange.isDarkTheme() ? AppThemeData.grey700 : AppThemeData.grey300,
                              buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.textBlack,
                              onTap: () {
                                Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                Get.offAllNamed(Routes.LANDING_SCREEN);
                              }),
                          RoundShapeButton(
                              size: Size(166.w, ScreenSize.height(6, context)),
                              title: "Next".tr,
                              buttonColor: AppThemeData.primary300,
                              buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100,
                              onTap: () {
                                if (index == controller.onboardingList.length - 1) {
                                  Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                  Get.offAllNamed(Routes.LANDING_SCREEN);
                                } else {
                                  index = index + 1;
                                  controller.pageController.jumpToPage(index);
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
