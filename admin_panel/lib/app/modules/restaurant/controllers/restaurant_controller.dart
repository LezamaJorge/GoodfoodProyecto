// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/add_address_model.dart';
import 'package:admin_panel/app/models/cuisine_model.dart';
import 'package:admin_panel/app/models/location_lat_lng.dart';
import 'package:admin_panel/app/models/owner_model.dart';
import 'package:admin_panel/app/models/positions.dart';
import 'package:admin_panel/app/models/vendor_model.dart';
import 'package:admin_panel/app/pdf_generate/generate_pdf_restaurant.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class RestaurantController extends GetxController {
  RxString title = "Restaurant".tr.obs;
  RxBool isLoading = true.obs;
  RxBool isSearchEnable = true.obs;
  RxString editingId = ''.obs;
  RxBool isEditing = false.obs;
  RxBool isPasswordVisible = true.obs;

  final List<TextEditingController> openingHoursController = List.generate(7, (_) => TextEditingController()).obs;
  final List<TextEditingController> closingHoursController = List.generate(7, (_) => TextEditingController()).obs;
  Rx<TextEditingController> restaurantNameController = TextEditingController().obs;
  Rx<TextEditingController> restaurantAddressController = TextEditingController().obs;

  Rx<TextEditingController> ownerFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> ownerLastNameController = TextEditingController().obs;
  Rx<TextEditingController> ownerEmailController = TextEditingController().obs;
  Rx<TextEditingController> ownerPasswordController = TextEditingController().obs;
  Rx<TextEditingController> ownerMobileNumberController = TextEditingController().obs;
  Rx<String> countryCode = "+91".obs;

  Rx<TextEditingController> searchController = TextEditingController().obs;

  Rx<TextEditingController> ownerNameController = TextEditingController().obs;

  Rx<TextEditingController> restaurantImageController = TextEditingController().obs;
  RxList<VendorModel> currentPageRestaurantList = <VendorModel>[].obs;
  Rx<VendorModel> restaurantModel = VendorModel().obs;

  List<String> restaurantType = ["Veg", "Non veg", "Both"];
  RxString selectedRestaurantType = "Veg".obs;
  Rx<CuisineModel> selectedCuisine = CuisineModel().obs;
  RxList<CuisineModel> cuisineList = <CuisineModel>[].obs;

  Rx<File> imagePath = File('').obs;
  RxString mimeType = 'image/png'.obs;
  Rx<Uint8List> imagePickedFileBytes = Uint8List(0).obs;
  RxBool uploading = false.obs;

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;

  RxString selectedSearchType = "Name".obs;
  RxString selectedSearchTypeForData = "restaurantName".obs;
  List<String> searchType = [
    "Name",
    "Email",
  ];

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

  Rx<File> restaurantLogo = File('').obs;
  RxString restaurantLogoURL = "".obs;
  Rx<TextEditingController> restaurantLogoController = TextEditingController().obs;
  Rx<File> restaurantCoverImage = File('').obs;
  RxString restaurantCoverImageURL = "".obs;
  Rx<TextEditingController> restaurantCoverImageController = TextEditingController().obs;

  Rx<LocationLatLng> locationLatLng = LocationLatLng().obs;
  RxString landmark = "".obs;
  RxString locality = "".obs;

  List<OpeningHoursModel> openingHoursList = [];
  final daySwitches = List.generate(7, (_) => false.obs);
  final openingHours = List.generate(7, (_) => TimeOfDay.now().obs);
  final closingHours = List.generate(7, (_) => TimeOfDay.now().obs);
  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getLocation();
    getRestaurant();
    getCuisine();
    super.onInit();
  }

  List<VendorModel> restaurantList = [];

  Future<void> downloadOrdersPdf(BuildContext context) async {
    isHistoryDownload(true);
    restaurantList = await FireStoreUtils.dataForRestaurantPdf(selectedDateRangeForPdf.value);
    await generateRestaurantExcelWeb(restaurantList, selectedDateRangeForPdf.value);
    Navigator.pop(context);
    isHistoryDownload(false);
  }

  Future<void> getRestaurant() async {
    isLoading.value = true;
    await FireStoreUtils.countRestaurants();
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  Future<void> getCuisine() async {
    isLoading.value = true;
    await FireStoreUtils.getCuisineList().then((value) {
      cuisineList.value = value;
    });
    isLoading.value = false;
  }

  void setDefaultData() {
    restaurantNameController.value.clear();
    restaurantAddressController.value.clear();
    restaurantImageController.value.clear();
    ownerMobileNumberController.value.clear();
    ownerEmailController.value.clear();
    ownerFirstNameController.value.clear();
    ownerLastNameController.value.clear();
    ownerPasswordController.value.clear();
    selectedRestaurantType.value = "";
    selectedCuisine.value = CuisineModel();
    imagePath.value = File('');
    mimeType.value = 'image/png';
    isEditing.value = false;
  }

  Future<void> getArgument(VendorModel vendorModel) async {
    restaurantModel.value = vendorModel;
    isEditing.value = true;
    editingId.value = vendorModel.ownerId!;
    log("====> 1: ${editingId.value}");
    log("Editing ID: ${vendorModel.ownerId}");
    // Reset image files to empty
    restaurantLogo.value = File("");
    restaurantCoverImage.value = File("");

    // Set basic text fields
    restaurantNameController.value.text = vendorModel.vendorName!;
    restaurantAddressController.value.text = vendorModel.address!.address!;

    // Set image URLs and controller text
    restaurantCoverImageController.value.text = vendorModel.coverImage!;
    restaurantCoverImageURL.value = vendorModel.coverImage!;

    restaurantLogoController.value.text = vendorModel.logoImage!;
    restaurantLogoURL.value = vendorModel.logoImage!;

    // Handle opening hours (expecting exactly 7 days)
    final hoursList = vendorModel.openingHoursList;
    if (hoursList != null && hoursList.length >= 7) {
      for (int i = 0; i < 7; i++) {
        final day = hoursList[i];
        daySwitches[i].value = day.isOpen ?? false;
        openingHours[i].value = Constant.stringToTimeOfDay(day.openingHours ?? "09:00 AM");
        closingHours[i].value = Constant.stringToTimeOfDay(day.closingHours ?? "10:00 PM");

        openingHoursController[i].text = day.openingHours!;
        closingHoursController[i].text = day.closingHours!;
      }
    }

    // Set restaurant type
    selectedRestaurantType.value = vendorModel.vendorType ?? "Veg";

    // Set cuisine
    final cuisineIndex = cuisineList.indexWhere((element) => element.id == vendorModel.cuisineId.toString());
    if (cuisineIndex != -1) {
      selectedCuisine.value = cuisineList[cuisineIndex];
    }

    // Load restaurant documents
    // final verifyModel = await FireStoreUtils.getVerifyDocumentRestaurantByRestaurantID(vendorModel.id!);
    // if (verifyModel != null) {
    //   verifyRestaurantModel.value = verifyModel;
    //   verifyDocumentList.value = verifyModel.verifyDocument ?? [];
    // }

    // Load owner info
    final owner = await FireStoreUtils.getOwnerByOwnerId(vendorModel.ownerId!);
    if (owner != null) {
      ownerFirstNameController.value.text = owner.firstName!;
      ownerLastNameController.value.text = owner.lastName!;
      ownerEmailController.value.text = owner.email!;
      ownerPasswordController.value.text = owner.password!;
      ownerMobileNumberController.value.text = owner.phoneNumber!;
      countryCode.value = owner.countryCode ?? "+91";
    }
  }

  Future<void> removeRestaurant(VendorModel restaurantModel) async {
    isLoading.value = true;
    await FireStoreUtils.fireStore.collection(CollectionName.vendors).doc(restaurantModel.id).delete().then((value) {
      ShowToastDialog.successToast("Restaurant deleted.".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading.value = false;
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

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return Constant.restaurantLength!;
    } else {
      return int.parse(data);
    }
  }

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.restaurantLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.restaurantLength! ? Constant.restaurantLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<VendorModel> currentPageRestaurant =
            await FireStoreUtils.getRestaurants(currentPage.value, itemPerPage, searchController.value.text, selectedSearchTypeForData.value, selectedDateRange.value);
        currentPageRestaurantList.value = currentPageRestaurant;
        // toSlug(delimiter: "-")
      } catch (error) {
        if (kDebugMode) {}
      }
    }
    update();
    isLoading.value = false;
  }

  Future<UserCredential?> signUpEmailWithPass() async {
    try {
      FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: "SecondaryApp",
        options: Firebase.app().options,
      );
      return await FirebaseAuth.instanceFor(app: secondaryApp)
          .createUserWithEmailAndPassword(
        email: ownerEmailController.value.text.toString(),
        password: ownerPasswordController.value.text,
      )
          .catchError((error) {
        throw error;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ShowToastDialog.errorToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ShowToastDialog.closeLoader();
        ShowToastDialog.errorToast('The account already exists for that email.');
      }
    }
    return null;
  }

  String getWeekDay(int index) {
    switch (index) {
      case 0:
        return "Sunday";
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      default:
        return "";
    }
  }

  void toggleDaySwitch(int index) {
    daySwitches[index].value = !daySwitches[index].value;
  }

  Future<void> selectOpeningHour(int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: openingHours[index].value,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppThemeData.primary500,
            hintColor: AppThemeData.primary500,
            colorScheme: const ColorScheme.light(
              primary: AppThemeData.primary500,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              // dialBackgroundColor: AppThemeData.primary500,
              dialHandColor: AppThemeData.primary500,
              dialTextColor: WidgetStateColor.resolveWith((states) => states.contains(WidgetState.selected) ? Colors.white : Colors.black),
              hourMinuteColor: AppThemeData.primary500,
              hourMinuteTextColor: Colors.white,
              entryModeIconColor: AppThemeData.primary500,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != openingHours[index].value) {
      openingHours[index].value = picked;
    }
  }

  Future<void> selectClosingHour(int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: closingHours[index].value,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppThemeData.primary500,
            hintColor: AppThemeData.primary500,
            colorScheme: const ColorScheme.light(
              primary: AppThemeData.primary500,
              onPrimary: Colors.white,
              // surface: AppThemeData.grey100,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              // dialBackgroundColor: AppThemeData.grey300,
              dialHandColor: AppThemeData.primary500,
              dialTextColor: WidgetStateColor.resolveWith((states) => states.contains(WidgetState.selected) ? Colors.white : Colors.black),
              hourMinuteColor: AppThemeData.primary500,
              hourMinuteTextColor: Colors.white,
              entryModeIconColor: AppThemeData.primary500,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != closingHours[index].value) {
      closingHours[index].value = picked;
    }
  }

  List<OpeningHoursModel> openingHour() {
    openingHoursList.clear();
    for (int i = 0; i < 7; i++) {
      openingHoursList.add(OpeningHoursModel(
        day: getWeekDay(i),
        isOpen: daySwitches[i].value,
        openingHours: openingHours[i].value.format(Get.context!),
        closingHours: closingHours[i].value.format(Get.context!),
      ));
    }
    return openingHoursList;
  }

  Future<void> getLocation() async {
    Constant.currentLocation = await Utils.getCurrentLocation();
  }

  Future<void> addOwner() async {
    isLoading.value = true;
    // add Owner
    await signUpEmailWithPass().then((value) async {
      OwnerModel ownerModel = OwnerModel();
      ownerModel.id = value!.user!.uid;
      ownerModel.firstName = ownerFirstNameController.value.text;
      ownerModel.lastName = ownerLastNameController.value.text;
      ownerModel.countryCode = countryCode.value;
      ownerModel.phoneNumber = ownerMobileNumberController.value.text;
      ownerModel.slug = ownerModel.fullNameString().toSlug(delimiter: '-');
      ownerModel.email = ownerEmailController.value.text;
      ownerModel.password = ownerPasswordController.value.text;
      ownerModel.userType = Constant.owner;
      ownerModel.loginType = Constant.emailLoginType;
      ownerModel.vendorId = "";
      ownerModel.walletAmount = "0.0";
      ownerModel.isOpen = true;
      ownerModel.isVerified = true;
      ownerModel.active = true;
      ownerModel.createdAt = Timestamp.now();

      // add restaurant
      VendorModel vendorModel = VendorModel();
      vendorModel.id = Constant.getUuid();
      vendorModel.vendorName = restaurantNameController.value.text;
      if (restaurantCoverImage.value.path.isNotEmpty || restaurantCoverImage.value.path == '') {
        vendorModel.coverImage = await FireStoreUtils.uploadPic(PickedFile(restaurantCoverImage.value.path), "restaurantImages/${vendorModel.id}", Constant.getUuid(), mimeType.value);
      }
      if (restaurantLogo.value.path.isNotEmpty || restaurantLogo.value.path == '') {
        vendorModel.logoImage = await FireStoreUtils.uploadPic(PickedFile(restaurantLogo.value.path), "restaurantImages/${vendorModel.id}", Constant.getUuid(), mimeType.value);
      }
      vendorModel.ownerId = ownerModel.id;
      vendorModel.ownerFullName = ownerModel.fullNameString();
      vendorModel.cuisineId = selectedCuisine.value.id;
      vendorModel.cuisineName = selectedCuisine.value.cuisineName;
      vendorModel.userType = Constant.restaurant;
      vendorModel.vendorType = selectedRestaurantType.value;
      vendorModel.reviewSum = '0.0';
      vendorModel.reviewCount = '0.0';
      vendorModel.createdAt = Timestamp.now();
      vendorModel.active = true;
      vendorModel.isOnline = true;
      vendorModel.openingHoursList = openingHour();
      GeoFirePoint position = GeoFlutterFire().point(latitude: locationLatLng.value.latitude!, longitude: locationLatLng.value.longitude!);
      vendorModel.position = Positions(geohash: position.hash, geoPoint: position.geoPoint);
      vendorModel.address = AddAddressModel(
          address: restaurantAddressController.value.text,
          locality: locality.value,
          landmark: landmark.value,
          location: locationLatLng.value,
          position: Positions(geoPoint: position.geoPoint, geohash: position.hash));

      ownerModel.vendorId = vendorModel.id;
      await FireStoreUtils.updateNewOwner(ownerModel).then((value) async {
        await FireStoreUtils.addRestaurant(vendorModel).then((value) async {
          // await uploadDocument(ownerModel, vendorModel);
          isLoading.value = false;
          getRestaurant();
          setOwnerDataDefault();
          ShowToastDialog.successToast("Restaurant Added..");
        });
        // Get.back(result: true);
      });
    });
  }

  Future<void> updateOwner() async {
    isLoading.value = true;

    try {
      // Ensure editingId is not empty
      if (editingId.value.isEmpty) {
        throw Exception("Owner ID is missing.");
      }

      // Fetch existing owner data
      OwnerModel? existingOwner = await FireStoreUtils.getOwnerByOwnerId(editingId.value);
      if (existingOwner == null || existingOwner.id == null) {
        throw Exception("Owner not found in database.");
      }

      restaurantModel.value.ownerId = editingId.value;
      OwnerModel? ownerModel = await FireStoreUtils.getOwnerByOwnerId(editingId.value);
      if (ownerModel == null) throw Exception("Owner not found.");

      // 🔄 Step 2: Update only changed owner fields from UI
      ownerModel.firstName = ownerFirstNameController.value.text.trim();
      ownerModel.lastName = ownerLastNameController.value.text.trim();
      ownerModel.slug = ownerModel.fullNameString().toSlug(delimiter: '-');

      if (ownerMobileNumberController.value.text.isNotEmpty) {
        ownerModel.phoneNumber = ownerMobileNumberController.value.text.trim();
      }
      if (countryCode.value.isNotEmpty) {
        ownerModel.countryCode = countryCode.value;
      }

      // Update restaurant (vendor) info
      VendorModel vendorModel = restaurantModel.value;
      vendorModel.vendorName = restaurantNameController.value.text.trim();

      // Upload new images if selected
      if (restaurantCoverImage.value.path.isNotEmpty) {
        vendorModel.coverImage = await FireStoreUtils.uploadPic(
          PickedFile(restaurantCoverImage.value.path),
          "restaurantImages/${vendorModel.id}",
          Constant.getUuid(),
          mimeType.value,
        );
      }

      if (restaurantLogo.value.path.isNotEmpty) {
        vendorModel.logoImage = await FireStoreUtils.uploadPic(
          PickedFile(restaurantLogo.value.path),
          "restaurantImages/${vendorModel.id}",
          Constant.getUuid(),
          mimeType.value,
        );
      }

      // Set other vendor details
      vendorModel.ownerFullName = ownerModel.fullNameString();
      vendorModel.cuisineId = selectedCuisine.value.id;
      vendorModel.cuisineName = selectedCuisine.value.cuisineName;
      vendorModel.vendorType = selectedRestaurantType.value;
      vendorModel.openingHoursList = openingHour();

      // Handle location update
      if (locationLatLng.value.latitude != null && locationLatLng.value.longitude != null) {
        // Location has been changed or set
        GeoFirePoint position = GeoFlutterFire().point(
          latitude: locationLatLng.value.latitude ?? 0.0,
          longitude: locationLatLng.value.longitude ?? 0.0,
        );

        vendorModel.position = Positions(
          geohash: position.hash,
          geoPoint: position.geoPoint,
        );

        vendorModel.address = AddAddressModel(
          address: restaurantAddressController.value.text.trim(),
          locality: locality.value,
          landmark: landmark.value,
          location: locationLatLng.value,
          position: Positions(
            geoPoint: position.geoPoint,
            geohash: position.hash,
          ),
        );
      } else {
        // Location not changed, retain existing location data
        // Assuming existing location is stored in vendorModel
        // Do nothing here
      }

      // Save updates to Firestore
      await FirebaseFirestore.instance.collection(CollectionName.owner).doc(ownerModel.id).set(ownerModel.toJson(), SetOptions(merge: true));
      await FireStoreUtils.updateNewRestaurant(vendorModel);

      // Upload any additional documents
      // await uploadDocument(ownerModel, vendorModel);

      isLoading.value = false;
      ShowToastDialog.successToast("Restaurant Updated Successfully");
    } catch (e) {
      isLoading.value = false;
      ShowToastDialog.errorToast("Update Failed. Please try again.");
      log("Error while updating restaurant/owner: $e");
    }
  }

  // Future<void> uploadDocument(OwnerModel ownerModel, VendorModel vendorModel) async {
  //   if (verifyDocumentList.isNotEmpty) {
  //     for (int i = 0; i < verifyDocumentList.length; i++) {
  //       VerifyRestaurantDocumentModel verifyDocumentModel = verifyDocumentList[i];
  //       final imagePath = verifyDocumentModel.documentImage;
  //       if (imagePath != null && imagePath.isNotEmpty) {
  //         try {
  //           Uint8List imageBytes = base64Decode(imagePath);
  //           String image = await Constant.uploadImageToFireStorage(
  //             imageBytes,
  //             "documentImage/${verifyDocumentModel.documentId}/${vendorModel.id}",
  //             "${DateTime.now().millisecondsSinceEpoch}",
  //           );
  //           verifyDocumentModel.documentId = verifyDocumentModel.documentId;
  //           verifyDocumentModel.documentImage = image;
  //           verifyDocumentModel.isVerify = true;
  //           verifyDocumentList[i] = verifyDocumentModel;
  //         } catch (error) {
  //           developer.log("Error uploadDocument: $error");
  //         }
  //       } else {
  //         log("Image not Found..");
  //       }
  //       verifyDocumentList.refresh();
  //     }
  //   }
  //   verifyRestaurantModel.value.ownerId = ownerModel.id;
  //   verifyRestaurantModel.value.vendorId = vendorModel.id;
  //   verifyRestaurantModel.value.vendorName = vendorModel.vendorName;
  //   verifyRestaurantModel.value.ownerEmail = ownerModel.email;
  //   verifyRestaurantModel.value.ownerName = ownerModel.fullNameString();
  //   verifyRestaurantModel.value.verifyDocument = verifyDocumentList;
  //   verifyRestaurantModel.value.createAt = Timestamp.now();
  //
  //   await FireStoreUtils.uploadRestaurantDocument(verifyRestaurantModel.value).then((value) async {
  //     log('done2');
  //   });
  // }

  void setOwnerDataDefault() {
    ownerFirstNameController.value.text = '';
    ownerLastNameController.value.text = '';
    ownerPasswordController.value.text = '';
    ownerEmailController.value.text = '';
    selectedRestaurantType.value = "Veg";
    locationLatLng.value = LocationLatLng();
    selectedCuisine.value = CuisineModel();
    restaurantNameController.value.text = '';
    restaurantCoverImageController.value.text = '';
    restaurantLogoController.value.text = '';
    restaurantLogo.value = File('');
    restaurantCoverImage.value = File('');
    isEditing.value = false;
  }
}
