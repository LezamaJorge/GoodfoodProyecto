import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/place_picker/location_controller.dart';
import 'package:restaurant/dependency/google_auto_complete_textfield/google_places_flutter.dart';
import 'package:restaurant/dependency/google_auto_complete_textfield/model/prediction.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../../themes/app_fonts.dart';

class LocationPickerScreen extends StatelessWidget {
  const LocationPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: LocationController(),
        builder: (controller) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark, // Android → black
                statusBarBrightness: Brightness.light,    // iOS → black
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: GooglePlaceAutoCompleteTextField(
                textEditingController: controller.searchController,
                containerHorizontalPadding: 10,
                googleAPIKey: Constant.googleMapKey,
                boxDecoration: BoxDecoration(
                  color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack :AppThemeData.primaryWhite,
                  borderRadius: BorderRadius.circular(50),
                ),
                inputDecoration: InputDecoration(
                  filled: true,
                  fillColor: themeChange.isDarkTheme() ?AppThemeData.primaryBlack: AppThemeData.primaryWhite,
                  hintText: 'Search place',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintStyle: TextStyle(fontSize: 14, fontFamily: FontFamily.regular),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  icon: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      // color: themeChange.getThem() ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),
                debounceTime: 600,
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  if (prediction.description != null && prediction.description!.trim().isNotEmpty) {
                    final lat = double.tryParse(prediction.lat ?? '');
                    final lng = double.tryParse(prediction.lng ?? '');
                    if (lat != null && lng != null) {
                      controller.searchController.text = prediction.description!;
                      controller.moveCameraTo(LatLng(lat, lng));
                    }
                  }
                },
                itemClick: (Prediction prediction) async {
                  if (prediction.description != null && prediction.description!.trim().isNotEmpty) {
                    final lat = double.tryParse(prediction.lat ?? '');
                    final lng = double.tryParse(prediction.lng ?? '');
                    if (lat != null && lng != null) {
                      controller.searchController.text = prediction.description!;
                      LatLng selectedLatLng = LatLng(lat, lng);
                      controller.selectedLocation.value = selectedLatLng;
                      await controller.getAddressFromLatLng(selectedLatLng);
                    }
                  }
                },
              ),
            ),
            body: controller.selectedLocation.value == null
                ? Center(child: Constant.loader())
                : Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: (controllers) {
                          controller.mapController = controllers;
                        },
                        initialCameraPosition: CameraPosition(
                          target: controller.selectedLocation.value!,
                          zoom: 15,
                        ),
                        onCameraMove: controller.onMapMoved,
                        onCameraIdle: () {
                          if (controller.selectedLocation.value != null) {
                            controller.getAddressFromLatLng(controller.selectedLocation.value!);
                          }
                        },
                      ),
                      Center(child: Icon(Icons.location_pin, size: 40, color: Colors.red)),
                      Positioned(
                        bottom: 40,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                             color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 5),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(() => Text(
                                    controller.address.value,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16, fontFamily: FontFamily.medium, color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack),
                                  )),
                              SizedBox(height: 10),
                              AppButton(
                                text: "Confirm Location",
                                textColor: AppThemeData.primaryWhite,
                                onTap: controller.confirmLocation,
                                color: AppThemeData.primary300,
                                elevation: 0,
                                shapeBorder: RoundedRectangleBorder(
                                  borderRadius: radius(12),
                                ),
                              )
                              // RoundShapeButton(
                              //     title: "Confirm Location",
                              //     buttonColor: AppThemData.primary500,
                              //     buttonTextColor: AppThemData.black,
                              //     onTap: controller.confirmLocation,
                              //     size: Size(190, 45))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}
