// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/currency_model.dart';
import 'package:admin_panel/app/modules/currency/views/currency_view.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:nb_utils/nb_utils.dart';

class CurrencyController extends GetxController {
  RxString title = "Currency".tr.obs;

  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> codeController = TextEditingController().obs;
  Rx<TextEditingController> symbolController = TextEditingController().obs;
  Rx<TextEditingController> decimalDigitsController = TextEditingController().obs;
  Rx<bool> isActive = false.obs;
  Rx<SymbolAt> symbolAt = SymbolAt.symbolAtLeft.obs;
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxList<CurrencyModel> currencyList = <CurrencyModel>[].obs;
  Rx<CurrencyModel> currencyModel = CurrencyModel().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading(true);
    currencyList.clear();
    List<CurrencyModel> data = await FireStoreUtils.getCurrencyList();
    currencyList.addAll(data);
    isLoading(false);
  }

  void setDefaultData() {
    nameController.value.text = "";
    symbolController.value.text = "";
    decimalDigitsController.value.text = "";
    codeController.value.text = "";
    isActive = false.obs;
    symbolAt = SymbolAt.symbolAtLeft.obs;
    isEditing = false.obs;
    isLoading = false.obs;
  }

  Future<void> updateCurrency() async {
    currencyModel.value.active = isActive.value;
    // currencyModel.value.createdAt = Timestamp.now();
    currencyModel.value.name = nameController.value.text;
    currencyModel.value.code = codeController.value.text;
    currencyModel.value.symbol = symbolController.value.text;
    currencyModel.value.decimalDigits = decimalDigitsController.value.text.toInt();
    currencyModel.value.symbolAtRight = symbolAt.value.name == SymbolAt.symbolAtRight.name ? true : false;
    await FireStoreUtils.updateCurrency(currencyModel.value);
    await getData();
  }

  Future<void> addCurrency() async {
    isLoading = true.obs;
    currencyModel.value.id = Constant.getRandomString(20);
    currencyModel.value.active = isActive.value;
    currencyModel.value.createdAt = Timestamp.now();
    currencyModel.value.name = nameController.value.text;
    currencyModel.value.code = codeController.value.text;
    currencyModel.value.symbol = symbolController.value.text;
    currencyModel.value.decimalDigits = decimalDigitsController.value.text.toInt();
    currencyModel.value.symbolAtRight = symbolAt.value.name == SymbolAt.symbolAtRight.name ? true : false;
    await FireStoreUtils.addCurrency(currencyModel.value);
    await getData();
    isLoading = false.obs;
  }

  Future<void> removeCurrency(CurrencyModel currencyModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.currencies).doc(currencyModel.id).delete().then((value) {
      ShowToastDialog.successToast("Currency removed.".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }

  Future<void> disableAllCurrencies() async {
    for (var currency in currencyList) {
      if (currency.active!) {
        currency.active = false;
        await FireStoreUtils.updateCurrency(currency);
      }
    }
  }
}
