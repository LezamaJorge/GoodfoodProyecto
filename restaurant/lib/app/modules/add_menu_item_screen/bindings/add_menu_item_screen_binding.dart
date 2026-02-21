import 'package:get/get.dart';

import '../controllers/add_menu_item_screen_controller.dart';

class AddMenuItemScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddMenuItemsScreenController>(
      () => AddMenuItemsScreenController(),
    );
  }
}
