// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant/app/models/notification_model.dart';
import 'package:restaurant/constant/collection_name.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

class NotificationScreenController extends GetxController {
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;

  RxBool isLoading = true.obs;

  RxList<NotificationModel> todayNotifications = <NotificationModel>[].obs;
  RxList<NotificationModel> yesterdayNotifications = <NotificationModel>[].obs;
  RxList<NotificationModel> olderNotifications = <NotificationModel>[].obs;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  var groupedNotifications = <String, List<NotificationModel>>{}.obs;

  @override
  void onInit() {
    getNotifications();
    super.onInit();
  }

  void getNotifications() {
    isLoading.value = true;

    try {
      FireStoreUtils.getNotificationList().listen((snapshot) {
        List<NotificationModel> notifications = [];

        for (var doc in snapshot.docs) {
          try {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            NotificationModel notification = NotificationModel.fromJson(data);
            notifications.add(notification);
          } catch (e,stack) {
            developer.log(
              'Error parsing notification data: $e',
              error: e,
              stackTrace: stack,
            );
            if (kDebugMode) {}
          }
        }

        notificationList.value = notifications;
        groupNotificationsByDate();
        isLoading.value = false;
      }, onError: (error) {
        isLoading.value = false;
        if (kDebugMode) {}
      });
    } catch (e,stack) {
      developer.log(
        'Error fetching notifications: $e',
        error: e,
        stackTrace: stack,
      );
      isLoading.value = false;
      if (kDebugMode) {}
    }
  }

  void groupNotificationsByDate() {
    Map<String, List<NotificationModel>> tempGroupedNotifications = {};

    for (var notification in notificationList) {
      if (notification.createdAt != null) {
        String formattedDate = DateFormat('dd/MM/yyyy').format(notification.createdAt!.toDate());
        tempGroupedNotifications.putIfAbsent(formattedDate, () => []);
        tempGroupedNotifications[formattedDate]!.add(notification);
      }
    }

    groupedNotifications.value = tempGroupedNotifications;
  }

  Future<void> deleteNotification(NotificationModel notification) async {
    try {
      await fireStore.collection(CollectionName.notification).doc(notification.id).delete();

      groupNotificationsByDate();
    } catch (e,stack) {
      developer.log(
        'Error deleting notification: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }
}
