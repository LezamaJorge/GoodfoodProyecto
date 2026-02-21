// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/constant/place_picker/selected_location_model.dart';

class LocationController extends GetxController {
  GoogleMapController? mapController;
  var selectedLocation = Rxn<LatLng>();
  var selectedPlaceAddress = Rxn<Placemark>();
  var address = "Move the map to select a location".obs;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    searchController.addListener(() {
      if (searchController.text.trim().isEmpty) {
        getCurrentLocation();
      }
    });
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      selectedLocation.value = LatLng(position.latitude, position.longitude);

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: selectedLocation.value!, zoom: 15),
        ),
      );
      getAddressFromLatLng(selectedLocation.value!);
    } catch (e) {
      if (kDebugMode) {}
    }
  }

  Future<void> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        selectedPlaceAddress.value = place;
        address.value = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
    } catch (e) {
      if (kDebugMode) {}
    }
  }

  void onMapMoved(CameraPosition position) {
    try {
      selectedLocation.value = position.target;
    } catch (e) {
      if (kDebugMode) {}
    }
  }

  void confirmLocation() {
    try {
      if (selectedLocation.value != null) {
        SelectedLocationModel selectedLocationModel = SelectedLocationModel(
          address: selectedPlaceAddress.value,
          latLng: selectedLocation.value,
        );
        Get.back(result: selectedLocationModel);
      }
    } catch (e) {
      if (kDebugMode) {}
    }
  }

  void moveCameraTo(LatLng target) {
    try {
      selectedLocation.value = target;
      mapController?.animateCamera(CameraUpdate.newLatLng(target));
      getAddressFromLatLng(target);
    } catch (e) {
      if (kDebugMode) {}
    }
  }
}
