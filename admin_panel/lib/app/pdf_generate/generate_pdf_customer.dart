// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';

Future<void> generateCustomerDataExcelWeb(List<UserModel> userList, DateTimeRange selectedDateRange) async {
  if (userList.isEmpty) {
    ShowToastDialog.errorToast('No data found for the selected date range.');
    return;
  }

  String formattedStartDate = DateFormat('dd-MM-yyyy').format(selectedDateRange.start);
  String formattedEndDate = DateFormat('dd-MM-yyyy').format(selectedDateRange.end);

  var excel = Excel.createExcel();
  Sheet sheet = excel['Customer_Report'];
  excel.setDefaultSheet('Customer_Report');

  // Add Header Row
  sheet.appendRow([
    TextCellValue("ID"),
    TextCellValue("Email"),
    TextCellValue("First Name"),
    TextCellValue("Last Name"),
    TextCellValue("Phone Number"),
    TextCellValue("Created At"),
  ]);

  // Add Data Rows
  for (var user in userList) {
    sheet.appendRow([
      TextCellValue(user.id?.substring(0, 5) ?? '-'),
      TextCellValue(user.email ?? '-'),
      TextCellValue(user.firstName ?? '-'),
      TextCellValue(user.lastName ?? '-'),
      TextCellValue(user.phoneNumber?.toString() ?? '-'),
      TextCellValue(user.createdAt != null
          ? DateFormat('yyyy-MM-dd HH:mm').format(user.createdAt!.toDate())
          : '-'),
    ]);
  }

  excel.save(fileName: 'CustomerReport_${formattedStartDate}_to_$formattedEndDate.xlsx');
}
