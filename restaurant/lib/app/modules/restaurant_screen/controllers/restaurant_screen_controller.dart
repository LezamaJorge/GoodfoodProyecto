// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/coupon_model.dart';
import 'package:restaurant/app/models/owner_model.dart';
import 'package:restaurant/app/models/vendor_model.dart';
import 'package:restaurant/constant/collection_name.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

class RestaurantScreenController extends GetxController {
  Rx<VendorModel> restaurantModel = VendorModel().obs;
  Rx<OwnerModel> ownerModel = OwnerModel().obs;
  RxList<CouponModel> restaurantOfferList = <CouponModel>[].obs;

  Rx<TextEditingController> couponTitleController = TextEditingController().obs;
  Rx<TextEditingController> couponCodeController = TextEditingController().obs;
  Rx<TextEditingController> expireDateController = TextEditingController().obs;
  Rx<TextEditingController> couponMinAmountController = TextEditingController().obs;
  Rx<TextEditingController> couponDiscountAmountController = TextEditingController().obs;

  RxBool isActive = false.obs;

  RxString selectedAdminCommissionType = "Fix".obs;
  List<String> adminCommissionType = ["Fix", "Percentage"];
  RxString couponPrivateType = "Public".obs;
  List<String> couponType = ["Private", "Public"];
  DateTime selectedDate = DateTime.now();
  Rx<String> editingId = "".obs;
  RxBool isEditing = false.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    try {
      ownerModel.value = Constant.ownerModel!;
      if (ownerModel.value.vendorId != null && ownerModel.value.vendorId!.isNotEmpty) {
        restaurantModel.value = Constant.vendorModel!;
        restaurantOfferList.clear();
        List<CouponModel> data = await FireStoreUtils.getRestaurantOffer(restaurantModel.value.id.toString());
        restaurantOfferList.addAll(data);
      }
      update();
      isLoading.value = false;
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log("Error fetching restaurant data: $e", error: e, stackTrace: stack);
      }
    }
  }


  Future<void> selectDate(BuildContext context) async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050),
      );
      if (picked != null && picked != selectedDate) {
        selectedDate = picked;
        expireDateController.value.text = selectedDate.toString();
        expireDateController.refresh();
      }
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log("Error selecting date: $e", error: e, stackTrace: stack);
      }
    }
  }

  Future<void> addCoupon() async {
    ShowToastDialog.showLoader('Please Wait..'.tr);
    try {
      await FireStoreUtils.addRestaurantOffer(CouponModel(
        id: Constant.getRandomString(20),
        active: isActive.value,
        minAmount: couponMinAmountController.value.text,
        title: couponTitleController.value.text,
        code: couponCodeController.value.text,
        isVendorOffer: true,
        vendorId: Constant.vendorModel!.id,
        amount: couponDiscountAmountController.value.text,
        isFix: selectedAdminCommissionType.value == "Fix",
        isPrivate: couponPrivateType.value != "Public",
        expireAt: Timestamp.fromDate(selectedDate),
      ));

      restaurantOfferList.clear();
      List<CouponModel> data = await FireStoreUtils.getRestaurantOffer(restaurantModel.value.id.toString());
      restaurantOfferList.addAll(data);

      ShowToastDialog.toast('Add Offer Successful'.tr);
      Get.back();
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log("Error adding offer: $e", error: e, stackTrace: stack);
      }
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  void setDefaultData() {
    try {
      couponTitleController.value.text = '';
      couponCodeController.value.text = '';
      couponMinAmountController.value.text = '';
      couponDiscountAmountController.value.text = '';
      expireDateController.value.text = '';
      isActive.value = false;
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log("Error setting default data: $e", error: e, stackTrace: stack);
      }
    }
  }

  Future<void> updateOfferCoupon(CouponModel couponModel) async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    try {
      bool isUpdate = await FireStoreUtils.updateRestaurantOffer(couponModel);
      if (isUpdate) {
        ShowToastDialog.toast("Offer updated successfully.".tr);
      } else {
        ShowToastDialog.toast("Failed to update offer.".tr);
      }
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log("Error updating offer: $e", error: e, stackTrace: stack);
      }
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> updateCoupon() async {
    try {
      await FireStoreUtils.updateRestaurantOffer(CouponModel(
        id: editingId.value,
        active: isActive.value,
        minAmount: couponMinAmountController.value.text,
        title: couponTitleController.value.text,
        code: couponCodeController.value.text,
        isVendorOffer: true,
        vendorId: Constant.vendorModel!.id,
        amount: couponDiscountAmountController.value.text,
        isFix: selectedAdminCommissionType.value == "Fix" ? true : false,
        isPrivate: couponPrivateType.value == "Public" ? false : true,
        expireAt: Timestamp.fromDate(selectedDate),
      ));

      restaurantOfferList.clear();
      List<CouponModel> data = await FireStoreUtils.getRestaurantOffer(restaurantModel.value.id.toString());
      restaurantOfferList.addAll(data);

      ShowToastDialog.toast('Update Offer Successful'.tr);
      Get.back();
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log("Error updating offer: $e", error: e, stackTrace: stack);
      }
    }
  }

  Future<void> removeOffer(CouponModel couponModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.coupon).doc(couponModel.id).delete();
      ShowToastDialog.toast("Restaurant Offer Deleted".tr);
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log("Error deleting offer: $e", error: e, stackTrace: stack);
      }
    }
  }
}
