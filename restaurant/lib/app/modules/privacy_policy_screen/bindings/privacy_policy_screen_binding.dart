import 'package:get/get.dart';
import 'package:restaurant/app/modules/privacy_policy_screen/controllers/privacy_policy_screen_controller.dart';

class PrivacyPolicyScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyPolicyScreenController>(() => PrivacyPolicyScreenController());
  }
}
