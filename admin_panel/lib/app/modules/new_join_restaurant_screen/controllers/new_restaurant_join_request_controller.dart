// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/owner_model.dart';
import 'package:admin_panel/app/models/verify_restaurant_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewRestaurantJoinRequestController extends GetxController {
  RxString title = "New Restaurant Join Request".tr.obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingVehicleDetails = false.obs;
  RxList<VerifyRestaurantDocumentModel> verifyDocumentList = <VerifyRestaurantDocumentModel>[].obs;
  Rx<OwnerModel> ownerModel = OwnerModel().obs;

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<OwnerModel> currentPageVerifyOwner = <OwnerModel>[].obs;
  Rx<TextEditingController> dateFiledController = TextEditingController().obs;
  RxBool isVerify = false.obs;
  RxString editingVerifyDocumentId = "".obs;

  Rx<TextEditingController> rejectedReasonController = TextEditingController().obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getData();
    dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    await FireStoreUtils.countUnVerifiedOwner();
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  void getArgument(OwnerModel owner) {
    ownerModel.value = owner;
    editingVerifyDocumentId.value = ownerModel.value.id!;
    verifyDocumentList.value = ownerModel.value.verifyDocument ?? [];
  }

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);

    totalPage.value = (Constant.unVerifiedOwner! / itemPerPage).ceil();

    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.unVerifiedOwner! ? Constant.unVerifiedOwner! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<OwnerModel> currentPageDriverData = await FireStoreUtils.getNewOwner(currentPage.value, itemPerPage);
        currentPageVerifyOwner.value = currentPageDriverData;
      } catch (error) {
        if (kDebugMode) {}
      }
    }
    update();
    isLoading.value = false;
  }

  Future<void> removeVerifyRestaurantDocument(String verifyRestaurantModelId) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.verifyVendor).doc(verifyRestaurantModelId).delete().then((value) {
      ShowToastDialog.successToast("Verify restaurant deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }

  Rx<DateTimeRange> selectedDate =
      DateTimeRange(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0))
          .obs;

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return Constant.unVerifiedOwner!;
    } else {
      return int.parse(data);
    }
  }

  Future<void> saveData() async {
    try {
      isLoading.value = true;

      bool allDocsApproved = verifyDocumentList.isNotEmpty && verifyDocumentList.every((doc) => doc.status == "approved");

      ownerModel.update((val) {
        if (val == null) return;

        val.isVerified = allDocsApproved && (val.isVerified ?? false);
      });

      await FireStoreUtils.updateNewOwner(ownerModel.value);

      ShowToastDialog.successToast("Status Updated".tr);
      getData();
    } catch (e) {
      ShowToastDialog.errorToast("Failed to update status: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
