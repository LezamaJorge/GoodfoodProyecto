import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/modules/customer_screen/views/customer_screen_view.dart';
import 'package:admin_panel/app/modules/dashboard_screen/views/dashboard_screen_view.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (homeController) {
          return Scaffold(
              backgroundColor: AppThemeData.lightGrey06,
              key: homeController.scaffoldKey,
              drawer: CommonUI.drawerCustom(scaffoldKey: controller.scaffoldKey, themeChange: themeChange),
              body: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: (!ResponsiveWidget.isDesktop(context))
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Flexible(
                                child: changeWidget(homeController),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MenuWidget(),
                            Obx(
                              () => Flexible(
                                child: changeWidget(homeController),
                              ),
                            ),
                          ],
                        ),
                ),
              ));
        });
  }


  Widget changeWidget(HomeController homeController) {
    switch (homeController.currentPageIndex.value) {
      case 0:
        return const DashboardScreenView();
      case 1:
        return const CustomerScreenView();
      default:
        return const HomeView();
    }
  }

}
