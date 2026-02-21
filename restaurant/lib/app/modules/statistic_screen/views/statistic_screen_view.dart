// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/pie_model.dart';
import 'package:restaurant/app/modules/statistic_screen/controllers/statistic_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticScreenView extends StatelessWidget {
  const StatisticScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<StatisticScreenController>(
      init: StatisticScreenController(),
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: const [0.1, 0.3],
                  colors: themeChange.isDarkTheme() ? [const Color(0xff180202), const Color(0xff1C1C22)] : [const Color(0xffFDE7E7), const Color(0xffFAFAFA)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark, // Android → black
                statusBarBrightness: Brightness.light,    // iOS → black
              ),
              backgroundColor: Colors.transparent,
              title: Row(
                children: [
                  SizedBox(
                    height: 28,
                    width: 28,
                    child: SvgPicture.asset(
                      "assets/images/logo.svg",
                      color: AppThemeData.primary300,
                    ),
                  ),
                  spaceW(),
                  TextCustom(
                    title: Constant.appName.value,
                    fontSize: 20,
                    color: AppThemeData.primary300,
                    fontFamily: FontFamily.bold,
                  ),
                ],
              ),
              actions: [
                Container(
                  height: 36.h,
                  width: 36.w,
                  decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/icons/ic_wallet.svg",
                      color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                    ),
                  ),
                ),
                spaceW(),
                Container(
                  height: 36.h,
                  width: 36.w,
                  decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/icons/ic_bell.svg",
                      color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                    ),
                  ),
                ),
                spaceW()
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: paddingEdgeInsets(),
                child: Obx(
                  () => controller.isLoading.value == true
                      ? Constant.loader()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              title: "Order Statistics".tr,
                              fontSize: 28,
                              maxLine: 2,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                              fontFamily: FontFamily.bold,
                              textAlign: TextAlign.start,
                            ),
                            2.height,
                            TextCustom(
                              title: "Track and analyze your restaurant’s order performance and trends.".tr,
                              fontSize: 16,
                              maxLine: 2,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                              fontFamily: FontFamily.regular,
                              textAlign: TextAlign.start,
                            ),
                            spaceH(height: 32.h),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextCustom(
                                      title: "Total Revenue".tr,
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                      fontFamily: FontFamily.medium,
                                      textAlign: TextAlign.start,
                                      fontSize: 16,
                                    ),
                                    spaceH(height: 2.h),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextCustom(
                                          title: controller.selectedTimeRevenue.value == 'Weekly' ? "${controller.weeklyRevenue.value}" : "${controller.totalRevenue.value}",
                                          fontSize: 12,
                                          color: AppThemeData.secondary300,
                                        ),
                                        SvgPicture.asset(
                                          "assets/icons/ic_up_arrow.svg",
                                          height: 11.h,
                                          width: 9.w,
                                          color: AppThemeData.secondary300,
                                        ),

                                        spaceW(width: 4.w),
                                        TextCustom(title: 'From Last ${controller.selectedTimeRevenue.value}')
                                      ],
                                    )
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppThemeData.grey300,
                                      width: 2,
                                    ),
                                  ),
                                  child: PopupMenuButton<String>(
                                    color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                                    padding: EdgeInsets.all(16),
                                    onSelected: (value) {
                                      controller.selectedTimeRevenue.value = value;
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'Weekly',
                                        child: Text('Weekly'),
                                      ),
                                      PopupMenuItem(
                                        value: 'Monthly',
                                        child: Text('Monthly'),
                                      ),
                                    ],
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextCustom(
                                          title: controller.selectedTimeRevenue.value,
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                                          fontSize: 14,
                                        ),
                                        spaceW(width: 4.w),
                                        SvgPicture.asset(
                                          "assets/icons/ic_down.svg",
                                          height: 8.h,
                                          width: 14.w,
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            spaceH(height: 14.h),
                            BarChartRevenue(),
                            spaceH(height: 24.h),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextCustom(
                                      title: "Total Orders".tr,
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                      fontFamily: FontFamily.medium,
                                      textAlign: TextAlign.start,
                                      fontSize: 16,
                                    ),
                                    spaceH(height: 2.h),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextCustom(
                                          title: '${controller.rejectedOrderListCount.value + controller.completedOrderListCount.value + controller.cancelledOrderListCount.value}',
                                          fontSize: 12,
                                          color: AppThemeData.secondary300,
                                        ),
                                        SvgPicture.asset(
                                          "assets/icons/ic_up_arrow.svg",
                                          height: 11.h,
                                          width: 9.w,
                                          color: AppThemeData.secondary300,
                                        ),
                                        spaceW(width: 4.w),
                                        TextCustom(title: 'From Last ${controller.selectedTimeTotalOrders.value}')
                                      ],
                                    )
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppThemeData.grey300,
                                      width: 2,
                                    ),
                                  ),
                                  child: PopupMenuButton<String>(
                                    color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                                    padding: EdgeInsets.all(16),
                                    onSelected: (value) {
                                      controller.selectedTimeTotalOrders.value = value;
                                      controller.fetchOrderStats();
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'Weekly',
                                        child: Text('Weekly'),
                                      ),
                                      PopupMenuItem(
                                        value: 'Monthly',
                                        child: Text('Monthly'),
                                      ),
                                    ],
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextCustom(
                                          title: controller.selectedTimeTotalOrders.value,
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                                          fontSize: 14,
                                        ),
                                        spaceW(width: 4.w),
                                        SvgPicture.asset(
                                          "assets/icons/ic_down.svg",
                                          height: 8.h,
                                          width: 14.w,
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            spaceH(height: 10.h),
                            controller.isLoadingChatData.value == true
                                ? Constant.loader()
                                : SfCircularChart(
                                    margin: EdgeInsets.all(0),
                                    legend: Legend(isVisible: true),
                                    series: <PieSeries<PieData, String>>[
                                      PieSeries<PieData, String>(
                                          explode: true,
                                          explodeIndex: 0,
                                          dataSource: controller.pieData,
                                          xValueMapper: (PieData data, _) => data.xData,
                                          yValueMapper: (PieData data, _) => data.yData,
                                          dataLabelMapper: (PieData data, _) => data.text,
                                          pointColorMapper: (PieData data, _) => data.color,
                                          dataLabelSettings: DataLabelSettings(isVisible: true),
                                          groupMode: CircularChartGroupMode.point,
                                          groupTo: 3
                                          ),
                                    ],
                                  ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BarChart extends StatelessWidget {
  final String selectedTimeframe;
  final List<BarChartGroupData> barGroups;

  const _BarChart({required this.selectedTimeframe, required this.barGroups});

  @override
  Widget build(BuildContext context) {
    double maxY = barGroups.map((group) => group.barRods[0].toY).reduce((a, b) => a > b ? a : b);

    maxY = maxY + (maxY * 0.1);

    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              final style = TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );

              return SideTitleWidget(
                meta: meta,
                space: 4,
                child: Text(value.toInt().toString(), style: style),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.blueAccent,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String text;
    if (selectedTimeframe == 'Weekly') {
      switch (value.toInt()) {
        case 0:
          text = 'Mn';
          break;
        case 1:
          text = 'Tu';
          break;
        case 2:
          text = 'Wd';
          break;
        case 3:
          text = 'Th';
          break;
        case 4:
          text = 'Fr';
          break;
        case 5:
          text = 'Sa';
          break;
        case 6:
          text = 'Su';
          break;
        default:
          text = '';
          break;
      }
    } else {
      switch (value.toInt()) {
        case 0:
          text = 'Ja';
          break;
        case 1:
          text = 'Fe';
          break;
        case 2:
          text = 'Ma';
          break;
        case 3:
          text = 'Ap';
          break;
        case 4:
          text = 'Ma';
          break;
        case 5:
          text = 'Ju';
          break;
        case 6:
          text = 'Ju';
          break;
        case 7:
          text = 'Au';
          break;
        case 8:
          text = 'Se';
          break;
        case 9:
          text = 'Oc';
          break;
        case 10:
          text = 'No';
          break;
        case 11:
          text = 'De';
          break;
        default:
          text = '';
          break;
      }
    }

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
    );
  }
}

class BarChartSample extends StatelessWidget {
  final controller = Get.put(StatisticScreenController());

  BarChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        AspectRatio(
          aspectRatio: 1.6,
          child: Obx(() => _BarChart(
                selectedTimeframe: controller.selectedTimeRevenue.value,
                barGroups: controller.getBarGroups(),
              )),
        ),
      ],
    );
  }
}

class BarChartRevenue extends StatelessWidget {
  final controller = Get.put(StatisticScreenController());

  BarChartRevenue({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.shouldShowChart()) {
        return Center(
          child: Text(
            "No data available for the selected timeframe.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return Column(
        children: [
          AspectRatio(
            aspectRatio: 1.6,
            child: _BarChart(
              selectedTimeframe: controller.selectedTimeRevenue.value,
              barGroups: controller.getBarGroups(),
            ),
          ),
        ],
      );
    });
  }
}

