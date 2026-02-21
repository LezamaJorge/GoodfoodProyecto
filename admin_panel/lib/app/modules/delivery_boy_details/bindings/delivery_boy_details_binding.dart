import 'package:admin_panel/app/modules/delivery_boy_details/controllers/delivery_boy_details_controller.dart';
import 'package:get/get.dart';

class DeliveryBoyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryBoyDetailsController>(() => DeliveryBoyDetailsController());
  }
}
