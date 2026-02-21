// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/category_model.dart';
import 'package:admin_panel/app/models/sub_category_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoryController extends GetxController {
  RxString title = "Sub Categories".tr.obs;
  Rx<TextEditingController> categoryName = TextEditingController().obs;
  Rx<TextEditingController> categoryImageName = TextEditingController().obs;
  Rx<File> imageFile = File('').obs;
  RxString mimeType = 'image/png'.obs;
  RxBool isLoading = false.obs;
  RxList<SubCategoryModel> subCategoryList = <SubCategoryModel>[].obs;
  RxBool isEditing = false.obs;
  RxBool isActive = false.obs;
  RxBool isImageUpdated = false.obs;
  RxString imageURL = "".obs;
  RxString editingId = "".obs;
  RxString categoryImage = "".obs;
  Rx<SubCategoryModel> subCategoryModel = SubCategoryModel().obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  Rx<CategoryModel> selectedCategory = CategoryModel().obs;

  Rx<TextEditingController> categoryNameController = TextEditingController().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    subCategoryList.clear();
    List<SubCategoryModel>? data = await FireStoreUtils.getSubCategory();
    subCategoryList.addAll(data);
    await FireStoreUtils.getCategory().then(
      (value) {
        categoryList.value = value;
            },
    );
    isLoading.value = false;
  }

  void setDefaultData() {
    categoryNameController.value.clear();
    subCategoryModel.value = SubCategoryModel();
    selectedCategory.value = CategoryModel();
    isEditing.value = false;
  }

  Future<void> getArguments(SubCategoryModel categoryModel) async {
    categoryNameController.value.text = categoryModel.subCategoryName!;
    subCategoryModel.value.id = categoryModel.id;
    selectedCategory.value = categoryList.firstWhere(
      (subCategory) => subCategory.id == categoryModel.categoryId,
      orElse: () => CategoryModel(), // Default value if not found
    );
  }

  // getData() async {
  //   isLoading = true.obs;
  //   subCategoryList.clear();
  //   List<SubCategoryModel> data = await FireStoreUtils.getSubCategory();
  //   log('=======${data.length}=>');
  //   subCategoryList.addAll(data);
  //   isLoading = false.obs;
  //   log('====isLoading===${isLoading.value}=>');
  // }

  Future<void> saveSubCategory() async {


    subCategoryModel.value.categoryId = selectedCategory.value.id;
    subCategoryModel.value.subCategoryName = categoryNameController.value.text;
    if (isEditing.value != true) {
      subCategoryModel.value.id = Constant.getUuid();
    }

    // subCategoryList.add(subCategoryModel.value);
    await FireStoreUtils.addSubCategory(subCategoryModel.value);
    getData();
  }

  Future<void> removeCategory(SubCategoryModel categoryModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.subCategory).doc(categoryModel.id).delete().then((value) {
      ShowToastDialog.successToast("Sub Category deleted.".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }
}
