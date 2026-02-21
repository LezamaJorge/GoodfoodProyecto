// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/bank_detail_model.dart';
import 'package:restaurant/constant/collection_name.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

class MyBankController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  TextEditingController bankHolderNameController = TextEditingController();
  TextEditingController bankAccountNumberController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController swiftCodeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankBranchCityController = TextEditingController();
  TextEditingController bankBranchCountryController = TextEditingController();
  RxString editingId = "".obs;
  RxBool isLoading = false.obs;

  Rx<BankDetailsModel> bankDetailsModel = BankDetailsModel().obs;
  List<BankDetailsModel> bankDetailsList = <BankDetailsModel>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    try {
      isLoading.value = true;
      bankDetailsList.clear();

      final value = await FireStoreUtils.getBankDetailList(FireStoreUtils.getCurrentUid());
      if (value != null) {
        bankDetailsList.addAll(value);
      }
    } catch (e, stack) {
      developer.log('Error fetching bank details:', error: e, stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }

  void setDefault() {
    try {
      bankHolderNameController.text = "";
      bankAccountNumberController.text = "";
      swiftCodeController.text = "";
      ifscCodeController.text = "";
      bankNameController.text = "";
      bankBranchCityController.text = "";
      bankBranchCountryController.text = "";
      editingId.value = "";
    } catch (e, stack) {
      developer.log('Error resetting bank form fields:', error: e, stackTrace: stack);
    }
  }

  Future<void> setBankDetails() async {
    try {
      bankDetailsModel.value.id = Constant.getUuid();
      bankDetailsModel.value.ownerId = FireStoreUtils.getCurrentUid();
      bankDetailsModel.value.holderName = bankHolderNameController.value.text;
      bankDetailsModel.value.accountNumber = bankAccountNumberController.value.text;
      bankDetailsModel.value.swiftCode = swiftCodeController.value.text;
      bankDetailsModel.value.ifscCode = ifscCodeController.value.text;
      bankDetailsModel.value.bankName = bankNameController.value.text;
      bankDetailsModel.value.branchCity = bankBranchCityController.value.text;
      bankDetailsModel.value.branchCountry = bankBranchCountryController.value.text;

      await FireStoreUtils.addBankDetail(bankDetailsModel.value);
      setDefault();
    } catch (e, stack) {
      developer.log('Error adding bank details:', error: e, stackTrace: stack);
    }
  }

  Future<void> updateBankDetail() async {
    try {
      bankDetailsModel.value.id = editingId.value;
      bankDetailsModel.value.ownerId = FireStoreUtils.getCurrentUid();
      bankDetailsModel.value.holderName = bankHolderNameController.value.text;
      bankDetailsModel.value.accountNumber = bankAccountNumberController.value.text;
      bankDetailsModel.value.swiftCode = swiftCodeController.value.text;
      bankDetailsModel.value.ifscCode = ifscCodeController.value.text;
      bankDetailsModel.value.bankName = bankNameController.value.text;
      bankDetailsModel.value.branchCity = bankBranchCityController.value.text;
      bankDetailsModel.value.branchCountry = bankBranchCountryController.value.text;

      await FireStoreUtils.updateBankDetail(bankDetailsModel.value);
      setDefault();
    } catch (e, stack) {
      developer.log('Error updating bank details:', error: e, stackTrace: stack);
    }
  }

  Future<void> deleteBankDetails(BankDetailsModel bankDetailsModel) async {
    try {
      isLoading.value = true;
      ShowToastDialog.showLoader("Please Wait..".tr);

      await FirebaseFirestore.instance.collection(CollectionName.bankDetails).doc(bankDetailsModel.id).delete();

      ShowToastDialog.toast("Bank details removed successfully.".tr);
      await getData();
    } catch (e, stack) {
      developer.log('Error deleting bank details:', error: e, stackTrace: stack);
    } finally {
      ShowToastDialog.closeLoader();
      isLoading.value = false;
    }
  }
}
