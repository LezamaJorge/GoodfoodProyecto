import 'package:admin_panel/app/modules/finance_setting/controllers/finance_controller.dart';
import 'package:get/get.dart';

class FinanceSettingBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut<FinanceSettingController>(()=>FinanceSettingController());
  }
}