// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          "assets/icons/error_text.svg",
          color: Colors.black,
          height: 395,
        ),
        const SizedBox(height: 30),
        CustomButtonWidget(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          title: "Go to Home",
          buttonColor: Colors.black,
          textColor: Colors.white,
          onPress: () async {
            bool isLogin = await FireStoreUtils.isLogin();
            if (Get.currentRoute != Routes.ERROR_SCREEN) {
              if (!isLogin) {
                Get.offAllNamed(Routes.LOGIN_PAGE);
              } else {
                FireStoreUtils.getAdmin().then(
                  (value) {
                    if (value != null) {
                      Constant.isDemoSet(value);
                    }
                  },
                );
                Get.offAllNamed(Routes.DASHBOARD_SCREEN);
              }
            }
          },
        ),
      ],
    );
  }
}
