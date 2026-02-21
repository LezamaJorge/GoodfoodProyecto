import 'package:get/get.dart';
import 'package:restaurant/app/modules/order_screen/controllers/order_screen_controller.dart';


class OrderScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderScreenController>(
      () => OrderScreenController(),
    );
  }
}
