// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/app/models/bank_detail_model.dart';
import 'package:customer/constant/collection_name.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBanksController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  RxString editingId = "".obs;
  RxBool isLoading = false.obs;
  Rx<BankDetailsModel> bankDetailsModel = BankDetailsModel().obs;
  RxList<BankDetailsModel> bankDetailsList = <BankDetailsModel>[].obs;

  Rx<TextEditingController> bankHolderNameController = TextEditingController().obs;
  Rx<TextEditingController> bankAccountNumberController = TextEditingController().obs;
  Rx<TextEditingController> swiftCodeController = TextEditingController().obs;
  Rx<TextEditingController> ifscCodeController = TextEditingController().obs;
  Rx<TextEditingController> bankNameController = TextEditingController().obs;
  Rx<TextEditingController> bankBranchCityController = TextEditingController().obs;
  Rx<TextEditingController> bankBranchCountryController = TextEditingController().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    try {
      isLoading.value = true;
      bankDetailsList.clear();

      final data = await FireStoreUtils.getBankDetailList(FireStoreUtils.getCurrentUid());

      bankDetailsList.addAll(data);
        } catch (e, stackTrace) {
      developer.log("Error getting bank details: ", error: e, stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  void setDefault() {
    try {
      bankHolderNameController.value.text = "";
      bankAccountNumberController.value.text = "";
      swiftCodeController.value.text = "";
      ifscCodeController.value.text = "";
      bankNameController.value.text = "";
      bankBranchCityController.value.text = "";
      bankBranchCountryController.value.text = "";
      editingId.value = "";
    } catch (e, stackTrace) {
      developer.log("Error resetting bank detail fields: ", error: e, stackTrace: stackTrace);
    }
  }

  Future<void> setBankDetails() async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    try {
      bankDetailsModel.value.id = Constant.getUuid();
      bankDetailsModel.value.customerId = FireStoreUtils.getCurrentUid();
      bankDetailsModel.value.holderName = bankHolderNameController.value.text;
      bankDetailsModel.value.accountNumber = bankAccountNumberController.value.text;
      bankDetailsModel.value.swiftCode = swiftCodeController.value.text;
      bankDetailsModel.value.ifscCode = ifscCodeController.value.text;
      bankDetailsModel.value.bankName = bankNameController.value.text;
      bankDetailsModel.value.branchCity = bankBranchCityController.value.text;
      bankDetailsModel.value.branchCountry = bankBranchCountryController.value.text;

      await FireStoreUtils.addBankDetail(bankDetailsModel.value);
      setDefault();
      Get.back();
      getData();
      ShowToastDialog.showToast("Bank details added successfully!".tr);
    } catch (e, stackTrace) {
      developer.log("Error adding bank details: ", error: e, stackTrace: stackTrace);
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> updateBankDetail() async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    try {
      bankDetailsModel.value.id = editingId.value;
      bankDetailsModel.value.customerId = FireStoreUtils.getCurrentUid();
      bankDetailsModel.value.holderName = bankHolderNameController.value.text;
      bankDetailsModel.value.accountNumber = bankAccountNumberController.value.text;
      bankDetailsModel.value.swiftCode = swiftCodeController.value.text;
      bankDetailsModel.value.ifscCode = ifscCodeController.value.text;
      bankDetailsModel.value.bankName = bankNameController.value.text;
      bankDetailsModel.value.branchCity = bankBranchCityController.value.text;
      bankDetailsModel.value.branchCountry = bankBranchCountryController.value.text;

      await FireStoreUtils.updateBankDetail(bankDetailsModel.value);
      setDefault();
      Get.back();
      getData();
      ShowToastDialog.showToast("Bank details updated successfully.".tr);
    } catch (e, stackTrace) {
      developer.log("Error updating bank details: ", error: e, stackTrace: stackTrace);
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> deleteBankDetails(BankDetailsModel bankDetailsModel) async {
    isLoading.value = true;
    ShowToastDialog.showLoader("Please Wait..".tr);
    try {
      await FirebaseFirestore.instance
          .collection(CollectionName.bankDetails)
          .doc(bankDetailsModel.id)
          .delete();
      ShowToastDialog.showToast("Bank details removed successfully.".tr);
      getData();
    } catch (e, stackTrace) {
      developer.log("Error deleting bank details: ", error: e, stackTrace: stackTrace);
    } finally {
      ShowToastDialog.closeLoader();
      isLoading.value = false;
    }
  }
}
