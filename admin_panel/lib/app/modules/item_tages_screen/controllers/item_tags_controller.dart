// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemTagsController extends GetxController{
  RxString title = "Item Tags".tr.obs;
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxString editingValue = "".obs;

  RxList<String> driverCancellingReasonList = <String>[].obs;
  Rx<TextEditingController> reasonController = TextEditingController().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading(true);
    driverCancellingReasonList.value = await FireStoreUtils.getItemTags();
    isLoading(false);
  }

  void setDefaultData() {
    reasonController.value.text = "";
    editingValue.value = "";
    isEditing.value = false;
    isLoading.value = false;
  }

  Future<void> addReason() async {
    isLoading.value = true;
    driverCancellingReasonList.add(reasonController.value.text);
    await FireStoreUtils.addItemTags(driverCancellingReasonList);
    setDefaultData();
    isLoading.value = false;
  }

  Future<void> updateReason() async {
    isEditing.value = true;
    driverCancellingReasonList[driverCancellingReasonList.indexWhere((element) => element == editingValue.value)] = reasonController.value.text;
    await FireStoreUtils.addItemTags(driverCancellingReasonList);
    setDefaultData();
    isEditing.value = false;
  }

  Future<void> removeReason(String reason) async {
    isLoading.value = true;
    driverCancellingReasonList.remove(reason);
    await FirebaseFirestore.instance.collection(CollectionName.settings).doc("item_tags").set(<String, List<String>>{"tags": driverCancellingReasonList}).then((value) {
      ShowToastDialog.successToast("Item Tag Deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    setDefaultData();
    isLoading.value = false;
  }
}