// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/onboarding_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddOnboardingController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxString editingId = "".obs;
  RxString title = 'Onboarding Screens'.tr.obs;

  RxList<OnboardingScreenModel> onboardingScreenList = <OnboardingScreenModel>[].obs;
  Rx<OnboardingScreenModel> onboardingModel = OnboardingScreenModel().obs;

  Rx<TextEditingController> titleController = TextEditingController().obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;
  Rx<TextEditingController> lightModeImageController = TextEditingController().obs;
  Rx<TextEditingController> darkModeImageController = TextEditingController().obs;
  Rx<File> lightModeImage = File('').obs;
  Rx<File> darkModeImage = File('').obs;
  RxString mimeType = 'image/png'.obs;
  RxBool isImageUpdated = false.obs;
  RxString lightModeImageURL = "".obs;
  RxString darkModeImageURL = "".obs;

  List<String> userType = ["Customer", "Driver", "Vendor"];
  RxString selectedUserType = "Customer".obs;
  RxBool isActive = true.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading(true);
    onboardingScreenList.clear();
    List<OnboardingScreenModel> data = await FireStoreUtils.getOnboardingScreen();
    onboardingScreenList.addAll(data);
    isLoading(false);
  }

  void getArgument(OnboardingScreenModel onboarding) {
    onboardingModel.value = onboarding;
    isEditing.value = true;
    editingId.value = onboardingModel.value.id!;
    titleController.value.text = onboardingModel.value.title!;
    descriptionController.value.text = onboardingModel.value.description!;
    lightModeImageController.value.text = onboardingModel.value.lightModeImage!;
    lightModeImageURL.value = onboardingModel.value.lightModeImage!;
    darkModeImageController.value.text = onboardingModel.value.darkModeImage!;
    darkModeImageURL.value = onboardingModel.value.darkModeImage!;
    selectedUserType.value = onboardingModel.value.type == "customer"
        ? "Customer"
        : onboardingModel.value.type == "driver"
            ? "Driver"
            : "Vendor";
    isActive.value = onboardingModel.value.status!;
  }

  Future<void> addOnboardingScreen() async {
    ShowToastDialog.showLoader("Please wait...".tr);
    onboardingModel.value.id = Constant.getRandomString(20);
    onboardingModel.value.title = titleController.value.text;
    onboardingModel.value.description = descriptionController.value.text;
    onboardingModel.value.type = selectedUserType.value == "Customer"
        ? "customer"
        : selectedUserType.value == "Driver"
            ? "driver"
            : "vendor";
    onboardingModel.value.status = isActive.value;
    onboardingModel.value.createdAt = Timestamp.now();
    if (lightModeImage.value.path.isNotEmpty && lightModeImage.value.path != "") {
      String url = await FireStoreUtils.uploadPic(PickedFile(lightModeImage.value.path), "OnboardingImage", "${onboardingModel.value.id}_light", mimeType.value);
      onboardingModel.value.lightModeImage = url;
    }

    if (darkModeImage.value.path.isNotEmpty && darkModeImage.value.path != "") {
      String url = await FireStoreUtils.uploadPic(PickedFile(darkModeImage.value.path), "OnboardingImage", "${onboardingModel.value.id}_dark", mimeType.value);
      onboardingModel.value.darkModeImage = url;
    }

    await FireStoreUtils.addOnboardingScreen(onboardingModel.value).then((value) {
      if (value == true) {
        Get.back();
        getData();
        ShowToastDialog.closeLoader();
        ShowToastDialog.successToast("Onboarding Screen Added Successfully.".tr);
        setDefaultData();
      }
    });
    isLoading.value = false;
  }

  Future<void> updateOnboardingScreen() async {
    ShowToastDialog.showLoader("Please wait...".tr);
    onboardingModel.value.id = editingId.value;
    if (lightModeImage.value.path.isNotEmpty) {
      String url = await FireStoreUtils.uploadPic(PickedFile(lightModeImage.value.path), "OnboardingImage", "${editingId.value}_light", mimeType.value);
      onboardingModel.value.lightModeImage = url;
    } else {
      onboardingModel.value.lightModeImage = lightModeImageURL.value;
    }
    if (darkModeImage.value.path.isNotEmpty) {
      String url = await FireStoreUtils.uploadPic(PickedFile(darkModeImage.value.path), "OnboardingImage", "${editingId.value}_dark", mimeType.value);
      onboardingModel.value.darkModeImage = url;
    } else {
      onboardingModel.value.darkModeImage = darkModeImageURL.value;
    }
    onboardingModel.value.title = titleController.value.text;
    onboardingModel.value.description = descriptionController.value.text;
    onboardingModel.value.type = selectedUserType.value == "Customer"
        ? "customer"
        : selectedUserType.value == "Driver"
            ? "driver"
            : "vendor";
    onboardingModel.value.status = isActive.value;

    await FireStoreUtils.updateOnboardingScreen(onboardingModel.value).then((value) {
      if (value == true) {
        Get.back();
        getData();
        ShowToastDialog.closeLoader();
        ShowToastDialog.successToast("Onboarding Screen Updated Successfully.".tr);
        setDefaultData();
      }
    });
  }

  Future<void> removeOnboarding(OnboardingScreenModel onboardingModel) async {
    ShowToastDialog.showLoader("Please wait...".tr);
    await FirebaseFirestore.instance.collection(CollectionName.onboardingScreen).doc(onboardingModel.id).delete().then((value) {
      ShowToastDialog.closeLoader();
      getData();
      ShowToastDialog.successToast("Onboarding Screen  deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }

  void setDefaultData() {
    titleController.value.text = "";
    descriptionController.value.text = "";
    lightModeImageController.value.text = "";
    lightModeImage.value = File('');
    lightModeImageURL.value = '';
    darkModeImageController.value.text = "";
    darkModeImage.value = File('');
    darkModeImageURL.value = '';
    mimeType.value = 'image/png';
    isEditing.value = false;
    isImageUpdated.value = false;
    selectedUserType.value = "Customer";
    isActive.value = true;
  }
}
