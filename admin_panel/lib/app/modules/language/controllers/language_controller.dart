// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/language_model.dart';
import 'package:admin_panel/app/modules/dashboard_screen/controllers/dashboard_screen_controller.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:image_picker/image_picker.dart';

class LanguageController extends GetxController {
  RxString title = "Language".tr.obs;
  Rx<LanguageModel> languageModel = LanguageModel().obs;
  Rx<TextEditingController> languageController = TextEditingController().obs;
  Rx<TextEditingController> codeController = TextEditingController().obs;
  RxBool isEditing = false.obs;
  RxBool isLoading = false.obs;
  RxBool isActive = false.obs;
  RxList<LanguageModel> languageList = <LanguageModel>[].obs;
  DashboardScreenController dashboardScreenController = Get.put(DashboardScreenController());

  Rx<File> imageFile = File('').obs;
  RxString mimeType = 'image/png'.obs;
  RxString imageURL = "".obs;
  RxString darkImageURL = "".obs;


  @override
  Future<void> onInit() async {
    await getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading(true);
    languageList.clear();
    List<LanguageModel> data = await FireStoreUtils.getLanguage();
    languageList.addAll(data);
    isLoading(false);
  }

  void setDefaultData() {
    languageController.value.text = "";
    codeController.value.text = "";
    imageURL.value = '';
    imageFile.value = File('');
    mimeType.value = 'image/png';
    isActive.value = false;
    isEditing.value = false;
  }

  Future<void> updateLanguage() async {
    String docId = languageModel.value.id!;
    if (imageFile.value.path.isNotEmpty) {
      String url = await FireStoreUtils.uploadPic(PickedFile(imageFile.value.path), "bannerImage", docId, mimeType.value);
      languageModel.value.image = url;
    } else{
      languageModel.value.image = imageURL.toString();
    }
    languageModel.value.name = languageController.value.text;
    languageModel.value.code = codeController.value.text;
    languageModel.value.active = isActive.value;
    await FireStoreUtils.updateLanguage(languageModel.value);
    await dashboardScreenController.getLanguage();
    await getData();
  }


  Future<void> addLanguage() async {
    isLoading = true.obs;
    languageModel.value.id = Constant.getRandomString(20);
    languageModel.value.name = languageController.value.text;
    languageModel.value.code = codeController.value.text;
    languageModel.value.active = isActive.value;
    String docId = Constant.getRandomString(20);
    String url = await FireStoreUtils.uploadPic(PickedFile(imageFile.value.path), "bannerImage", docId, mimeType.value);
    languageModel.value.image =url;
    await FireStoreUtils.addLanguage(languageModel.value);
    await dashboardScreenController.getLanguage();
    await getData();
    isLoading = false.obs;
  }

  Future<void> removeLanguage(LanguageModel languageModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.languages).doc(languageModel.id).delete().then((value) {
      ShowToastDialog.successToast("Language removed.".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    await dashboardScreenController.getLanguage();
    isLoading = false.obs;
  }
}
