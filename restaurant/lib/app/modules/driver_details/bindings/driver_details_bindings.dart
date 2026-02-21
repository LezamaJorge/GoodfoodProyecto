import 'package:get/get.dart';
import 'package:restaurant/app/modules/driver_details/controllers/driver_details_controllers.dart';

class DriverDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverDetailsControllers>(
      () => DriverDetailsControllers(),
    );
  }
}
