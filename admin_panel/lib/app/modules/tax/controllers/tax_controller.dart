// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/tax_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TaxController extends GetxController{
  RxString title = "Taxes".tr.obs;
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxList<TaxModel> taxList = <TaxModel>[].obs;
  Rx<TaxModel> taxModel = TaxModel().obs;
  Rx<TextEditingController> taxNameController = TextEditingController().obs;
  Rx<TextEditingController> taxAmountController = TextEditingController().obs;
  Rx<bool> isActive = true.obs;
  RxString selectedCountry = "India".obs;

  List<String> taxType = ["Percentage", "Fix"];
  RxString selectedTaxType = "Percentage".obs;

  @ override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    taxList.clear();
    List<TaxModel>? data = await FireStoreUtils.getTax();
    taxList.addAll(data);
    isLoading.value = false;
  }

  void setDefaultData() {
    selectedCountry = "India".obs;
    selectedTaxType = "Fix".obs;
    taxNameController.value.text = "";
    taxAmountController.value.text = "";
    isEditing = false.obs;
    isLoading = false.obs;
  }

  Future<void> addTax() async {
    isLoading = true.obs;
    taxModel.value.id = Constant.getRandomString(20);
    taxModel.value.active = isActive.value;
    taxModel.value.country = selectedCountry.value;
    taxModel.value.isFix = selectedTaxType.value == "Fix" ? true : false;
    taxModel.value.name = taxNameController.value.text;
    taxModel.value.value = taxAmountController.value.text;
    await FireStoreUtils.addTax(taxModel.value);
    await getData();

    isLoading = false.obs;
  }

  Future<void> updateTax() async {
    taxModel.value.active = isActive.value;
    taxModel.value.country = selectedCountry.value;
    taxModel.value.isFix = selectedTaxType.value == "Fix" ? true : false;
    taxModel.value.name = taxNameController.value.text;
    taxModel.value.value = taxAmountController.value.text;
    await FireStoreUtils.updateTax(taxModel.value);
    await getData();
  }

  Future<void> removeTax(TaxModel taxModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.countryTax).doc(taxModel.id).delete().then((value) {
      ShowToastDialog.successToast("Tax removed successfully.".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }
}