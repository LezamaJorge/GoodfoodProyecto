// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:admin_panel/app/dependecy/location_picker_flutter_map/src/classes.dart';
import 'package:admin_panel/app/dependecy/location_picker_flutter_map/src/location_picker.dart';
import 'package:admin_panel/app/models/location_lat_lng.dart';
import 'package:admin_panel/app/modules/customer_screen/controllers/customer_screen_controller.dart';
import 'package:admin_panel/app/modules/restaurant/controllers/restaurant_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../constant/constants.dart';

class Utils {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<void> showPlacePicker(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const LocationPicker();
        },
      ),
    );
  }
}

class LocationPicker extends StatelessWidget {
  const LocationPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterLocationPicker(
      trackMyPosition: true,
      initZoom: 11,
      minZoomLevel: 5,
      maxZoomLevel: 16,
      initPosition: LatLong(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude),
      searchBarBackgroundColor: Colors.white,
      selectedLocationButtonTextStyle: const TextStyle(fontSize: 18),
      mapLanguage: 'en',
      onError: (e) => log(e.toString()),
      onPicked: (pickedData) async {
        RestaurantController restaurantController = Get.put(RestaurantController());
        CustomerScreenController customerController = Get.put(CustomerScreenController());
        double latitude = pickedData.latLong.latitude;
        double longitude = pickedData.latLong.longitude;
        restaurantController.locationLatLng.value = LocationLatLng(latitude: latitude, longitude: longitude);
        restaurantController.restaurantAddressController.value.text = pickedData.address.toString();
        customerController.locationLatLng.value = LocationLatLng(latitude: latitude, longitude: longitude);
        customerController.addressController.value.text = pickedData.address.toString();
        Get.back();
      },
    ));
  }
}
