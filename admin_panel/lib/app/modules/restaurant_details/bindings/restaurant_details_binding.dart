import 'package:admin_panel/app/modules/restaurant_details/controllers/restaurant_details_controller.dart';
import 'package:get/get.dart';

class RestaurantDetailsBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut<RestaurantDetailsController>(()=>RestaurantDetailsController());
  }
}