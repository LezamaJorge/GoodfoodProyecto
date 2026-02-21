import 'package:customer/app/modules/category_screen/controllers/category_screen_controller.dart';
import 'package:get/get.dart';

class CategoryScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryScreenController>(() => CategoryScreenController());
  }
}
