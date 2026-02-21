// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;
import 'dart:developer';

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/order_status.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/admin_commission_model.dart';
import 'package:admin_panel/app/models/admin_model.dart';
import 'package:admin_panel/app/models/banner_model.dart';
import 'package:admin_panel/app/models/onboarding_model.dart';
import 'package:admin_panel/app/models/order_model.dart';
import 'package:admin_panel/app/models/category_model.dart';
import 'package:admin_panel/app/models/constant_model.dart';
import 'package:admin_panel/app/models/contact_us_model.dart';
import 'package:admin_panel/app/models/coupon_model.dart';
import 'package:admin_panel/app/models/cuisine_model.dart';
import 'package:admin_panel/app/models/currency_model.dart';
import 'package:admin_panel/app/models/owner_model.dart';
import 'package:admin_panel/app/models/product_model.dart';
import 'package:admin_panel/app/models/vendor_model.dart';
import 'package:admin_panel/app/models/review_model.dart';
import 'package:admin_panel/app/models/sub_category_model.dart';
import 'package:admin_panel/app/models/tax_model.dart';
import 'package:admin_panel/app/models/user_model.dart';
import 'package:admin_panel/app/models/documents_model.dart';
import 'package:admin_panel/app/models/driver_user_model.dart';
import 'package:admin_panel/app/models/global_value_model.dart';
import 'package:admin_panel/app/models/language_model.dart';
import 'package:admin_panel/app/models/payment_method_model.dart';
import 'package:admin_panel/app/models/payout_request_model.dart';
import 'package:admin_panel/app/models/verify_restaurant_model.dart';
import 'package:admin_panel/app/models/verify_driver_model.dart';
import 'package:admin_panel/app/models/wallet_transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FireStoreUtils {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<bool> userExistOrNot(String uid) async {
    bool isExist = false;
    try {
      await fireStore.collection(CollectionName.admin).doc(uid).get().then(
        (value) {
          if (value.exists) {
            Constant.adminModel = AdminModel.fromJson(value.data()!);
            isExist = true;
          }
        },
      );
    } catch (e, stack) {
      developer.log("Error checking if user exists", error: e, stackTrace: stack);
    }
    return isExist;
  }

  static Future<bool> isLogin() async {
    bool isLogin = false;
    if (FirebaseAuth.instance.currentUser != null) {
      isLogin = await userExistOrNot(FirebaseAuth.instance.currentUser!.uid);
    } else {
      isLogin = false;
    }
    return isLogin;
  }

  static Future<AdminModel?> getAdminProfile(String uuid) async {
    AdminModel? adminModel;

    await fireStore.collection(CollectionName.admin).doc(uuid).get().then((value) {
      if (value.exists) {
        Constant.adminModel = AdminModel.fromJson(value.data()!);
        adminModel = AdminModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      adminModel = null;
    });
    return adminModel;
  }

  static Future<void> getSettings() async {
    try {
      var value = await fireStore.collection(CollectionName.settings).doc("constant").get();
      if (value.exists) {
        Constant.appColor = value.data()!["appColor"];
        Constant.appName = value.data()!["appName"];
        Constant.distanceType = value.data()!["distanceType"] ?? "KM";
        Constant.googleMapKey = value.data()!["googleMapKey"] ?? "";
        Constant.notificationServerKey = value.data()!["notification_server_key"] ?? "";
      }
      var adminValue = await fireStore.collection(CollectionName.settings).doc("admin_commission").get();
      Constant.adminCommission = AdminCommission.fromJson(adminValue.data()!);
    } catch (e, stack) {
      developer.log("Error getting app settings", error: e, stackTrace: stack);
    }
  }

  static Future<CurrencyModel?> getCurrency() async {
    CurrencyModel? currencyModel;
    try {
      var value = await fireStore.collection(CollectionName.currencies).where("active", isEqualTo: true).get();
      if (value.docs.isNotEmpty) {
        currencyModel = CurrencyModel.fromJson(value.docs.first.data());
      }
    } catch (e, stack) {
      developer.log("Error fetching currency", error: e, stackTrace: stack);
    }
    return currencyModel;
  }

  static Future<int> countUsers() async {
    final CollectionReference<Map<String, dynamic>> userList = FirebaseFirestore.instance.collection(CollectionName.customer);
    AggregateQuerySnapshot query = await userList.count().get();
    Constant.usersLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countStatusWiseCustomer(DateTimeRange? dateTimeRange) async {
    final CollectionReference<Map<String, dynamic>> ordersCollection = FirebaseFirestore.instance.collection(CollectionName.customer);

    Query<Map<String, dynamic>> bookingList = ordersCollection;

    if (dateTimeRange != null) {
      bookingList = bookingList.where('createdAt', isGreaterThanOrEqualTo: dateTimeRange.start).where('createdAt', isLessThanOrEqualTo: dateTimeRange.end);
    }

    AggregateQuerySnapshot query = await bookingList.count().get();
    Constant.usersLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countProducts() async {
    final CollectionReference<Map<String, dynamic>> userList = FirebaseFirestore.instance.collection(CollectionName.product);
    AggregateQuerySnapshot query = await userList.count().get();
    Constant.productLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countRestaurantProducts(String restaurantID) async {
    final Query<Map<String, dynamic>> userList = FirebaseFirestore.instance.collection(CollectionName.product).where('vendorId', isEqualTo: restaurantID);
    AggregateQuerySnapshot query = await userList.count().get();

    Constant.restaurantProductLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countPendingOrders() async {
    final Query<Map<String, dynamic>> pendingOrderList = FirebaseFirestore.instance.collection(CollectionName.orders).where('orderStatus', isEqualTo: OrderStatus.orderPending);
    AggregateQuerySnapshot query = await pendingOrderList.count().get();
    return query.count ?? 0;
  }

  static Future<int> countCompletedOrders() async {
    final Query<Map<String, dynamic>> completedOrderList = FirebaseFirestore.instance.collection(CollectionName.orders).where('orderStatus', isEqualTo: OrderStatus.orderComplete);
    AggregateQuerySnapshot query = await completedOrderList.count().get();
    return query.count ?? 0;
  }

  static Future<int> countRejectedOrders() async {
    final Query<Map<String, dynamic>> rejectedOrderList = FirebaseFirestore.instance
        .collection(CollectionName.orders)
        .where('orderStatus', whereIn: [OrderStatus.orderCancel, OrderStatus.orderRejected, OrderStatus.driverRejected]);
    AggregateQuerySnapshot query = await rejectedOrderList.count().get();
    Constant.rejectedOrderLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countOrdersByCustomerId(String id) async {
    final Query<Map<String, dynamic>> orderList = FirebaseFirestore.instance.collection(CollectionName.orders).where('customerId', isEqualTo: id);
    AggregateQuerySnapshot query = await orderList.count().get();
    Constant.userOrderLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countSearchUsers(String searchQuery, String searchType) async {
    final Query<Map<String, dynamic>> userList = FirebaseFirestore.instance.collection(CollectionName.customer).where(
          searchType,
          isGreaterThanOrEqualTo: searchQuery,
          isLessThan: "$searchQuery\uf8ff",
        );
    AggregateQuerySnapshot query = await userList.count().get();
    Constant.usersLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countSearchProduct(String searchQuery) async {
    final Query<Map<String, dynamic>> productList = FirebaseFirestore.instance.collection(CollectionName.product).where(
          'productName',
          isGreaterThanOrEqualTo: searchQuery,
          isLessThan: "$searchQuery\uf8ff",
        );
    AggregateQuerySnapshot query = await productList.count().get();
    Constant.productLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countDriverOrders(String driverId) async {
    try {
      var bookingList = FirebaseFirestore.instance.collection(CollectionName.orders).where('driverId', isEqualTo: driverId);

      var query = await bookingList.count().get();
      Constant.driverOrderLength = query.count ?? 0;
      return query.count ?? 0;
    } catch (error) {
      developer.log('Error in countDriverOrders: $error');
      return 0;
    }
  }

  static Future<List<UserModel>> getUsers(
    int pageNumber,
    int pageSize,
    String searchQuery,
    String searchType,
    DateTimeRange? dateTimeRange,
  ) async {
    List<UserModel> userList = [];
    try {
      DocumentSnapshot? lastDocument;
      if (searchQuery.isNotEmpty) {
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.customer)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.customer)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              UserModel userModel = UserModel.fromJson(element.data());
              userList.add(userModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.customer)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              UserModel userModel = UserModel.fromJson(element.data());
              userList.add(userModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        }
      } else {
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.customer)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.customer)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              UserModel userModel = UserModel.fromJson(element.data());
              userList.add(userModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.customer)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              UserModel userModel = UserModel.fromJson(element.data());
              userList.add(userModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        }
      }
    } catch (error) {
      developer.log(error.toString());
    }
    return userList;
  }

  static Future<List<ProductModel>> getAllProduct(int pageNumber, int pageSize, String searchQuery) async {
    List<ProductModel> productList = [];
    try {
      DocumentSnapshot? lastDocument;
      if (searchQuery.isNotEmpty) {
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.product)
              .where(
                'productName',
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('createdAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.product)
              .where(
                'productName',
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('createAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              ProductModel productModel = ProductModel.fromJson(element.data());
              productList.add(productModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.product)
              .where(
                'productName',
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('createAt', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              ProductModel productModel = ProductModel.fromJson(element.data());
              productList.add(productModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        }
      } else {
        if (pageNumber > 1) {
          var documents = await fireStore.collection(CollectionName.product).orderBy('createAt', descending: true).limit(pageSize * (pageNumber - 1)).get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore.collection(CollectionName.product).orderBy('createAt', descending: true).startAfterDocument(lastDocument).limit(pageSize).get().then((value) {
            for (var element in value.docs) {
              ProductModel productModel = ProductModel.fromJson(element.data());
              productList.add(productModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        } else {
          await fireStore.collection(CollectionName.product).orderBy('createAt', descending: true).limit(pageSize).get().then((value) {
            for (var element in value.docs) {
              ProductModel productModel = ProductModel.fromJson(element.data());
              productList.add(productModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        }
      }
    } catch (error) {
      developer.log(error.toString());
    }
    return productList;
  }

  static Future<List<ProductModel>> getAllRestaurantProduct(int pageNumber, int pageSize, String searchQuery, String restaurantId) async {
    List<ProductModel> productList = [];
    try {
      DocumentSnapshot? lastDocument;
      if (searchQuery.isNotEmpty) {
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.product)
              .where('vendorId', isEqualTo: restaurantId)
              .where(
                'productName',
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('createdAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.product)
              .where('vendorId', isEqualTo: restaurantId)
              .where(
                'productName',
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('createAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              ProductModel productModel = ProductModel.fromJson(element.data());
              productList.add(productModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.product)
              .where('vendorId', isEqualTo: restaurantId)
              .where(
                'productName',
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('createAt', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              ProductModel productModel = ProductModel.fromJson(element.data());
              productList.add(productModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        }
      } else {
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.product)
              .where('vendorId', isEqualTo: restaurantId)
              .orderBy('createAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.product)
              .where('vendorId', isEqualTo: restaurantId)
              .orderBy('createAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              ProductModel productModel = ProductModel.fromJson(element.data());
              productList.add(productModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        } else {
          await fireStore.collection(CollectionName.product).where('vendorId', isEqualTo: restaurantId).orderBy('createAt', descending: true).limit(pageSize).get().then((value) {
            for (var element in value.docs) {
              ProductModel productModel = ProductModel.fromJson(element.data());
              productList.add(productModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        }
      }
    } catch (error) {
      developer.log(error.toString());
    }
    return productList;
  }

  static Future<int> countDrivers() async {
    final CollectionReference<Map<String, dynamic>> userList = FirebaseFirestore.instance.collection(CollectionName.driver);
    AggregateQuerySnapshot query = await userList.count().get();
    Constant.driverLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countDriversWithMonth(DateTimeRange? dateTimeRange) async {
    final CollectionReference<Map<String, dynamic>> ordersCollection = FirebaseFirestore.instance.collection(CollectionName.driver);

    Query<Map<String, dynamic>> restaurantList = ordersCollection;

    if (dateTimeRange != null) {
      restaurantList = restaurantList.where('createdAt', isGreaterThanOrEqualTo: dateTimeRange.start).where('createdAt', isLessThanOrEqualTo: dateTimeRange.end);
    }

    AggregateQuerySnapshot query = await restaurantList.count().get();
    Constant.driverLength = query.count ?? 0;

    return query.count ?? 0;
  }

  static Future<int> countNewOwners() async {
    final CollectionReference<Map<String, dynamic>> userList = FirebaseFirestore.instance.collection(CollectionName.owner);
    AggregateQuerySnapshot query = await userList.count().get();
    Constant.ownerLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countUnVerifiedOwner() async {
    final userList = FirebaseFirestore.instance.collection(CollectionName.owner).where('isVerified', isEqualTo: false);
    final query = await userList.count().get();
    Constant.unVerifiedOwner = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countRestaurantReview(String restaurantId) async {
    final Query<Map<String, dynamic>> userList = FirebaseFirestore.instance.collection(CollectionName.reviewCustomer).where('vendorId', isEqualTo: restaurantId);
    AggregateQuerySnapshot query = await userList.count().get();
    Constant.restaurantReviewLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countOrders() async {
    try {
      final CollectionReference<Map<String, dynamic>> bookingList = FirebaseFirestore.instance.collection(CollectionName.orders);
      AggregateQuerySnapshot query = await bookingList.count().get();
      Constant.orderLength = query.count ?? 0;
      return query.count ?? 0;
    } catch (error) {
      developer.log("countOrders Error: $error");
      return 0;
    }
  }

  static Future<int> countStatusWiseBooking({
    required String driverId,
    required String status,
    required DateTimeRange dateTimeRange,
    required String restaurantId,
  }) async {
    try {
      final CollectionReference<Map<String, dynamic>> ordersCollection = FirebaseFirestore.instance.collection(CollectionName.orders);
      Query<Map<String, dynamic>> bookingList = ordersCollection.where('createdAt', isGreaterThanOrEqualTo: dateTimeRange.start).where('createdAt', isLessThan: dateTimeRange.end);

      if (status != 'All') {
        bookingList = bookingList.where('orderStatus', isEqualTo: status);
      }

      if (driverId.isNotEmpty && driverId != 'All') {
        bookingList = bookingList.where('driverId', isEqualTo: driverId);
      }

      if (restaurantId.isNotEmpty && restaurantId != 'All') {
        bookingList = bookingList.where('vendorId', isEqualTo: restaurantId);
      }

      AggregateQuerySnapshot query = await bookingList.count().get();
      Constant.orderLength = query.count ?? 0;
      return query.count ?? 0;
    } catch (error) {
      developer.log("countStatusWiseBooking Error: $error");
      return 0;
    }
  }

  static Future<int> countRestaurantOrders(String restaurantID) async {
    try {
      final Query<Map<String, dynamic>> bookingList = FirebaseFirestore.instance.collection(CollectionName.orders).where('vendorId', isEqualTo: restaurantID);

      AggregateQuerySnapshot query = await bookingList.count().get();
      Constant.restaurantOrderLength = query.count ?? 0;
      return query.count ?? 0;
    } catch (error) {
      developer.log("countRestaurantOrders Error: $error");
      return 0;
    }
  }

  static Future<int> countStatusWiseOrder(String? status, DateTimeRange? dateTimeRange) async {
    try {
      Query<Map<String, dynamic>> bookingList = FirebaseFirestore.instance.collection(CollectionName.orders);

      if (status == 'All') {
        bookingList = bookingList.where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start).where('createdAt', isLessThan: dateTimeRange.end);
      } else {
        bookingList =
            bookingList.where('orderStatus', isEqualTo: status).where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start).where('createdAt', isLessThan: dateTimeRange.end);
      }

      AggregateQuerySnapshot query = await bookingList.count().get();
      Constant.orderLength = query.count ?? 0;
      return query.count ?? 0;
    } catch (error) {
      developer.log("countStatusWiseOrder Error: $error");
      return 0;
    }
  }

  static Future<int> countStatusWiseRestaurantOrder(String? status, DateTimeRange? dateTimeRange, String restaurantID) async {
    try {
      Query<Map<String, dynamic>> bookingList = FirebaseFirestore.instance
          .collection(CollectionName.orders)
          .where('vendorId', isEqualTo: restaurantID)
          .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThan: dateTimeRange.end);

      if (status != 'All') {
        bookingList = bookingList.where('orderStatus', isEqualTo: status);
      }

      AggregateQuerySnapshot query = await bookingList.count().get();
      Constant.restaurantOrderLength = query.count ?? 0;
      return query.count ?? 0;
    } catch (e) {
      developer.log("countStatusWiseRestaurantOrder Error: $e");
      return 0;
    }
  }

  static Future<int> countStatusWiseOrderRestaurant(String? status, DateTimeRange? dateTimeRange, String restaurantID) async {
    try {
      Query<Map<String, dynamic>> bookingList = FirebaseFirestore.instance
          .collection(CollectionName.orders)
          .where('vendorId', isEqualTo: restaurantID)
          .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThan: dateTimeRange.end);

      if (status != 'All') {
        bookingList = bookingList.where('orderStatus', isEqualTo: status);
      }

      AggregateQuerySnapshot query = await bookingList.count().get();
      Constant.restaurantOrderLength = query.count ?? 0;
      return query.count ?? 0;
    } catch (e) {
      developer.log("countStatusWiseOrderRestaurant Error: $e");
      return 0;
    }
  }

  static Future<int> countStatusWiseOrderDriver({
    required String status,
    required DateTimeRange dateTimeRange,
    required String driverId,
  }) async {
    try {
      Query<Map<String, dynamic>> bookingList = FirebaseFirestore.instance
          .collection(CollectionName.orders)
          .where('driverId', isEqualTo: driverId)
          .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange.start, isLessThan: dateTimeRange.end);

      if (status != 'All') {
        bookingList = bookingList.where('orderStatus', isEqualTo: status);
      }

      AggregateQuerySnapshot query = await bookingList.count().get();
      Constant.restaurantOrderLength = query.count ?? 0;
      return query.count ?? 0;
    } catch (e) {
      developer.log("countStatusWiseOrderDriver Error: $e");
      return 0;
    }
  }

  static Future<int> countRestaurants() async {
    try {
      final CollectionReference<Map<String, dynamic>> restaurantList = FirebaseFirestore.instance.collection(CollectionName.vendors);
      AggregateQuerySnapshot query = await restaurantList.count().get();
      Constant.restaurantLength = query.count ?? 0;
      return query.count ?? 0;
    } catch (e) {
      developer.log("countRestaurants Error: $e");
      return 0;
    }
  }

  static Future<int> countOwners() async {
    try {
      final CollectionReference<Map<String, dynamic>> ownerList = FirebaseFirestore.instance.collection(CollectionName.owner);
      AggregateQuerySnapshot query = await ownerList.count().get();
      Constant.ownerLength = query.count ?? 0;
      return query.count ?? 0;
    } catch (e) {
      developer.log("countOwners Error: $e");
      return 0;
    }
  }

  static Future<int> countRestaurantsWithMonth(DateTimeRange? dateTimeRange) async {
    final CollectionReference<Map<String, dynamic>> ordersCollection = FirebaseFirestore.instance.collection(CollectionName.vendors);

    Query<Map<String, dynamic>> restaurantList = ordersCollection;

    if (dateTimeRange != null) {
      restaurantList = restaurantList.where('createdAt', isGreaterThanOrEqualTo: dateTimeRange.start).where('createdAt', isLessThanOrEqualTo: dateTimeRange.end);
    }

    AggregateQuerySnapshot query = await restaurantList.count().get();
    Constant.restaurantLength = query.count ?? 0;

    return query.count ?? 0;
  }

  static Future<int> countOwnersWithMonth(DateTimeRange? dateTimeRange) async {
    final CollectionReference<Map<String, dynamic>> ownerCollection = FirebaseFirestore.instance.collection(CollectionName.owner);

    Query<Map<String, dynamic>> ownerList = ownerCollection;

    if (dateTimeRange != null) {
      ownerList = ownerList.where('createdAt', isGreaterThanOrEqualTo: dateTimeRange.start).where('createdAt', isLessThanOrEqualTo: dateTimeRange.end);
    }

    AggregateQuerySnapshot query = await ownerList.count().get();
    Constant.ownerLength = query.count ?? 0;

    return query.count ?? 0;
  }

  static Future<int> countSearchRestaurant(String searchQuery, String searchType) async {
    try {
      final query = FirebaseFirestore.instance.collection(CollectionName.vendors).where(searchType, isGreaterThanOrEqualTo: searchQuery, isLessThan: "$searchQuery\uf8ff");

      AggregateQuerySnapshot count = await query.count().get();
      Constant.restaurantLength = count.count ?? 0;
      return count.count ?? 0;
    } catch (e) {
      developer.log("countSearchRestaurant Error: $e");
      return 0;
    }
  }

  static Future<int> countSearchOwner(String searchQuery, String searchType) async {
    try {
      final query = FirebaseFirestore.instance.collection(CollectionName.owner).where(searchType, isGreaterThanOrEqualTo: searchQuery, isLessThan: "$searchQuery\uf8ff");

      AggregateQuerySnapshot count = await query.count().get();
      Constant.ownerLength = count.count ?? 0;
      return count.count ?? 0;
    } catch (e) {
      developer.log("countSearchOwner Error: $e");
      return 0;
    }
  }

  static Future<List<DriverUserModel>> getAllDriver() async {
    List<DriverUserModel> driverUserModelList = [];
    await fireStore.collection(CollectionName.driver).orderBy('createdAt', descending: true).get().then((value) {
      for (var element in value.docs) {
        DriverUserModel driverUserModel = DriverUserModel.fromJson(element.data());
        driverUserModelList.add(driverUserModel);
      }
    }).catchError((error) {
      developer.log(error.toString());
    });
    return driverUserModelList;
  }

  static Future<List<OrderModel>> getOrders(int pageNumber, int pageSize, String? status, DateTimeRange? dateTimeRange, String driverId, String restaurantId) async {
    List<OrderModel> ordersList = [];

    try {
      bool isDriverAll = driverId == '' || driverId == 'All';
      bool isStatusAll = status == 'All';
      bool isRestaurantAll = restaurantId == '' || restaurantId == 'All';

      if (isStatusAll && isDriverAll) {
        DocumentSnapshot? lastDocument;
        var baseQuery = fireStore.collection(CollectionName.orders).where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end);

        if (!isRestaurantAll) {
          baseQuery = baseQuery.where('vendorId', isEqualTo: restaurantId);
        }

        baseQuery = baseQuery.orderBy('createdAt', descending: true);

        if (pageNumber > 1) {
          var documents = await baseQuery.limit(pageSize * (pageNumber - 1)).get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }

        var pagedQuery = baseQuery;
        if (lastDocument != null) {
          pagedQuery = baseQuery.startAfterDocument(lastDocument);
        }

        await pagedQuery.limit(pageSize).get().then((value) {
          for (var element in value.docs) {
            ordersList.add(OrderModel.fromJson(element.data()));
          }
        }).catchError((error) {
          developer.log(error.toString());
        });
      } else if (!isDriverAll) {
        DocumentSnapshot? lastDocument;
        var baseQuery = fireStore
            .collection(CollectionName.orders)
            .where('driverId', isEqualTo: driverId)
            .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end);

        if (!isStatusAll) {
          baseQuery = baseQuery.where('orderStatus', isEqualTo: status);
        }

        if (!isRestaurantAll) {
          baseQuery = baseQuery.where('vendorId', isEqualTo: restaurantId);
        }

        baseQuery = baseQuery.orderBy('createdAt', descending: true);

        if (pageNumber > 1) {
          var documents = await baseQuery.limit(pageSize * (pageNumber - 1)).get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }

        var pagedQuery = baseQuery;
        if (lastDocument != null) {
          pagedQuery = baseQuery.startAfterDocument(lastDocument);
        }

        await pagedQuery.limit(pageSize).get().then((value) {
          for (var element in value.docs) {
            ordersList.add(OrderModel.fromJson(element.data()));
          }
        }).catchError((error) {
          developer.log(error.toString());
        });
      } else {
        DocumentSnapshot? lastDocument;
        var baseQuery = fireStore
            .collection(CollectionName.orders)
            .where('orderStatus', isEqualTo: status)
            .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end);

        if (!isRestaurantAll) {
          baseQuery = baseQuery.where('vendorId', isEqualTo: restaurantId);
        }

        baseQuery = baseQuery.orderBy('createdAt', descending: true);

        if (pageNumber > 1) {
          var documents = await baseQuery.limit(pageSize * (pageNumber - 1)).get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }

        var pagedQuery = baseQuery;
        if (lastDocument != null) {
          pagedQuery = baseQuery.startAfterDocument(lastDocument);
        }

        await pagedQuery.limit(pageSize).get().then((value) {
          for (var element in value.docs) {
            ordersList.add(OrderModel.fromJson(element.data()));
          }
        }).catchError((error) {
          developer.log(error.toString());
        });
      }
    } catch (error) {
      developer.log(error.toString());
    }

    return ordersList;
  }

  static Future<List<OrderModel>> getRestaurantOrders(int pageNumber, int pageSize, String? status, DateTimeRange? dateTimeRange, String restaurantID) async {
    List<OrderModel> bookingList = [];
    try {
      if (status == 'All') {
        DocumentSnapshot? lastDocument;
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.orders)
              .where('vendorId', isEqualTo: restaurantID)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.orders)
              .where('vendorId', isEqualTo: restaurantID)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              OrderModel bookingModel = OrderModel.fromJson(element.data());
              bookingList.add(bookingModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.orders)
              .where('vendorId', isEqualTo: restaurantID)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              OrderModel bookingModel = OrderModel.fromJson(element.data());
              bookingList.add(bookingModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        }
      } else {
        DocumentSnapshot? lastDocument;
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.orders)
              .where('vendorId', isEqualTo: restaurantID)
              .where('orderStatus', isEqualTo: status)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.orders)
              .where('vendorId', isEqualTo: restaurantID)
              .where('orderStatus', isEqualTo: status)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              OrderModel bookingModel = OrderModel.fromJson(element.data());
              bookingList.add(bookingModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.orders)
              .where('vendorId', isEqualTo: restaurantID)
              .where('orderStatus', isEqualTo: status)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              OrderModel bookingModel = OrderModel.fromJson(element.data());
              bookingList.add(bookingModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        }
      }
    } catch (error) {
      developer.log(error.toString());
    }
    return bookingList;
  }

  static Future<List<DriverUserModel>> getDriver(
    int pageNumber,
    int pageSize,
    String searchQuery,
    String searchType,
    DateTimeRange? dateTimeRange,
  ) async {
    List<DriverUserModel> userList = [];
    try {
      DocumentSnapshot? lastDocument;
      if (searchQuery.isNotEmpty) {
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.driver)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.driver)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              DriverUserModel driverModel = DriverUserModel.fromJson(element.data());
              userList.add(driverModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.driver)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              DriverUserModel driverModel = DriverUserModel.fromJson(element.data());
              userList.add(driverModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        }
      } else {
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.driver)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.driver)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              DriverUserModel driverModel = DriverUserModel.fromJson(element.data());
              userList.add(driverModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.driver)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              DriverUserModel driverModel = DriverUserModel.fromJson(element.data());
              userList.add(driverModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        }
      }
    } catch (error) {
      developer.log(error.toString());
    }
    return userList;
  }

  static Future<List<OwnerModel>> getNewOwner(int pageNumber, int pageSize) async {
    List<OwnerModel> ownerList = [];
    try {
      DocumentSnapshot? lastDocument;

      if (pageNumber > 1) {
        var documents =
            await fireStore.collection(CollectionName.owner).where("isVerified", isEqualTo: false).orderBy('createdAt', descending: true).limit(pageSize * (pageNumber - 1)).get();

        if (documents.docs.isNotEmpty) {
          lastDocument = documents.docs.last;
        }
      }

      Query query = fireStore.collection(CollectionName.owner).where("isVerified", isEqualTo: false).orderBy('createdAt', descending: true).limit(pageSize);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      var snapshot = await query.get();
      for (var element in snapshot.docs) {
        OwnerModel ownerModel = OwnerModel.fromJson(element.data() as Map<String, dynamic>);
        ownerList.add(ownerModel);
      }
    } catch (error) {
      developer.log(error.toString());
    }
    return ownerList;
  }

  static Future<List<ReviewModel>> getRestaurantReview(int pageNumber, int pageSize, String searchQuery, String searchType, String restaurantId) async {
    List<ReviewModel> restaurantReviewList = [];
    try {
      DocumentSnapshot? lastDocument;
      if (searchQuery.isNotEmpty) {
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.reviewCustomer)
              .where('vendorId', isEqualTo: restaurantId)
              .where('type', isEqualTo: Constant.restaurant)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('date', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.reviewCustomer)
              .where('vendorId', isEqualTo: restaurantId)
              .where('type', isEqualTo: Constant.restaurant)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('date', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              ReviewModel driverModel = ReviewModel.fromJson(element.data());
              restaurantReviewList.add(driverModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.reviewCustomer)
              .where('vendorId', isEqualTo: restaurantId)
              .where('type', isEqualTo: Constant.restaurant)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('date', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              ReviewModel driverModel = ReviewModel.fromJson(element.data());
              restaurantReviewList.add(driverModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        }
      } else {
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.reviewCustomer)
              .where('vendorId', isEqualTo: restaurantId)
              .orderBy('date', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.reviewCustomer)
              .where('vendorId', isEqualTo: restaurantId)
              .orderBy('date', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              ReviewModel driverModel = ReviewModel.fromJson(element.data());
              restaurantReviewList.add(driverModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.reviewCustomer)
              .where('vendorId', isEqualTo: restaurantId)
              .orderBy('date', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              ReviewModel driverModel = ReviewModel.fromJson(element.data());
              restaurantReviewList.add(driverModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        }
      }
    } catch (error) {
      developer.log(error.toString());
    }
    return restaurantReviewList;
  }

  static Future<List<OrderModel>> getDriverOrders(
      {required int pageNumber, required int pageSize, required String? status, required DateTimeRange? dateTimeRange, required String driverId}) async {
    List<OrderModel> bookingList = [];
    try {
      if (status == 'All') {
        DocumentSnapshot? lastDocument;
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.orders)
              .where('driverId', isEqualTo: driverId)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.orders)
              .where('driverId', isEqualTo: driverId)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              OrderModel bookingModel = OrderModel.fromJson(element.data());
              bookingList.add(bookingModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.orders)
              .where('driverId', isEqualTo: driverId)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              OrderModel bookingModel = OrderModel.fromJson(element.data());
              bookingList.add(bookingModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        }
      } else {
        DocumentSnapshot? lastDocument;
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.orders)
              .where('driverId', isEqualTo: driverId)
              .where('orderStatus', isEqualTo: status)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.orders)
              .where('driverId', isEqualTo: driverId)
              .where('orderStatus', isEqualTo: status)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              OrderModel bookingModel = OrderModel.fromJson(element.data());
              bookingList.add(bookingModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.orders)
              .where('driverId', isEqualTo: driverId)
              .where('orderStatus', isEqualTo: status)
              .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
              .orderBy('createdAt', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              OrderModel bookingModel = OrderModel.fromJson(element.data());
              bookingList.add(bookingModel);
            }
          }).catchError((error) {
            developer.log(error.toString());
          });
        }
      }
    } catch (error) {
      developer.log(error.toString());
    }
    return bookingList;
  }

  static Future<bool> updateDriver(DriverUserModel driverUserModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.driver).doc(driverUserModel.driverId).update(driverUserModel.toJson());
      return true;
    } catch (error) {
      developer.log("updateDriver Error: $error");
      return false;
    }
  }

  static Future<bool> updateNewOwner(OwnerModel ownerModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.owner).doc(ownerModel.id).set(ownerModel.toJson());
      return true;
    } catch (error) {
      developer.log("updateOwner Error: $error");
      return false;
    }
  }

  static Future<bool> addRestaurant(VendorModel vendorModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.vendors).doc(vendorModel.id).set(vendorModel.toJson());
      return true;
    } catch (error) {
      developer.log("addRestaurant Error: $error");
      return false;
    }
  }

  static Future<bool> addUser(UserModel userModel) async {
    bool isUpdate = false;
    try {
      await fireStore.collection(CollectionName.customer).doc(userModel.id).set(userModel.toJson());
      Constant.userModel = userModel;
      isUpdate = true;
    } catch (e, stack) {
      developer.log("Failed to update user", error: e, stackTrace: stack);
    }
    return isUpdate;
  }

  static Future<bool> addOwner(OwnerModel ownerModel) async {
    bool isUpdate = false;
    try {
      await fireStore.collection(CollectionName.owner).doc(ownerModel.id).set(ownerModel.toJson());
      Constant.ownerModel = ownerModel;
      isUpdate = true;
    } catch (e, stack) {
      developer.log("Failed to update user", error: e, stackTrace: stack);
    }
    return isUpdate;
  }

  static Future<bool> addDeliveryBoy(DriverUserModel driverUserModel) async {
    bool isUpdate = false;
    try {
      await fireStore.collection(CollectionName.driver).doc(driverUserModel.driverId).set(driverUserModel.toJson());
      Constant.driverUserModel = driverUserModel;
      isUpdate = true;
    } catch (e, stack) {
      developer.log("Failed to update driver", error: e, stackTrace: stack);
    }
    return isUpdate;
  }

  static Future<bool> addVerifyDeliveryBoy(VerifyDriverModel driverModel) async {
    bool isUpdate = false;
    try {
      await fireStore.collection(CollectionName.verifyDriver).doc(driverModel.driverId).set(driverModel.toJson());
      isUpdate = true;
    } catch (e, stack) {
      developer.log("Failed to update verify driver", error: e, stackTrace: stack);
    }
    return isUpdate;
  }

  static Future<UserModel?> getUserByUserID(String id) async {
    UserModel? userModel;

    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.customer).doc(id).get();
      if (value.exists) {
        userModel = UserModel.fromJson(value.data()!);
      } else {
        userModel = UserModel(firstName: "Unknown User");
      }
    } catch (e, stack) {
      developer.log("Error fetching user by id", error: e, stackTrace: stack);
    }
    return userModel;
  }

  static Future<DocumentsModel?> getDocumentByDocumentId(String id) async {
    DocumentsModel? documentModel;

    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.documents).doc(id).get();
      if (value.exists) {
        documentModel = DocumentsModel.fromJson(value.data()!);
      }
    } catch (e, stack) {
      developer.log("Error fetching document by id", error: e, stackTrace: stack);
    }
    return documentModel;
  }

  static Future<List<DocumentModel>?> getDocumentsList({required String? userType}) async {
    List<DocumentModel> documentList = <DocumentModel>[];

    try {
      var value = await fireStore.collection(CollectionName.documents).where("type", isEqualTo: userType).where('active', isEqualTo: true).get();
      for (var element in value.docs) {
        DocumentModel categoryModel = DocumentModel.fromJson(element.data());
        documentList.add(categoryModel);
      }
    } catch (e, stack) {
      developer.log("Error fetching documents list", error: e, stackTrace: stack);
    }
    return documentList;
  }

  static Future<VendorModel?> getRestaurant(String uuid) async {
    VendorModel? restaurantModel;

    try {
      final documentSnapshot = await fireStore.collection(CollectionName.vendors).doc(uuid).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          Constant.restaurantModel = VendorModel.fromJson(data);
          restaurantModel = VendorModel.fromJson(data);
        }
      }
    } catch (error) {
      developer.log("Failed to retrieve restaurant: $error");
      restaurantModel = null;
    }

    return restaurantModel;
  }

  static Future<DriverUserModel?> getDriverByDriverID(String id) async {
    DriverUserModel? driverUserModel;
    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.driver).doc(id).get();
      if (value.exists) {
        driverUserModel = DriverUserModel.fromJson(value.data()!);
      } else {
        driverUserModel = DriverUserModel(firstName: "Unknown Driver");
      }
    } catch (e, stack) {
      developer.log("Error fetching driver by id", error: e, stackTrace: stack);
    }
    return driverUserModel;
  }

  static Future<OwnerModel?> getOwnerByOwnerId(String ownerId) async {
    OwnerModel? ownerModel;
    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.owner).doc(ownerId).get();
      if (value.exists) {
        ownerModel = OwnerModel.fromJson(value.data()!);
      } else {
        ownerModel = OwnerModel(firstName: "Unknown Owner");
      }
    } catch (e, stack) {
      developer.log("Error fetching owner by id", error: e, stackTrace: stack);
    }
    return ownerModel;
  }

  static Future<UserModel?> getCustomerByCustomerID(String id) async {
    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.customer).doc(id).get();
      if (value.exists) {
        return UserModel.fromJson(value.data()!);
      } else {
        return UserModel(firstName: "Unknown User");
      }
    } catch (e) {
      developer.log("getCustomerByCustomerID Error: $e");
      return null;
    }
  }

  static Future<VendorModel?> getRestaurantByRestaurantId(String uuid) async {
    try {
      var value = await fireStore.collection(CollectionName.vendors).doc(uuid).get();
      if (value.exists) {
        return VendorModel.fromJson(value.data()!);
      }
    } catch (e) {
      developer.log("getRestaurantByRestaurantId Error: $e");
    }
    return null;
  }

  static Future<OrderModel?> getOrderByOrderId(String orderId) async {
    OrderModel? orderModel;

    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.orders).doc(orderId).get();
      if (value.exists) {
        orderModel = OrderModel.fromJson(value.data()!);
      } else {
        log("No Order Found for $orderId");
      }
    } catch (e, stack) {
      developer.log("Error fetching order by id", error: e, stackTrace: stack);
    }
    return orderModel;
  }

  static Future<List<OrderModel>> getOrderByUserId(String? userId) async {
    List<OrderModel> orderList = [];
    try {
      var querySnapshot = await fireStore.collection(CollectionName.orders).where('customerId', isEqualTo: userId).orderBy('createdAt', descending: true).get();

      for (var element in querySnapshot.docs) {
        orderList.add(OrderModel.fromJson(element.data()));
      }
    } catch (e) {
      developer.log('Error fetching orders for user $userId: $e');
    }
    return orderList;
  }

  static Future<List<OrderModel>> getAllOrderByRestaurant(String? restaurantId) async {
    List<OrderModel> orderList = [];
    try {
      var querySnapshot = await fireStore.collection(CollectionName.orders).where('vendorId', isEqualTo: restaurantId).orderBy('createdAt', descending: true).get();

      orderList = querySnapshot.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    } catch (error) {
      developer.log('Error in getAllOrderByRestaurant: $error');
    }
    return orderList;
  }

  static Future<ProductModel?> getProductByProductId(String productId) async {
    try {
      var value = await fireStore.collection(CollectionName.product).where('id', isEqualTo: productId).get();

      if (value.docs.isNotEmpty) {
        return ProductModel.fromJson(value.docs.first.data());
      }
    } catch (error) {
      developer.log('Error in getProductByProductId: $error');
    }
    return null;
  }

  static Future<List<OrderModel>> dataForOrdersPdf(
    DateTimeRange? dateTimeRange,
    String driverId,
    String bookingStatus,
    String selectTimeStatus,
  ) async {
    List<OrderModel> ordersList = [];

    try {
      Query query = fireStore.collection(CollectionName.orders);

      if (bookingStatus != 'All') {
        query = query.where('orderStatus', isEqualTo: bookingStatus);
      }

      if (driverId != 'All') {
        query = query.where('driverId', isEqualTo: driverId);
      }

      if (selectTimeStatus != 'All' && dateTimeRange != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: dateTimeRange.start).where('createdAt', isLessThanOrEqualTo: dateTimeRange.end);
      }

      query = query.orderBy('createdAt', descending: true);

      QuerySnapshot querySnapshot = await query.get();

      for (var element in querySnapshot.docs) {
        OrderModel orderModel = OrderModel.fromJson(element.data() as Map<String, dynamic>);
        ordersList.add(orderModel);
      }
    } catch (error) {
      developer.log('Error fetching PDF cab data: $error');
    }

    return ordersList;
  }

  static Future<List<OrderModel>> dataForOrdersPdfFromRestaurant(
    DateTimeRange? dateTimeRange,
    String bookingStatus,
    String restaurantId,
    String selectTimeStatus,
  ) async {
    List<OrderModel> ordersList = [];

    try {
      Query query = fireStore.collection(CollectionName.orders);

      if (bookingStatus != 'All') {
        query = query.where('orderStatus', isEqualTo: bookingStatus);
      }

      if (restaurantId != '') {
        query = query.where('vendorId', isEqualTo: restaurantId);
      }

      if (selectTimeStatus != 'All' && dateTimeRange != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: dateTimeRange.start).where('createdAt', isLessThanOrEqualTo: dateTimeRange.end);
      }

      query = query.orderBy('createdAt', descending: true);

      QuerySnapshot querySnapshot = await query.get();

      for (var element in querySnapshot.docs) {
        OrderModel orderModel = OrderModel.fromJson(element.data() as Map<String, dynamic>);
        ordersList.add(orderModel);
      }
    } catch (error) {
      developer.log('Error fetching PDF cab data: $error');
    }

    return ordersList;
  }

  static Future<List<WithdrawModel>> dataForPayOutRequestPdf(DateTimeRange? dateTimeRange, String type, String status) async {
    List<WithdrawModel> payoutRequestList = [];

    try {
      Query query = fireStore.collection(CollectionName.withDrawHistory);
      if (dateTimeRange != null) {
        query = query.where('createdDate', isGreaterThanOrEqualTo: dateTimeRange.start).where('createdDate', isLessThanOrEqualTo: dateTimeRange.end);
      }
      if (status != "All") {
        query = query.where('paymentStatus', isEqualTo: status);
      }
      if (type != "All") {
        if (type == "Driver") {
          query = query.where('type', isEqualTo: 'driver');
        } else if (type == "Restaurant") {
          query = query.where('type', isEqualTo: 'restaurant');
        }
      }
      query = query.orderBy('createdDate', descending: true);

      QuerySnapshot querySnapshot = await query.get();

      for (var element in querySnapshot.docs) {
        WithdrawModel orderModel = WithdrawModel.fromJson(element.data() as Map<String, dynamic>);
        payoutRequestList.add(orderModel);
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error in get payout request PDF: $error');
      }
    }
    return payoutRequestList;
  }

  static Future<List<DriverUserModel>> dataForDriverUserPdf(DateTimeRange? dateTimeRange) async {
    List<DriverUserModel> driverUserList = [];
    try {
      QuerySnapshot querySnapshot;
      querySnapshot = await fireStore
          .collection(CollectionName.driver)
          .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
          .orderBy('createdAt', descending: true)
          .get();
      for (var element in querySnapshot.docs) {
        DriverUserModel orderModel = DriverUserModel.fromJson(element.data() as Map<String, dynamic>);
        driverUserList.add(orderModel);
      }
    } catch (error) {
      developer.log("error in get Driver history $error");
    }
    return driverUserList;
  }

  static Future<List<VendorModel>> dataForRestaurantPdf(DateTimeRange? dateTimeRange) async {
    List<VendorModel> restaurantList = [];
    try {
      QuerySnapshot querySnapshot;
      querySnapshot = await fireStore
          .collection(CollectionName.vendors)
          .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
          .orderBy('createdAt', descending: true)
          .get();
      for (var element in querySnapshot.docs) {
        VendorModel orderModel = VendorModel.fromJson(element.data() as Map<String, dynamic>);
        restaurantList.add(orderModel);
      }
    } catch (error) {
      developer.log("error in get restaurant history $error");
    }
    return restaurantList;
  }

  static Future<List<OwnerModel>> dataForOwnerPdf(DateTimeRange? dateTimeRange) async {
    List<OwnerModel> ownerList = [];
    try {
      QuerySnapshot querySnapshot;
      querySnapshot = await fireStore
          .collection(CollectionName.owner)
          .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
          .orderBy('createdAt', descending: true)
          .get();
      for (var element in querySnapshot.docs) {
        OwnerModel ownerModel = OwnerModel.fromJson(element.data() as Map<String, dynamic>);
        ownerList.add(ownerModel);
      }
    } catch (error) {
      developer.log("error in get restaurant history $error");
    }
    return ownerList;
  }

  static Future<List<UserModel>> dataForCustomersPdf(DateTimeRange? dateTimeRange) async {
    List<UserModel> customerList = [];
    try {
      QuerySnapshot querySnapshot;
      querySnapshot = await fireStore
          .collection(CollectionName.customer)
          .where('createdAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
          .orderBy('createdAt', descending: true)
          .get();
      for (var element in querySnapshot.docs) {
        UserModel orderModel = UserModel.fromJson(element.data() as Map<String, dynamic>);
        customerList.add(orderModel);
      }
    } catch (error) {
      developer.log("error in get customer history $error");
    }
    return customerList;
  }

  static Future<AdminModel?> getAdmin() async {
    AdminModel? adminModel;
    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.admin).doc(FireStoreUtils.getCurrentUid()).get();
      if (value.exists) {
        adminModel = AdminModel.fromJson(value.data()!);
      }
    } catch (e, stack) {
      developer.log("Failed to fetch admin data", error: e, stackTrace: stack);
    }
    return adminModel;
  }

  static Future<bool> setAdmin(AdminModel adminModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.admin).doc(FireStoreUtils.getCurrentUid()).set(adminModel.toJson());
      return true;
    } catch (error) {
      developer.log("setAdmin Error: $error");
      return false;
    }
  }

  static Future<List<LanguageModel>> getLanguage() async {
    List<LanguageModel> languageModelList = [];
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection(CollectionName.languages).get();

      for (var document in snap.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        if (data != null) {
          languageModelList.add(LanguageModel.fromJson(data));
        } else {
          developer.log("getLanguage: Document data is null");
        }
      }
    } catch (error) {
      developer.log("getLanguage Error: $error");
    }
    return languageModelList;
  }

  static Future<bool> addLanguage(LanguageModel languageModel) async {
    try {
      await fireStore.collection(CollectionName.languages).doc(languageModel.id).set(languageModel.toJson());

      ShowToastDialog.successToast("Saved successfully.".tr);
      return true;
    } catch (error) {
      developer.log("addLanguage Error: $error");
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
      return false;
    }
  }

  static Future<bool> updateLanguage(LanguageModel languageModel) async {
    try {
      await fireStore.collection(CollectionName.languages).doc(languageModel.id).update(languageModel.toJson());

      ShowToastDialog.successToast("Language updated.".tr);
      return true;
    } catch (error) {
      developer.log("updateLanguage Error: $error");
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
      return false;
    }
  }

  static Future<PaymentModel?> getPayment() async {
    PaymentModel? paymentModel;
    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.settings).doc("payment").get();

      if (value.exists) {
        Constant.paymentModel = PaymentModel.fromJson(value.data()!);
        paymentModel = PaymentModel.fromJson(value.data()!);
      }
    } catch (e) {
      developer.log("getPayment Error: $e");
    }
    return paymentModel;
  }

  static Future<bool> setPayment(PaymentModel paymentModel) {
    return FirebaseFirestore.instance.collection(CollectionName.settings).doc("payment").update(paymentModel.toJson()).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);

      return false;
    });
  }

  static Future<ConstantModel?> getGeneralSetting() async {
    ConstantModel? constantModel;
    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.settings).doc("constant").get();
      if (value.exists) {
        Constant.constantModel = ConstantModel.fromJson(value.data()!);
        constantModel = ConstantModel.fromJson(value.data()!);
      }
    } catch (e, stack) {
      developer.log("Failed to fetch general settings", error: e, stackTrace: stack);
    }
    return constantModel;
  }

  static Future<GlobalValueModel?> getGlobalValueSetting() async {
    GlobalValueModel? globalValueModel;
    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.settings).doc("globalValue").get();
      if (value.exists) {
        Constant.constantModel = ConstantModel.fromJson(value.data()!);
        globalValueModel = GlobalValueModel.fromJson(value.data()!);
      }
    } catch (e, stack) {
      developer.log("Failed to fetch global value settings", error: e, stackTrace: stack);
    }
    return globalValueModel;
  }

  static Future<bool> setGlobalValueSetting(GlobalValueModel globalValueModel) {
    return FirebaseFirestore.instance.collection(CollectionName.settings).doc("globalValue").set(globalValueModel.toJson(), SetOptions(merge: true)).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      developer.log("error in set Global value $error");
      return false;
    });
  }

  static Future<bool> setGeneralSetting(ConstantModel constantModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.settings).doc("constant").set(constantModel.toJson(), SetOptions(merge: true));
      return true;
    } catch (error) {
      developer.log("setGeneralSetting Error: $error");
      return false;
    }
  }

  static Future<bool> addCurrency(CurrencyModel currencyModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.currencies).doc(currencyModel.id).set(currencyModel.toJson());
      return true;
    } catch (error) {
      developer.log("addCurrency Error: $error");
      return false;
    }
  }

  static Future<bool> updateCurrency(CurrencyModel currencyModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.currencies).doc(currencyModel.id).update(currencyModel.toJson());
      return true;
    } catch (error) {
      developer.log("updateCurrency Error: $error");
      return false;
    }
  }

  static Future<List<CurrencyModel>> getCurrencyList() async {
    List<CurrencyModel> currencyModelList = [];
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection(CollectionName.currencies).get();

      for (var document in snap.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        if (data != null) {
          currencyModelList.add(CurrencyModel.fromJson(data));
        }
      }
    } catch (error) {
      developer.log("getCurrencyList Error: $error");
    }
    return currencyModelList;
  }

  static Future<bool> setContactusSetting(ContactUsModel contactUsModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.settings).doc("contact_us").set(contactUsModel.toJson());
      return true;
    } catch (error) {
      developer.log("setContactusSetting Error: $error");
      return false;
    }
  }

  static Future<ContactUsModel?> getContactusSetting() async {
    ContactUsModel? contactUsModel;
    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.settings).doc("contact_us").get();

      if (value.exists) {
        contactUsModel = ContactUsModel.fromJson(value.data()!);
      }
    } catch (e) {
      developer.log("getContactusSetting Error: $e");
    }
    return contactUsModel;
  }

  static Future<AdminCommission?> getAdminCommission() async {
    AdminCommission? adminCommissionModel;
    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.settings).doc("admin_commission").get();

      if (value.exists) {
        adminCommissionModel = AdminCommission.fromJson(value.data()!);
      }
    } catch (e) {
      developer.log("getAdminCommission Error: $e");
    }
    return adminCommissionModel;
  }

  static Future<bool> setAdminCommission(AdminCommission adminCommissionModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.settings).doc("admin_commission").set(adminCommissionModel.toJson(), SetOptions(merge: true));
      return true;
    } catch (error) {
      developer.log("setAdminCommission Error: $error");
      return false;
    }
  }

  static Future<bool> removeRestaurantReview(ReviewModel reviewModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.reviewCustomer).doc(reviewModel.id).delete();
      return true;
    } catch (error) {
      developer.log("removeRestaurantReview Error: $error");
      return false;
    }
  }

  static Future<String> uploadPic(PickedFile image, String fileName, String filePath, String mimeType) async {
    UploadTask uploadTask;
    Reference ref = FirebaseStorage.instance.ref().child(fileName).child(filePath);

    uploadTask = ref.putData(
        await image.readAsBytes(),
        SettableMetadata(
          contentType: mimeType,
          customMetadata: {'picked-file-path': image.path},
        ));

    String url = await uploadTask.then((taskSnapshot) async {
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    });
    return url;
  }

  static Future<String> uploadMultiplePic(XFile image, String filePath, String fileName) async {
    Reference ref = FirebaseStorage.instance.ref().child('$filePath/$fileName');
    UploadTask uploadTask;
    uploadTask = ref.putData(
        await image.readAsBytes(),
        SettableMetadata(
          contentType: "image/png",
          customMetadata: {'picked-file-path': image.path},
        ));
    var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static Future<List<DocumentsModel>> getDocument() async {
    List<DocumentsModel> documentModelList = [];
    try {
      var value = await fireStore.collection(CollectionName.documents).get();
      for (var element in value.docs) {
        DocumentsModel documentModel = DocumentsModel.fromJson(element.data());
        documentModelList.add(documentModel);
      }
    } catch (error) {
      developer.log("getDocument Error: $error");
    }
    return documentModelList;
  }

  static Future<bool> addDocument(DocumentsModel documentModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.documents).doc(documentModel.id).set(documentModel.toJson());

      ShowToastDialog.successToast("Document saved.".tr);
      return true;
    } catch (error) {
      developer.log("addDocument Error: $error");
      return false;
    }
  }

  // static Future<bool> uploadRestaurantDocument(VerifyRestaurantModel restaurantModel) async {
  //   try {
  //     await fireStore.collection(CollectionName.verifyVendor).doc(restaurantModel.vendorId).set(restaurantModel.toJson());
  //     return true;
  //   } catch (error) {
  //     developer.log("uploadRestaurantDocument Error: $error");
  //     return false;
  //   }
  // }

  static Future<VerifyDriverModel?> getVerifyDriverModelByDriverID(String id) async {
    VerifyDriverModel? driverUserModel;
    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.verifyDriver).doc(id).get();

      if (value.exists) {
        driverUserModel = VerifyDriverModel.fromJson(value.data()!);
      } else {
        driverUserModel = VerifyDriverModel(driverName: "Unknown Driver");
      }
    } catch (error) {
      developer.log("getVerifyDriverModelByDriverID Error: $error");
    }
    return driverUserModel;
  }

  // static Future<VerifyRestaurantModel?> getVerifyDocumentRestaurantByRestaurantID(String id) async {
  //   VerifyRestaurantModel? restaurantModel;
  //   try {
  //     var value = await FirebaseFirestore.instance.collection(CollectionName.verifyVendor).doc(id).get();
  //
  //     if (value.exists) {
  //       restaurantModel = VerifyRestaurantModel.fromJson(value.data()!);
  //     } else {
  //       restaurantModel = VerifyRestaurantModel(ownerName: "Unknown Driver");
  //     }
  //   } catch (error) {
  //     developer.log("getVerifyDocumentRestaurantByRestaurantID Error: $error");
  //   }
  //   return restaurantModel;
  // }

  static Future<List<WithdrawModel>> getPayoutRequest({
    String status = "All",
    required String type,
    DateTimeRange? dateTimeRange,
  }) async {
    List<WithdrawModel> payoutRequestList = [];
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection(CollectionName.withDrawHistory);
      Query query = collection;

      if (dateTimeRange != null) {
        query = query.where('createdDate', isGreaterThanOrEqualTo: dateTimeRange.start).where('createdDate', isLessThanOrEqualTo: dateTimeRange.end);
      }

      if (status != "All") {
        query = query.where('paymentStatus', isEqualTo: status);
      }

      if (type == "Driver") {
        query = query.where('type', isEqualTo: 'driver');
      } else if (type == "Restaurant") {
        query = query.where('type', isEqualTo: 'restaurant');
      }

      QuerySnapshot querySnapshot = await query.get();

      for (var element in querySnapshot.docs) {
        WithdrawModel payoutRequest = WithdrawModel.fromJson(element.data() as Map<String, dynamic>);
        payoutRequestList.add(payoutRequest);
      }
    } catch (error) {
      developer.log("getPayoutRequest Error: $error");
    }
    return payoutRequestList;
  }

  static Future<bool> updatePayoutRequest(WithdrawModel payoutRequestModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.withDrawHistory).doc(payoutRequestModel.id).update(payoutRequestModel.toJson());

      ShowToastDialog.successToast("Payout request submitted.".tr);
      return true;
    } catch (e) {
      developer.log("updatePayoutRequest Error: $e");
      return false;
    }
  }

  static Future<List<CategoryModel>> getCategory() async {
    List<CategoryModel> categoryModel = [];
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection(CollectionName.category).get();
      for (var document in snap.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        if (data != null) {
          categoryModel.add(CategoryModel.fromJson(data));
        }
      }
    } catch (e) {
      developer.log("getCategory Error: $e");
    }
    return categoryModel;
  }

  static Future<CategoryModel?> getCategoryByCategoryID(String id) async {
    CategoryModel? categoryModel;
    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.category).doc(id).get();
      if (value.exists) {
        categoryModel = CategoryModel.fromJson(value.data()!);
      }
    } catch (e) {
      developer.log("getCategoryByCategoryID Error: $e");
    }
    return categoryModel;
  }

  static Future<List<SubCategoryModel>> getSubCategory() async {
    List<SubCategoryModel> subCategoryModel = [];
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection(CollectionName.subCategory).get();
      for (var document in snap.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        if (data != null) {
          subCategoryModel.add(SubCategoryModel.fromJson(data));
        }
      }
    } catch (e) {
      developer.log("getSubCategory Error: $e");
    }
    return subCategoryModel;
  }

  static Future<bool> addSubCategory(SubCategoryModel subCategoryModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.subCategory).doc(subCategoryModel.id).set(subCategoryModel.toJson());

      ShowToastDialog.successToast("Subcategory saved.".tr);
      return true;
    } catch (e) {
      developer.log("addSubCategory Error: $e");
      return false;
    }
  }

  static Future<List<SubCategoryModel>?> getSubCategoryList(String? categoryId) async {
    List<SubCategoryModel> subCategoryList = [];
    try {
      var value = await fireStore.collection(CollectionName.subCategory).where("categoryId", isEqualTo: categoryId).get();

      for (var element in value.docs) {
        SubCategoryModel subCategoryModel = SubCategoryModel.fromJson(element.data());
        subCategoryList.add(subCategoryModel);
      }
    } catch (e) {
      developer.log("getSubCategoryList Error: $e");
    }
    return subCategoryList;
  }

  static Future<List<CouponModel>> getCoupon() async {
    List<CouponModel> couponModelList = [];
    try {
      var value = await fireStore.collection(CollectionName.coupon).where('isVendorOffer', isEqualTo: false).get();

      for (var element in value.docs) {
        CouponModel couponModel = CouponModel.fromJson(element.data());
        couponModelList.add(couponModel);
      }
    } catch (e) {
      developer.log("getCoupon Error: $e");
    }
    return couponModelList;
  }

  static Future<List<CouponModel>> getRestaurantOffer() async {
    List<CouponModel> couponModelList = [];
    try {
      var value = await fireStore.collection(CollectionName.coupon).where('isVendorOffer', isEqualTo: true).get();

      for (var element in value.docs) {
        CouponModel couponModel = CouponModel.fromJson(element.data());
        couponModelList.add(couponModel);
      }
    } catch (e) {
      developer.log("getRestaurantOffer Error: $e");
    }
    return couponModelList;
  }

  static Future<bool> addCoupon(CouponModel couponModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.coupon).doc(couponModel.id).set(couponModel.toJson());

      ShowToastDialog.successToast("Coupon saved.".tr);
      return true;
    } catch (e) {
      developer.log("addCoupon Error: $e");
      return false;
    }
  }

  static Future<bool> addRestaurantOffer(CouponModel couponModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.coupon).doc(couponModel.id).set(couponModel.toJson());

      ShowToastDialog.successToast("Offer added to restaurant.".tr);
      return true;
    } catch (e) {
      developer.log("addRestaurantOffer Error: $e");
      return false;
    }
  }

  static Future<bool> updateCoupon(CouponModel couponModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.coupon).doc(couponModel.id).update(couponModel.toJson());

      ShowToastDialog.successToast("Coupon saved.".tr);
      return true;
    } catch (e) {
      developer.log("updateCoupon Error: $e");
      return false;
    }
  }

  static Future<bool> updateRestaurantOffer(CouponModel couponModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.coupon).doc(couponModel.id).update(couponModel.toJson());

      ShowToastDialog.successToast("Offer added to restaurant.".tr);
      return true;
    } catch (e) {
      developer.log("updateRestaurantOffer Error: $e");
      return false;
    }
  }

  static Future<bool> updateDocument(DocumentsModel documentModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.documents).doc(documentModel.id).update(documentModel.toJson());

      ShowToastDialog.successToast("Document saved.".tr);
      return true;
    } catch (e) {
      developer.log("updateDocument Error: $e");
      return false;
    }
  }

  static Future<bool?> updateDriverWallet({required String amount, required String userId}) async {
    try {
      DriverUserModel? userModel = await getDriverByDriverID(userId);
      if (userModel != null) {
        userModel.walletAmount = (double.parse(userModel.walletAmount.toString()) + double.parse(amount)).toString();
        return await updateDriver(userModel);
      }
    } catch (e) {
      developer.log("updateDriverWallet Error: $e");
    }
    return false;
  }

  static Future<bool?> updateOwnerWallet({required String amount, required String userId}) async {
    try {
      OwnerModel? ownerModel = await getOwnerByOwnerId(userId);
      if (ownerModel != null) {
        ownerModel.walletAmount = (double.parse(ownerModel.walletAmount.toString()) + double.parse(amount)).toString();
        return await updateNewOwner(ownerModel);
      }
    } catch (e) {
      developer.log("updateOwnerWallet Error: $e");
    }
    return false;
  }

  static Future<bool> updateUsers(UserModel userModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.customer).doc(userModel.id).update(userModel.toJson());
      return true;
    } catch (e) {
      developer.log("updateUsers Error: $e");
      return false;
    }
  }

  static Future<bool> updateOwner(OwnerModel ownerModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.owner).doc(ownerModel.id).update(ownerModel.toJson());
      return true;
    } catch (e) {
      developer.log("updateOwners Error: $e");
      return false;
    }
  }

  static Future<bool> updateVerifyDocuments(VerifyDriverModel verifyDriverModel, String driverID) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.verifyDriver).doc(driverID).update(verifyDriverModel.toJson());
      return true;
    } catch (e) {
      developer.log("updateVerifyDocuments Error: $e");
      return false;
    }
  }

  // static Future<bool> updateVerifyDocumentsRestaurant(VerifyRestaurantModel verifyDriverModel, String restaurantID) async {
  //   try {
  //     await FirebaseFirestore.instance.collection(CollectionName.verifyVendor).doc(restaurantID).update(verifyDriverModel.toJson());
  //     return true;
  //   } catch (e) {
  //     developer.log("updateVerifyDocumentsRestaurant Error: $e");
  //     return false;
  //   }
  // }

  static Future<bool> updateItems(ProductModel productModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.product).doc(productModel.id).update(productModel.toJson());
      return true;
    } catch (e) {
      developer.log("updateItems Error: $e");
      return false;
    }
  }

  static Future<bool> updateCategory(CategoryModel map) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.category).doc(map.id).update(map.toJson());
      return true;
    } catch (e) {
      developer.log("updateCategory Error: $e");
      return false;
    }
  }

  static Future<bool> addBanner(BannerModel bannerModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.banner).doc(bannerModel.id).set(bannerModel.toJson());
      return true;
    } catch (e) {
      developer.log("addBanner Error: $e");
      return false;
    }
  }

  static Future<bool> updateBanner(BannerModel bannerModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.banner).doc(bannerModel.id).update(bannerModel.toJson());
      return true;
    } catch (e) {
      developer.log("updateBanner Error: $e");
      return false;
    }
  }

  static Future<List<VendorModel>> getRestaurants(
    int pageNumber,
    int pageSize,
    String searchQuery,
    String searchType,
    DateTimeRange? dateTimeRange,
  ) async {
    List<VendorModel> restaurantList = [];
    DocumentSnapshot? lastDocument;

    try {
      Query query = FirebaseFirestore.instance.collection(CollectionName.vendors);

      if (searchQuery.isNotEmpty) {
        query = query.where(searchType, isGreaterThanOrEqualTo: searchQuery, isLessThan: "$searchQuery\uf8ff");
      }

      if (dateTimeRange != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: dateTimeRange.start).where('createdAt', isLessThanOrEqualTo: dateTimeRange.end);
      }

      query = query.orderBy('createdAt', descending: true);

      if (pageNumber > 1) {
        final previousDocs = await query.limit(pageSize * (pageNumber - 1)).get();
        if (previousDocs.docs.isNotEmpty) {
          lastDocument = previousDocs.docs.last;
        }
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.limit(pageSize).get();

      for (var doc in snapshot.docs) {
        restaurantList.add(VendorModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      developer.log("getRestaurants Error: $e");
    }

    return restaurantList;
  }

  static Future<List<OwnerModel>> getOwner(
    int pageNumber,
    int pageSize,
    String searchQuery,
    String searchType,
    DateTimeRange? dateTimeRange,
  ) async {
    List<OwnerModel> ownerList = [];
    DocumentSnapshot? lastDocument;

    try {
      Query query = FirebaseFirestore.instance.collection(CollectionName.owner);

      if (searchQuery.isNotEmpty) {
        query = query.where(searchType, isGreaterThanOrEqualTo: searchQuery, isLessThan: "$searchQuery\uf8ff");
      }

      if (dateTimeRange != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: dateTimeRange.start).where('createdAt', isLessThanOrEqualTo: dateTimeRange.end);
      }

      query = query.orderBy('createdAt', descending: true);

      if (pageNumber > 1) {
        final previousDocs = await query.limit(pageSize * (pageNumber - 1)).get();
        if (previousDocs.docs.isNotEmpty) {
          lastDocument = previousDocs.docs.last;
        }
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.limit(pageSize).get();

      for (var doc in snapshot.docs) {
        ownerList.add(OwnerModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      developer.log("getOwners Error: $e");
    }

    return ownerList;
  }

  static Future<bool> updateNewRestaurant(VendorModel restaurantModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.vendors).doc(restaurantModel.id).update(restaurantModel.toJson());
      return true;
    } catch (e) {
      developer.log("updateRestaurant Error: $e");
      return false;
    }
  }

  static Future<List<BannerModel>> getBanner() async {
    List<BannerModel> bannerModel = [];
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection(CollectionName.banner).get();
      for (var document in snap.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        if (data != null) {
          bannerModel.add(BannerModel.fromJson(data));
        }
      }
    } catch (e) {
      developer.log("getBanner Error: $e");
    }
    return bannerModel;
  }

  static Future<bool> addCancellingReason(List<String> reasonList) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.settings).doc("cancelling_reason").set({"reasons": reasonList});
      ShowToastDialog.successToast("Cancellation reason saved.".tr);
      return true;
    } catch (e) {
      developer.log("addCancellingReason Error: $e");
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
      return false;
    }
  }

  static Future<bool> addDriverCancellingReason(List<String> reasonList) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.settings).doc("driver_reject_reason").set({"reasons": reasonList});
      ShowToastDialog.successToast("Driver Cancelling Reason Saved...!".tr);
      return true;
    } catch (e) {
      developer.log("addDriverCancellingReason Error: $e");
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
      return false;
    }
  }

  static Future<bool> addItemTags(List<String> tags) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.settings).doc("item_tags").set({"tags": tags});
      ShowToastDialog.successToast("Item Tag Saved...!");
      return true;
    } catch (e) {
      developer.log("addItemTags Error: $e");
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
      return false;
    }
  }

  static Future<List<String>> getCancellingReason() async {
    List<String> reasonList = [];
    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.settings).doc("cancelling_reason").get();
      if (value.exists) {
        List<dynamic> data = value.data()?["reasons"] ?? [];
        reasonList.addAll(data.map((e) => e.toString()));
      }
    } catch (e) {
      developer.log("getCancellingReason Error: $e");
    }
    return reasonList;
  }

  static Future<List<String>> getDriverCancellingReason() async {
    final List<String> reasonList = [];
    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.settings).doc("driver_reject_reason").get();
      if (value.exists) {
        final List<dynamic> data = value.data()?["reasons"] ?? [];
        reasonList.addAll(data.map((element) => element.toString()));
      }
    } catch (e) {
      developer.log('Error fetching driver cancelling reasons: $e');
    }
    return reasonList;
  }

  static Future<List<String>> getItemTags() async {
    final List<String> tagsList = [];
    try {
      var value = await FirebaseFirestore.instance.collection(CollectionName.settings).doc("item_tags").get();
      if (value.exists) {
        final List<dynamic> data = value.data()?["tags"] ?? [];
        tagsList.addAll(data.map((element) => element.toString()));
      }
    } catch (e) {
      developer.log('Error fetching item tags: $e');
    }
    return tagsList;
  }

  static Future<List<TaxModel>> getTax() async {
    List<TaxModel> taxList = [];
    try {
      var value = await fireStore.collection(CollectionName.countryTax).get();
      for (var element in value.docs) {
        taxList.add(TaxModel.fromJson(element.data()));
      }
    } catch (e) {
      developer.log('Error fetching tax: $e');
    }
    return taxList;
  }

  static Future<bool> addTax(TaxModel taxModel) async {
    try {
      await fireStore.collection(CollectionName.countryTax).doc(taxModel.id).set(taxModel.toJson());
      ShowToastDialog.successToast("Tax Saved...!".tr);
      return true;
    } catch (e) {
      developer.log('Error adding tax: $e');
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
      return false;
    }
  }

  static Future<bool> updateTax(TaxModel taxModel) async {
    try {
      await fireStore.collection(CollectionName.countryTax).doc(taxModel.id).update(taxModel.toJson());
      ShowToastDialog.successToast("Tax Updated...!");
      return true;
    } catch (e) {
      developer.log('Error updating tax: $e');
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
      return false;
    }
  }

  static Future<bool> addCategory(CategoryModel categoryModel) async {
    try {
      await fireStore.collection(CollectionName.category).doc(categoryModel.id).set(categoryModel.toJson());

      ShowToastDialog.successToast("Category Saved...!".tr);
      return true;
    } catch (error) {
      developer.log('Error in addCategory: $error');
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
      return false;
    }
  }

  static Future<List<OrderModel>> getRecentBooking({String? status}) async {
    List<OrderModel> bookingModelList = [];
    try {
      var querySnapshot = await fireStore.collection(CollectionName.orders).orderBy('createdAt', descending: true).get();

      bookingModelList = querySnapshot.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    } catch (error) {
      developer.log('Error in getRecentBooking: $error');
    }
    return bookingModelList;
  }

  static Future<List<OrderModel>> getCompletedOrder(String restaurantId) async {
    List<OrderModel> bookingModelList = [];
    try {
      var querySnapshot = await fireStore
          .collection(CollectionName.orders)
          .where('vendorId', isEqualTo: restaurantId)
          .where('orderStatus', isEqualTo: 'order_complete')
          .orderBy('createdAt', descending: true)
          .get();

      bookingModelList = querySnapshot.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    } catch (error) {
      developer.log('Error in getCompletedOrder: $error');
    }
    return bookingModelList;
  }

  static Future<List<CuisineModel>> getCuisineList() async {
    List<CuisineModel> cuisineList = [];
    try {
      var snapshot = await fireStore.collection(CollectionName.cuisine).where("active", isEqualTo: true).get();

      cuisineList = snapshot.docs.map((e) => CuisineModel.fromJson(e.data())).toList();
    } catch (error) {
      developer.log('Error in getCuisineList: $error');
    }
    return cuisineList;
  }

  static Future<bool> addCuisine(CuisineModel cuisineModel) async {
    try {
      await fireStore.collection(CollectionName.cuisine).doc(cuisineModel.id).set(cuisineModel.toJson());

      ShowToastDialog.successToast("Cuisine Saved...!".tr);
      return true;
    } catch (error) {
      developer.log('Error in addCuisine: $error');
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
      return false;
    }
  }

  static Future<List<CuisineModel>> getAllCuisine() async {
    List<CuisineModel> cuisineModelList = [];
    try {
      var snap = await FirebaseFirestore.instance.collection(CollectionName.cuisine).get();

      cuisineModelList = snap.docs.map((doc) => CuisineModel.fromJson(doc.data())).toList();
    } catch (error) {
      developer.log('Error in getAllCuisine: $error');
    }
    return cuisineModelList;
  }

  static Future<bool> updateCuisine(CuisineModel cuisineModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.cuisine).doc(cuisineModel.id).update(cuisineModel.toJson());
      return true;
    } catch (error) {
      developer.log('Error in updateCuisine: $error');
      return false;
    }
  }

  static Future<List<VendorModel>> getAllRestaurant() async {
    List<VendorModel> restaurantList = [];
    try {
      var snap = await FirebaseFirestore.instance.collection(CollectionName.vendors).get();

      restaurantList = snap.docs.map((doc) => VendorModel.fromJson(doc.data())).toList();
    } catch (error) {
      developer.log('Error in getAllRestaurant: $error');
    }
    return restaurantList;
  }

  static Future<bool> addProduct(ProductModel productModel) async {
    try {
      await fireStore.collection(CollectionName.product).doc(productModel.id).set(productModel.toJson());
      ShowToastDialog.successToast("Item Saved...!".tr);
      return true;
    } catch (error) {
      developer.log('Error in addProduct: $error');
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
      return false;
    }
  }

  static Future<bool> updateProduct(ProductModel productModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.product).doc(productModel.id).update(productModel.toJson());
      ShowToastDialog.successToast("Item Updated...!".tr);
      return true;
    } catch (error) {
      developer.log('Error in updateProduct: $error');
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
      return false;
    }
  }

  static Future<List<OrderModel>> getAllOrderByDriver(String? status, String? driverId) async {
    try {
      final collection = fireStore.collection(CollectionName.orders);
      Query query = collection.where('driverId', isEqualTo: driverId);

      if (status != null && status != 'All') {
        query = query.where('orderStatus', isEqualTo: status);
      }

      final querySnapshot = await query.orderBy('createdAt', descending: true).get();
      return querySnapshot.docs.map((doc) => OrderModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (error) {
      developer.log('Error in getAllOrderByDriver: $error');
      return [];
    }
  }

  static Future<bool> addWalletTransaction(WalletTransactionModel walletTransactionModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.walletTransaction).doc(walletTransactionModel.id).set(walletTransactionModel.toJson());
      return true;
    } catch (error) {
      developer.log('Error in addWalletTransaction: $error');
      return false;
    }
  }

  static Future<List<WalletTransactionModel>> getWalletTransactionByUserId({required String userId, required String type}) async {
    List<WalletTransactionModel> transactions = [];
    try {
      final snapshot = await fireStore
          .collection(CollectionName.walletTransaction)
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: type)
          .orderBy('createdDate', descending: true)
          .get();

      transactions = snapshot.docs
          .map((doc) {
            try {
              return WalletTransactionModel.fromJson(doc.data());
            } catch (e) {
              developer.log('Error parsing WalletTransactionModel: $e');
              return null;
            }
          })
          .whereType<WalletTransactionModel>()
          .toList();
    } catch (error) {
      developer.log('Error in getWalletTransactionByUserId: $error');
    }
    return transactions;
  }

  static Future<List<BankDetailsModel>> getBankDetailsByUserId(String driverId) async {
    List<BankDetailsModel> bankDetailsList = [];
    try {
      final snapshot = await fireStore.collection(CollectionName.bankDetails).where('driverId', isEqualTo: driverId).get();

      bankDetailsList = snapshot.docs
          .map((doc) {
            try {
              return BankDetailsModel.fromJson(doc.data());
            } catch (e) {
              developer.log('Error parsing BankDetailsModel: $e');
              return null;
            }
          })
          .whereType<BankDetailsModel>()
          .toList();
    } catch (error) {
      developer.log('Error in getBankDetailsByUserId: $error');
    }
    return bankDetailsList;
  }

  static Future<List<VendorModel>> getVendorListByOwnerId(String ownerId) async {
    List<VendorModel> vendorList = [];
    await FirebaseFirestore.instance
        .collection(CollectionName.vendors) // use your actual restaurant collection
        .where("ownerId", isEqualTo: ownerId)
        .get()
        .then((value) {
      vendorList = value.docs.map((e) => VendorModel.fromJson(e.data())).toList();
    });
    return vendorList;
  }

  static Future<bool> addOnboardingScreen(OnboardingScreenModel onboardingModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.onboardingScreen).doc(onboardingModel.id).set(onboardingModel.toJson());
      return true;
    } catch (e) {
      developer.log("Error in add onboarding: $e");
      return false;
    }
  }

  static Future<bool> updateOnboardingScreen(OnboardingScreenModel onboardingModel) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.onboardingScreen).doc(onboardingModel.id).update(onboardingModel.toJson());
      return true;
    } catch (e) {
      developer.log("Error in update onboarding: $e");
      return false;
    }
  }

  static Future<List<OnboardingScreenModel>> getOnboardingScreen() async {
    List<OnboardingScreenModel> onboardingModel = [];
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection(CollectionName.onboardingScreen).orderBy("createdAt", descending: true).get();
      for (var document in snap.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        if (data != null) {
          onboardingModel.add(OnboardingScreenModel.fromJson(data));
        }
      }
    } catch (e) {
      developer.log("Error in getOnboarding: $e");
    }
    return onboardingModel;
  }
}
