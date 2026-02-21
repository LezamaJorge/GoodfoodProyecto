import 'package:get/get.dart';

import '../controllers/order_detail_screen_controller.dart';

class OrderDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailScreenController>(
      () => OrderDetailScreenController(),
    );
  }
}
