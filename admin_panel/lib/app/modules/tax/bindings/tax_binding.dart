import 'package:admin_panel/app/modules/tax/controllers/tax_controller.dart';
import 'package:get/get.dart';

class TaxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaxController>(() => TaxController());
  }
}
