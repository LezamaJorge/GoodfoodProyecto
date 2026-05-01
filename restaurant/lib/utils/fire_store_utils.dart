// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:developer';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/app/models/bank_detail_model.dart';
import 'package:restaurant/app/models/category_model.dart';
import 'package:restaurant/app/models/coupon_model.dart';
import 'package:restaurant/app/models/cuisine_model.dart';
import 'package:restaurant/app/models/document_model.dart';
import 'package:restaurant/app/models/driver_user_model.dart';
import 'package:restaurant/app/models/language_model.dart';
import 'package:restaurant/app/models/notification_model.dart';
import 'package:restaurant/app/models/onboarding_model.dart';
import 'package:restaurant/app/models/order_model.dart';
import 'package:restaurant/app/models/owner_model.dart';
import 'package:restaurant/app/models/payment_method_model.dart';
import 'package:restaurant/app/models/product_model.dart';
import 'package:restaurant/app/models/vendor_model.dart';
import 'package:restaurant/app/models/sub_category_model.dart';
import 'package:restaurant/app/models/transaction_log_model.dart';
import 'package:restaurant/app/models/user_model.dart';
import 'package:restaurant/app/models/wallet_transaction_model.dart';
import 'package:restaurant/app/models/withdraw_model.dart';
import 'package:restaurant/constant/constant.dart';

import '../app/models/admin_commission.dart';
import '../app/models/currency_model.dart';
import '../constant/collection_name.dart';

class FireStoreUtils {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static String? getCurrentUid() {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        return FirebaseAuth.instance.currentUser!.uid;
      }
    } catch (e, stack) {
      developer.log('Error getting current user ID: $e', error: e, stackTrace: stack);
    }
    return null;
  }

  static Future<bool> userExistOrNot(String uid) async {
    try {
      final doc = await fireStore.collection(CollectionName.owner).doc(uid).get();
      return doc.exists;
    } catch (e, stack) {
      developer.log('Error checking user existence: $e', error: e, stackTrace: stack);
      return false;
    }
  }

  static Future<bool> isLogin() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        return await userExistOrNot(currentUser.uid);
      }
    } catch (e, stack) {
      developer.log('Error checking login status: $e', error: e, stackTrace: stack);
    }
    return false;
  }

  static Future<bool?> setNotification(NotificationModel notificationModel) async {
    try {
      await fireStore.collection(CollectionName.notification).doc(notificationModel.id).set(notificationModel.toJson());
      return true;
    } catch (e, stack) {
      developer.log('Error setting notification: $e', error: e, stackTrace: stack);
      return false;
    }
  }

  Future<void> getAdminCommission() async {
    try {
      final doc = await fireStore.collection(CollectionName.settings).doc("admin_commission").get();
      if (doc.exists) {
        AdminCommission adminCommission = AdminCommission.fromJson(doc.data()!);
        if (adminCommission.active == true) {
          Constant.adminCommission = adminCommission;
        }
      }
    } catch (e, stack) {
      developer.log('Error fetching admin commission: $e', error: e, stackTrace: stack);
    }
  }

  Future<void> getSettings() async {
    try {
      final doc = await fireStore.collection(CollectionName.settings).doc("constant").get();
      if (doc.exists) {
        final data = doc.data()!;
        Constant.radius = data["radius"] ?? "50";
        Constant.minimumAmountToDeposit = data["minimum_amount_deposit"] ?? "100";
        Constant.minimumAmountToWithdrawal = data["minimum_amount_withdraw"] ?? "100";
        Constant.googleMapKey = data["googleMapKey"] ?? "";
        Constant.termsAndConditions = data["termsAndConditions"];
        Constant.aboutApp = data["aboutApp"];
        Constant.privacyPolicy = data["privacyPolicy"];
        Constant.senderId = data["notification_senderId"];
        Constant.jsonFileURL = data["jsonFileURL"];
        Constant.extraChargeGst = data["extraCharge_GST"] ?? false;
        Constant.appName.value = data["appName"] ?? Constant.appName.value;
        Constant.appColor = data["restaurantAppColor"];
        Constant.isDocumentVerificationEnable = data["isVendorDocumentVerification"] ?? true;
        Constant.isSelfDelivery = data["isSelfDelivery"] ?? false;
      }
    } catch (e, stack) {
      developer.log('Error fetching settings: $e', error: e, stackTrace: stack);
    }
  }

  Future<CurrencyModel?> getCurrency() async {
    try {
      final querySnapshot = await fireStore.collection(CollectionName.currencies).where("active", isEqualTo: true).get();

      if (querySnapshot.docs.isNotEmpty) {
        return CurrencyModel.fromJson(querySnapshot.docs.first.data());
      }
    } catch (e, stack) {
      developer.log('Error fetching currency: $e', error: e, stackTrace: stack);
    }
    return null;
  }

  static Future<List<LanguageModel>> getLanguage() async {
    List<LanguageModel> languageModelList = [];
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection(CollectionName.languages).get();
      for (var document in snap.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        if (data != null) {
          languageModelList.add(LanguageModel.fromJson(data));
        }
      }
    } catch (e, stack) {
      developer.log('Error fetching languages: $e', error: e, stackTrace: stack);
    }
    return languageModelList;
  }

  static Future<List<OrderModel>> getOrderListForStatement(DateTimeRange? dateTimeRange) async {
    List<OrderModel> orderList = [];
    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.orders)
          .where('vendorId', isEqualTo: Constant.ownerModel!.vendorId)
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: dateTimeRange!.start,
            isLessThan: dateTimeRange.end,
          )
          .orderBy('createdAt', descending: true)
          .get();

      for (var element in querySnapshot.docs) {
        OrderModel documentModel = OrderModel.fromJson(element.data());
        orderList.add(documentModel);
      }
    } catch (e, stack) {
      developer.log('Error fetching order list for statement: $e', error: e, stackTrace: stack);
    }
    return orderList;
  }

  static Future<List<CuisineModel>?> getCuisineList() async {
    List<CuisineModel> cuisineList = <CuisineModel>[];
    try {
      final querySnapshot = await fireStore.collection(CollectionName.cuisine).where("active", isEqualTo: true).get();

      for (var element in querySnapshot.docs) {
        CuisineModel categoryModel = CuisineModel.fromJson(element.data());
        cuisineList.add(categoryModel);
      }
    } catch (e, stack) {
      developer.log('Error fetching cuisine list: $e', error: e, stackTrace: stack);
    }
    return cuisineList;
  }

  static Future<bool?> setTransactionLog(TransactionLogModel transactionLogModel) async {
    try {
      await fireStore.collection(CollectionName.transactionLog).doc(transactionLogModel.id).set(transactionLogModel.toJson());
      return true;
    } catch (e, stack) {
      developer.log('Error setting transaction log: $e', error: e, stackTrace: stack);
      return false;
    }
  }

  static Future<List<CategoryModel>?> getCategoryList() async {
    List<CategoryModel> categoryList = <CategoryModel>[];
    try {
      final querySnapshot = await fireStore.collection(CollectionName.category).where("active", isEqualTo: true).get();

      for (var element in querySnapshot.docs) {
        CategoryModel categoryModel = CategoryModel.fromJson(element.data());
        categoryList.add(categoryModel);
      }
    } catch (e, stack) {
      developer.log('Error fetching category list: $e', error: e, stackTrace: stack);
    }
    return categoryList;
  }

  static Future<List<SubCategoryModel>?> getSubCategoryList(String? categoryId) async {
    List<SubCategoryModel> subCateGoryList = <SubCategoryModel>[];
    try {
      final querySnapshot = await fireStore.collection(CollectionName.sub_category).where("categoryId", isEqualTo: categoryId).get();

      for (var element in querySnapshot.docs) {
        SubCategoryModel subCategoryModel = SubCategoryModel.fromJson(element.data());
        subCateGoryList.add(subCategoryModel);
      }
    } catch (e, stack) {
      developer.log('Error fetching subcategory list: $e', error: e, stackTrace: stack);
    }
    return subCateGoryList;
  }

  static Future<List<String>?> getTagsList() async {
    List<String> tagsList = <String>[];
    try {
      final docSnapshot = await fireStore.collection(CollectionName.settings).doc("item_tags").get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        tagsList = List<String>.from(docSnapshot.data()!['tags']);
      }
    } catch (e, stack) {
      developer.log('Error fetching tags list: $e', error: e, stackTrace: stack);
    }
    return tagsList;
  }

  static Future<List<ProductModel>?> getProductList(String? restaurantId) async {
    List<ProductModel> productList = <ProductModel>[];
    try {
      final querySnapshot = await fireStore.collection(CollectionName.product).where("vendorId", isEqualTo: restaurantId).get();

      for (var element in querySnapshot.docs) {
        ProductModel productModel = ProductModel.fromJson(element.data());
        productList.add(productModel);
      }
    } catch (e, stack) {
      developer.log('Error fetching product list: $e', error: e, stackTrace: stack);
    }
    return productList;
  }

  static Future<ProductModel?> getProduct(String uuid) async {
    try {
      final docSnapshot = await fireStore.collection(CollectionName.product).doc(uuid).get();
      if (docSnapshot.exists) {
        return ProductModel.fromJson(docSnapshot.data()!);
      }
    } catch (e, stack) {
      developer.log('Error fetching product: $e', error: e, stackTrace: stack);
    }
    return null;
  }

  static Future<OwnerModel?> getOwnerProfile(String uuid) async {
    try {
      final docSnapshot = await fireStore.collection(CollectionName.owner).doc(uuid).get();
      if (docSnapshot.exists) {
        OwnerModel model = OwnerModel.fromJson(docSnapshot.data()!);
        Constant.ownerModel = model;
        return model;
      }
    } catch (e, stack) {
      developer.log('Error fetching owner profile: $e', error: e, stackTrace: stack);
    }
    return null;
  }

  static Future<bool> addRestaurantOffer(CouponModel couponModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.coupon).doc(couponModel.id).set(couponModel.toJson());
      return true;
    } catch (e, stack) {
      developer.log('Error adding restaurant offer: $e', error: e, stackTrace: stack);
      return false;
    }
  }

  static Future<bool> updateRestaurantOffer(CouponModel couponModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.coupon).doc(couponModel.id).update(couponModel.toJson());
      return true;
    } catch (e, stack) {
      developer.log('Error updating restaurant offer: $e', error: e, stackTrace: stack);
      return false;
    }
  }

  static Future<bool> updateOwner(OwnerModel ownerModel) async {
    try {
      await fireStore.collection(CollectionName.owner).doc(ownerModel.id).set(ownerModel.toJson());
      Constant.ownerModel = ownerModel;
      return true;
    } catch (e, stack) {
      developer.log('Error updating owner: $e', error: e, stackTrace: stack);
      return false;
    }
  }

  static Future<bool> updateRestaurant(VendorModel vendorModel) async {
    try {
      await fireStore.collection(CollectionName.vendors).doc(vendorModel.id).set(vendorModel.toJson());

      Constant.vendorModel = vendorModel;
      return true;
    } catch (e, stack) {
      developer.log('Error updating restaurant: $e', error: e, stackTrace: stack);
      return false;
    }
  }

  static Future<bool> updateProduct(ProductModel productModel) async {
    try {
      await fireStore.collection(CollectionName.product).doc(productModel.id).set(productModel.toJson());

      return true;
    } catch (e, stack) {
      developer.log('Error updating product: $e', error: e, stackTrace: stack);
      return false;
    }
  }

  static Future<List<DocumentModel>?> getDocumentsList() async {
    List<DocumentModel> documentList = <DocumentModel>[];
    try {
      final querySnapshot = await fireStore.collection(CollectionName.documents).where("type", isEqualTo: "Vendor").where('active', isEqualTo: true).get();

      for (var element in querySnapshot.docs) {
        DocumentModel categoryModel = DocumentModel.fromJson(element.data());
        documentList.add(categoryModel);
      }
    } catch (e, stack) {
      developer.log('Error fetching documents: $e', error: e, stackTrace: stack);
    }
    return documentList;
  }

  static Future<List<CouponModel>> getRestaurantOffer(String restaurantID) async {
    List<CouponModel> couponModelList = [];
    try {
      final querySnapshot = await fireStore.collection(CollectionName.coupon).where('isVendorOffer', isEqualTo: true).where('vendorId', isEqualTo: restaurantID).get();

      for (var element in querySnapshot.docs) {
        CouponModel couponModel = CouponModel.fromJson(element.data());
        couponModelList.add(couponModel);
      }
    } catch (e, stack) {
      developer.log('Error fetching restaurant offers: $e', error: e, stackTrace: stack);
    }
    return couponModelList;
  }

  static Future<DocumentModel?> getDocument(String uuid) async {
    try {
      final docSnapshot = await fireStore.collection(CollectionName.documents).doc(uuid).get();
      if (docSnapshot.exists) {
        return DocumentModel.fromJson(docSnapshot.data()!);
      }
    } catch (e, stack) {
      developer.log('Error fetching document: $e', error: e, stackTrace: stack);
    }
    return null;
  }

  static Future<DriverUserModel?> getDriverUserProfile(String uuid) async {
    try {
      final docSnapshot = await fireStore.collection(CollectionName.driver).doc(uuid).get();
      if (docSnapshot.exists) {
        return DriverUserModel.fromJson(docSnapshot.data()!);
      }
    } catch (e, stack) {
      developer.log('Error fetching driver user profile: $e', error: e, stackTrace: stack);
    }
    return null;
  }

  static Future<VendorModel?> getRestaurant(String uuid) async {
    VendorModel? vendorModel;

    try {
      final documentSnapshot = await fireStore.collection(CollectionName.vendors).doc(uuid).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          Constant.vendorModel = VendorModel.fromJson(data);
          vendorModel = VendorModel.fromJson(data);
        }
      } else {}
    } catch (error, stack) {
      developer.log('Error fetching restaurant: $error', error: error, stackTrace: stack);
      vendorModel = null;
    }
    return vendorModel;
  }

  Future<PaymentModel?> getPayment() async {
    try {
      final doc = await fireStore.collection(CollectionName.settings).doc("payment").get();
      if (doc.exists && doc.data() != null) {
        PaymentModel paymentModel = PaymentModel.fromJson(doc.data()!);
        Constant.paymentModel = paymentModel;
        return paymentModel;
      }
    } catch (e, stack) {
      developer.log('Error fetching payment settings: $e', error: e, stackTrace: stack);
    }
    return null;
  }

  static Future<List<WalletTransactionModel>?> getWalletTransaction() async {
    List<WalletTransactionModel> walletTransactionModelList = [];
    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.walletTransaction)
          .where('userId', isEqualTo: FireStoreUtils.getCurrentUid())
          .where('type', isEqualTo: Constant.owner)
          .orderBy('createdDate', descending: true)
          .get();

      for (var element in querySnapshot.docs) {
        WalletTransactionModel walletTransactionModel = WalletTransactionModel.fromJson(element.data());
        walletTransactionModelList.add(walletTransactionModel);
      }
    } catch (e, stack) {
      developer.log('Error fetching wallet transactions: $e', error: e, stackTrace: stack);
    }
    return walletTransactionModelList;
  }

  static Future<List<BankDetailsModel>?> getBankDetailList(String? ownerId) async {
    List<BankDetailsModel> bankDetailsList = [];
    try {
      final querySnapshot = await fireStore.collection(CollectionName.bankDetails).where("ownerId", isEqualTo: ownerId).get();

      for (var element in querySnapshot.docs) {
        BankDetailsModel bankDetailModel = BankDetailsModel.fromJson(element.data());
        bankDetailsList.add(bankDetailModel);
      }
    } catch (e, stack) {
      developer.log('Error fetching bank details: $e', error: e, stackTrace: stack);
    }
    return bankDetailsList;
  }

  static Future<bool?> setWalletTransaction(WalletTransactionModel walletTransactionModel) async {
    try {
      await fireStore.collection(CollectionName.walletTransaction).doc(walletTransactionModel.id).set(walletTransactionModel.toJson());
      return true;
    } catch (e, stack) {
      developer.log('Error setting wallet transaction: $e', error: e, stackTrace: stack);
      return false;
    }
  }

  static Future<bool?> updateUserWallet({required String amount, required String customerId}) async {
    try {
      final user = await getCustomerUserProfile(customerId);
      if (user != null) {
        user.walletAmount = (double.parse(user.walletAmount.toString()) + double.parse(amount)).toString();
        await FireStoreUtils.updateUser(user);
        return true;
      }
    } catch (e, stack) {
      developer.log('Error updating user wallet: $e', error: e, stackTrace: stack);
      return false;
    }
    return false;
  }

  static Future<bool> addOwner(OwnerModel ownerModel) async {
    bool isUpdate = false;
    try {
      await fireStore.collection(CollectionName.owner).doc(ownerModel.id).set(ownerModel.toJson());
      Constant.ownerModel = ownerModel;
      isUpdate = true;
    } catch (e, stack) {
      developer.log('Error adding owner: $e', error: e, stackTrace: stack);
      isUpdate = false;
    }
    return isUpdate;
  }

  static Future<bool> addDriver(DriverUserModel driverModel) async {
    bool isUpdate = false;
    try {
      await fireStore.collection(CollectionName.driver).doc(driverModel.driverId).set(driverModel.toJson());
      isUpdate = true;
    } catch (e, stack) {
      developer.log('Error adding owner: $e', error: e, stackTrace: stack);
      isUpdate = false;
    }
    return isUpdate;
  }

  static Future<bool> updateUser(UserModel userModel) async {
    bool isUpdate = false;
    try {
      await fireStore.collection(CollectionName.customers).doc(userModel.id).set(userModel.toJson());
      isUpdate = true;
    } catch (e, stack) {
      developer.log('Error updating user: $e', error: e, stackTrace: stack);
      isUpdate = false;
    }
    return isUpdate;
  }

  static Future<bool?> updateOwnerWallet({required String amount, required String ownerID}) async {
    bool isAdded = false;

    try {
      final ownerProfile = await getOwnerProfile(ownerID);

      if (ownerProfile != null) {
        OwnerModel ownerModel = ownerProfile;

        double currentAmount = double.tryParse(ownerModel.walletAmount.toString()) ?? 0.0;
        double addAmount = double.tryParse(amount) ?? 0.0;
        ownerModel.walletAmount = (currentAmount + addAmount).toString();

        isAdded = await FireStoreUtils.updateOwner(ownerModel);
      }
    } catch (e, stack) {
      developer.log("Error in updateOwnerWallet", error: e, stackTrace: stack);
      isAdded = false;
    }

    return isAdded;
  }

  static Future<bool?> updateOwnerWalletDebited({required String amount, required String ownerID}) async {
    bool isAdded = false;

    try {
      final ownerProfile = await getOwnerProfile(ownerID);

      if (ownerProfile != null) {
        OwnerModel ownerModel = ownerProfile;

        double currentAmount = double.tryParse(ownerModel.walletAmount.toString()) ?? 0.0;
        double debitAmount = double.tryParse(amount) ?? 0.0;
        ownerModel.walletAmount = (currentAmount - debitAmount).toString();

        isAdded = await FireStoreUtils.updateOwner(ownerModel);
      }
    } catch (e, stack) {
      developer.log("Error in updateOwnerWalletDebited", error: e, stackTrace: stack);
      isAdded = false;
    }

    return isAdded;
  }

  static Future<List<WithdrawModel>> getWithDrawRequest() async {
    List<WithdrawModel> withdrawalList = [];
    try {
      final querySnapshot =
          await fireStore.collection(CollectionName.withdrawalHistory).where('ownerId', isEqualTo: getCurrentUid()).orderBy('createdDate', descending: true).get();

      for (var element in querySnapshot.docs) {
        WithdrawModel documentModel = WithdrawModel.fromJson(element.data());
        withdrawalList.add(documentModel);
      }
    } catch (e, stack) {
      developer.log('Error fetching withdrawal requests: $e', error: e, stackTrace: stack);
    }
    return withdrawalList;
  }

  static Future<bool?> setWithdrawRequest(WithdrawModel withdrawModel) async {
    bool isAdded = false;
    try {
      await fireStore.collection(CollectionName.withdrawalHistory).doc(withdrawModel.id).set(withdrawModel.toJson());
      isAdded = true;
    } catch (e, stack) {
      developer.log('Error setting withdraw request: $e', error: e, stackTrace: stack);
      isAdded = false;
    }
    return isAdded;
  }

  static Future<bool> addBankDetail(BankDetailsModel bankDetailsModel) async {
    bool isUpdate = false;
    try {
      await fireStore.collection(CollectionName.bankDetails).doc(bankDetailsModel.id).set(bankDetailsModel.toJson());
      isUpdate = true;
    } catch (e, stack) {
      developer.log('Error adding bank details: $e', error: e, stackTrace: stack);
      isUpdate = false;
    }
    return isUpdate;
  }

  static Future<bool> updateBankDetail(BankDetailsModel bankDetailsModel) async {
    bool isUpdate = false;
    try {
      await fireStore.collection(CollectionName.bankDetails).doc(bankDetailsModel.id).update(bankDetailsModel.toJson());
      isUpdate = true;
    } catch (e, stack) {
      developer.log('Error updating bank details: $e', error: e, stackTrace: stack);
      isUpdate = false;
    }
    return isUpdate;
  }

  static Future<bool> updateOrder(OrderModel bookingModel) async {
    bool isUpdate = false;
    try {
      await fireStore.collection(CollectionName.orders).doc(bookingModel.id).update(bookingModel.toJson());
      isUpdate = true;
    } catch (e, stack) {
      developer.log('Error updating order: $e', error: e, stackTrace: stack);
      isUpdate = false;
    }
    return isUpdate;
  }

  static Future<bool> updateDriver(DriverUserModel driverModel) async {
    try {
      await fireStore.collection(CollectionName.driver).doc(driverModel.driverId).update(driverModel.toJson());
      return true;
    } catch (e) {
      developer.log("Failed to update driver: $e");
      return false;
    }
  }

  static Future<List<OrderModel>> getOrders() async {
    List<OrderModel> bookingsList = [];
    try {
      QuerySnapshot snapshot =
          await fireStore.collection(CollectionName.orders).where('vendorId', isEqualTo: Constant.ownerModel!.vendorId).orderBy('createdAt', descending: true).get();

      for (var doc in snapshot.docs) {
        OrderModel booking = OrderModel.fromJson(doc.data() as Map<String, dynamic>);
        bookingsList.add(booking);
      }
    } catch (error, stack) {
      developer.log('Error fetching orders: $error', error: error, stackTrace: stack);
    }
    return bookingsList;
  }

  static Future<UserModel?> getCustomerUserProfile(String uuid) async {
    UserModel? userModel;
    try {
      DocumentSnapshot snapshot = await fireStore.collection(CollectionName.customers).doc(uuid).get();
      if (snapshot.exists) {
        userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      }
    } catch (error, stack) {
      developer.log('Error Customer fetching user profile: $error', error: error, stackTrace: stack);
      userModel = null;
    }
    return userModel;
  }

  static Stream<QuerySnapshot> getNotificationList() {
    try {
      return fireStore.collection(CollectionName.notification).where('ownerId', isEqualTo: FireStoreUtils.getCurrentUid()).orderBy('createdAt', descending: true).snapshots();
    } catch (e, stack) {
      developer.log('Error in getNotificationList: $e', error: e, stackTrace: stack);
      return const Stream.empty();
    }
  }

  static Future<List<OnboardingScreenModel>> getOnboardingDataList() async {
    List<OnboardingScreenModel> onboardingList = [];
    try {
      var snapshot = await fireStore
          .collection(CollectionName.onboardingScreen)
          .where('status', isEqualTo: true)
          .where('type', isEqualTo: 'vendor')
          .orderBy('createdAt', descending: false)
          .get();
      for (var element in snapshot.docs) {
        onboardingList.add(OnboardingScreenModel.fromJson(element.data()));
      }
    } catch (e) {
      developer.log("Failed to fetch Onboarding list: $e");
    }
    return onboardingList;
  }

  static Future<List<DriverUserModel>?> getDriverByVendorId(String? vendorId) async {
    List<DriverUserModel> driverList = <DriverUserModel>[];
    try {
      final querySnapshot = await fireStore.collection(CollectionName.driver).where("vendorId", isEqualTo: vendorId).get();
      log("Driver list length: ${querySnapshot.docs.length}");
      for (var element in querySnapshot.docs) {
        DriverUserModel driverModel = DriverUserModel.fromJson(element.data());
        driverList.add(driverModel);
        log("Driver list length: ${driverList.length}");
      }
    } catch (e, stack) {
      developer.log('Error Driver list: $e', error: e, stackTrace: stack);
    }
    return driverList;
  }

  static Future<List<DriverUserModel>> getAllDrivers() async {
    List<DriverUserModel> driverList = [];
    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.driver)
          .where('isOnline', isEqualTo: true)
          .where('active', isEqualTo: true)
          .get();

      for (var doc in querySnapshot.docs) {
        driverList.add(DriverUserModel.fromJson(doc.data()));
      }
    } catch (e) {
      developer.log("Error fetching all drivers: $e");
    }
    return driverList;
  }

  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 - math.cos((lat2 - lat1) * p) / 2 + math.cos(lat1 * p) * math.cos(lat2 * p) * (1 - math.cos((lon2 - lon1) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a));
  }
}
