// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant/app/models/driver_user_model.dart';
import 'package:restaurant/app/models/order_model.dart';
import 'package:restaurant/app/models/user_model.dart';
import 'package:restaurant/app/models/vendor_model.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../constant/constant.dart';

class OrderDetailScreenController extends GetxController {
  RxBool restaurantStatus = true.obs;
  RxBool isLoading = false.obs;
  RxList<String> tagsList = <String>[
    "Preparing",
    "Ready",
    "Pickup",
  ].obs;
  RxString selectedTags = "Preparing".obs;

  Rx<OrderModel> bookingModel = OrderModel().obs;
  Rx<UserModel> customerUserModel = UserModel().obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  Rx<VendorModel> restaurantModel = VendorModel().obs;

  final RxList<dynamic> pairedDevices = <dynamic>[].obs;
  final RxString selectedPrinterMac = ''.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    isLoading.value = true;
    try {
      dynamic argumentData = Get.arguments;
      if (argumentData != null) {
        bookingModel.value = argumentData['BookingModel'];
        await getCustomerProfile();
        await getDriver();
        // await getRestaurant();
      }
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log('Error in getArgument: $e\n$stack');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCustomerProfile() async {
    try {
      final profile = await FireStoreUtils.getCustomerUserProfile(bookingModel.value.customerId!);
      if (profile != null) {
        customerUserModel.value = profile;
      }
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log('Error in getCustomerProfile: $e\n$stack');
      }
    }
  }

  Future<void> getDriver() async {
    try {
      final driver = await FireStoreUtils.getDriverUserProfile(bookingModel.value.driverId.toString());
      if (driver != null) {
        driverModel.value = driver;
      }
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log('Error in getDriver: $e\n$stack');
      }
    }
  }

  Future<void> fetchPairedPrinters() async {
    pairedDevices.clear();
    if (!await requestPermissions()) {
      ShowToastDialog.toast('Bluetooth or Location permission is required.');
      return;
    }
    try {
      final devices = await PrintBluetoothThermal.pairedBluetooths;
      pairedDevices.addAll(devices);
    } catch (e, s) {
      if (kDebugMode) {
        developer.log('Error fetching paired printers:', error: e, stackTrace: s);
      }
      ShowToastDialog.toast('Failed to fetch paired Bluetooth printers.');
    }
  }

  Future<bool> requestPermissions() async {
    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    final allGranted = statuses.values.every((status) => status.isGranted);
    if (!allGranted) {
      debugPrint('Bluetooth or Location permission denied.');
    }
    return allGranted;
  }

  Future<void> printTicket() async {
    try {
      if (!await requestPermissions()) {
        ShowToastDialog.toast('Bluetooth or Location permission is required.');
        return;
      }

      // Step 2: Check if Bluetooth is ON
      bool isBluetoothEnabled = false;
      try {
        isBluetoothEnabled = await PrintBluetoothThermal.bluetoothEnabled;
      } catch (e, s) {
        if (kDebugMode) {
          developer.log('Error checking Bluetooth status:', error: e, stackTrace: s);
        }
        ShowToastDialog.toast('Failed to check Bluetooth status.');
        return;
      }
      if (!isBluetoothEnabled) {
        ShowToastDialog.toast('Please turn on Bluetooth to continue.');
        return;
      }

      await fetchPairedPrinters();
      if (pairedDevices.isEmpty) {
        ShowToastDialog.toast('No paired Bluetooth printers found.');
        return;
      }

      final pickedMac = await Get.dialog<String>(
        PrinterSelectionDialog(devices: pairedDevices),
        barrierDismissible: false,
      );

      if (pickedMac == null || pickedMac.isEmpty) {
        if (kDebugMode) debugPrint('No printer selected.');
        return;
      }

      selectedPrinterMac.value = pickedMac;

      bool connected = false;
      try {
        connected = await PrintBluetoothThermal.connect(macPrinterAddress: pickedMac);
      } catch (e, s) {
        if (kDebugMode) {
          developer.log('Error connecting to printer:', error: e, stackTrace: s);
        }
        ShowToastDialog.toast('Failed to connect to the Bluetooth printer.');
        return;
      }
      if (!connected) {
        ShowToastDialog.toast('Could not connect to the Bluetooth printer.');
        return;
      }

      final buffer = StringBuffer();
      buffer.writeln(Constant.vendorModel?.vendorName ?? 'Vendor');
      buffer.writeln(Constant.vendorModel?.address?.address ?? 'Address');
      buffer.writeln('Phone: ${customerUserModel.value.countryCode ?? ''} ${customerUserModel.value.phoneNumber ?? ''}');
      buffer.writeln('Invoice');
      buffer.writeln('Date: ${Constant.timestampToDateWithTime(bookingModel.value.createdAt!)}');
      buffer.writeln('Customer: ${(customerUserModel.value.firstName ?? '')} ${(customerUserModel.value.lastName ?? '')}');
      buffer.writeln('Bill No: ${Constant.showId(bookingModel.value.id.toString())}');
      buffer.writeln('Payment Mode: ${bookingModel.value.paymentType ?? 'Cash'}');
      buffer.writeln('-----------------------------');

      for (var item in bookingModel.value.items ?? []) {
        final name = item.productName ?? "";
        final qty = item.quantity ?? 0;
        final price = item.totalAmount ?? 0.0;
        buffer.writeln("$name x$qty   ₹${price.toStringAsFixed(2)}");
      }

      buffer.writeln('-----------------------------');
      buffer.writeln('Thank You, Visit Again!');

      final bytes = Uint8List.fromList(utf8.encode(buffer.toString()));

      try {
        await PrintBluetoothThermal.writeBytes(bytes);
      } catch (e, s) {
        if (kDebugMode) {
          developer.log('Error writing bytes to printer:', error: e, stackTrace: s);
        }
        ShowToastDialog.toast('Failed to send receipt to printer.');
        return;
      }

      ShowToastDialog.toast('Receipt sent to printer.');
      if (kDebugMode) debugPrint('Printed successfully on $pickedMac');
    } catch (e, s) {
      if (kDebugMode) {
        developer.log('Print Error:', error: e, stackTrace: s);
      }
      ShowToastDialog.toast('Something went wrong while printing.');
    } finally {
      try {
        await PrintBluetoothThermal.disconnect;
      } catch (e, s) {
        if (kDebugMode) {
          developer.log('Error disconnecting printer:', error: e, stackTrace: s);
        }
      }
    }
  }

}

class PrinterSelectionDialog extends StatelessWidget {
  final List<dynamic> devices;

  const PrinterSelectionDialog({super.key, required this.devices});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Bluetooth Printer'),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: ListView.builder(
          itemCount: devices.length,
          itemBuilder: (_, index) {
            final device = devices[index];
            return ListTile(
              title: Text(device.name ?? 'Unknown'),
              subtitle: Text(device.macAdress ?? ''),
              onTap: () => Navigator.of(context).pop(device.macAdress),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
