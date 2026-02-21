import 'package:admin_panel/app/modules/delivery_boy/controllers/delivery_boy_controller.dart';
import 'package:get/get.dart';

class DeliveryBoyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryBoyController>(
      () => DeliveryBoyController(),
    );
  }
}
