import 'package:admin_panel/app/modules/driver_cancelling_reason/controllers/driver_cancelling_reason_controller.dart';
import 'package:get/get.dart';

class DriverCancellingReasonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverCancellingReasonController>(
          () => DriverCancellingReasonController(),
    );
  }
}
