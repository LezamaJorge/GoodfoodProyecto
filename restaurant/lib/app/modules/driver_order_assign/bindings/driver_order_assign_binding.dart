import 'package:get/get.dart';

import '../controllers/driver_order_assign_controller.dart';

class DriverOrderAssignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverOrderAssignController>(
      () => DriverOrderAssignController(),
    );
  }
}
