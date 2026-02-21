import 'package:customer/app/modules/my_banks/controllers/my_banks_controller.dart';
import 'package:get/get.dart';

class MyBanksBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<MyBanksController>(()=>MyBanksController());
  }
}
