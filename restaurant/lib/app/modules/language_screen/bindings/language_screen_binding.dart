import 'package:get/get.dart';
import 'package:restaurant/app/modules/language_screen/controllers/language_screen_controller.dart';

class LanguageScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageScreenController>(
      () => LanguageScreenController(),
    );
  }
}
