// ignore_for_file: depend_on_referenced_packages, unrelated_type_equality_checks

import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant/app/models/add_address_model.dart';
import 'package:restaurant/app/models/cuisine_model.dart';
import 'package:restaurant/app/models/location_lat_lng.dart';
import 'package:restaurant/app/models/positions_model.dart';
import 'package:restaurant/app/models/vendor_model.dart';
import 'package:restaurant/app/widget/permission_dialog.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/dependency/geoflutterfire/src/geoflutterfire.dart';
import 'package:restaurant/dependency/geoflutterfire/src/models/point.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRestaurantScreenController extends GetxController {
  RxString isSelected = "".obs;
  Rx<TextEditingController> restaurantNameController = TextEditingController().obs;
  final List<TextEditingController> openingHoursController = List.generate(7, (_) => TextEditingController()).obs;
  final List<TextEditingController> closingHoursController = List.generate(7, (_) => TextEditingController()).obs;
  Rx<TextEditingController> restaurantAddressController = TextEditingController().obs;
  Rx<LocationLatLng> locationLatLng = LocationLatLng().obs;
  Rx<RestaurantType> restaurantType = RestaurantType.veg.obs;
  TimeOfDay? openingTime;
  TimeOfDay? closingTime;
  final ImagePicker imagePicker = ImagePicker();
  Rx<String> logoImage = "".obs;
  Rx<String> coverImage = "".obs;
  Rx<CuisineModel> selectedCuisine = CuisineModel().obs;
  RxList<CuisineModel> cuisineList = <CuisineModel>[].obs;
  RxList<String> pageList = <String>["Upload Restaurant Cover and Logo", "Add The Restaurant Details", "Select Opening Hours"].obs;
  Rx<String> editPage = "".obs;
  var currentStep = 0.obs;
  RxBool isTermsCondition = false.obs;
  RxBool isEdited = false.obs;
  RxBool isPasswordVisible = true.obs;
  RxString counCode = "+1".obs;
  RxString loginType = "".obs;
  RxString landmark = "".obs;
  RxString locality = "".obs;

  Rx<VendorModel> restaurantModel = VendorModel().obs;
  Rx<bool> isLoading = false.obs;
  Rx<bool> restaurantDetailButton = false.obs;
  List<OpeningHoursModel> entries = [];

  final daySwitches = List.generate(7, (_) => false.obs);
  final openingHours = List.generate(7, (_) => TimeOfDay.now().obs);
  final closingHours = List.generate(7, (_) => TimeOfDay.now().obs);

  @override
  Future<void> onInit() async {
    await getData();
    checkIfFieldsAreFilled();
    super.onInit();
  }

  void toggleDaySwitch(int index) {
    try {
      daySwitches[index].value = !daySwitches[index].value;
    } catch (e, stack) {
      developer.log("Error toggling day switch:", error: e, stackTrace: stack);
    }
  }

  final isAllOpeningHoursSelected = false.obs;

  void validateOpeningHours() {
    try {
      bool oneValid = false;
      for (int i = 0; i < 7; i++) {
        if (daySwitches[i].value || openingHoursController[i].text.isNotEmpty || closingHoursController[i].text.isNotEmpty) {
          oneValid = true;
          break;
        }
      }
      isAllOpeningHoursSelected.value = oneValid;
    } catch (e, stack) {
      developer.log("Error validating opening hours:", error: e, stackTrace: stack);
      isAllOpeningHoursSelected.value = false;
    }
  }

  Future<void> selectOpeningHour(int index) async {
    try {
      final TimeOfDay? picked = await showTimePicker(
        context: Get.context!,
        initialTime: openingHours[index].value,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppThemeData.primary300,
              hintColor: AppThemeData.primary300,
              colorScheme: ColorScheme.light(
                primary: AppThemeData.primary300,
                onPrimary: Colors.white,
                surface: AppThemeData.grey100,
                onSurface: Colors.black,
              ),
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Colors.white,
                dialBackgroundColor: AppThemeData.grey300,
                dialHandColor: AppThemeData.primary300,
                dialTextColor: WidgetStateColor.resolveWith((states) => states.contains(WidgetState.selected) ? Colors.white : Colors.black),
                hourMinuteColor: AppThemeData.primary300,
                hourMinuteTextColor: Colors.white,
                entryModeIconColor: AppThemeData.primary300,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null && picked != openingHours[index].value) {
        openingHours[index].value = picked;
        openingHoursController[index].text = Constant.formatTimeOfDayTo12Hour(picked);
        validateOpeningHours();
      }
    } catch (e, stack) {
      developer.log("Error selecting opening hour:", error: e, stackTrace: stack);
    }
  }

  Future<void> selectClosingHour(int index) async {
    try {
      final TimeOfDay? picked = await showTimePicker(
        context: Get.context!,
        initialTime: closingHours[index].value,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppThemeData.primary300,
              hintColor: AppThemeData.primary300,
              colorScheme: ColorScheme.light(
                primary: AppThemeData.primary300,
                onPrimary: Colors.white,
                surface: AppThemeData.grey100,
                onSurface: Colors.black,
              ),
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Colors.white,
                dialBackgroundColor: AppThemeData.grey300,
                dialHandColor: AppThemeData.primary300,
                dialTextColor: WidgetStateColor.resolveWith((states) => states.contains(WidgetState.selected) ? Colors.white : Colors.black),
                hourMinuteColor: AppThemeData.primary300,
                hourMinuteTextColor: Colors.white,
                entryModeIconColor: AppThemeData.primary300,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null && picked != closingHours[index].value) {
        closingHours[index].value = picked;
        closingHoursController[index].text = Constant.formatTimeOfDayTo12Hour(picked);
        validateOpeningHours();
      }
    } catch (e, stack) {
      developer.log("Error selecting closing hour:", error: e, stackTrace: stack);
    }
  }

  Future<void> openingHoursEntries() async {
    try {
      entries.clear();
      for (int i = 0; i < 7; i++) {
        bool isOpen = daySwitches[i].value;
        String day = getWeekDay(i);

        String opening;
        String closing;

        if (isOpen && openingHoursController[i].text.isNotEmpty && closingHoursController[i].text.isNotEmpty) {
          opening = openingHoursController[i].text.trim();
          closing = closingHoursController[i].text.trim();
        } else if (restaurantModel.value.openingHoursList != null && restaurantModel.value.openingHoursList!.length == 7) {
          opening = restaurantModel.value.openingHoursList![i].openingHours!;
          closing = restaurantModel.value.openingHoursList![i].closingHours!;
        } else {
          opening = '11:00 AM';
          closing = '11:00 PM';
        }

        entries.add(OpeningHoursModel(
          isOpen: isOpen,
          day: day,
          openingHours: opening,
          closingHours: closing,
        ));
      }
    } catch (e, stack) {
      developer.log("Error in openingHoursEntries:", error: e, stackTrace: stack);
    }
  }

  String getWeekDay(int index) {
    try {
      switch (index) {
        case 0:
          return "Sunday".tr;
        case 1:
          return "Monday".tr;
        case 2:
          return "Tuesday".tr;
        case 3:
          return "Wednesday".tr;
        case 4:
          return "Thursday".tr;
        case 5:
          return "Friday".tr;
        case 6:
          return "Saturday".tr;
        default:
          return "";
      }
    } catch (e, stack) {
      developer.log("Error getting week day:", error: e, stackTrace: stack);
      return "";
    }
  }

  void checkIfFieldsAreFilled() {
    try {
      if (restaurantNameController.value.text.isNotEmpty && restaurantAddressController.value.text.isNotEmpty && selectedCuisine.value.id != null) {
        restaurantDetailButton.value = true;
      } else {
        restaurantDetailButton.value = false;
      }
    } catch (e, stack) {
      developer.log("Error checking fields:", error: e, stackTrace: stack);
      restaurantDetailButton.value = false;
    }
  }

  Future<void> getArgument() async {
    try {
      dynamic argumentData = Get.arguments;
      if (argumentData != null) {
        restaurantModel.value = argumentData['restaurantModel'];
        logoImage.value = restaurantModel.value.logoImage.toString();
        coverImage.value = restaurantModel.value.coverImage.toString();
        restaurantNameController.value.text = restaurantModel.value.vendorName.toString();
        restaurantAddressController.value.text = restaurantModel.value.address!.address.toString();
        landmark.value = restaurantModel.value.address!.landmark!;
        locality.value = restaurantModel.value.address!.locality!;
        locationLatLng.value = restaurantModel.value.address!.location!;

        restaurantType.value = restaurantModel.value.vendorType == "Veg"
            ? RestaurantType.veg
            : restaurantModel.value.vendorType == "Non veg"
                ? RestaurantType.nonVeg
                : RestaurantType.both;

        int index = cuisineList.indexWhere(
          (element) => element.id == restaurantModel.value.cuisineId.toString(),
        );
        if (index != -1) {
          selectedCuisine.value = cuisineList[index];
        }

        if (restaurantModel.value.openingHoursList != null && restaurantModel.value.openingHoursList!.length >= 7) {
          for (int i = 0; i < 7; i++) {
            daySwitches[i].value = restaurantModel.value.openingHoursList![i].isOpen!;
            openingHours[i].value = Constant.stringToTimeOfDay(restaurantModel.value.openingHoursList![i].openingHours!);
            closingHours[i].value = Constant.stringToTimeOfDay(restaurantModel.value.openingHoursList![i].closingHours!);
            openingHoursController[i].text = restaurantModel.value.openingHoursList![i].openingHours.toString();
            closingHoursController[i].text = restaurantModel.value.openingHoursList![i].closingHours.toString();
          }
        }

        editPage.value = argumentData['editPage'];
        int stepIndex = pageList.indexOf(editPage.value);
        currentStep.value = stepIndex != -1 ? stepIndex : 0;
      }
    } catch (e, stack) {
      developer.log("Error getting arguments:", error: e, stackTrace: stack);
    }
  }

  Future<void> getData() async {
    try {
      isLoading.value = true;

      try {
        final cuisineData = await FireStoreUtils.getCuisineList();
        if (cuisineData != null) {
          cuisineList.value = cuisineData;
        }
      } catch (e, stack) {
        developer.log("Error fetching cuisine list:", error: e, stackTrace: stack);
      }

      try {
        await getArgument();
      } catch (e, stack) {
        developer.log("Error getting arguments:", error: e, stackTrace: stack);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void nextStep() {
    try {
      if (currentStep.value < pageList.length - 1) {
        currentStep.value++;
      }
    } catch (e, stack) {
      developer.log("Error in nextStep:", error: e, stackTrace: stack);
    }
  }

  void previousStep() {
    try {
      if (currentStep.value > 0) {
        currentStep.value--;
      }
    } catch (e, stack) {
      developer.log("Error in previousStep:", error: e, stackTrace: stack);
    }
  }

  Future<String?> pickFile() async {
    try {
      XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 60,
      );

      if (image == null) return null;
      final allowedExtensions = ['jpg', 'jpeg', 'png'];
      final extension = image.name.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        ShowToastDialog.toast("Only JPG, JPEG and PNG images are allowed".tr);
        return null;
      }

      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 50,
      );

      if (compressedBytes == null) {
        ShowToastDialog.toast("Image compression failed".tr);
        return null;
      }

      File compressedFile = File(image.path);
      await compressedFile.writeAsBytes(compressedBytes);
      return compressedFile.path;
    } on PlatformException catch (e, stack) {
      developer.log("Error picking file:", error: e, stackTrace: stack);
    } catch (e, stack) {
      developer.log("Error picking file:", error: e, stackTrace: stack);
    }
    return null;
  }

  void checkPermission(Function() onTap) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        ShowToastDialog.toast("You have to allow location permission to use your location".tr);
      } else if (permission == LocationPermission.deniedForever) {
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return const PermissionDialog();
          },
        );
      } else {
        onTap();
      }
    } catch (e, stack) {
      developer.log("Error checking permission:", error: e, stackTrace: stack);
    }
  }

  Future<void> saveData() async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);
      if (restaurantModel.value.id == null || restaurantModel.value.ownerId == null) {
        restaurantModel.value.id = Constant.getUuid();
        restaurantModel.value.ownerId = Constant.ownerModel!.id;
      }

      restaurantModel.value.vendorName = restaurantNameController.value.text;

      if (!Constant.hasValidUrl(logoImage.value)) {
        restaurantModel.value.logoImage = await Constant.uploadRestaurantImage(logoImage.value, restaurantModel.value.id!);
      }

      if (!Constant.hasValidUrl(coverImage.value)) {
        restaurantModel.value.coverImage = await Constant.uploadRestaurantImage(coverImage.value, restaurantModel.value.id!);
      }

      restaurantModel.value.cuisineId = selectedCuisine.value.id;
      restaurantModel.value.cuisineName = selectedCuisine.value.cuisineName;
      restaurantModel.value.userType = Constant.restaurant;
      restaurantModel.value.active = true;
      restaurantModel.value.createdAt = Timestamp.now();
      restaurantModel.value.reviewCount = '0';
      restaurantModel.value.reviewSum = '0';


      GeoFirePoint position =
      Geoflutterfire().point(latitude: locationLatLng.value.latitude!, longitude: locationLatLng.value.longitude!);

      restaurantModel.value.position = Positions(geoPoint: position.geoPoint, geohash: position.hash);


      restaurantModel.value.address = AddAddressModel(
        address: restaurantAddressController.value.text,
        locality: locality.value,
        landmark: landmark.value,
        location: locationLatLng.value,
      );

      restaurantModel.value.openingHoursList = entries;
      restaurantModel.value.ownerFullName = Constant.ownerModel!.fullNameString();
      restaurantModel.value.vendorType = restaurantType.value == RestaurantType.veg
          ? "Veg"
          : restaurantType.value == RestaurantType.nonVeg
              ? "Non veg"
              : "Both";

      bool isUpdate = await FireStoreUtils.updateRestaurant(restaurantModel.value);
      if (isUpdate) {
        restaurantNameController.value.clear();
        restaurantAddressController.value.clear();
      }

      Constant.ownerModel!.vendorId = restaurantModel.value.id;
      await FireStoreUtils.updateOwner(Constant.ownerModel!);

      Constant.vendorModel = restaurantModel.value;
      if (isEdited.value) {
        ShowToastDialog.toast('your restaurant update successful'.tr);
      }
      Get.back(result: true);
    } catch (e, stack) {
      developer.log("Error Saving Data:", error: e, stackTrace: stack);
    } finally {
      ShowToastDialog.closeLoader();
    }
  }
}

enum RestaurantType { veg, nonVeg, both }
