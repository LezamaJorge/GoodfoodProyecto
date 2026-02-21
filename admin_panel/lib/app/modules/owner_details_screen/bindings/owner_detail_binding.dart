
import 'package:get/get.dart';

import '../controllers/owner_detail_controller.dart';

class OwnerDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OwnerDetailController>(
      () => OwnerDetailController(),
    );
  }
}
