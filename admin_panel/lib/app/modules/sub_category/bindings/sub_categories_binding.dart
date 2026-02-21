import 'package:admin_panel/app/modules/sub_category/controllers/sub_categories_controller.dart';
import 'package:get/get.dart';

class SubCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubCategoryController>(
      () => SubCategoryController(),
    );
  }
}
