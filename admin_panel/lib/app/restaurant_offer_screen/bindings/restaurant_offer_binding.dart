import 'package:admin_panel/app/restaurant_offer_screen/controllers/restaurant_offer_controller.dart';
import 'package:get/get.dart';


class BannerScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestaurantOfferController>(
      () => RestaurantOfferController(),
    );
  }
}
