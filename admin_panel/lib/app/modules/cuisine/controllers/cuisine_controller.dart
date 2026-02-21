
import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/cuisine_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CuisineController extends GetxController {
  RxString title = "Cuisine".tr.obs;
  RxBool isLoading = true.obs;
  RxBool isEditing = false.obs;
  RxBool isActive = false.obs;

  RxList<CuisineModel> cuisineList = <CuisineModel>[].obs;
  Rx<CuisineModel> cuisineModel = CuisineModel().obs;

  Rx<TextEditingController> cuisineNameController = TextEditingController().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    cuisineList.clear();
    List<CuisineModel>? data = await FireStoreUtils.getAllCuisine();
    cuisineList.addAll(data);
    isLoading.value = false;
  }

  void setDefaultData() {
    cuisineNameController.value.text = "";
    isActive.value = false;
    isEditing.value = false;
  }

  Future<void> addCuisine() async {
    isLoading.value = true;
    cuisineModel.value.id = Constant.getRandomString(20);
    cuisineModel.value.cuisineName = cuisineNameController.value.text;
    cuisineModel.value.active = isActive.value;
    await FireStoreUtils.addCuisine(cuisineModel.value);
    await getData();
    isLoading.value = false;
  }

  Future<void> updateCuisine() async {
    isLoading.value = true;
    cuisineModel.value.cuisineName = cuisineNameController.value.text;
    cuisineModel.value.active = isActive.value;
    await FireStoreUtils.updateCuisine(cuisineModel.value);
    await getData();
    isLoading.value = false;
  }

  Future<void> removeCuisine(CuisineModel cuisineModel) async {
    isLoading.value = true;
    await FireStoreUtils.fireStore.collection(CollectionName.cuisine).doc(cuisineModel.id).delete().then((value) {
      ShowToastDialog.successToast("Cuisine removed.".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
  }
}
