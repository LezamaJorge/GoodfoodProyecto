import 'package:admin_panel/app/modules/item_tages_screen/controllers/item_tags_controller.dart';
import 'package:get/get.dart';

class ItemTagsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemTagsController>(
          () => ItemTagsController(),
    );
  }
}
