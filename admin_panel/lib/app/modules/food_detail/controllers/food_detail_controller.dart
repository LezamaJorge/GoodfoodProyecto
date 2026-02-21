
import 'package:admin_panel/app/models/product_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class FoodDetailController extends GetxController {
  RxString title = "Food Details".tr.obs;
  RxBool isLoading = true.obs;
  Rx<ProductModel> productModel = ProductModel().obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    String productId = Get.parameters['productId']!;
    await FireStoreUtils.getProductByProductId(productId).then((value) {
      if (value != null) {
        productModel.value = value;
      }
    });
    isLoading.value = false;
  }

  double calculateReview(double reviewSum, double reviewCount) {
    if (reviewCount == 0) {
      return 0;
    }
    double averageRating = reviewSum / reviewCount;
    return (averageRating / 10) * 5;
  }
}
