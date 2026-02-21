import 'package:admin_panel/app/modules/cancelling_reason/controllers/cancelling_reason_controller.dart';
import 'package:get/get.dart';

class CancellingReasonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancellingReasonController>(
          () => CancellingReasonController(),
    );
  }
}
