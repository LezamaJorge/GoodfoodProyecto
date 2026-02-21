import 'package:admin_panel/app/modules/verify_document_screen/controllers/verify_delivery_boy_controller.dart';
import 'package:get/get.dart';


class NewRestaurantJoinRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyDeliveryBoyController>(
      () => VerifyDeliveryBoyController(),
    );
  }
}
