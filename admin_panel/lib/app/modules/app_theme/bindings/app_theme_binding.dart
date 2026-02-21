import 'package:admin_panel/app/modules/app_theme/controllers/app_theme_controller.dart';
import 'package:get/get.dart';


class AppThemeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppThemeController>(
          () => AppThemeController(),
    );
  }
}