// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/models/vendor_model.dart';
import 'package:admin_panel/app/models/review_model.dart';
import 'package:admin_panel/app/modules/restaurant_details/controllers/restaurant_details_controller.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RestaurantReviewController extends GetxController {
  RxString title = "Review".tr.obs;
  RxBool isLoading = true.obs;
  RxBool isEditing = false.obs;

  RxList<ReviewModel> reviewList = <ReviewModel>[].obs;
  Rx<VendorModel> restaurantModel = VendorModel().obs;

  RxList<ReviewModel> currentPageRestaurantReview = <ReviewModel>[].obs;

  RxDouble rating = 0.0.obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;

  int total1Length = 0;
  int total2Length = 0;
  int total3Length = 0;
  int total4Length = 0;
  int total5Length = 0;

  @override
  void onInit() {
    RestaurantDetailsController restaurantDetailsController = Get.put(RestaurantDetailsController());
    restaurantModel.value = restaurantDetailsController.restaurantModel.value;
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getData();
    calculateRatingCounts(restaurantModel.value.id!);
    super.onInit();
  }

  double calculatePercentage(int value, int total) {
    // if (total == 0) return 0.0;
    // return (value / total) / 5;
    if (total == 0) return 0.0;
    return (value / total) * 0.10;
  }

  Future<void> getData() async {
    isLoading.value = true;
    await FireStoreUtils.countRestaurantReview(restaurantModel.value.id.toString());
    setPagination(totalItemPerPage.value);
    rating.value = double.parse(
      Constant.calculateReview(
        reviewCount: restaurantModel.value.reviewCount!,
        reviewSum: restaurantModel.value.reviewSum!,
      ),
    );
    isLoading.value = false;
  }

  Future<void> calculateRatingCounts(String restaurantId) async {
    try {
      // Initialize variables for each rating count

      // Reference to the reviews collection filtered by restaurantId
      final Query<Map<String, dynamic>> reviewsQuery = FirebaseFirestore.instance.collection(CollectionName.reviewCustomer).where('vendorId', isEqualTo: restaurantId);

      final QuerySnapshot<Map<String, dynamic>> reviewsSnapshot = await reviewsQuery.get();

      for (var doc in reviewsSnapshot.docs) {
        String? rating = doc.data()['rating'] as String?;

        if (rating != null) {
          double ratingValue = double.tryParse(rating) ?? 0.0;

          int roundedRating = ratingValue.floor();

          if (roundedRating == 1.0) {
            total1Length++;
          } else if (roundedRating == 2.0) {
            total2Length++;
          } else if (roundedRating == 3.0) {
            total3Length++;
          } else if (roundedRating == 4.0) {
            total4Length++;
          } else if (roundedRating == 5.0) {
            total5Length++;
          }
        }
      }
    } catch (e) {
      log('Error calculating rating counts: $e');
    }
  }

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return reviewList.length;
    } else {
      return int.parse(data);
    }
  }

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.restaurantReviewLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.restaurantReviewLength! ? Constant.restaurantReviewLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<ReviewModel> currentPageDriverData = await FireStoreUtils.getRestaurantReview(currentPage.value, itemPerPage, "", "", restaurantModel.value.id.toString());
        currentPageRestaurantReview.value = currentPageDriverData;
      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
  }
}
