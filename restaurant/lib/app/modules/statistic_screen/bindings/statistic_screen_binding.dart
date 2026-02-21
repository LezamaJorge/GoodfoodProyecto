import 'package:get/get.dart';

import '../controllers/statistic_screen_controller.dart';

class StatisticScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatisticScreenController>(
      () => StatisticScreenController(),
    );
  }
}
