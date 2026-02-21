import 'package:get/get.dart';

import '../controllers/foods_controller.dart';

class FoodsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodsController>(
      () => FoodsController(),
    );
  }
}
