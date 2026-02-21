// ignore_for_file: deprecated_member_use
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/notification_model.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import '../controllers/notification_screen_controller.dart';
import 'widget/notification_widget.dart';

class NotificationScreenView extends StatelessWidget {
  const NotificationScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<NotificationScreenController>(
        autoRemove: false,
        init: NotificationScreenController(),
        builder: (controller) {
          return Container(
             decoration: BoxDecoration(
                gradient: LinearGradient(
                    stops: const [0.1, 0.3],
                    colors: themeChange.isDarkTheme() ? [const Color(0xff1C1C22), const Color(0xff1C1C22)] : [const Color(0xffFDE7E7), const Color(0xffFFFFFF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Scaffold(
                backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                appBar: AppBar(
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark, // Android → black
                    statusBarBrightness: Brightness.light,    // iOS → black
                  ),
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  leading: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
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
                ),
                body: Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(
                            title: "Notification".tr,
                            fontSize: 28,
                            maxLine: 2,
                            color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                            fontFamily: FontFamily.bold,
                            textAlign: TextAlign.start,
                          ),
                          2.height,
                          TextCustom(
                            title: "Stay updated with the latest offers, order updates, and important notifications.".tr,
                            fontSize: 16,
                            maxLine: 2,
                            color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                            fontFamily: FontFamily.regular,
                            textAlign: TextAlign.start,
                          ),
                          spaceH(height: 22),
                          controller.isLoading.value == true
                              ? Constant.loader()
                              : controller.notificationList.isEmpty
                                  ? Center(child: TextCustom(title: 'No Available Notification'.tr))
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: controller.groupedNotifications.length,
                                          itemBuilder: (context, index) {
                                            String date = controller.groupedNotifications.keys.elementAt(index);
                                            List<NotificationModel> notifications = controller.groupedNotifications[date]!;

                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    date,
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: notifications.length,
                                                  itemBuilder: (context, subIndex) {
                                                    NotificationModel notification = notifications[subIndex];
                                                    return NotificationTile(
                                                      notification: notification,
                                                      onDelete: (NotificationModel value) {
                                                        if (kDebugMode) {
                                                        }
                                                        controller.deleteNotification(value);
                                                        int index = controller.olderNotifications.indexOf(notification);

                                                        if (index != -1) {
                                                          controller.olderNotifications.removeAt(index);
                                                          controller.groupNotificationsByDate();
                                                        } else {
                                                          if (kDebugMode) {
                                                          }
                                                        }
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                        ],
                      ),
                    ),
                  ),
                )),
          );
        });
  }
}
