// ignore_for_file: use_super_parameters

import 'package:admin_panel/app/modules/error_screen/views/widget/error_text.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/error_screen_controller.dart';

class ErrorScreenView extends GetView<ErrorScreenController> {
  const ErrorScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ErrorScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppThemeData.lynch50,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResponsiveWidget.isMobile(context)
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 500,
                              width: 300,
                              child: ErrorText(),
                            ),
                            spaceH(height: 50),
                            FittedBox(
                              child: Lottie.asset(
                                "assets/animation/food_animation.json",
                                height: 400.0,
                                width: 1000.0,
                              ),
                            ),
                          ],
                        )
                      : FittedBox(
                          child: Row(
                            children: [
                              Lottie.asset(
                                "assets/animation/food_animation.json",
                                height: 400.0,
                                width: 1000.0,
                              ),
                              // Image.asset(
                              //   "assets/animation/cab_animation.gif",
                              //   fit: BoxFit.fitWidth,
                              //   height: 400.0,
                              //   width: 1000.0,
                              // ),
                              const ErrorText(),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
