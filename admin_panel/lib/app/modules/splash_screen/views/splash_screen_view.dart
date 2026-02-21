// ignore_for_file: use_super_parameters

import 'package:admin_panel/app/modules/splash_screen/controllers/splash_screen_controller.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppThemeData.primaryWhite,
          body: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: 300,
              child: Lottie.asset(
                "assets/animation/food_animation.json",
              ),
            ),
          ),
        );
      },
    );
  }
}
