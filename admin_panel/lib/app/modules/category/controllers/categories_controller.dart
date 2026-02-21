// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/category_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  RxString title = "Categories".tr.obs;
  Rx<TextEditingController> categoryNameController = TextEditingController().obs;
  Rx<TextEditingController> categoryImageName = TextEditingController().obs;
  Rx<File> imageFile = File('').obs;
  RxString mimeType = 'image/png'.obs;
  RxBool isLoading = false.obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  Rx<CategoryModel> categoryModel = CategoryModel().obs;
  RxBool isEditing = false.obs;
  RxBool isActive = false.obs;
  RxBool isImageUpdated = false.obs;
  RxString imageURL = "".obs;
  RxString editingId = "".obs;
  RxString categoryImage = "".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void setDefaultData() {
    categoryNameController.value.text = "";
    imageURL.value = '';
    imageFile.value = File('');
    mimeType.value = 'image/png';
    isActive.value = false;
    isEditing.value = false;
  }

  Future<void> getData() async {
    isLoading.value = true;
    categoryList.clear();
    List<CategoryModel>? data = await FireStoreUtils.getCategory();
    categoryList.addAll(data);
    isLoading.value = false;
  }

  Future<void> removeCategory(CategoryModel categoryModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.category).doc(categoryModel.id).delete().then((value) {
      ShowToastDialog.successToast("Category deleted.".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }
}
