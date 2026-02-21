import 'package:customer/app/modules/home/views/home_view.dart';
import 'package:customer/app/modules/my_wallet/views/my_wallet_view.dart';
import 'package:customer/app/modules/order_screen/views/order_screen_view.dart';
import 'package:customer/app/modules/profile_screen/views/profile_screen_view.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class DashboardScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxList pageList = [
    const HomeView(),
    const OrderScreenView(),
    const MyWalletView(),
    const ProfileScreenView()].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    if(FireStoreUtils.getCurrentUid() != null){
      await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()!);
    }
  }
}
