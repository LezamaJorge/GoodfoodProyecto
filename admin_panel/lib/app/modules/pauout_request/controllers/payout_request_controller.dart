// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages


import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/models/payout_request_model.dart';
import 'package:admin_panel/app/pdf_generate/generate_pdf_payout_request.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PayoutRequestController extends GetxController {
  RxString title = "Payout Request".tr.obs;

  RxBool isLoading = true.obs;
  RxBool isHistoryDownload = false.obs;

  // RxList<BookingModel> bookingList = <BookingModel>[].obs;
  RxList<WithdrawModel> payoutRequestList = <WithdrawModel>[].obs;

  // RxList<BookingModel> tempList = <BookingModel>[].obs;

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<WithdrawModel> currentPayoutRequest = <WithdrawModel>[].obs;

  Rx<TextEditingController> dateFiledController = TextEditingController().obs;
  Rx<TextEditingController> adminNoteController = TextEditingController().obs;
  Rx<TextEditingController> paymentIdController = TextEditingController().obs;

  RxString userSelectedPaymentStatus = "Pending".obs;
  List<String> paymentStatusType = ["Pending", "Complete", "Rejected"];
  RxString selectedPayoutStatus = "All".obs;
  RxString selectedPayoutStatusForStatement = "All".obs;
  RxString selectedType = "All".obs;
  RxString selectedTypeForStatement = "All".obs;
  List<String> payoutStatus = [
    "All",
    "Pending",
    "Complete",
    "Rejected",
  ];
  List<String> payoutType = [
    "All",
    "Driver",
    "Restaurant",
  ];

  Rx<TextEditingController> dateRangeController = TextEditingController().obs;
  DateTime? startDateForPdf;
  DateTime? endDateForPdf;
  Rx<DateTimeRange> selectedDateRangeForPdf = (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;

  List<WithdrawModel> payoutRequestDataList = [];

  RxString selectedDateOption = "All".obs;
  RxString selectedDateOptionForPdf = "All".obs;
  List<String> dateOption = ["All", "Last Month", "Last 6 Months", "Last Year", "Custom"];
  RxBool isCustomVisible = false.obs;
  DateTime? startDate;
  DateTime? endDate;
  Rx<DateTimeRange> selectedDateRange = (DateTimeRange(
    start: DateTime(
      DateTime.now().year,
      DateTime.now().month - 5, // Subtract 5 months
      1, // Start of the month
    ),
    end: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      23,
      59,
      59,
      999, // End of the day
    ),
  )).obs;

  // RxString userSelectedPaymentStatus = "Pending".obs;
  // List<String> paymentStatusType = ["Place", "Pending", "Complete", "Rejected"];

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getPayoutRequest();
    dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
    super.onInit();
  }

  Future<void> getPayoutRequest() async {
    isLoading.value = true;
    // tempList.value = await FireStoreUtils.getBooking();
    // bookingList.value = await FireStoreUtils.getBooking();
    payoutRequestList.value = await FireStoreUtils.getPayoutRequest(status: selectedPayoutStatus.value, type: selectedType.value, dateTimeRange: selectedDateRange.value);
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  Future<void> getFilterPayoutRequest() async {
    isLoading.value = true;
    payoutRequestList.clear();
    payoutRequestList.value = await FireStoreUtils.getPayoutRequest(status: selectedPayoutStatus.value, type: selectedType.value, dateTimeRange: selectedDateRange.value);
    setPagination(totalItemPerPage.value);
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  Future<void> downloadOrdersPdf(BuildContext context) async {
    isHistoryDownload(true);
    payoutRequestDataList = await FireStoreUtils.dataForPayOutRequestPdf(selectedDateRangeForPdf.value, selectedTypeForStatement.value, selectedPayoutStatusForStatement.value);
    await generatePayoutRequestExcelWeb(payoutRequestDataList, selectedDateRangeForPdf.value);
    Navigator.pop(context);
    isHistoryDownload(false);
  }

  Rx<DateTimeRange> selectedDate = DateTimeRange(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0)).obs;

  void setPagination(String page) {
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (payoutRequestList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > payoutRequestList.length ? payoutRequestList.length : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      currentPayoutRequest.value = payoutRequestList.sublist(startIndex.value, endIndex.value);
    }
    isLoading.value = false;
    update();
  }

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return payoutRequestList.length;
    } else {
      return int.parse(data);
    }
  }
}
