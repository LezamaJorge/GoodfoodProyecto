
import 'package:admin_panel/app/models/order_model.dart';
import 'package:admin_panel/app/models/user_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:get/get.dart';


class CustomerDetailScreenController extends GetxController {
  RxString title = "User Detail".tr.obs;
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;
  RxList<OrderModel> bookingList = <OrderModel>[].obs;
  RxInt totalOrders = 0.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    String userId = Get.parameters['userId']!;
    await FireStoreUtils.getUserByUserID(userId).then((value) {
      if (value != null) {
        userModel.value = value;
      }
    });

    await getOrders();
    totalOrders.value = await FireStoreUtils.countOrdersByCustomerId(userModel.value.id.toString());
  }

  Future<void> getOrders() async {
    isLoading.value = true;
    bookingList.value = await FireStoreUtils.getOrderByUserId(userModel.value.id);
    isLoading.value = false;
  }
}
