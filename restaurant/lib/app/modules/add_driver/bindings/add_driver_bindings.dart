import 'package:get/get.dart';
import '../controllers/add_driver_controllers.dart';

class AddDriverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddDriverController>(
      () => AddDriverController(),
    );
  }
}
