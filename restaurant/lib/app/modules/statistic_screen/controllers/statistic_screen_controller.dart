
// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;

import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/order_model.dart';
import 'package:restaurant/app/models/pie_model.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class StatisticScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingChatData = false.obs;
  RxList<OrderModel> bookedOrderList = <OrderModel>[].obs;
  RxString selectedTimeRevenue = 'Monthly'.obs;
  RxString selectedTimeTotalOrders = 'Monthly'.obs;
  RxDouble totalRevenue = 0.0.obs;
  RxDouble weeklyRevenue = 0.0.obs;

  var rejectedOrderListCount = 0.obs;
  var completedOrderListCount = 0.obs;
  var cancelledOrderListCount = 0.obs;

  RxList<PieData> pieData = <PieData>[].obs;
  RxMap<String, double> dailyRevenue = {
    'Mon': 0.0,
    'Tue': 0.0,
    'Wed': 0.0,
    'Thu': 0.0,
    'Fri': 0.0,
    'Sat': 0.0,
    'Sun': 0.0,
  }.obs;

  RxMap<String, double> monthlyRevenue = {
    'Jan': 0.0,
    'Feb': 0.0,
    'Mar': 0.0,
    'Apr': 0.0,
    'May': 0.0,
    'Jun': 0.0,
    'Jul': 0.0,
    'Aug': 0.0,
    'Sep': 0.0,
    'Oct': 0.0,
    'Nov': 0.0,
    'Dec': 0.0,
  }.obs;

  @override
  void onInit() {
    getOrderBooked();
    super.onInit();
  }

  Future<void> getOrderBooked() async {
    try {
      isLoading.value = true;
      bookedOrderList.clear();
      bookedOrderList.value = await FireStoreUtils.getOrders();
      fetchOrderStats();
      calculationOfRevenue();
    } catch (e,stack) {
      developer.log('Error fetching orders: $e\n$stack');
    } finally {
      isLoading.value = false;
    }
  }

  List<BarChartGroupData> getBarGroups() {
    try {
      Map<String, double> dailyReven = dailyRevenue;
      Map<String, double> monthlyReve = monthlyRevenue;

      if (selectedTimeRevenue.value == 'Weekly') {
        List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

        return daysOfWeek.asMap().entries.map((entry) {
          String day = entry.value;
          double revenue = dailyReven[day] ?? 0.0;
          return BarChartGroupData(
            x: entry.key,
            barRods: [BarChartRodData(toY: revenue)],
          );
        }).toList();
      } else if (selectedTimeRevenue.value == 'Monthly') {
        List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

        return months.asMap().entries.map((entry) {
          String month = entry.value;
          double revenue = monthlyReve[month] ?? 0.0;
          return BarChartGroupData(
            x: entry.key,
            barRods: [BarChartRodData(toY: revenue)],
          );
        }).toList();
      }
    } catch (e,stack) {
      developer.log('Error generating bar chart data: $e\n$stack');
    }

    return [];
  }

  bool shouldShowChart() {
    try {
      if (selectedTimeRevenue.value == 'Weekly') {
        return isDataAvailable(dailyRevenue);
      } else if (selectedTimeRevenue.value == 'Monthly') {
        return isDataAvailable(monthlyRevenue);
      }
    } catch (e,stack) {
      developer.log('Error checking chart visibility: $e\n$stack');
    }
    return false;
  }

  bool isDataAvailable(Map<String, double> data) {
    try {
      return data.values.any((value) => value > 0);
    } catch (e,stack) {
      developer.log('Error checking data availability: $e\n$stack');
      return false;
    }
  }

  void calculationOfRevenue() {
    try {
      Timestamp today = Timestamp.now();
      DateTime todayDate = today.toDate();
      DateTime weekStartDate = todayDate.subtract(Duration(days: 6));
      int currentYear = todayDate.year;

      Map<String, double> tempDailyRevenue = {
        'Mon': 0.0,
        'Tue': 0.0,
        'Wed': 0.0,
        'Thu': 0.0,
        'Fri': 0.0,
        'Sat': 0.0,
        'Sun': 0.0,
      };

      Map<String, double> tempMonthlyRevenue = {
        'Jan': 0.0,
        'Feb': 0.0,
        'Mar': 0.0,
        'Apr': 0.0,
        'May': 0.0,
        'Jun': 0.0,
        'Jul': 0.0,
        'Aug': 0.0,
        'Sep': 0.0,
        'Oct': 0.0,
        'Nov': 0.0,
        'Dec': 0.0,
      };

      for (OrderModel order in bookedOrderList) {
        try {
          if (order.createdAt != null) {
            DateTime orderDate = order.createdAt!.toDate();
            double orderSubtotal = double.tryParse(order.subTotal ?? '0') ?? 0.0;

            if (orderDate.year == currentYear) {
              if (orderDate.isAfter(weekStartDate) && orderDate.isBefore(todayDate.add(Duration(days: 1)))) {
                String dayOfWeek = getDayOfWeek(orderDate);
                weeklyRevenue.value += orderSubtotal;
                tempDailyRevenue[dayOfWeek] = tempDailyRevenue[dayOfWeek]! + orderSubtotal;
              }

              String month = getMonthName(orderDate);
              totalRevenue.value += orderSubtotal;
              tempMonthlyRevenue[month] = tempMonthlyRevenue[month]! + orderSubtotal;
            }
          }
        } catch (e,stack) {
          developer.log('Error processing order: $e\n$stack');
        }
      }

      dailyRevenue.value = tempDailyRevenue;
      monthlyRevenue.value = tempMonthlyRevenue;
    } catch (e,stack) {
      developer.log('Error calculating revenue: $e\n$stack');
    }
  }

  void updateChartData() {
    try {
      pieData.clear();

      if (rejectedOrderListCount.value > 0) {
        pieData.add(PieData('Rejected', rejectedOrderListCount.value, '${rejectedOrderListCount.value}', AppThemeData.danger300));
      }
      if (completedOrderListCount.value > 0) {
        pieData.add(PieData('Completed', completedOrderListCount.value, '${completedOrderListCount.value}', AppThemeData.secondary300));
      }
      if (cancelledOrderListCount.value > 0) {
        pieData.add(PieData('Cancelled', cancelledOrderListCount.value, '${cancelledOrderListCount.value}', AppThemeData.info300));
      }

      if (pieData.isEmpty) {
        pieData.add(PieData('No Data ${selectedTimeTotalOrders.value}', 1, 'No Data ${selectedTimeTotalOrders.value}', AppThemeData.primary200));
      }
    } catch (e,stack) {
      developer.log('Error updating chart data: $e\n$stack');
    }
  }

  void fetchOrderStats() async {
    isLoadingChatData.value = true;
    try {
      List<OrderModel> allOrders = bookedOrderList;
      int rejectedOrdersCount = 0;
      int completedOrdersCount = 0;
      int cancelledOrdersCount = 0;

      DateTime today = DateTime.now();

      if (selectedTimeTotalOrders.value == 'Monthly') {
        DateTime startOfMonth = DateTime(today.year, today.month, 1);
        DateTime endOfMonth = DateTime(today.year, today.month + 1, 0, 23, 59, 59);

        rejectedOrdersCount = allOrders
            .where((order) =>
                order.orderStatus == 'order_rejected' &&
                order.createdAt != null &&
                order.createdAt!.toDate().isAfter(startOfMonth) &&
                order.createdAt!.toDate().isBefore(endOfMonth))
            .length;

        completedOrdersCount = allOrders
            .where((order) =>
                order.orderStatus == 'order_complete' &&
                order.createdAt != null &&
                order.createdAt!.toDate().isAfter(startOfMonth) &&
                order.createdAt!.toDate().isBefore(endOfMonth))
            .length;

        cancelledOrdersCount = allOrders
            .where((order) =>
                order.orderStatus == 'order_cancel' && order.createdAt != null && order.createdAt!.toDate().isAfter(startOfMonth) && order.createdAt!.toDate().isBefore(endOfMonth))
            .length;
      } else {
        DateTime weekStartDate = today.subtract(Duration(days: 7));
        DateTime weekEndDate = today;

        rejectedOrdersCount = allOrders
            .where((order) =>
                order.orderStatus == 'order_rejected' &&
                order.createdAt != null &&
                order.createdAt!.toDate().isAfter(weekStartDate) &&
                order.createdAt!.toDate().isBefore(weekEndDate))
            .length;

        completedOrdersCount = allOrders
            .where((order) =>
                order.orderStatus == 'order_complete' &&
                order.createdAt != null &&
                order.createdAt!.toDate().isAfter(weekStartDate) &&
                order.createdAt!.toDate().isBefore(weekEndDate))
            .length;

        cancelledOrdersCount = allOrders
            .where((order) =>
                order.orderStatus == 'order_cancel' &&
                order.createdAt != null &&
                order.createdAt!.toDate().isAfter(weekStartDate) &&
                order.createdAt!.toDate().isBefore(weekEndDate))
            .length;
      }

      rejectedOrderListCount.value = rejectedOrdersCount;
      completedOrderListCount.value = completedOrdersCount;
      cancelledOrderListCount.value = cancelledOrdersCount;

      updateChartData();
    } catch (e,stack) {
      developer.log('Error fetching order stats: $e\n$stack');
    } finally {
      isLoadingChatData.value = false;
    }
  }
}

String getMonthName(DateTime date) {
  List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return months[date.month - 1];
}

String getDayOfWeek(DateTime date) {
  List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return daysOfWeek[date.weekday - 1];
}