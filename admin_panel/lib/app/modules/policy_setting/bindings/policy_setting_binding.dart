import 'package:admin_panel/app/modules/policy_setting/controllers/policy_setting_controller.dart';
import 'package:get/get.dart';

class PolicySettingBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut<PolicySettingController>(()=>PolicySettingController());
  }
}