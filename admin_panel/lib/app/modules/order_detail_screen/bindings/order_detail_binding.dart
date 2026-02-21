
import 'package:admin_panel/app/modules/order_detail_screen/controllers/order_detail_controller.dart';
import 'package:get/get.dart';

class OrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailController>(
      () => OrderDetailController(),
    );
  }
}
