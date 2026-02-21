import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant/app/modules/profile_screen/controllers/profile_screen_controller.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

class EditProfileScreenController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
  Rx<String?> countryCode = "+91".obs;
  Rx<bool> isLoading = false.obs;
  RxString profileImage = "".obs;
  final ImagePicker imagePicker = ImagePicker();

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    try {
      firstNameController.value.text = Constant.ownerModel!.firstName.toString();
      lastNameController.value.text = Constant.ownerModel!.lastName.toString();
      emailController.value.text = Constant.ownerModel!.email.toString();
      mobileNumberController.value.text = Constant.ownerModel!.phoneNumber.toString();
      profileImage.value = Constant.ownerModel!.profileImage.toString();
    } catch (e, stack) {
      developer.log("Error loading data: $e", stackTrace: stack);
    }
  }

  Future<void> updateProfile() async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    try {
      if (profileImage.value.isNotEmpty && !Constant.hasValidUrl(profileImage.value)) {
        profileImage.value = await Constant.uploadImageToFireStorage(
          File(profileImage.value),
          "profileImage/${FireStoreUtils.getCurrentUid()}",
          File(profileImage.value).path.split('/').last,
        );
      }

      Constant.ownerModel!.profileImage = profileImage.value;
      Constant.ownerModel!.firstName = firstNameController.value.text;
      Constant.ownerModel!.lastName = lastNameController.value.text;
      Constant.ownerModel!.email = emailController.value.text;
      Constant.ownerModel!.phoneNumber = mobileNumberController.value.text;

      await FireStoreUtils.updateOwner(Constant.ownerModel!).then((value) {
        firstNameController.value.clear();
        lastNameController.value.clear();
        emailController.value.clear();
        mobileNumberController.value.clear();
        ProfileScreenController profileScreenController = Get.put(ProfileScreenController());
        profileScreenController.getData();
        ShowToastDialog.toast("Saved successfully.".tr);
        Get.back();
      });
    } catch (e, stack) {
      developer.log("Error updating profile: $e", stackTrace: stack);
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> pickFile({required ImageSource source}) async {
    isLoading.value = true;
    try {
      XFile? image = await imagePicker.pickImage(source: source, imageQuality: 100);
      if (image == null) return;

      Get.back();
      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 25,
      );
      File compressedFile = File(image.path);
      await compressedFile.writeAsBytes(compressedBytes!);

      profileImage.value = compressedFile.path;
    } on PlatformException catch (e, stack) {
      developer.log("Error picking image: $e", stackTrace: stack);
    } catch (e, stack) {
      developer.log("Unexpected error picking image: $e", stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }
}
