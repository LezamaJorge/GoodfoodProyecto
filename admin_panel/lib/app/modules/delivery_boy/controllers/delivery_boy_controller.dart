// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';

import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/driver_user_model.dart';
import 'package:admin_panel/app/models/verify_driver_model.dart';
import 'package:admin_panel/app/models/verify_restaurant_model.dart';
import 'package:admin_panel/app/pdf_generate/generate_pdf_deliveryboy.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/collection_name.dart';

class DeliveryBoyController extends GetxController {
  RxString title = "Delivery Boy".tr.obs;
  RxBool isLoading = true.obs;
  RxBool isEditing = false.obs;
  RxString selectedSearchType = "Name".tr.obs;
  RxString selectedSearchTypeForData = "slug".obs;
  List<String> searchType = [
    "Name",
    "Phone",
    "Email",
  ];
  RxBool isSearchEnable = true.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<TextEditingController> dateFiledController = TextEditingController().obs;
  RxList<DriverUserModel> currentPageDriver = <DriverUserModel>[].obs;

  Rx<File> profileImage = File('').obs;
  RxString profileImageURL = "".obs;
  RxBool isProfileUpdated = false.obs;
  RxBool isPasswordVisible = true.obs;
  Rx<TextEditingController> profileImageController = TextEditingController().obs;
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  RxString countryCode = '+91'.obs;
  Rx<TextEditingController> vehicleModelController = TextEditingController().obs;
  Rx<TextEditingController> vehicleNumberController = TextEditingController().obs;

  Rx<TextEditingController> vehicleImageController = TextEditingController().obs;
  Rx<File> vehicleImage = File('').obs;
  RxString vehicleImageUrl = "".obs;
  RxString mimeType = 'image/png'.obs;
  RxBool isImageUpdated = false.obs;
  List<String> vehicleType = ["Bike", "Scooter"];
  RxString selectedVehicleType = "Bike".obs;
  RxString editingId = ''.obs;

  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  Rx<VerifyDriverModel> verifyDriverModel = VerifyDriverModel().obs;
  RxList<DocumentModel> documentsList = <DocumentModel>[].obs;
  RxList<VerifyDocumentModel> verifyDocumentList = <VerifyDocumentModel>[].obs;

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;

  Rx<TextEditingController> dateRangeController = TextEditingController().obs;
  DateTime? startDateForPdf;
  DateTime? endDateForPdf;
  Rx<DateTimeRange> selectedDateRangeForPdf =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;

  RxString selectedDateOption = "All".obs;
  RxString selectedDateOptionForPdf = "All".obs;
  List<String> dateOption = ["All", "Last Month", "Last 6 Months", "Last Year", "Custom"];
  RxBool isCustomVisible = false.obs;
  RxBool isHistoryDownload = false.obs;

  DateTime? startDate;
  DateTime? endDate;
  Rx<DateTimeRange> selectedDateRange = (DateTimeRange(
    start: DateTime(
      DateTime.now().year,
      DateTime.now().month - 5, // Subtract 5 months
      1, // Start of the month
    ),
    end: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      23,
      59,
      59,
      999, // End of the day
    ),
  )).obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getUser();
    dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
    super.onInit();
  }

  Future<void> getArgument(DriverUserModel driversModel) async {
    driverModel.value = driversModel;
    isEditing.value = true;
    profileImage.value = File('');
    vehicleImage.value = File('');
    editingId.value = driverModel.value.driverId ?? '';
    firstNameController.value.text = driverModel.value.firstName ?? '';
    lastNameController.value.text = driverModel.value.lastName ?? '';
    countryCode.value = driverModel.value.countryCode ?? '+91';
    phoneNumberController.value.text = driverModel.value.phoneNumber ?? '';
    profileImageURL.value = driverModel.value.profileImage ?? '';
    profileImageController.value.text = driverModel.value.profileImage ?? '';
    emailController.value.text = driverModel.value.email ?? '';
    passwordController.value.text = driverModel.value.password ?? "";
    selectedVehicleType.value = driverModel.value.driverVehicleDetails!.vehicleTypeName! == "bike" ? "Bike" : "Scooter";
    vehicleModelController.value.text = driverModel.value.driverVehicleDetails?.modelName ?? '';
    vehicleNumberController.value.text = driverModel.value.driverVehicleDetails?.vehicleNumber ?? '';
    vehicleImageController.value.text = driverModel.value.driverVehicleDetails?.vehicleImage ?? '';
    vehicleImageUrl.value = driverModel.value.driverVehicleDetails?.vehicleImage ?? '';
    verifyDriverModel.value = (await FireStoreUtils.getVerifyDriverModelByDriverID(driverModel.value.driverId!))!;
    verifyDocumentList.value = verifyDriverModel.value.verifyDocument!;
  }

  Future<void> getSearchType() async {
    isLoading.value = true;
    if (selectedSearchType.value == "Phone") {
      selectedSearchTypeForData.value = "phoneNumber";
    } else if (selectedSearchType.value == "Email") {
      selectedSearchTypeForData.value = "email";
    } else {
      selectedSearchTypeForData.value = "slug";
    }
    isLoading.value = false;
  }

  List<DriverUserModel> driverUserList = [];

  Future<void> downloadOrdersPdf(BuildContext context) async {
    isHistoryDownload(true);
    driverUserList = await FireStoreUtils.dataForDriverUserPdf(selectedDateRangeForPdf.value);
    await generateDeliveryBoyExcelWeb(driverUserList, selectedDateRangeForPdf.value);
    Navigator.pop(context);
    isHistoryDownload(false);
  }

  Future<void> getUser() async {
    isLoading.value = true;
    await FireStoreUtils.countDrivers();
    setPagination(totalItemPerPage.value);
    await FireStoreUtils.getDocumentsList(userType: 'Driver').then((value) {
      documentsList.value = value!;
      verifyDocumentList.clear();
      for (var element in documentsList) {
        VerifyDocumentModel documentModel = VerifyDocumentModel(documentId: element.id, documentImage: [], isVerify: false, isTwoSide: element.isTwoSide);
        verifyDocumentList.add(documentModel);
      }
    });
    isLoading.value = false;
  }

  Rx<DateTimeRange> selectedDate =
      DateTimeRange(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0))
          .obs;

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return Constant.driverLength!;
    } else {
      return int.parse(data);
    }
  }

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.driverLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.driverLength! ? Constant.driverLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<DriverUserModel> currentPageDriverData =
            await FireStoreUtils.getDriver(currentPage.value, itemPerPage, searchController.value.text, selectedSearchTypeForData.value, selectedDateRange.value);
        currentPageDriver.value = currentPageDriverData;
      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
  }

  Future<void> removeDeliveryBoy(DriverUserModel driverModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.driver).doc(driverModel.driverId).delete().then((value) {
      ShowToastDialog.successToast(" Delivery agent removed.".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }

  Future<UserCredential?> signUpEmailWithPass() async {
    try {
      FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: "SecondaryApp",
        options: Firebase.app().options,
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
        ShowToastDialog.errorToast("This email is already registered.");
      }
    }
    return null;
  }

  Future<void> addDeliveryBoy() async {
    isLoading.value = true;
    await signUpEmailWithPass().then((value) async {
      DriverUserModel driverModel = DriverUserModel();
      driverModel.driverId = value!.user!.uid;
      driverModel.firstName = firstNameController.value.text;
      driverModel.lastName = lastNameController.value.text;
      driverModel.countryCode = countryCode.value;
      driverModel.phoneNumber = phoneNumberController.value.text;
      driverModel.email = emailController.value.text;
      if (profileImage.value.path.isNotEmpty && profileImage.value.path != "") {
        String? downloadUrl = await FireStoreUtils.uploadPic(PickedFile(profileImage.value.path), "profileImage/${driverModel.driverId}", "${driverModel.driverId}", mimeType.value);
        driverModel.profileImage = downloadUrl;
      }
      driverModel.password = passwordController.value.text;
      driverModel.loginType = Constant.emailLoginType;
      driverModel.slug = driverModel.fullNameString().toSlug(delimiter: '-');
      driverModel.userType = Constant.driver;
      driverModel.walletAmount = '0.0';
      driverModel.active = true;
      driverModel.isVerified = true;
      driverModel.isOnline = true;
      driverModel.status = 'free';
      String image = await FireStoreUtils.uploadPic(PickedFile(vehicleImage.value.path), "vehicleImages/${driverModel.driverId}", Constant.getRandomString(20), mimeType.value);
      driverModel.driverVehicleDetails = DriverVehicleDetails(
          isVerified: true,
          modelName: vehicleModelController.value.text,
          vehicleNumber: vehicleNumberController.value.text,
          vehicleTypeName: selectedVehicleType.value == "Bike" ? "bike" : "scooter",
          vehicleImage: image);
      driverModel.createdAt = Timestamp.now();

      if (verifyDocumentList.isNotEmpty) {
        for (var document in verifyDocumentList) {
          for (int i = 0; i < document.documentImage!.length; i++) {
            final image = document.documentImage![i];
            // Check if the URL is valid
            String imageUrl = await Constant.uploadImageToFireStorage(
              image,
              "driver_documents/${document.documentId}/${driverModel.driverId}",
              "${DateTime.now().millisecondsSinceEpoch}",
            );

            // Replace the old path with the new URL
            document.documentImage![i] = imageUrl;
            document.documentId = document.documentId;
            document.isVerify = true;
          }
        }
        verifyDocumentList.refresh();
      }

      VerifyDriverModel verifyDriver = VerifyDriverModel(
        createAt: driverModel.createdAt,
        driverEmail: driverModel.email,
        driverId: driverModel.driverId,
        driverName: '${driverModel.firstName} ${driverModel.lastName}',
        verifyDocument: verifyDocumentList,
      );
      await FireStoreUtils.addVerifyDeliveryBoy(verifyDriver);
      await FireStoreUtils.addDeliveryBoy(driverModel).then((value) {
        isLoading.value = false;
        getUser();
        ShowToastDialog.successToast("Delivery Boy Added..");
      });
    });
  }

  Future<void> updateDeliveryBoy() async {
    Constant.waitingLoader();
    driverModel.value.driverId = editingId.value;
    driverModel.value.firstName = firstNameController.value.text;
    driverModel.value.lastName = lastNameController.value.text;
    if (profileImage.value.path.isNotEmpty) {
      String? downloadUrl = await FireStoreUtils.uploadPic(PickedFile(profileImage.value.path), "profileImage".tr, editingId.value, mimeType.value);
      driverModel.value.profileImage = downloadUrl;
    }
    driverModel.value.slug = driverModel.value.fullNameString().toSlug(delimiter: '-');
    String image = await FireStoreUtils.uploadPic(PickedFile(vehicleImage.value.path), "vehicleImages/${driverModel.value.driverId}", Constant.getRandomString(20), mimeType.value);
    driverModel.value.driverVehicleDetails = DriverVehicleDetails(
        isVerified: true,
        modelName: vehicleModelController.value.text,
        vehicleNumber: vehicleNumberController.value.text,
        vehicleTypeName: selectedVehicleType.value == "Bike" ? "bike" : "scooter",
        vehicleImage: image);

    bool isSaved = await FireStoreUtils.updateDriver(driverModel.value);
    if (isSaved) {
      Get.back();
      getUser();
      ShowToastDialog.successToast("Delivery agent details updated.".tr);
    } else {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
      Get.back();
    }
  }

  final ImagePicker picker = ImagePicker();

  Future<void> documentPickFile({
    required ImageSource source,
    required VerifyDocumentModel verifyDocumentModel,
    required int docIndex,
    required int imageIndex,
  }) async {
    try {
      XFile? image = await picker.pickImage(source: source, imageQuality: 60);
      if (image == null) return;
      // On Web, no file path, get bytes instead
      final allowedExtensions = ['jpg', 'jpeg', 'png'];
      String fileExtension = image.name.split('.').last.toLowerCase();

      if (!allowedExtensions.contains(fileExtension)) {
        ShowToastDialog.errorToast("Invalid file type. Please select a .jpg, .jpeg, or .png image.".tr);
        return;
      }
      Uint8List bytes = await image.readAsBytes();
      if (verifyDocumentModel.documentImage != null && verifyDocumentModel.documentImage!.length > imageIndex) {
        verifyDocumentModel.documentImage![imageIndex] = bytes;
      } else {
        verifyDocumentModel.documentImage!.add(bytes);
      }

      verifyDocumentList[docIndex] = verifyDocumentModel;
      verifyDocumentList.refresh();
    } on PlatformException catch (e) {
      ShowToastDialog.errorToast("${"Failed to pick".tr} : \n $e");
    }
  }

  void setDefaultData() {
    firstNameController.value.text = "";
    lastNameController.value.text = "";
    emailController.value.text = "";
    passwordController.value.text = "";
    phoneNumberController.value.text = "";
    profileImageController.value.text = "";
    profileImageURL.value = "";
    profileImage.value = File("");
    countryCode.value = '+91';
    selectedVehicleType.value = "Bike";
    vehicleImageController.value.text = "";
    vehicleNumberController.value.text = "";
    vehicleModelController.value.text = "";
    vehicleImage.value = File("");
    vehicleImageUrl.value = "";
    mimeType.value = "image/png";
    editingId.value = '';
    isEditing.value = false;
    verifyDocumentList.clear();
    verifyDriverModel.value = VerifyDriverModel();
    if (documentsList.isNotEmpty) {
      for (var element in documentsList) {
        verifyDocumentList.add(VerifyDocumentModel(
          documentId: element.id,
          documentImage: [],
          isVerify: false,
          isTwoSide: element.isTwoSide,
        ));
      }
    }
    verifyDocumentList.refresh();
  }
}
