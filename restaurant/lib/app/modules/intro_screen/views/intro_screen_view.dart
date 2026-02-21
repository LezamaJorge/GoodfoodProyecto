import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/onboarding_model.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../controllers/intro_screen_controller.dart';
import 'widgets/intro_page_view.dart';

class IntroScreenView extends StatelessWidget {
  const IntroScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: IntroScreenController(),
        builder: (controller) {
          return Obx(
            () => Scaffold(
                backgroundColor: controller.currentPage.value == 0
                    ? themeChange.isDarkTheme()
                        ? const Color(0xFF180202)
                        : const Color(0xFFFFFFE7)
                    : controller.currentPage.value == 1
                        ? themeChange.isDarkTheme()
                            ? const Color(0xFF180202)
                            : const Color(0xFFEDFAFF)
                        : themeChange.isDarkTheme()
                            ? const Color(0xFF180202)
                            : const Color(0xFFFFF3F1),
                body: PageView.builder(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.onboardingList.length,
                    onPageChanged: (index) {
                      controller.currentPage.value = index;
                    },
                    itemBuilder: (context, index) {
                      OnboardingScreenModel item = controller.onboardingList[index];
                      return IntroScreenPage(
                        title: item.title!,
                        body: item.description!,
                        textColor: index == 0
                            ? AppThemeData.danger300
                            : index == 1
                                ? AppThemeData.success300
                                : AppThemeData.info300,
                        image: item.lightModeImage!,
                        imageDarkMode: item.darkModeImage!,
                      );
                    })
                ),
          );
        });
  }
}
