// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/addons_model.dart';
import 'package:admin_panel/app/models/category_model.dart';
import 'package:admin_panel/app/models/product_model.dart';
import 'package:admin_panel/app/models/vendor_model.dart';
import 'package:admin_panel/app/models/sub_category_model.dart';
import 'package:admin_panel/app/models/variation_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class FoodsController extends GetxController {
  RxString title = "Foods".tr.obs;
  RxBool isLoading = true.obs;
  RxBool isEditing = false.obs;

  RxInt selectedGender = 1.obs;
  RxBool isSearchEnable = true.obs;

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<ProductModel> currentPageUser = <ProductModel>[].obs;
  Rx<TextEditingController> dateFiledController = TextEditingController().obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<TextEditingController> itemNameController = TextEditingController().obs;
  Rx<TextEditingController> itemDescriptionController = TextEditingController().obs;
  Rx<TextEditingController> itemPriceController = TextEditingController().obs;
  Rx<TextEditingController> maxQtyController = TextEditingController().obs;
  Rx<TextEditingController> discountController = TextEditingController().obs;
  Rx<TextEditingController> addonsNameController = TextEditingController().obs;
  Rx<TextEditingController> variationsOptionNameController = TextEditingController().obs;
  Rx<TextEditingController> addonsPriceController = TextEditingController().obs;
  Rx<TextEditingController> variationsPriceController = TextEditingController().obs;
  List<String> discountType = ["Fixed", "Percentage"];
  RxString selectedDiscountType = "".obs;
  List<String> itemType = ["Veg", "Non veg", "Both"];
  RxString selectedItemType = "Veg".obs;
  RxList<VendorModel> restaurantList = <VendorModel>[].obs;
  Rx<VendorModel> selectedRestaurantId = VendorModel().obs;
  Rx<CategoryModel> selectedCategory = CategoryModel().obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  Rx<SubCategoryModel> selectedSubCategory = SubCategoryModel().obs;
  RxList<SubCategoryModel> subCategoryList = <SubCategoryModel>[].obs;
  RxList<AddonsModel> addonsList = <AddonsModel>[].obs;

  RxList<VariationModel> variationList = <VariationModel>[].obs;

  Rx<TextEditingController> variationNameController = TextEditingController().obs;
  Rx<TextEditingController> optionNameController = TextEditingController().obs;
  Rx<TextEditingController> optionPriceController = TextEditingController().obs;

  RxBool itemInStock = true.obs;
  RxBool variationInStockDemo = true.obs;
  RxBool addonsInStock = true.obs;
  var independentSwitchState = true.obs;
  RxBool addonsVariationsInStock = true.obs;
  RxBool variationInStock = true.obs;
  RxBool isActive = true.obs;
  RxList<String> tagsList = <String>[].obs;
  RxString selectedTags = "".obs;
  RxString editingId = ''.obs;
  Rx<ProductModel> productModel = ProductModel().obs;
  Rx<File> imageFile = File('').obs;
  RxString imageURL = "".obs;
  Rx<TextEditingController> imageController = TextEditingController().obs;
  RxString mimeType = 'image/png'.obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getUser();
    super.onInit();
  }

  Future<void> removeProduct(ProductModel productModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.product).doc(productModel.id).delete().then((value) {
      ShowToastDialog.successToast("Product deleted.".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }

  void toggleIndependentSwitch(bool value) {
    independentSwitchState.value = value;
  }

  void addVariation(String name, bool inStock) {
    variationList.add(
      VariationModel(name: name, inStock: inStock, optionList: []),
    );
    variationNameController.value.clear();
  }

  void addOptionToVariation(int variationIndex, String optionName, String optionPrice) {
    String validatedOptionName = optionName.isEmpty ? "N/A" : optionName;
    String validatedOptionPrice = optionPrice.isEmpty ? "N/A" : optionPrice;

    OptionModel option = OptionModel(name: validatedOptionName, price: validatedOptionPrice);
    variationList[variationIndex].optionList?.add(option);
    variationList.refresh();

    optionNameController.value.clear();
    optionPriceController.value.clear();
  }

  void removeOptionToVariation(int variationIndex) {
    variationList.removeAt(variationIndex);
    variationList.refresh();
  }

  void removeOptionFromVariation(int variationIndex, int optionIndex) {
    variationList[variationIndex].optionList?.removeAt(optionIndex);
    variationList.refresh();
  }

  Future<void> getUser() async {
    isLoading.value = true;
    await FireStoreUtils.countProducts();
    setPagination(totalItemPerPage.value);

    await FireStoreUtils.getCategory().then(
      (value) {
        categoryList.value = value;
            },
    );
    await FireStoreUtils.getItemTags().then(
      (value) {
        tagsList.value = value;
            },
    );

    await FireStoreUtils.getAllRestaurant().then((value) {
      restaurantList.value = value;
    });
    isLoading.value = false;
  }

  void removeVariation(int index) {
    variationList.removeAt(index);
    variationList.refresh();
  }

  Rx<DateTimeRange> selectedDate = DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0),
          end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0))
      .obs;

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.productLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.productLength! ? Constant.productLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<ProductModel> currentPageUserData = await FireStoreUtils.getAllProduct(currentPage.value, itemPerPage, searchController.value.text);
        currentPageUser.value = currentPageUserData;
      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
  }

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return Constant.productLength!;
    } else {
      return int.parse(data);
    }
  }

  Future<void> getSubCategory(String categoryId) async {
    await FireStoreUtils.getSubCategoryList(categoryId).then(
      (value) {
        if (value != null) {
          subCategoryList.value = value;
        }
      },
    );
    update();
  }

  Future<void> saveItem() async {
    String docId = Constant.getUuid();

    Constant.waitingLoader();

    if (productModel.value.id == null || productModel.value.vendorId == null) {
      productModel.value.id = docId;
      productModel.value.vendorId = selectedRestaurantId.value.id;
    }

    productModel.value.productName = itemNameController.value.text;
    productModel.value.categoryId = selectedCategory.value.id;
    productModel.value.categoryModel = selectedCategory.value;
    productModel.value.subCategoryId = selectedSubCategory.value.id;
    productModel.value.subCategoryModel = selectedSubCategory.value;
    productModel.value.variationList = variationList;

    if (imageURL.isEmpty || imageURL.value == '') {
      imageURL.value = await FireStoreUtils.uploadPic(PickedFile(imageFile.value.path), "restaurantImages/${selectedRestaurantId.value.id}", docId, mimeType.value);
      productModel.value.productImage = imageURL.value;
    } else {
      productModel.value.productImage = imageURL.value;
    }

    productModel.value.foodType = selectedItemType.value;
    productModel.value.discountType = selectedDiscountType.value;
    productModel.value.discount = discountController.value.text;
    productModel.value.price = itemPriceController.value.text;
    productModel.value.maxQuantity = maxQtyController.value.text;
    productModel.value.status = true;
    productModel.value.inStock = itemInStock.value;
    productModel.value.description = itemDescriptionController.value.text;
    productModel.value.createAt = Timestamp.now();
    productModel.value.addonsList = addonsList;
    productModel.value.itemTag = selectedTags.toString();

    await FireStoreUtils.addProduct(productModel.value);

    Get.back();
    setDefaultData();
    isLoading = false.obs;
    getUser();
  }

  Future<void> getArguments(ProductModel productsModel) async {
    productModel.value = productsModel;
    isEditing.value = true;
    editingId.value = productModel.value.id!;
    int restaurantIndex = restaurantList.indexWhere((element) => element.id == productModel.value.vendorId);
    if (restaurantIndex != -1) {
      selectedRestaurantId.value = restaurantList[restaurantIndex];
    }
    imageFile.value = File('');
    imageURL.value = productModel.value.productImage!;
    imageController.value.text = productModel.value.productImage!;
    itemNameController.value.text = productModel.value.productName!;
    itemDescriptionController.value.text = productModel.value.description!;
    itemPriceController.value.text = productModel.value.price!;
    maxQtyController.value.text = productModel.value.maxQuantity!;
    discountController.value.text = productModel.value.discount!;
    selectedDiscountType.value = productModel.value.discountType!;
    variationList.value = productModel.value.variationList!;
    int index = categoryList.indexWhere((element) => element.id == productModel.value.categoryId);
    if (index != -1) {
      selectedCategory.value = categoryList[index];
      await getSubCategory(selectedCategory.value.id.toString());
    }
    int index1 = subCategoryList.indexWhere((element) => element.id == productModel.value.subCategoryId);
    if (index1 != -1) {
      selectedSubCategory.value = subCategoryList[index1];
    }
    selectedItemType.value = productModel.value.foodType!;
    itemInStock.value = productModel.value.inStock!;
    isActive.value = productModel.value.status!;
    selectedTags.value = productModel.value.itemTag!;
    addonsList.value = productModel.value.addonsList!;
  }

  Future<void> updateProduct() async {
    String docId = productModel.value.id!;
    if (imageFile.value.path.isNotEmpty) {
      String url = await FireStoreUtils.uploadPic(PickedFile(imageFile.value.path), "restaurantImages", docId, mimeType.value);
      productModel.value.productImage = url;
    } else {
      productModel.value.productImage = imageURL.toString();
    }

    productModel.value.vendorId = selectedRestaurantId.value.id;
    productModel.value.productName = itemNameController.value.text;
    productModel.value.categoryId = selectedCategory.value.id;
    productModel.value.categoryModel = selectedCategory.value;
    productModel.value.subCategoryId = selectedSubCategory.value.id;
    productModel.value.subCategoryModel = selectedSubCategory.value;
    productModel.value.variationList = variationList;
    productModel.value.foodType = selectedItemType.value;
    productModel.value.discountType = selectedDiscountType.value;
    productModel.value.discount = discountController.value.text;
    productModel.value.price = itemPriceController.value.text;
    productModel.value.maxQuantity = maxQtyController.value.text;
    productModel.value.status = true;
    productModel.value.inStock = itemInStock.value;
    productModel.value.description = itemDescriptionController.value.text;
    productModel.value.addonsList = addonsList;
    productModel.value.itemTag = selectedTags.toString();

    await FireStoreUtils.updateProduct(productModel.value);
    await FireStoreUtils.countProducts();
    setPagination(totalItemPerPage.value);
    Get.back();
    isLoading.value = false;
  }

  void setDefaultData() {
    imageURL.value = "";
    itemNameController.value.text = "";
    itemPriceController.value.text = "";
    itemDescriptionController.value.text = "";
    discountController.value.text = "";
    maxQtyController.value.text = "";
    selectedRestaurantId.value = VendorModel();
    selectedTags.value = "";
    selectedItemType.value = "Veg";
    variationList.clear();
    variationNameController.value.clear();
    optionNameController.value.clear();
    optionPriceController.value.clear();
    selectedCategory.value = CategoryModel();
    selectedSubCategory.value = SubCategoryModel();
    selectedDiscountType.value = "";
    imageFile.value = File('');
    mimeType.value = 'image/png';
    addonsList.value = [];
    itemInStock.value = true;
    isActive.value = true;
    isEditing.value = false;
  }
}
