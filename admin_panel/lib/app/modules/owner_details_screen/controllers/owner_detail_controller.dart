// import 'dart:developer';
//
// import 'package:admin_panel/app/models/owner_model.dart';
// import 'package:admin_panel/app/models/vendor_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../../constant/constants.dart';
// import '../../../constant/show_toast.dart';
// import '../../../models/wallet_transaction_model.dart';
// import '../../../utils/fire_store_utils.dart';
//
// class OwnerDetailController extends GetxController {
//   RxString title = "Owner Detail".tr.obs;
//   RxBool isLoading = true.obs;
//   Rx<OwnerModel> ownerModel = OwnerModel().obs;
//   RxList<VendorModel> restaurantList = <VendorModel>[].obs;
//   Rx<TextEditingController> topUpAmountController = TextEditingController().obs;
//   RxList<WalletTransactionModel> walletTransactionList = <WalletTransactionModel>[].obs;
//   RxString totalItemPerPage = '0'.obs;
//
//   RxInt totalOrders = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     totalItemPerPage.value = Constant.numOfPageIemList.first;
//     getArgument();
//   }
//
//   getArgument() async {
//     String ownerId = Get.parameters['ownerId']!;
//     await FireStoreUtils.getOwnerByOwnerID(ownerId).then((value) {
//       if (value != null) {
//         ownerModel.value = value;
//       }
//     });
//     getWalletTransaction();
//     isLoading.value = false;
//   }
//
//   getWalletTransaction() async {
//     isLoading.value = true;
//     await FireStoreUtils.getWalletTransactionByUserId(type: "owner", userId: ownerModel.value.vendorId.toString()).then(
//       (value) {
//         walletTransactionList.value = value;
//       },
//     ).catchError((error) {
//       log("Error fetching wallet transactions: $error");
//       ShowToastDialog.errorToast("Failed to fetch wallet transactions".tr);
//     });
//
//     isLoading.value = false;
//   }
//
//   completeTopUp(String transactionId) async {
//     WalletTransactionModel walletTransactionModel = WalletTransactionModel(
//       id: Constant.getUuid(),
//       amount: topUpAmountController.value.text,
//       createdDate: Timestamp.now(),
//       userId: ownerModel.value.vendorId,
//       transactionId: transactionId,
//       paymentType: "admin",
//       note: "Wallet Top up by admin",
//       type: "owner",
//       isCredit: true,
//     );
//     await FireStoreUtils.addWalletTransaction(walletTransactionModel).then((value) {
//       if (value == true) {
//         FireStoreUtils.updateOwnerWallet(amount: topUpAmountController.value.text, userId: ownerModel.value.vendorId.toString()).then((value) async {
//           if (value == true) {
//             Get.back();
//             ShowToastDialog.successToast("Top Up Successful".tr);
//             ownerModel.value = (await FireStoreUtils.getOwnerByOwnerID(ownerModel.value.vendorId.toString()))!;
//             getWalletTransaction();
//             topUpAmountController.value.clear();
//           } else {
//             log("Failed to update wallet");
//           }
//         });
//       }
//     }).catchError((error) {
//       ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
//     });
//   }
// }


// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'package:admin_panel/app/models/owner_model.dart';
import 'package:admin_panel/app/models/vendor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constant/constants.dart';
import '../../../constant/show_toast.dart';
import '../../../models/wallet_transaction_model.dart';
import '../../../utils/fire_store_utils.dart';

class OwnerDetailController extends GetxController {
  RxString title = "Owner Details".tr.obs;
  RxString transactionTitle = "Wallet Transaction".tr.obs;
  RxBool isLoading = true.obs;
  Rx<OwnerModel> ownerModel = OwnerModel().obs;
  RxList<VendorModel> restaurantList = <VendorModel>[].obs;
  Rx<TextEditingController> topUpAmountController = TextEditingController().obs;
  RxList<WalletTransactionModel> walletTransactionList = <WalletTransactionModel>[].obs;
  RxString totalItemPerPage = '0'.obs;
  RxInt totalOrders = 0.obs;


  @override
  void onInit() {
    super.onInit();
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getArgument();
  }

  Future<void> getArgument() async {
    String ownerId = Get.parameters['ownerId']!;
    await FireStoreUtils.getOwnerByOwnerId(ownerId).then((value) {
      if (value != null) {
        ownerModel.value = value;
      }
    });

    await getRestaurantsForOwner();
    await getWalletTransaction();

    isLoading.value = false;
  }

  Future<void> getRestaurantsForOwner() async {
    isLoading.value = true;
    try {
      restaurantList.value = await FireStoreUtils.getVendorListByOwnerId(ownerModel.value.id ?? "");
    } catch (e) {
      log("Error fetching restaurants for owner: $e");
      ShowToastDialog.errorToast("Failed to fetch restaurants");
    }
    isLoading.value = false;
  }

  Future<void> getWalletTransaction() async {
    isLoading.value = true;
    await FireStoreUtils.getWalletTransactionByUserId(
      type: "owner",
      userId: ownerModel.value.id.toString(),
    ).then((value) {
      walletTransactionList.value = value;
    }).catchError((error) {
      log("Error fetching wallet transactions: $error");
      ShowToastDialog.errorToast("Failed to fetch wallet transactions".tr);
    });
    isLoading.value = false;
  }

  Future<void> completeTopUp(String transactionId) async {
    Constant.loader();
    WalletTransactionModel walletTransactionModel = WalletTransactionModel(
      id: Constant.getUuid(),
      amount: topUpAmountController.value.text,
      createdDate: Timestamp.now(),
      userId: ownerModel.value.id,
      transactionId: transactionId,
      paymentType: "admin",
      note: "Wallet Top up by admin",
      type: "owner",
      isCredit: true,
    );
    await FireStoreUtils.addWalletTransaction(walletTransactionModel).then((value) {
      if (value == true) {
        FireStoreUtils.updateOwnerWallet(
          amount: topUpAmountController.value.text,
          userId: ownerModel.value.id.toString(),
        ).then((value) async {
          if (value == true) {
            Get.back();
            ShowToastDialog.successToast("Top Up Successful".tr);
            ownerModel.value = (await FireStoreUtils.getOwnerByOwnerId(ownerModel.value.id.toString()))!;
            getWalletTransaction();
            topUpAmountController.value.clear();
          } else {
            log("Failed to update wallet");
          }
        });
      }
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
  }
}
