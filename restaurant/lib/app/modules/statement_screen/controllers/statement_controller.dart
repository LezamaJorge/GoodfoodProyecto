import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/order_model.dart';
import 'package:restaurant/app/modules/statement_screen/statment_excel_sheet/generate_pdf_for_order.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import '../../../../utils/fire_store_utils.dart';

class StatementController extends GetxController {
  RxBool isLoading = false.obs;

  RxString selectedSearchType = "Cab".obs;
  RxString selectedSearchTypeForData = "slug".obs;

  DateTime? startDateForPdf;
  DateTime? endDateForPdf;

  RxBool isDatePickerEnableForPdf = true.obs;
  Rx<DateTimeRange> selectedDateRangeForPdf =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;

  RxString selectedDateOption = "All".obs;
  List<String> dateOption = ["All", "Last Month", "Last 6 Months", "Last Year", "Custom"];
  RxBool isCustomVisible = false.obs;
  RxBool isHistoryDownload = false.obs;

  List<OrderModel> interCityDataList = [];


  Future<void> dataGetForPdf() async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);

      interCityDataList = await FireStoreUtils.getOrderListForStatement(selectedDateRangeForPdf.value);

      await generateOrdersExcelSheet(interCityDataList, selectedDateRangeForPdf.value);
    } catch (e,stack) {
      developer.log("Error in dataGetForPdf: $e\nStack: $stack");
    } finally {
      ShowToastDialog.closeLoader();
    }
  }
}
