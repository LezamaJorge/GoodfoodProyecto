// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/category_model.dart';
import 'package:restaurant/app/models/product_model.dart';
import 'package:restaurant/app/models/sub_category_model.dart';
import 'package:restaurant/constant/collection_name.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

class MenuScreenController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> isSubCategoryLoading = false.obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<ProductModel> allProductList = <ProductModel>[].obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;

  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<TextEditingController> notUseController = TextEditingController().obs;
  RxList<SubCategoryModel> subCategoryList = <SubCategoryModel>[].obs;
  Rx<CategoryModel> selectedCategory = CategoryModel().obs;
  Rx<SubCategoryModel> selectedSubCategory = SubCategoryModel().obs;
  RxList<ProductModel> filteredProductList = <ProductModel>[].obs;
  RxList<bool> isOpen = <bool>[].obs;

  RxList<ProductModel> searchFoodList = <ProductModel>[].obs;
  RxMap<String, int> categoryProductCount = <String, int>{}.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    try {
      productList.clear();
      subCategoryList.clear();
      categoryList.clear();
      allProductList.clear();

      isLoading.value = true;

      final products = await FireStoreUtils.getProductList(Constant.vendorModel!.id);
      if (products != null) {
        productList.addAll(products);
        allProductList.addAll(products);
      }

      final categories = await FireStoreUtils.getCategoryList();
      if (categories != null) {
        categoryList.add(CategoryModel(id: 'all', categoryName: 'All', active: true));
        categoryList.addAll(categories);
      }

      selectedCategory.value = categoryList.first;
      await getSubCategory(categoryList.first.id.toString());

      countProductsByCategory();
    } catch (e, stack) {
      developer.log("Error fetching data:", error: e, stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }

  void countProductsByCategory() {
    try {
      categoryProductCount.clear();

      for (var product in allProductList) {
        if (product.categoryModel != null && product.categoryModel!.id != null) {
          String categoryId = product.categoryModel!.id.toString();

          if (categoryProductCount.containsKey(categoryId)) {
            categoryProductCount[categoryId] = categoryProductCount[categoryId]! + 1;
          } else {
            categoryProductCount[categoryId] = 1;
          }
        } else {}
      }
    } catch (e, stack) {
      developer.log("Error counting products by category:", error: e, stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }

  void filterSearchResults() {
    try {
      String query = searchController.value.text.trim().toLowerCase();

      if (query.isEmpty) {
        searchFoodList.assignAll(allProductList);
      } else {
        searchFoodList.assignAll(
          allProductList.where((product) => product.productName != null && product.productName!.toLowerCase().contains(query)).toList(),
        );
      }
    } catch (e, stack) {
      developer.log("Error filtering search results:", error: e, stackTrace: stack);
    }
  }

  Future<void> getSubCategory(String categoryId) async {
    try {
      subCategoryList.clear();

      final value = await FireStoreUtils.getSubCategoryList(categoryId);
      if (value != null) {
        List<SubCategoryModel> filteredSubCategories = value.where((subCategory) {
          return allProductList.any((product) => product.subCategoryId == subCategory.id);
        }).toList();

        isOpen.value = List.generate(filteredSubCategories.length, (index) => true);
        subCategoryList.addAll(filteredSubCategories);
      }
    } catch (e, stack) {
      developer.log("Error fetching subcategories:", error: e, stackTrace: stack);
    } finally {
      isSubCategoryLoading.value = false;
    }
  }

  void filterProductList() {
    try {
      filteredProductList.clear();
      filteredProductList.addAll(productList.where((product) {
        final matchesCategory = selectedCategory.value.id == null || product.categoryId == selectedCategory.value.id;
        final matchesSubCategory = selectedSubCategory.value.id == null || product.subCategoryId == selectedSubCategory.value.id;
        return matchesCategory && matchesSubCategory;
      }).toList());
      filteredProductList.refresh();
    } catch (e, stack) {
      developer.log("Error filtering product list:", error: e, stackTrace: stack);
    }
  }

  Future<void> updateProduct(ProductModel productModel) async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);
      bool isUpdate = await FireStoreUtils.updateProduct(productModel);

      if (isUpdate) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.toast("Product updated successfully.".tr);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.toast("Failed to update the product.".tr);
      }
    } catch (e, stack) {
      developer.log("Error updating product:", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> removeItem(String? itemId) async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);

      await FirebaseFirestore.instance.collection(CollectionName.product).doc(itemId).delete();

      await getData();
      filterProductList();

      ShowToastDialog.closeLoader();
      ShowToastDialog.toast("Item removed successfully.".tr);
    } catch (e, stack) {
      developer.log("Error removing item:", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
    }
  }
}
