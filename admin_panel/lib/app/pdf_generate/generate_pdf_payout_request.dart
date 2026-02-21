// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin_panel/app/models/payout_request_model.dart';

Future<void> generatePayoutRequestExcelWeb(List<WithdrawModel> payoutRequestList, DateTimeRange selectedRange) async {
  if (payoutRequestList.isEmpty) {
    ShowToastDialog.errorToast('No data found for the selected date range.');
    return;
  }
  String formattedStartDate = DateFormat('dd-MM-yyyy').format(selectedRange.start);
  String formattedEndDate = DateFormat('dd-MM-yyyy').format(selectedRange.end);

  var excel = Excel.createExcel();
  Sheet sheet = excel['Payout_Request_Report'];
  excel.setDefaultSheet('Payout_Request_Report');

  sheet.appendRow([
    TextCellValue("ID"),
    TextCellValue("Amount"),
    TextCellValue("Admin Note"),
    TextCellValue("Payment Status"),
    TextCellValue("Holder Name"),
    TextCellValue("Account Number"),
    TextCellValue("Bank Name"),
    TextCellValue("IFSC Code"),
    TextCellValue("Swift Code"),
    TextCellValue("Branch Country"),
    TextCellValue("Date"),
  ]);

  for (var payout in payoutRequestList) {
    sheet.appendRow([
      TextCellValue(payout.id?.substring(0, 5) ?? '-'),
      TextCellValue(payout.amount ?? '-'),
      TextCellValue(payout.adminNote ?? '-'),
      TextCellValue(payout.paymentStatus ?? '-'),
      TextCellValue(payout.bankDetails?.holderName ?? '-'),
      TextCellValue(payout.bankDetails?.accountNumber ?? '-'),
      TextCellValue(payout.bankDetails?.bankName ?? '-'),
      TextCellValue(payout.bankDetails?.ifscCode ?? '-'),
      TextCellValue(payout.bankDetails?.swiftCode ?? '-'),
      TextCellValue(payout.bankDetails?.branchCountry ?? '-'),
      TextCellValue(
        payout.createdDate != null
            ? DateFormat('yyyy-MM-dd HH:mm').format(payout.createdDate!.toDate())
            : '-',
      ),
    ]);
  }

  excel.save(fileName: 'PayoutRequest_Report_${formattedStartDate}_to_$formattedEndDate.xlsx');
}
