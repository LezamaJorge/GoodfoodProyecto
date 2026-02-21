// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/order_model.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/cart_model.dart';

Future<void> generateOrdersExcelWeb(List<OrderModel> orderList, DateTimeRange selectedRange) async {
  if (orderList.isEmpty) {
    ShowToastDialog.errorToast('No data found for the selected date range.');
    return;
  }

  String formattedStartDate = DateFormat('dd-MM-yyyy').format(selectedRange.start);
  String formattedEndDate = DateFormat('dd-MM-yyyy').format(selectedRange.end);

  var excel = Excel.createExcel();
  Sheet sheet = excel['Orders_Report'];
  excel.setDefaultSheet('Orders_Report');

  sheet.appendRow([
    TextCellValue("Order ID".tr),
    TextCellValue("Restaurant Address".tr),
    TextCellValue("Customer Address".tr),
    TextCellValue("Total Amount".tr),
    TextCellValue("Payment Type".tr),
    TextCellValue("Payment Status".tr),
    TextCellValue("Delivery Charge".tr),
    TextCellValue("Items".tr),
    TextCellValue("Cart IDs".tr),
    TextCellValue("Add-Ons".tr),
    TextCellValue("Order Date".tr),
  ]);

  String formatItems(List<CartModel>? items) {
    if (items == null || items.isEmpty) return '-';
    return items.map((item) =>
    "${item.productName ?? 'Unknown'} (${item.quantity ?? 0})"
    ).join("\n");
  }

  String formatCartIds(List<CartModel>? items) {
    if (items == null || items.isEmpty) return '-';
    return items.map((item) => "ID: ${item.id?.toString() ?? '-'}").join(", ");
  }

  String formatAddOns(List<CartModel>? items) {
    if (items == null || items.isEmpty) return '-';
    return items.map((item) {
      if (item.addOns == null || item.addOns!.isEmpty) return '-';
      return item.addOns!.join(", ");
    }).join("\n");
  }

  for (var order in orderList) {
    sheet.appendRow([
      TextCellValue(order.id?.substring(0, 5) ?? '-'),
      TextCellValue(order.vendorAddress?.address ?? '-'),
      TextCellValue(order.customerAddress?.address ?? '-'),
      TextCellValue(order.totalAmount ?? '-'),
      TextCellValue(order.paymentType ?? '-'),
      TextCellValue(order.paymentStatus == true ? "Paid" : "Unpaid"),
      TextCellValue(order.deliveryCharge ?? '-'),
      TextCellValue(formatItems(order.items)),
      TextCellValue(formatCartIds(order.items)),
      TextCellValue(formatAddOns(order.items)),
      TextCellValue(order.createdAt != null
          ? DateFormat('dd MMM, yyyy  hh:mm a').format(order.createdAt!.toDate())
          : "-"),
    ]);
  }

  excel.save(fileName: 'Orders_Report_${formattedStartDate}_to_$formattedEndDate.xlsx');
}
