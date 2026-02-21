// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'dart:developer' as developer;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant/app/models/addons_model.dart';
import 'package:restaurant/app/models/category_model.dart';
import 'package:restaurant/app/models/product_model.dart';
import 'package:restaurant/app/models/sub_category_model.dart';
import 'package:restaurant/app/models/variation_model.dart';
import 'package:restaurant/app/modules/menu_screen/controllers/menu_screen_controller.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

class AddMenuItemsScreenController extends GetxController {
  RxString isSelected = "".obs;
  Rx<TextEditingController> itemNameController = TextEditingController().obs;
  Rx<TextEditingController> itemDescriptionController = TextEditingController().obs;
  Rx<TextEditingController> priceController = TextEditingController().obs;
  Rx<TextEditingController> addonsNameController = TextEditingController().obs;
  Rx<TextEditingController> addonsPriceController = TextEditingController().obs;
  Rx<TextEditingController> discountController = TextEditingController().obs;
  Rx<TextEditingController> maxQuantityController = TextEditingController().obs;
  Rx<TextEditingController> variationNameController = TextEditingController().obs;
  RxList<TextEditingController> optionNameController = <TextEditingController>[].obs;
  RxList<TextEditingController> optionPriceController = <TextEditingController>[].obs;
  RxBool itemInStock = true.obs;
  RxBool addonsInStock = true.obs;
  RxBool variationInStock = true.obs;
  Rx<FoodType> foodType = FoodType.veg.obs;
  final ImagePicker imagePicker = ImagePicker();
  Rx<String> itemImage = "".obs;
  Rx<CategoryModel> selectedCategory = CategoryModel().obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  Rx<SubCategoryModel> selectedSubCategory = SubCategoryModel().obs;
  RxList<SubCategoryModel> subCategoryList = <SubCategoryModel>[].obs;
  RxList<AddonsModel> addonsList = <AddonsModel>[].obs;
  RxList<VariationModel> variationList = <VariationModel>[].obs;
  RxList<String> tagsList = <String>[].obs;
  RxString selectedTags = "".obs;
  List<String> discountType = ["Fixed", "Percentage"];
  RxString selectedDiscountType = "".obs;
  RxList<String> pageList = <String>["Add Menu Item", "Add Price Details", "Add Addons Details", "Add Variations Details", "Select Tags"].obs;
  var currentStep = 0.obs;
  RxString productModelId = "".obs;
  Rx<ProductModel> productModel = ProductModel().obs;
  Rx<bool> isLoading = false.obs;

  @override
  Future<void> onInit() async {
    await getData();
    addOptionController();
    super.onInit();
  }

  RxList<OptionModel> setOptionListFromController() {
    RxList<OptionModel> optionList = <OptionModel>[].obs;
    try {
      for (int i = 0; i < optionNameController.length; i++) {
        optionList.add(
          OptionModel(
            name: optionNameController[i].value.text,
            price: optionPriceController[i].value.text,
          ),
        );
      }
    } catch (e, stack) {
      developer.log("Error setting option list from controller:", error: e, stackTrace: stack);
    }
    return optionList;
  }

  void setOptionControllersFromList(List<OptionModel> optionList) {
    try {
      optionNameController.value = [];
      optionPriceController.value = [];

      for (var option in optionList) {
        optionNameController.add(TextEditingController(text: option.name.toString()));
        optionPriceController.add(TextEditingController(text: option.price.toString()));
      }
    } catch (e, stack) {
      developer.log("Error setting option controllers from list:", error: e, stackTrace: stack);
    }
    update();
  }

  void addOptionController() {
    try {
      optionNameController.add(TextEditingController());
      optionPriceController.add(TextEditingController());
    } catch (e, stack) {
      developer.log("Error adding option controller:", error: e, stackTrace: stack);
    }
    update();
  }

  void removeOptionController() {
    try {
      if (optionNameController.isNotEmpty && optionPriceController.isNotEmpty) {
        optionNameController.removeAt(optionNameController.length - 1);
        optionPriceController.removeAt(optionPriceController.length - 1);
      }
    } catch (e, stack) {
      developer.log("Error removing option controller:", error: e, stackTrace: stack);
    }
    update();
  }

  bool areAllDetailsFilledOfAddMenuItem() {
    try {
      return itemImage.value.isNotEmpty &&
          itemNameController.value.text.isNotEmpty &&
          itemDescriptionController.value.text.isNotEmpty &&
          selectedCategory.value.id != null &&
          selectedSubCategory.value.id != null;
    } catch (e, stack) {
      developer.log("Error All Details Filled:", error: e, stackTrace: stack);
      return false;
    }
  }

  bool areAllDetailsFilledOfPriceDetails() {
    try {
      return selectedDiscountType.value.isNotEmpty &&
          priceController.value.text.isNotEmpty &&
          discountController.value.text.isNotEmpty &&
          maxQuantityController.value.text.isNotEmpty;
    } catch (e, stack) {
      developer.log("Error All Details Filled:", error: e, stackTrace: stack);
      return false;
    }
  }

  bool areAllDetailsFilledOfAddonsDetails() {
    try {
      return addonsNameController.value.text.isNotEmpty && addonsPriceController.value.text.isNotEmpty;
    } catch (e, stack) {
      developer.log("Error All Details Filled:", error: e, stackTrace: stack);
      return false;
    }
  }

  Future<void> getData() async {
    try {
      isLoading.value = true;

      try {
        final categories = await FireStoreUtils.getCategoryList();
        if (categories != null) {
          categoryList.value = categories;
        }
      } catch (e, stack) {
        developer.log("Error fetching category list:", error: e, stackTrace: stack);
      }

      try {
        final tags = await FireStoreUtils.getTagsList();
        if (tags != null) {
          tagsList.value = tags;
        }
      } catch (e, stack) {
        developer.log("Error fetching tags list:", error: e, stackTrace: stack);
      }

      getArgument();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getArgument() async {
    try {
      dynamic argumentData = Get.arguments;
      if (argumentData != null) {
        productModelId.value = argumentData['productModelId'];

        try {
          final value = await FireStoreUtils.getProduct(productModelId.toString());
          if (value != null) {
            productModel.value = value;
            itemNameController.value.text = value.productName ?? '';
            itemDescriptionController.value.text = value.description ?? '';
            priceController.value.text = value.price ?? '';
            discountController.value.text = value.discount ?? '';
            maxQuantityController.value.text = value.maxQuantity ?? '';
            itemInStock.value = value.inStock ?? false;
            foodType.value = value.foodType == "Veg" ? FoodType.veg : FoodType.nonVeg;
            itemImage.value = value.productImage ?? '';

            int index = categoryList.indexWhere((element) => element.id == value.categoryId);
            if (index != -1) {
              selectedCategory.value = categoryList[index];
              await getSubCategory(selectedCategory.value.id.toString());
            }

            int index1 = subCategoryList.indexWhere((element) => element.id == value.subCategoryId);
            if (index1 != -1) {
              selectedSubCategory.value = subCategoryList[index1];
            }

            selectedDiscountType.value = value.discountType ?? '';
            addonsList.value = value.addonsList ?? [];
            variationList.value = value.variationList ?? [];
            selectedTags.value = value.itemTag ?? '';
          }
        } catch (e, stack) {
          developer.log("Error fetching product data:", error: e, stackTrace: stack);
        }
      }
    } finally {
      update();
    }
  }

  Future<void> getSubCategory(String categoryId) async {
    try {
      final value = await FireStoreUtils.getSubCategoryList(categoryId);
      if (value != null) {
        subCategoryList.value = value;
      }
    } finally {
      update();
    }
  }

  void nextStep() {
    try {
      if (currentStep.value < pageList.length - 1) {
        currentStep.value++;
      }
    } catch (e, stack) {
      developer.log("Error in nextStep:", error: e, stackTrace: stack);
    }
  }

  void previousStep() {
    try {
      if (currentStep.value > 0) {
        currentStep.value--;
      }
    } catch (e, stack) {
      developer.log("Error in previousStep:", error: e, stackTrace: stack);
    }
  }

  Future<String?> pickFile() async {
    try {
      XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 60,
      );

      if (image == null) return null;

      final allowedExtensions = ['jpg', 'jpeg', 'png'];
      final extension = image.name.split('.').last.toLowerCase();

      if (!allowedExtensions.contains(extension)) {
        ShowToastDialog.toast("Only JPG, JPEG, and PNG images are allowed".tr);
        return null;
      }

      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 50,
      );

      if (compressedBytes == null) {
        ShowToastDialog.toast("Image compression failed".tr);
        return null;
      }

      File compressedFile = File(image.path);
      await compressedFile.writeAsBytes(compressedBytes);
      return compressedFile.path;
    } on PlatformException catch (e, stack) {
      developer.log("Error picking image:", error: e, stackTrace: stack);
    } catch (e, stack) {
      developer.log("Error picking image:", error: e, stackTrace: stack);
    }
    return null;
  }

  Future<void> saveData() async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    try {
      if (productModel.value.id == null || productModel.value.vendorId == null) {
        productModel.value.id = Constant.getUuid();
        productModel.value.vendorId = Constant.vendorModel!.id;
      }

      productModel.value.productName = itemNameController.value.text;
      productModel.value.categoryId = selectedCategory.value.id;
      productModel.value.categoryModel = selectedCategory.value;
      productModel.value.subCategoryId = selectedSubCategory.value.id;
      productModel.value.subCategoryModel = selectedSubCategory.value;

      if (!Constant.hasValidUrl(itemImage.value)) {
        productModel.value.productImage = await Constant.uploadRestaurantImage(
          itemImage.value,
          productModel.value.id!,
        );
      }

      productModel.value.foodType = Constant.vendorModel!.vendorType == "Veg"
          ? "Veg"
          : Constant.vendorModel!.vendorType == "Non veg"
              ? "Non veg"
              : foodType.value == FoodType.veg
                  ? "Veg"
                  : "Non veg";

      productModel.value.discountType = selectedDiscountType.value;
      productModel.value.discount = discountController.value.text;
      productModel.value.price = priceController.value.text;
      productModel.value.maxQuantity = maxQuantityController.value.text;
      productModel.value.status = true;
      productModel.value.inStock = itemInStock.value;
      productModel.value.description = itemDescriptionController.value.text;
      productModel.value.createAt = Timestamp.now();
      productModel.value.addonsList = addonsList;
      productModel.value.variationList = variationList;
      productModel.value.itemTag = selectedTags.toString();

      bool isUpdate = await FireStoreUtils.updateProduct(productModel.value);
      if (isUpdate) {
        MenuScreenController menuScreenController = Get.put(MenuScreenController());
        await menuScreenController.getData();
        Get.back();
      }
    } catch (e, stack) {
      developer.log("Error Saving Date:", error: e, stackTrace: stack);
    } finally {
      ShowToastDialog.closeLoader();
    }
  }
}

enum FoodType { veg, nonVeg }
