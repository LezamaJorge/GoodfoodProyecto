// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin_panel/app/models/vendor_model.dart';

Future<void> generateRestaurantExcelWeb(List<VendorModel> restaurantList, DateTimeRange selectedRange) async {
  if (restaurantList.isEmpty) {
    ShowToastDialog.errorToast('No data found for the selected date range.');
    return;
  }

  String formattedStartDate = DateFormat('dd-MM-yyyy').format(selectedRange.start);
  String formattedEndDate = DateFormat('dd-MM-yyyy').format(selectedRange.end);

  var excel = Excel.createExcel();
  Sheet sheet = excel['Restaurant_Report'];
  excel.setDefaultSheet('Restaurant_Report');

  // Add headers
  sheet.appendRow([
    TextCellValue("ID"),
    TextCellValue("Owner Name"),
    TextCellValue("Restaurant Name"),
    TextCellValue("Restaurant Type"),
    TextCellValue("User Type"),
    TextCellValue("Document Verified"),
    TextCellValue("Restaurant Address"),
    TextCellValue("Created At"),
  ]);

  // Add restaurant data
  for (var restaurant in restaurantList) {
    sheet.appendRow([
      TextCellValue(restaurant.id?.substring(0, 5) ?? '-'),
      TextCellValue(restaurant.ownerFullName ?? '-'),
      TextCellValue(restaurant.vendorName ?? '-'),
      TextCellValue(restaurant.vendorType ?? '-'),
      TextCellValue(restaurant.userType?.toString() ?? '-'),
      TextCellValue(restaurant.address?.address ?? '-'),
      TextCellValue(
        restaurant.createdAt != null
            ? DateFormat('yyyy-MM-dd HH:mm').format(restaurant.createdAt!.toDate())
            : '-',
      ),
    ]);
  }

  excel.save(fileName: 'Restaurant_Report_${formattedStartDate}_to_$formattedEndDate.xlsx');
}
