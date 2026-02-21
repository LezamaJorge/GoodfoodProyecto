import 'package:admin_panel/app/modules/customer_detail_screen/controllers/customer_detail_screen_controller.dart';
import 'package:get/get.dart';

class CustomerDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerDetailScreenController>(
      () => CustomerDetailScreenController(),
    );
  }
}
