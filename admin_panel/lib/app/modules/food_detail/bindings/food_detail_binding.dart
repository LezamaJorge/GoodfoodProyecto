import 'package:admin_panel/app/modules/food_detail/controllers/food_detail_controller.dart';
import 'package:get/get.dart';

class FoodDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodDetailController>(() => FoodDetailController());
  }
}
