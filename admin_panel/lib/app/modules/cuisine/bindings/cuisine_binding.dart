import 'package:admin_panel/app/modules/cuisine/controllers/cuisine_controller.dart';
import 'package:get/get.dart';

class CuisineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CuisineController>(
      () => CuisineController(),
    );
  }
}
