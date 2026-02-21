import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:restaurant/app/modules/home/views/home_view.dart';
import 'package:restaurant/app/modules/menu_screen/views/menu_screen_view.dart';
import 'package:restaurant/app/modules/profile_screen/views/profile_screen_view.dart';
import 'package:restaurant/app/modules/restaurant_screen/views/restaurant_screen_view.dart';
import 'package:restaurant/app/modules/statistic_screen/views/statistic_screen_view.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

import '../../../../constant/show_toast_dialogue.dart';

class DashboardScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxList pageList = [const HomeView(), const StatisticScreenView(), RestaurantScreenView(), const MenuScreenView(), const ProfileScreenView()].obs;

  @override
  void onInit() {
    getData();
    redirectScreen();
    super.onInit();
  }

  Future<void> getData() async {
    try {
      await FireStoreUtils.getOwnerProfile(FireStoreUtils.getCurrentUid()!);

      if (Constant.ownerModel != null && Constant.ownerModel!.vendorId != null && Constant.ownerModel!.vendorId!.isNotEmpty) {
        await FireStoreUtils.getRestaurant(Constant.ownerModel!.vendorId.toString()).then((value) {
          Constant.vendorModel = value;
        });
      } else {
        Constant.vendorModel = null;
      }
    } catch (e, stack) {
      developer.log("Error fetching owner/restaurant data: $e", stackTrace: stack);
      ShowToastDialog.toast("Failed to fetch owner/restaurant data".tr);
    }
  }

  void redirectScreen() {
    try {
      if (Constant.ownerModel != null) {
        selectedIndex.value = Constant.ownerModel!.isVerified == false ? 2 : 0;
      }
    } catch (e, stack) {
      developer.log("Error redirecting screen: $e", stackTrace: stack);
    }
  }
}
