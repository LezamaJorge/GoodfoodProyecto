import 'package:admin_panel/app/modules/pauout_request/controllers/payout_request_controller.dart';
import 'package:get/get.dart';

class PayoutRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayoutRequestController>(
      () => PayoutRequestController(),
    );
  }
}
