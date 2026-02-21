import 'dart:developer' as developer;

import 'package:customer/app/models/add_address_model.dart';
import 'package:customer/app/models/banner_model.dart';
import 'package:customer/app/models/cart_model.dart';
import 'package:customer/app/models/category_model.dart';
import 'package:customer/app/models/location_lat_lng.dart';
import 'package:customer/app/models/product_model.dart';
import 'package:customer/app/models/vendor_model.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/extension/string_extensions.dart';
import 'package:customer/services/database_helper.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<bool> isLoading = false.obs;
  RxList<BannerModel> bannerList = <BannerModel>[].obs;

  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<VendorModel> restaurantList = <VendorModel>[].obs;
  RxList<VendorModel> top5RestaurantList = <VendorModel>[].obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  Rx<AddAddressModel> selectedAddress = AddAddressModel().obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  RxList<ProductModel> searchProductList = <ProductModel>[].obs;
  CartDatabaseHelper cartDatabaseHelper = CartDatabaseHelper();
  RxList<CartModel> cartItemsList = <CartModel>[].obs;

  final List<Color> colors = [
    const Color(0xff3232AA),
    const Color(0xff1E955E),
    const Color(0xff007F90),
  ];

  final List<String> svgPaths = [
    "assets/images/banner.svg",
    "assets/images/banner_1.svg",
    "assets/images/banner_2.svg",
  ];

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    categoryList.clear();
    restaurantList.clear();
    top5RestaurantList.clear();
    productList.clear();

    await getLocation();
    await FireStoreUtils.getProductList().then((value) {
      productList.addAll(value);
    });

    await FireStoreUtils.getBannerList().then((value) {
      bannerList.value = value;
    });

    await FireStoreUtils.getCategoryList().then((value) {
      categoryList.addAll(value);
    });

    if (FireStoreUtils.getCurrentUid() != null) {
      cartItemsList.value = await cartDatabaseHelper.getAllCartItems(FireStoreUtils.getCurrentUid().toString());
    }

    await getNearbyRestaurant();
    fetchTop5Restaurants();
    await searchFoodNearby();

    isLoading.value = false;

    update();
  }

  int getCartItemCount() {
    try {
      return cartItemsList.length;
    } catch (e, stack) {
      developer.log("Error getting cart item count: $e", stackTrace: stack);
      return 0;
    }
  }

  Future<void> fetchTop5Restaurants() async {
    List<VendorModel>? allRestaurants = restaurantList;

    if (allRestaurants.isEmpty) {
      return;
    }

    List<VendorModel> validRestaurants = allRestaurants.where((restaurant) {
      int reviewCount = int.tryParse(restaurant.reviewCount ?? '0') ?? 0;
      return reviewCount > 0;
    }).toList();

    validRestaurants.sort((a, b) {
      double aScore = (double.tryParse(a.reviewSum ?? '0') ?? 0) / (double.tryParse(a.reviewCount ?? '1') ?? 1);
      double bScore = (double.tryParse(b.reviewSum ?? '0') ?? 0) / (double.tryParse(b.reviewCount ?? '1') ?? 1);
      return bScore.compareTo(aScore);
    });

    List<VendorModel> top5 = validRestaurants.take(5).toList();

    if (top5.length < 5) {
      List<VendorModel> remainingRestaurants = allRestaurants.where((restaurant) {
        return !validRestaurants.contains(restaurant);
      }).toList();

      top5.addAll(remainingRestaurants.take(5 - top5.length));
    }

    top5RestaurantList.value = top5;
  }

  Future<void> getNearbyRestaurant() async {
    isLoading.value = true;

    try {
      restaurantList.value = await FireStoreUtils.getAllRestaurant(
          latitude: selectedAddress.value.location!.latitude!.toDouble(),
          longitude: selectedAddress.value.location!.longitude!.toDouble(),
          radiusKm: Constant.restaurantRadius.toDouble());
      restaurantList.refresh();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchFoodNearby() async {
    final query = searchController.value.text.trim().toLowerCase();
    if (query.isEmpty) {
      searchProductList.clear();
      return;
    }

    isLoading.value = true;

    try {
      List<String> vendorIds = restaurantList.map((e) => e.id ?? "").where((id) => id.isNotEmpty).toList();

      List<ProductModel> productList = await FireStoreUtils.getProductsFromVendorsWithSearch(
        vendorIds: vendorIds,
        query: query,
      );

      searchProductList.assignAll(productList);
    } catch (e, stack) {
      developer.log("Error searching food nearby: $e", error: e, stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getLocation() async {
    try {
      if (FireStoreUtils.getCurrentUid() != null && Constant.userModel != null && Constant.userModel!.addAddresses != null && Constant.userModel!.addAddresses!.isNotEmpty) {
        // Logged-in user: use default address
        selectedAddress.value = Constant.userModel!.addAddresses!.firstWhere(
          (element) => element.isDefault == true,
          orElse: () => Constant.userModel!.addAddresses!.first,
        );
        Constant.currentLocation = selectedAddress.value;
      } else {
        final placemarks = await placemarkFromCoordinates(Constant.currentLocation!.location!.latitude!, Constant.currentLocation!.location!.longitude!);
        final placeMark = placemarks.first;

        final fullAddress = "${placeMark.street}, ${placeMark.name}, ${placeMark.subLocality}, "
            "${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";

        AddAddressModel guestAddress = AddAddressModel(
          id: Constant.getUuid(),
          location: LocationLatLng(latitude: Constant.currentLocation!.location!.latitude, longitude: Constant.currentLocation!.location!.longitude),
          address: fullAddress,
          addressAs: "Home",
          isDefault: true,
          locality: placeMark.locality,
          landmark: placeMark.subLocality,
          name: "Guest",
        );

        selectedAddress.value = guestAddress;
        Constant.currentLocation = guestAddress;
      }

      Constant.country = (await placemarkFromCoordinates(
            selectedAddress.value.location!.latitude!,
            selectedAddress.value.location!.longitude!,
          ))[0]
              .country ??
          'Unknown';
    } catch (e, stack) {
      developer.log("Error in getLocation (HomeController)", error: e, stackTrace: stack);
    }
  }
}
