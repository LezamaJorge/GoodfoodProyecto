// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/driver_user_model.dart';

Future<void> generateDeliveryBoyExcelWeb(List<DriverUserModel> deliveryBoyList, DateTimeRange selectedDateRange) async {
  if (deliveryBoyList.isEmpty) {
    ShowToastDialog.errorToast('No data found for the selected date range.');
    return;
  }
  String formattedStartDate = DateFormat('dd-MM-yyyy').format(selectedDateRange.start);
  String formattedEndDate = DateFormat('dd-MM-yyyy').format(selectedDateRange.end);

  var excel = Excel.createExcel();
  Sheet sheet = excel['DeliveryBoy_Report'];
  excel.setDefaultSheet('DeliveryBoy_Report');

  // Add Header Row
  sheet.appendRow([
    TextCellValue("ID"),
    TextCellValue("Email"),
    TextCellValue("First Name"),
    TextCellValue("Last Name"),
    TextCellValue("Phone Number"),
    TextCellValue("Vehicle Type Name"),
    TextCellValue("Vehicle Number"),
    TextCellValue("Created At"),
  ]);

  // Add Data Rows
  for (var e in deliveryBoyList) {
    sheet.appendRow([
      TextCellValue(e.driverId?.substring(0, 5) ?? '-'),
      TextCellValue(e.email ?? '-'),
      TextCellValue(e.firstName ?? '-'),
      TextCellValue(e.lastName ?? '-'),
      TextCellValue(e.phoneNumber?.toString() ?? '-'),
      TextCellValue(e.driverVehicleDetails?.vehicleTypeName ?? '-'),
      TextCellValue(e.driverVehicleDetails?.vehicleNumber ?? '-'),
      TextCellValue(e.createdAt != null
          ? DateFormat('yyyy-MM-dd HH:mm').format(e.createdAt!.toDate())
          : '-'),
    ]);
  }

  excel.save(fileName: 'DeliveryBoy_Report_${formattedStartDate}_to_$formattedEndDate.xlsx');
}
