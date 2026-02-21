// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/owner_model.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> generateOwnerExcelWeb(List<OwnerModel> ownerList, DateTimeRange selectedRange) async {
  if (ownerList.isEmpty) {
    ShowToastDialog.errorToast('No data found for the selected date range.');
    return;
  }

  String formattedStartDate = DateFormat('dd-MM-yyyy').format(selectedRange.start);
  String formattedEndDate = DateFormat('dd-MM-yyyy').format(selectedRange.end);

  var excel = Excel.createExcel();
  Sheet sheet = excel['Owner_Report'];
  excel.setDefaultSheet('Owner_Report');

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
  for (var owner in ownerList) {
    sheet.appendRow([
      TextCellValue(owner.id?.substring(0, 5) ?? '-'),
      TextCellValue(owner.firstName ?? '-'),
      TextCellValue(owner.lastName ?? '-'),
      TextCellValue(owner.loginType ?? '-'),
      TextCellValue(owner.userType ?? '-'),
      TextCellValue(owner.phoneNumber ?? '-'),
      TextCellValue(owner.email ?? '-'),
      TextCellValue(owner.walletAmount ?? '-'),
      TextCellValue(
        owner.createdAt != null ? DateFormat('yyyy-MM-dd HH:mm').format(owner.createdAt!.toDate()) : '-',
      ),
    ]);
  }

  excel.save(fileName: 'Owner_Report_${formattedStartDate}_to_$formattedEndDate.xlsx');
}
