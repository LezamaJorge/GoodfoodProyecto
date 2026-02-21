import 'package:admin_panel/app/modules/owner/controllers/owner_controller.dart';
import 'package:get/get.dart';

class OwnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OwnerController>(
      () => OwnerController(),
    );
  }
}
