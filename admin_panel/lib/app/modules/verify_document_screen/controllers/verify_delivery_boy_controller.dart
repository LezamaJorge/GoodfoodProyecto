

// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/driver_user_model.dart';
import 'package:admin_panel/app/models/verify_driver_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VerifyDeliveryBoyController extends GetxController {
  RxString title = "Verify Delivery Boy".tr.obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingVehicleDetails = false.obs;
  RxList<DriverUserModel> driverList = <DriverUserModel>[].obs;
  RxList<VerifyDocumentModel> verifyDocumentList = <VerifyDocumentModel>[].obs;
  Rx<VerifyDriverModel> verifyDriverModel = VerifyDriverModel().obs;
  Rx<DriverUserModel> driverUserModel = DriverUserModel().obs;
  RxList<DriverUserModel> tempList = <DriverUserModel>[].obs;
  // RxList<DriverUserModel> tempList = <DriverUserModel>[].obs;
  Rx<DriverUserModel> driverUserDetails = DriverUserModel().obs;


  var currentPage =  1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<DriverUserModel> currentPageVerifyDriver = <DriverUserModel>[].obs;
  Rx<TextEditingController> dateFiledController = TextEditingController().obs;
  RxBool isVerify = false.obs;
  RxString editingVerifyDocumentId = "".obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getData();
    dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    // tempList.value = await FireStoreUtils.getVerifyDriverModel();
    // driverList.value = await FireStoreUtils.getVerifyDriverModel();
    await FireStoreUtils.countDrivers();
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  Rx<DateTimeRange> selectedDateRangeInVerify = (DateTimeRange(
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

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.driverLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.driverLength! ? Constant.driverLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<DriverUserModel> currentPageDriverData = await FireStoreUtils.getDriver(currentPage.value, itemPerPage, "", "",selectedDateRangeInVerify.value);
        currentPageVerifyDriver.value = currentPageDriverData;
      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
  }

  Future<void> removeVerifyDocument(VerifyDriverModel verifyDriverModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.verifyDriver).doc(verifyDriverModel.driverId).delete().then((value) {
      ShowToastDialog.successToast("Verify Driver deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }

  Rx<DateTimeRange> selectedDate = DateTimeRange(
      start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0),
      end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0))
      .obs;

  // setPagination(String page) {
  //   totalItemPerPage.value = page;
  //   int itemPerPage = pageValue(page);
  //   totalPage.value = (driverList.length / itemPerPage).ceil();
  //   startIndex.value = (currentPage.value - 1) * itemPerPage;
  //   endIndex.value = (currentPage.value * itemPerPage) > driverList.length ? driverList.length : (currentPage.value * itemPerPage);
  //   if (endIndex.value < startIndex.value) {
  //     currentPage.value = 1;
  //     setPagination(page);
  //   } else {
  //     currentPageVerifyDriver.value = driverList.sublist(startIndex.value, endIndex.value);
  //   }
  //   isLoading.value = false;
  //   update();
  // }

  RxString totalItemPerPage = '0'.obs;
  int pageValue(String data) {
    if (data == 'All') {
      return driverList.length;
    } else {
      return int.parse(data);
    }
  }

  // updateVerifyStatus(VerifyDocumentModel verifyDocumentModel) async {
  // var id = verifyDriverModel.value.verifyDocument!.documentId.toString();

  // int index = verifyDriverModel.value.verifyDocument!.indexWhere((element) => element.documentId == verifyDocumentModel.documentId);
  //
  // if (index != -1) {
  //   verifyDocumentList[index] = VerifyDocumentModel(
  //       documentId: verifyDocumentModel.documentId,
  //       isVerify: verifyDocumentModel.isVerify,
  //       documentImage: verifyDocumentModel.documentImage,
  //       dob: verifyDocumentModel.dob,
  //       name: verifyDocumentModel.name,
  //       number: verifyDocumentModel.number);
  //
  //   verifyDriverModel.value.verifyDocument = verifyDocumentList;
  // }
  //   bool isSaved = await FireStoreUtils.updateVerifyDocuments(verifyDriverModel.value,editingVerifyDocumentId);
  //
  //   if (isSaved) {
  //     getData();
  //     ShowToastDialog.successToast("Status Update");
  //   }
  // }

  Future<void> saveData() async {
    isLoading.value = true;
    int trueCount = 0;
    for (var element in verifyDocumentList) {
      updateVerifyStatus(element);
      if (element.isVerify == true) {
        trueCount++;
      }
    }

    driverUserDetails.update((val) {
      val!.isVerified = trueCount == verifyDocumentList.length;
      if (trueCount == verifyDocumentList.length) {
        if (driverUserDetails.value.driverVehicleDetails!.isVerified == true) {
          val.isVerified = true;
        } else {
          val.isVerified = false;
        }
      } else {
        val.isVerified = false;
      }
    });

    if (driverUserDetails.value.driverVehicleDetails!.isVerified == true) {
      trueCount++;
    }

    await FireStoreUtils.updateDriver(driverUserDetails.value);
    isLoading.value = false;
    ShowToastDialog.successToast("Status Update".tr);
  }

  Future<void> updateVerifyStatus(VerifyDocumentModel verifyDocumentModel) async {
    bool isSaved = await FireStoreUtils.updateVerifyDocuments(verifyDriverModel.value, verifyDriverModel.value.driverId.toString());

    if (isSaved) {
      getData();
    }
  }

  Future<void> getDriverDetails(String driverId) async {
    isLoadingVehicleDetails = true.obs;
    await FireStoreUtils.getDriverByDriverID(driverId.toString()).then((value) {
      if (value != null) {
        DriverUserModel driverUserModel = value;
        driverUserDetails.value = driverUserModel;

        driverUserModel.isVerified = verifyDocumentList.where((element) => element.isVerify == false).isEmpty ? true : false;
        // FireStoreUtils.updateDriver(driverUserModel!);
      }
    });
    isLoadingVehicleDetails(false);
  }
}
