import 'package:admin_panel/app/modules/add_onboarding/controllers/add_onboarding_controller.dart';
import 'package:get/get.dart';

class AddOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddOnboardingController>(() => AddOnboardingController());
  }
}
