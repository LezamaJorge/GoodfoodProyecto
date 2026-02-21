// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/banner_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BannerScreenController extends GetxController {
  RxString title = "Banner".tr.obs;

  Rx<TextEditingController> bannerName = TextEditingController().obs;
  Rx<TextEditingController> bannerDescription = TextEditingController().obs;
  Rx<TextEditingController> bannerImageName = TextEditingController().obs;
  Rx<File> imageFile = File('').obs;
  RxString mimeType = 'image/png'.obs;
  RxBool isLoading = false.obs;
  RxList<BannerModel> bannerList = <BannerModel>[].obs;
  Rx<BannerModel> bannerModel = BannerModel().obs;

  RxBool isEditing = false.obs;
  RxBool isImageUpdated = false.obs;
  RxString imageURL = "".obs;
  RxString editingId = "".obs;

  Rx<TextEditingController> offerText = TextEditingController().obs;
  RxBool isOfferBanner = false.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading(true);
    bannerList.clear();
    List<BannerModel> data = await FireStoreUtils.getBanner();
    bannerList.addAll(data);
    isLoading(false);
  }

  void setDefaultData() {
    bannerName.value.text = "";
    bannerDescription.value.text = "";
    bannerImageName.value.text = "";
    isEditing.value = false;
    bannerName.value.clear();
    bannerDescription.value.clear();
    bannerImageName.value.clear();
    imageFile.value = File('');
    mimeType.value = 'image/png';
    editingId.value = '';
    isEditing.value = false;
    isImageUpdated.value = false;
    imageURL.value = '';
    offerText.value.text = '';
    isOfferBanner.value = false;
  }

  Future<void> updateBanner(BuildContext context) async {
    Navigator.pop(context);
    isEditing = true.obs;
    String docId = bannerModel.value.id!;
    if (imageFile.value.path.isNotEmpty) {
      String url = await FireStoreUtils.uploadPic(PickedFile(imageFile.value.path), "bannerImage", docId, mimeType.value);
      bannerModel.value.image = url;
    } else {
      bannerModel.value.image = imageURL.value;
    }

    bannerModel.value.bannerName = bannerName.value.text;
    bannerModel.value.bannerDescription = bannerDescription.value.text;
    bannerModel.value.isOfferBanner = isOfferBanner.value;
    bannerModel.value.offerText = offerText.value.text;
    await FireStoreUtils.updateBanner(bannerModel.value);
    setDefaultData();
    await getData();
    isEditing = false.obs;
  }

  Future<void> addBanner(BuildContext context) async {
    if (imageFile.value.path.isNotEmpty) {
      Navigator.pop(context);
      isLoading = true.obs;
      String docId = Constant.getRandomString(20);
      String url = await FireStoreUtils.uploadPic(PickedFile(imageFile.value.path), "bannerImage", docId, mimeType.value);
      bannerModel.value.id = docId;
      bannerModel.value.image = url;
      bannerModel.value.bannerName = bannerName.value.text;
      bannerModel.value.bannerDescription = bannerDescription.value.text;
      bannerModel.value.isOfferBanner = isOfferBanner.value;

      bannerModel.value.offerText = offerText.value.text;

      await FireStoreUtils.addBanner(bannerModel.value);
      setDefaultData();
      await getData();
      isLoading = false.obs;
    } else {
      ShowToastDialog.errorToast("Please select a valid banner image".tr);
    }
  }

  Future<void> removeBanner(BannerModel bannerModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.banner).doc(bannerModel.id).delete().then((value) {
      ShowToastDialog.successToast("Banner deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
    getData();
  }
}
