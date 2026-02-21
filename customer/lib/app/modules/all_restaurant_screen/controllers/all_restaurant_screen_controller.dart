import 'dart:developer' as developer;

import 'package:customer/app/models/cart_model.dart';
import 'package:customer/app/models/vendor_model.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/extension/string_extensions.dart';
import 'package:customer/services/database_helper.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class AllRestaurantScreenController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<VendorModel> allRestaurantList = <VendorModel>[].obs;
  RxList<VendorModel> vegRestaurantList = <VendorModel>[].obs;
  RxList<VendorModel> nonVegRestaurantList = <VendorModel>[].obs;
  RxList<VendorModel> topRatedRestaurantList = <VendorModel>[].obs;
  Rx<VendorModel> restaurantModel = VendorModel().obs;
  var selectedType = 0.obs;

  CartDatabaseHelper cartDatabaseHelper = CartDatabaseHelper();
  RxList<CartModel> cartItemsList = <CartModel>[].obs;

  @override
  void onInit() {
    getData(isAllRestaurantFetch: true, isVegRestaurantFetch: true, isNonVegRestaurantFetch: true, isTopRatedRestaurantFetch: true);
    super.onInit();
  }

  Future<void> getData(
      {required bool isAllRestaurantFetch, required bool isVegRestaurantFetch, required bool isNonVegRestaurantFetch, required bool isTopRatedRestaurantFetch}) async {
    if (isAllRestaurantFetch) {
      allRestaurantList.value = await FireStoreUtils.getAllRestaurant(
          latitude: Constant.currentLocation!.location!.latitude!.toDouble(),
          longitude: Constant.currentLocation!.location!.longitude!.toDouble(),
          radiusKm: Constant.restaurantRadius.toDouble());
    }
    if (isVegRestaurantFetch) {
      vegRestaurantList.value = (await FireStoreUtils.getVegRestaurant(
          latitude: Constant.currentLocation!.location!.latitude!.toDouble(),
          longitude: Constant.currentLocation!.location!.longitude!.toDouble(),
          radius: Constant.restaurantRadius.toDouble()));
    }
    if (isNonVegRestaurantFetch) {
      nonVegRestaurantList.value = (await FireStoreUtils.getNonVegRestaurant(
          latitude: Constant.currentLocation!.location!.latitude!.toDouble(),
          longitude: Constant.currentLocation!.location!.longitude!.toDouble(),
          radius: Constant.restaurantRadius.toDouble()));
    }
    if (isTopRatedRestaurantFetch) {
      topRatedRestaurants(
          latitude: Constant.currentLocation!.location!.latitude!.toDouble(),
          longitude: Constant.currentLocation!.location!.longitude!.toDouble(),
          radius: Constant.restaurantRadius.toDouble());
    }
    isLoading.value = false;
  }

  Future<void> topRatedRestaurants({
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    final validRestaurants = allRestaurantList.where((restaurant) {
      final reviewCount = int.tryParse(restaurant.reviewCount ?? '0') ?? 0;
      return reviewCount > 0;
    }).toList();

    validRestaurants.sort((a, b) {
      final aScore = (double.tryParse(a.reviewSum ?? '0') ?? 0) / (double.tryParse(a.reviewCount ?? '1') ?? 1);
      final bScore = (double.tryParse(b.reviewSum ?? '0') ?? 0) / (double.tryParse(b.reviewCount ?? '1') ?? 1);
      return bScore.compareTo(aScore);
    });

    topRatedRestaurantList.value = validRestaurants;
  }

  int getCartItemCount() {
    try {
      return cartItemsList.length;
    } catch (e, stack) {
      developer.log("Error getting cart item count: $e", stackTrace: stack);
      return 0;
    }
  }
}
