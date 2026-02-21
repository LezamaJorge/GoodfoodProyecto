import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/models/contact_us_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';

class ContactUsController extends GetxController {
  RxString title = "Contact Us".tr.obs;

  Rx<TextEditingController> emailSubjectController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;

  Rx<ContactUsModel> contactUsModel = ContactUsModel().obs;

  void setContactData() {
    if (emailSubjectController.value.text.isEmpty || emailController.value.text.isEmpty || phoneNumberController.value.text.isEmpty || addressController.value.text.isEmpty) {
      ShowToastDialog.errorToast("All fields are required.".tr);
    } else {
      Constant.waitingLoader();
      contactUsModel.value.emailSubject = emailSubjectController.value.text;
      contactUsModel.value.email = emailController.value.text;
      contactUsModel.value.phoneNumber = phoneNumberController.value.text;
      contactUsModel.value.address = addressController.value.text;

      FireStoreUtils.setContactusSetting(contactUsModel.value).then((value) {
        Get.back();
        ShowToastDialog.successToast("Contact details updated successfully.".tr);
      });
    }
  }

  void getContactData() {
    FireStoreUtils.getContactusSetting().then((value) {
      if (value != null) {
        contactUsModel.value = value;
        emailSubjectController.value.text = contactUsModel.value.emailSubject!;
        emailController.value.text = contactUsModel.value.email!;
        phoneNumberController.value.text = contactUsModel.value.phoneNumber!;
        addressController.value.text = contactUsModel.value.address!;
      }
    });
  }

  @override
  void onInit() {
    getContactData();
    super.onInit();
  }
}
