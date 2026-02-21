
// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/coupon_model.dart';
import 'package:admin_panel/app/models/vendor_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

  class RestaurantOfferController extends GetxController {
    GlobalKey<ScaffoldState> scaffoldKeyDrawer = GlobalKey<ScaffoldState>();

    final count = 0.obs;
    RxString title = "Restaurant Offer".tr.obs;
    RxList<CouponModel> restaurantOfferList = <CouponModel>[].obs;
    Rx<TextEditingController> couponTitleController = TextEditingController().obs;
    Rx<TextEditingController> couponCodeController = TextEditingController().obs;
    Rx<TextEditingController> couponAmountController = TextEditingController().obs;
    Rx<TextEditingController> couponMinAmountController = TextEditingController().obs;
    Rx<TextEditingController> expireDateController = TextEditingController().obs;
    RxList<VendorModel> restaurantList = <VendorModel>[].obs;
    Rx<VendorModel> selectedRestaurantId = VendorModel().obs;


    DateTime selectedDate = DateTime.now();
    RxBool isEditing = false.obs;
    RxBool isLoading = false.obs;
    RxBool isActive = false.obs;
    Rx<String> editingId = "".obs;

    RxString selectedAdminCommissionType = "Fix".obs;
    List<String> adminCommissionType = ["Fix", "Percentage"];
    RxString couponPrivateType = "Public".obs;
    List<String> couponType = ["Private", "Public"];


    @override
    void onInit() {
      super.onInit();
      getData();
    }

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2050));
      if (picked != null && picked != selectedDate) {
        selectedDate = picked;
        expireDateController.value.text = selectedDate.toString();
      }
    }

    Future<void> getData() async {
      try {
        isLoading.value = true;
        restaurantOfferList.clear();
        List<CouponModel> data = await FireStoreUtils.getRestaurantOffer();
        restaurantOfferList.addAll(data);
        await FireStoreUtils.getAllRestaurant().then((value) {
          restaurantList.value = value;
        });
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> addCoupon() async {
      isLoading = true.obs;
      await FireStoreUtils.addRestaurantOffer(CouponModel(
        id: Constant.getRandomString(20),
        active: isActive.value,
        minAmount: couponMinAmountController.value.text,
        title: couponTitleController.value.text,
        code: couponCodeController.value.text,
        isVendorOffer: true,
        vendorId: selectedRestaurantId.value.id,
        amount: couponAmountController.value.text,
        isFix: selectedAdminCommissionType.value == "Fix" ? true : false,
        isPrivate: couponPrivateType.value == "Public" ? false : true,
        expireAt: Timestamp.fromDate(selectedDate),
      ));
      await getData();
      isLoading = false.obs;
    }

    Future<void> updateCoupon() async {
      isEditing = true.obs;
      await FireStoreUtils.updateRestaurantOffer(CouponModel(
        id: editingId.value,
        active: isActive.value,
        isVendorOffer: true,
        minAmount: couponMinAmountController.value.text,
        title: couponTitleController.value.text,
        code: couponCodeController.value.text,
        vendorId: selectedRestaurantId.value.id,
        amount: couponAmountController.value.text,
        isFix: selectedAdminCommissionType.value == "Fix" ? true : false,
        isPrivate: couponPrivateType.value == "Public" ? false : true,
        expireAt: Timestamp.fromDate(selectedDate),
      ));
      await getData();
      isEditing = false.obs;
    }

    Future<void> removeCoupon(CouponModel couponModel) async {
      isLoading = true.obs;
      await FirebaseFirestore.instance.collection(CollectionName.coupon).doc(couponModel.id).delete().then((value) {
        ShowToastDialog.successToast("Restaurant Offer deleted...!".tr);
      }).catchError((error) {
        ShowToastDialog.errorToast("Restaurant Offer went wrong".tr);
      });
      await getData();
      isLoading = false.obs;
    }

    void setDefaultData() {
      couponTitleController.value.text = '';
      couponCodeController.value.text = '';
      couponMinAmountController.value.text = '';
      couponAmountController.value.text = '';
      expireDateController.value.text = '';
      isActive.value = false;
      isEditing.value = false;
    }
}
