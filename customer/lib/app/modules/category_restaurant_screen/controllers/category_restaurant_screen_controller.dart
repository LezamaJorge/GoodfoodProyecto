import 'dart:developer' as developer;

import 'package:customer/app/models/cart_model.dart';
import 'package:customer/app/models/category_model.dart';
import 'package:customer/app/models/product_model.dart';
import 'package:customer/app/models/vendor_model.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/services/database_helper.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryRestaurantScreenController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<VendorModel> allRestaurantList = <VendorModel>[].obs;
  RxList<VendorModel> vegRestaurantList = <VendorModel>[].obs;
  RxList<VendorModel> nonVegRestaurantList = <VendorModel>[].obs;
  RxList<VendorModel> topRatedRestaurantList = <VendorModel>[].obs;
  Rx<VendorModel> restaurantModel = VendorModel().obs;
  Rx<CategoryModel> categoryModel = CategoryModel().obs;
  var selectedType = 0.obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<dynamic> restaurantIdList = <dynamic>[].obs;
  RxList<VendorModel> top5RestaurantList = <VendorModel>[].obs;
  CartDatabaseHelper cartDatabaseHelper = CartDatabaseHelper();
  RxList<CartModel> cartItemsList = <CartModel>[].obs;

  @override
  void onInit() {
    getArgument();
    // getNearbyRestaurant();
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      categoryModel.value = argumentData['categoryModel'];

      await FireStoreUtils.getCategoryProductList(categoryModel.value.id!).then((value) {
        productList.addAll(value);

        Set<String> uniqueRestaurantIds = {};
        for (var product in productList) {
          if (product.vendorId != null) {
            uniqueRestaurantIds.add(product.vendorId!);
          }
        }
        restaurantIdList.addAll(uniqueRestaurantIds);
      });

      getData();
    } else {}
  }

  Future<void> getData() async {
    // isLoading.value = true;
    allRestaurantList.clear();
    vegRestaurantList.clear();
    nonVegRestaurantList.clear();
    allRestaurantList.value = await FireStoreUtils.getAllRestaurant(
        latitude: Constant.currentLocation!.location!.latitude!.toDouble(),
        longitude: Constant.currentLocation!.location!.longitude!.toDouble(),
        radiusKm: Constant.restaurantRadius.toDouble());

    var filteredRestaurants = allRestaurantList.where((restaurant) {
      return restaurantIdList.contains(restaurant.id);
    }).toList();

    allRestaurantList.addAll(filteredRestaurants);

    for (var restaurant in filteredRestaurants) {
      if (restaurant.vendorType != null) {
        if (restaurant.vendorType == "Veg") {
          vegRestaurantList.add(restaurant);
        } else if (restaurant.vendorType == "Non veg") {
          nonVegRestaurantList.add(restaurant);
        }
      }
    }

    if (FireStoreUtils.getCurrentUid() != null) {
      cartItemsList.value = await cartDatabaseHelper.getAllCartItems(FireStoreUtils.getCurrentUid().toString());
    }

    fetchTop5Restaurants();

    isLoading.value = false;
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
    List<VendorModel>? allRestaurants = allRestaurantList;

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
      return bScore.compareTo(aScore); // Descending order
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
}
