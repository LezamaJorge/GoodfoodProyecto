import 'dart:developer' as developer;

import 'package:customer/app/models/user_model.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:get/get.dart';


class ProfileScreenController extends GetxController {
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    try {
      if(FireStoreUtils.getCurrentUid() != null){
        userModel.value = Constant.userModel!;
        update();
      }

    } catch (e, stack) {
      developer.log("Error getting user data: $e", stackTrace: stack);
    }
  }
}
