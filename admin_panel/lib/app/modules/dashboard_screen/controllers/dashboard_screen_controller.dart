// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/order_status.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/admin_model.dart';
import 'package:admin_panel/app/models/order_model.dart';
import 'package:admin_panel/app/models/cart_model.dart';
import 'package:admin_panel/app/models/user_model.dart';
import 'package:admin_panel/app/models/language_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardScreenController extends GetxController {
  GlobalKey<ScaffoldState> scaffoldKeyDrawer = GlobalKey<ScaffoldState>();

  RxBool isLoading = true.obs;
  RxBool isUserData = true.obs;
  RxDouble totalEarnings = 0.0.obs;

  RxDouble numberOfUser = 0.0.obs;

  RxList<LanguageModel> languageList = <LanguageModel>[].obs;
  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<AdminModel> admin = AdminModel().obs;
  RxList<OrderModel> recentOrderList = <OrderModel>[].obs;
  RxList<OrderModel> orderList = <OrderModel>[].obs;
  RxList<CartModel> top5FoodList = <CartModel>[].obs;

  var monthlyUserCount = List<int>.filled(12, 0).obs;
  RxBool isLoadingBookingChart = true.obs;
  RxList<UserModel> recentUserList = <UserModel>[].obs;
  List<ChartData>? usersChartData;
  List<ChartData>? recentUsersChartData;
  List<ChartDataCircle>? usersCircleChartData;
  List<ChartDataCircle> chartDataCircle = [];
  List<SalesStatistic> salesStatistic = [];
  RxInt totalOrders = 0.obs;
  RxInt totalUser = 0.obs;
  RxInt totalDriver = 0.obs;
  RxInt totalPendingOrders = 0.obs;
  RxInt totalCompletedOrders = 0.obs;
  RxInt totalRejectedOrders = 0.obs;

  @override
  void onInit() {
    getData();
    refreshRecentOrders();
    super.onInit();
  }

  void toggleDrawer() {
    GlobalKey<ScaffoldState> scaffoldKey = scaffoldKeyDrawer;
    scaffoldKey.currentState?.openDrawer();
  }

  Future<void> getData() async {
    isLoading = true.obs;
    isUserData = true.obs;
    Constant.getCurrencyData();
    LanguageModel languageModel = await Constant.getLanguageData();
    selectedLanguage.value = languageModel;
    getAllStatisticData();
    await getLanguage();
    usersChartData = List.filled(12, ChartData("", 0));
    usersCircleChartData = List.filled(12, ChartDataCircle("", 0, Colors.amber));
    getTop5Products();
    isLoading = false.obs;
  }

  Future<void> refreshRecentOrders() async {
    orderList.value = await FireStoreUtils.getRecentBooking(status: "All");
    recentOrderList.value = orderList.sublist(0, 5);
  }

  Future<void> getAllStatisticData() async {
    isUserData.value = true;
    isLoadingBookingChart.value = true;
    totalUser.value = await FireStoreUtils.countUsers();
    totalDriver.value = await FireStoreUtils.countDrivers();
    totalPendingOrders.value = await FireStoreUtils.countPendingOrders();
    totalCompletedOrders.value = await FireStoreUtils.countCompletedOrders();
    totalRejectedOrders.value = await FireStoreUtils.countRejectedOrders();
    totalOrders.value = await FireStoreUtils.countOrders();

    chartDataCircle = [
      ChartDataCircle('Total Pending Orders'.tr, totalPendingOrders.value, const Color(0xff0479C7)),
      ChartDataCircle('Total Completed Orders'.tr, totalCompletedOrders.value, const Color(0xffF87626)),
      ChartDataCircle('Total Rejected Orders'.tr, totalRejectedOrders.value, const Color(0xffF85A40)),
    ];
    await getCountData();
    await getRecentUsersLastWeek();
    for (var order in orderList) {
      if (order.orderStatus == OrderStatus.orderComplete) {
        totalEarnings.value += Constant.calculateFinalAmount(order);
      }
    }
    isLoadingBookingChart.value = false;
    isUserData.value = false;
  }

  List<CartModel> getTop5Products() {
    Map<String, int> productFrequency = {};

    for (var order in orderList) {
      if (order.items != null) {
        for (var item in order.items!) {
          if (item.productId != null) {
            productFrequency[item.productId!] = (productFrequency[item.productId!] ?? 0) + 1;
          }
        }
      }
    }

    var sortedProductEntries = productFrequency.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    var top5ProductIds = sortedProductEntries.take(5).map((entry) => entry.key).toList();

    for (var order in orderList) {
      if (order.items != null) {
        for (var item in order.items!) {
          if (top5ProductIds.contains(item.productId) && !top5FoodList.any((product) => product.productId == item.productId)) {
            top5FoodList.add(item);
          }
        }
      }
    }

    return top5FoodList;
  }

  Future<void> getCountData() async {
    isLoadingBookingChart.value = true;
    List<Future<void>> monthDataFutures = [
      getMonthWiseData("01", 0, "JAN"),
      getMonthWiseData("02", 1, "FEB"),
      getMonthWiseData("03", 2, "MAR"),
      getMonthWiseData("04", 3, "APR"),
      getMonthWiseData("05", 4, "MAY"),
      getMonthWiseData("06", 5, "JUN"),
      getMonthWiseData("07", 6, "JUL"),
      getMonthWiseData("08", 7, "AUG"),
      getMonthWiseData("09", 8, "SEP"),
      getMonthWiseData("10", 9, "OCT"),
      getMonthWiseData("11", 10, "NOV"),
      getMonthWiseData("12", 11, "DEC"),
    ];

    await Future.wait(monthDataFutures);
    isLoadingBookingChart.value = false;
  }

  Future<void> getMonthWiseData(String monthValue, int index, String monthName) async {
    // int month = int.parse(monthValue);
    int month = int.parse(monthValue);
    int year = DateTime.now().year;
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0, 23, 59, 59);

    List<UserModel> user = [];
    try {
      QuerySnapshot value = await FirebaseFirestore.instance
          .collection(CollectionName.customer)
          .where("createdAt", isGreaterThanOrEqualTo: firstDayOfMonth, isLessThanOrEqualTo: lastDayOfMonth)
          .where("isActive", isEqualTo: true)
          .get();

      for (var element in value.docs) {
        Map<String, dynamic>? elementData = element.data() as Map<String, dynamic>?;
        if (elementData != null) {
          UserModel userData = UserModel.fromJson(elementData);
          user.add(userData);
        }
      }

      numberOfUser.value = 0.0;
      numberOfUser.value = double.parse(user.length.toString());

      usersChartData![index] = ChartData(monthName, numberOfUser.value);
    } catch (e) {
      developer.log("Error in get month wise data :", error: e);
    }
  }

  Future<void> getLanguage() async {
    await FireStoreUtils.getAdmin().then((value) {
      if (value != null) {
        admin.value = value;
        Constant.adminModel = value;
        Constant.isDemoSet(value);
      }
    }).catchError((error) {
      log('error in getAdmin type ${error.toString()}');
    });
    await FireStoreUtils.getLanguage().then((value) {
      languageList.value = value;
      for (var element in languageList) {
        if (element.code == "en") {
          selectedLanguage.value = element;
          continue;
        } else {
          selectedLanguage.value = languageList.first;
        }
      }
    }).catchError((error) {
      developer.log('error in getLanguage type:', error: error);
    });
  }

  Future<void> getRecentUsersLastWeek() async {
    DateTime now = DateTime.now();
    DateTime lastWeek = now.subtract(const Duration(days: 7));

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(CollectionName.customer)
          .where('createdAt', isGreaterThanOrEqualTo: lastWeek)
          .where('createdAt', isLessThanOrEqualTo: now)
          .where("active", isEqualTo: true)
          .get();

      recentUserList.value = querySnapshot.docs.map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

      generateWeeklyUserChart();
    } catch (e) {
      if(kDebugMode){

      }
    }
  }

  void generateWeeklyUserChart() {
    Map<String, int> userCountByDay = {};

    for (var i = 0; i < 7; i++) {
      String day = DateFormat('EEE').format(DateTime.now().subtract(Duration(days: i)));
      userCountByDay[day] = 0;
    }

    for (var user in recentUserList) {
      String day = DateFormat('EEE').format(user.createdAt!.toDate());
      if (userCountByDay.containsKey(day)) {
        userCountByDay[day] = userCountByDay[day]! + 1;
      }
    }

    recentUsersChartData = userCountByDay.entries.map((e) => ChartData(e.key, e.value.toDouble())).toList();
  }

  Future<void> removeOrder(OrderModel bookingModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.orders).doc(bookingModel.id).delete().then((value) {
      ShowToastDialog.successToast("Order deleted.".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}

class ChartDataCircle {
  ChartDataCircle(this.x, this.y, [this.color]);

  final String x;
  final int y;
  final Color? color;
}

class SalesStatistic {
  SalesStatistic(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
