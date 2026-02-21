// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/location_lat_lng.dart';
import '../../../models/owner_model.dart';
import '../../../pdf_generate/generate_pdf_owner.dart';

class OwnerController extends GetxController {
  RxString title = "Owner".tr.obs;
  RxBool isLoading = true.obs;
  RxBool isEditing = false.obs;
  Rx<OwnerModel> ownerModel = OwnerModel().obs;

  RxList<OwnerModel> currentPageOwnerList = <OwnerModel>[].obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<TextEditingController> imageController = TextEditingController().obs;
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<String> countryCode = '+91'.obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  RxString selectedSearchTypeForData = "Name".obs;
  RxString selectedSearchType = "Name".obs;
  List<String> searchType = [
    "Name",
    "Email",
  ];

  Rx<File> imagePath = File('').obs;
  RxString imageURL = "".obs;
  RxString mimeType = 'image/png'.obs;
  Rx<Uint8List> imagePickedFileBytes = Uint8List(0).obs;
  RxBool uploading = false.obs;
  RxString editingId = ''.obs;

  RxString totalItemPerPage = '0'.obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxString selectedDateOption = "All".obs;
  DateTime? startDate;
  DateTime? endDate;
  List<String> dateOption = ["All", "Last Month", "Last 6 Months", "Last Year", "Custom"];
  RxBool isSearchEnable = true.obs;
  Rx<TextEditingController> dateRangeController = TextEditingController().obs;
  RxString selectedDateOptionForPdf = "All".obs;
  Rx<DateTimeRange> selectedDateRangeForPdf =
      (DateTimeRange(start: DateTime(DateTime
          .now()
          .year, DateTime.january, 1),
          end: DateTime(
              DateTime
                  .now()
                  .year,
              DateTime
                  .now()
                  .month,
              DateTime
                  .now()
                  .day,
              23,
              59,
              0,
              0))).obs;
  RxBool isCustomVisible = false.obs;
  DateTime? startDateForPdf;
  DateTime? endDateForPdf;
  RxBool isHistoryDownload = false.obs;
  RxBool isPasswordVisible = true.obs;


  Rx<LocationLatLng> locationLatLng = LocationLatLng().obs;

  Rx<DateTimeRange> selectedDateRange = (DateTimeRange(
    start: DateTime(
      DateTime
          .now()
          .year,
      DateTime
          .now()
          .month - 5,
      1,
    ),
    end: DateTime(
      DateTime
          .now()
          .year,
      DateTime
          .now()
          .month,
      DateTime
          .now()
          .day,
      23,
      59,
      59,
      999,
    ),
  )).obs;

  @override
  void onInit() {
    super.onInit();
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    setPagination(totalItemPerPage.value);
  }

  Future<void> getOwner() async {
    isLoading.value = true;
    await FireStoreUtils.countOwners();
    isLoading.value = false;
  }

  void getArgument(OwnerModel ownerModels) {
    ownerModel.value = ownerModels;
    isEditing.value = true;

    imagePath.value = File("");
    firstNameController.value.text = ownerModel.value.firstName!;
    lastNameController.value.text = ownerModel.value.lastName!;
    emailController.value.text = ownerModel.value.email!;
    countryCode.value = ownerModel.value.countryCode!;
    phoneNumberController.value.text = ownerModel.value.phoneNumber!;
    if (ownerModel.value.profileImage != null && ownerModel.value.profileImage!.isNotEmpty) {
      imageController.value.text = ownerModel.value.profileImage!;
      imageURL.value = ownerModel.value.profileImage!;
    }
    editingId.value = ownerModel.value.id!;
  }

  int pageValue(String data) {
    if (data == 'All') {
      return Constant.ownerLength!;
    } else {
      return int.parse(data);
    }
  }

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.ownerLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.ownerLength! ? Constant.ownerLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<OwnerModel> currentPageOwner =
        await FireStoreUtils.getOwner(currentPage.value, itemPerPage, searchController.value.text, selectedSearchTypeForData.value, selectedDateRange.value);
        currentPageOwnerList.value = currentPageOwner;
      } catch (error) {
        if (kDebugMode) {}
      }
    }
    update();
    isLoading.value = false;
  }

  List<OwnerModel> ownerList = [];

  Future<void> downloadOrdersPdf(BuildContext context) async {
    isHistoryDownload(true);
    ownerList = await FireStoreUtils.dataForOwnerPdf(selectedDateRangeForPdf.value);
    await generateOwnerExcelWeb(ownerList, selectedDateRangeForPdf.value);
    if (context.mounted) {
      Navigator.pop(context);
    }
    isHistoryDownload(false);
  }

  Future<void> getSearchType() async {
    isLoading.value = true;
    if (selectedSearchType.value == "Email") {
      selectedSearchTypeForData.value = "email";
    } else {
      selectedSearchTypeForData.value = "slug";
    }
    isLoading.value = false;
  }

  Future<void> removeOwners(OwnerModel ownerModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.owner).doc(ownerModel.id).delete().then((value) {
      ShowToastDialog.successToast("Owner deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }

  Future<void> updateOwner() async {
    Constant.waitingLoader();
    if (imagePath.value.path.isNotEmpty) {
      String? downloadUrl = await FireStoreUtils.uploadPic(PickedFile(imagePath.value.path), "profileImage".tr, editingId.value, mimeType.value);
      ownerModel.value.profileImage = downloadUrl;
    }
    ownerModel.value.id = editingId.value;
    ownerModel.value.firstName = firstNameController.value.text;
    ownerModel.value.lastName = lastNameController.value.text;
    ownerModel.value.slug = ownerModel.value.fullNameString().toSlug(delimiter: '-');
    bool isSaved = await FireStoreUtils.updateOwner(ownerModel.value);
    if (isSaved) {
      Get.back();
      getOwner();
      ShowToastDialog.successToast("Owner data updated".tr);
    } else {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
      Get.back();
    }
  }

  Future<UserCredential?> signUpEmailWithPass() async {
    try {
      FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: "SecondaryApp",
        options: Firebase
            .app()
            .options,
      );
      return await FirebaseAuth.instanceFor(app: secondaryApp).createUserWithEmailAndPassword(
        email: emailController.value.text.toString(),
        password: passwordController.value.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ShowToastDialog.closeLoader();
        log('The account already exists for that email.');
      }
    }
    return null;
  }

  Future<void> addOwner() async {
    isLoading.value = true;
    await signUpEmailWithPass().then((value) async {
      OwnerModel ownerModel = OwnerModel();
      ownerModel.id = value!.user!.uid;
      ownerModel.firstName = firstNameController.value.text;
      ownerModel.lastName = lastNameController.value.text;
      if (imagePath.value.path.isNotEmpty && imagePath.value.path != "") {
        String? downloadUrl = await FireStoreUtils.uploadPic(PickedFile(imagePath.value.path), "profileImage/${ownerModel.id}", "${ownerModel.id}", mimeType.value);
        ownerModel.profileImage = downloadUrl;
      }
      ownerModel.countryCode = countryCode.value;
      ownerModel.phoneNumber = phoneNumberController.value.text;
      ownerModel.email = emailController.value.text;
      ownerModel.password = passwordController.value.text;
      ownerModel.loginType = Constant.emailLoginType;
      ownerModel.slug = ownerModel.fullNameString().toSlug(delimiter: '-');
      ownerModel.userType = Constant.user;
      ownerModel.walletAmount = '0.0';
      ownerModel.active = true;
      ownerModel.createdAt = Timestamp.now();

      await FireStoreUtils.addOwner(ownerModel).then((value) async {
        isLoading.value = false;
        await setPagination(totalItemPerPage.value);
        ShowToastDialog.successToast("Owner Added..");
      });
    });
  }

  void setDefaultData() {
    firstNameController.value.text = '';
    lastNameController.value.text = '';
    countryCode.value = '+91';
    phoneNumberController.value.text = '';
    emailController.value.text = '';
    passwordController.value.text = '';
    imageController.value.text = "";
    imagePath.value = File('');
    mimeType.value = 'image/png';
    editingId.value = '';
    isEditing.value = false;
  }
}
