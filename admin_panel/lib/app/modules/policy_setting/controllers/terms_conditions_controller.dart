
import 'package:admin_panel/app/models/constant_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

class TermsConditionsController extends GetxController {
  RxString title = "Terms & Condition".tr.obs;
  RxString result = ''.obs;


  Rx<ConstantModel> constantModel = ConstantModel().obs;


  Future<void> getSettingData() async {
    await FireStoreUtils.getGeneralSetting().then((value) async {
      if (value != null) {
        final document = parse(value.aboutApp!.toString());

        result.value = parse(document.body!.text).documentElement!.text;
        constantModel.value = value;
      }
    });
  }

  @override
  void onInit() {
    getSettingData();
    super.onInit();
  }

}
