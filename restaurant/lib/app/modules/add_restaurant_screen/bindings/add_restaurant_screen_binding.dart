import 'package:get/get.dart';
import 'package:restaurant/app/modules/add_restaurant_screen/controllers/add_restaurant_screen_controller.dart';

class AddRestaurantScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddRestaurantScreenController>(
      () => AddRestaurantScreenController(),
    );
  }
}
