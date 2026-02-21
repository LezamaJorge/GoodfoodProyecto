import 'dart:developer' as developer;
import 'package:customer/app/models/product_model.dart';
import 'package:customer/app/models/vendor_model.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/extension/string_extensions.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchFoodScreenController extends GetxController {
  Rx<TextEditingController> searchController = TextEditingController().obs;
  RxList<ProductModel> searchProductList = <ProductModel>[].obs;
  RxBool isLoading = false.obs;
  RxList<VendorModel> restaurants = <VendorModel>[].obs;
  Future<void> searchFoodNearby({
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    final query = searchController.value.text.trim().toLowerCase();
    if (query.isEmpty) {
      searchProductList.clear();
      return;
    }

    isLoading.value = true;

    try {
      restaurants.value = await FireStoreUtils.getAllRestaurant(
        latitude: latitude,
        longitude: longitude,
          radiusKm: Constant.restaurantRadius.toDouble()
      );

      List<String> vendorIds = restaurants.map((e) => e.id ?? "").where((id) => id.isNotEmpty).toList();

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


  // Future<void> searchFood() async {
  //   final query = searchController.value.text.trim();
  //   if (query.isEmpty) {
  //     searchProductList.clear();
  //     return;
  //   }
  //
  //   isLoading.value = true;
  //
  //   try {
  //     List<ProductModel>? productList = await FireStoreUtils.getProductListByName(query);
  //     searchProductList.assignAll(productList);
  //       } catch (e, stack) {
  //     developer.log("Error searching food: $e", error: e, stackTrace: stack);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
