// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/add_address_model.dart';
import 'package:admin_panel/app/models/location_lat_lng.dart';
import 'package:admin_panel/app/models/positions.dart';
import 'package:admin_panel/app/models/user_model.dart';
import 'package:admin_panel/app/pdf_generate/generate_pdf_customer.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomerScreenController extends GetxController {
  RxString title = "Customers".tr.obs;
  RxBool isLoading = true.obs;
  RxBool isEditing = false.obs;
  RxBool isHistory = false.obs;
  RxInt selectedGender = 1.obs;
  RxBool isSearchEnable = true.obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<UserModel> currentPageUser = <UserModel>[].obs;
  Rx<TextEditingController> dateFiledController = TextEditingController().obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  RxString selectedSearchType = "Name".obs;
  RxString selectedSearchTypeForData = "slug".obs;
  List<String> searchType = [
    "Name",
    "Phone",
    "Email",
  ];

  Rx<TextEditingController> dateRangeController = TextEditingController().obs;
  DateTime? startDateForPdf;
  DateTime? endDateForPdf;
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

  RxBool isPasswordVisible = true.obs;
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<String> countryCode = '+91'.obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> imageController = TextEditingController().obs;
  RxString editingId = ''.obs;
  Rx<UserModel> userModel = UserModel().obs;

  Rx<File> imagePath = File('').obs;
  RxString imageURL = "".obs;
  RxString mimeType = 'image/png'.obs;
  Rx<Uint8List> imagePickedFileBytes = Uint8List(0).obs;
  RxBool uploading = false.obs;

  Rx<LocationLatLng> locationLatLng = LocationLatLng().obs;
  RxString landmark = "".obs;
  RxString locality = "".obs;

  RxString selectedDateOptionForPdf = "All".obs;
  RxString selectedDateOption = "All".obs;
  List<String> dateOption = ["All", "Last Month", "Last 6 Months", "Last Year", "Custom"];
  RxBool isCustomVisible = false.obs;
  DateTime? startDate;
  DateTime? endDate;
  Rx<DateTimeRange> selectedDateRange = (DateTimeRange(
    start: DateTime(
      DateTime
          .now()
          .year,
      DateTime
          .now()
          .month - 5, // Subtract 5 months
      1, // Start of the month
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
      999, // End of the day
    ),
  )).obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getUser();
    getLocation();
    dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
    super.onInit();
  }

  void getArgument(UserModel usersModel) {
    userModel.value = usersModel;
    isEditing.value = true;
    imagePath.value = File("");
    editingId.value = userModel.value.id!;
    firstNameController.value.text = userModel.value.firstName!;
    lastNameController.value.text = userModel.value.lastName!;
    emailController.value.text = userModel.value.email!;
    addressController.value.text = userModel.value.addAddresses!.first.address ?? "";
    countryCode.value = userModel.value.countryCode!;
    phoneNumberController.value.text = userModel.value.phoneNumber!;
    if (userModel.value.profilePic != null && userModel.value.profilePic!.isNotEmpty) {
      imageController.value.text = userModel.value.profilePic!;
      imageURL.value = userModel.value.profilePic!;
    }
  }

  Future<void> getLocation() async {
    Constant.currentLocation = await Utils.getCurrentLocation();
  }

  List<UserModel> selectedCustomerList = [];

  Future<void> downloadOrdersPdf(BuildContext context) async {
    isHistory(true);
    selectedCustomerList = await FireStoreUtils.dataForCustomersPdf(selectedDateRangeForPdf.value);
    await generateCustomerDataExcelWeb(selectedCustomerList, selectedDateRangeForPdf.value);
    Navigator.pop(context);
    isHistory(false);
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

  Future<void> removeCustomers(UserModel userModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.customer).doc(userModel.id).delete().then((value) {
      ShowToastDialog.successToast("Customer deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }

  Future<void> getUser() async {
    isLoading.value = true;
    await FireStoreUtils.countUsers();
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  Rx<DateTimeRange> selectedDate = DateTimeRange(
      start: DateTime(DateTime
          .now()
          .year, DateTime
          .now()
          .month, DateTime
          .now()
          .day, 0, 0, 0),
      end: DateTime(DateTime
          .now()
          .year, DateTime
          .now()
          .month, DateTime
          .now()
          .day, 23, 59, 0))
      .obs;

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.usersLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.usersLength! ? Constant.usersLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<UserModel> currentPageUserData = await FireStoreUtils.getUsers(
            currentPage.value, itemPerPage, searchController.value.text.toSlug(delimiter: "-"), selectedSearchTypeForData.value, selectedDateRange.value);
        currentPageUser.value = currentPageUserData;
      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
  }

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return Constant.usersLength!;
    } else {
      return int.parse(data);
    }
  }

  Future<void> pickPhoto() async {
    try {
      uploading.value = true;
      ImagePicker picker = ImagePicker();
      final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      File imageFile = File(img!.path);

      imageController.value.text = img.name;
      imagePath.value = imageFile;
      imagePickedFileBytes.value = await img.readAsBytes();
      mimeType.value = "${img.mimeType}";
      uploading.value = false;
    } catch (e) {
      uploading.value = false;
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

  Future<void> addUser() async {
    isLoading.value = true;
    await signUpEmailWithPass().then((value) async {
      UserModel userModel = UserModel();
      userModel.id = value!.user!.uid;
      userModel.firstName = firstNameController.value.text;
      userModel.lastName = lastNameController.value.text;
      if (imagePath.value.path.isNotEmpty && imagePath.value.path != "") {
        String? downloadUrl = await FireStoreUtils.uploadPic(PickedFile(imagePath.value.path), "profileImage/${userModel.id}", "${userModel.id}", mimeType.value);
        userModel.profilePic = downloadUrl;
      }
      GeoFirePoint position = GeoFlutterFire().point(latitude: locationLatLng.value.latitude!, longitude: locationLatLng.value.longitude!);
      userModel.addAddresses = [
        AddAddressModel(
          id: Constant.getUuid(),
          addressAs: "Home",
          address: addressController.value.text,
          locality: locality.value,
          landmark: landmark.value,
          location: locationLatLng.value,
          isDefault: true,
          name: userModel.fullNameString(),
          position: Positions(geohash: position.hash, geoPoint: position.geoPoint),
        )
      ];
      userModel.countryCode = countryCode.value;
      userModel.phoneNumber = phoneNumberController.value.text;
      userModel.email = emailController.value.text;
      userModel.password = passwordController.value.text;
      userModel.loginType = Constant.emailLoginType;
      userModel.slug = userModel.fullNameString().toSlug(delimiter: '-');
      userModel.userType = Constant.user;
      userModel.walletAmount = '0.0';
      userModel.isActive = true;
      userModel.createdAt = Timestamp.now();

      await FireStoreUtils.addUser(userModel).then((value) {
        isLoading.value = false;
        getUser();
        ShowToastDialog.successToast("Customer Added..");
      });
    });
  }

  Future<void> updateUser() async {
    Constant.waitingLoader();
    if (imagePath.value.path.isNotEmpty) {
      String? downloadUrl = await FireStoreUtils.uploadPic(PickedFile(imagePath.value.path), "profileImage".tr, editingId.value, mimeType.value);
      userModel.value.profilePic = downloadUrl;
    }
    userModel.value.id = editingId.value;
    userModel.value.firstName = firstNameController.value.text;
    userModel.value.lastName = lastNameController.value.text;
    userModel.value.slug = userModel.value.fullNameString().toSlug(delimiter: '-');
    bool isSaved = await FireStoreUtils.updateUsers(userModel.value);
    if (isSaved) {
      Get.back();
      getUser();
      ShowToastDialog.successToast("Users data updated".tr);
    } else {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
      Get.back();
    }
  }

  void setDefaultData() {
    firstNameController.value.text = '';
    lastNameController.value.text = '';
    countryCode.value = '+91';
    phoneNumberController.value.text = '';
    emailController.value.text = '';
    passwordController.value.text = '';
    addressController.value.text = '';
    imageController.value.text = "";
    imagePath.value = File('');
    locationLatLng.value = LocationLatLng();
    mimeType.value = 'image/png';
    editingId.value = '';
    isEditing.value = false;
  }
}
