// ignore_for_file: non_constant_identifier_names

class ConstantModel {
  String? jsonFileURL;
  String? notificationServerKey;
  String? minimumAmountDeposit;
  String? minimumAmountWithdraw;
  String? googleMapKey;
  String? privacyPolicy;
  String? termsAndConditions;
  String? aboutApp;
  String? customerAppColor;
  String? appName;
  String? secondsForOrderCancel;
  String? restaurantAppColor;
  String? driverAppColor;
  bool? isVendorDocumentVerification;
  bool? isDriverDocumentVerification;
  bool? isSelfDelivery;

  ConstantModel(
      {this.jsonFileURL,
      this.notificationServerKey,
      this.googleMapKey,
      this.privacyPolicy,
      this.termsAndConditions,
      this.minimumAmountDeposit,
      this.minimumAmountWithdraw,
      this.aboutApp,
      this.customerAppColor,
      this.appName,
      this.secondsForOrderCancel,
      this.restaurantAppColor,
      this.driverAppColor,
      this.isVendorDocumentVerification,
      this.isDriverDocumentVerification,
      this.isSelfDelivery});

  ConstantModel.fromJson(Map<String, dynamic> json) {
    jsonFileURL = json['jsonFileURL'] ?? '';
    notificationServerKey = json['notification_senderId'] ?? '';
    googleMapKey = json['googleMapKey'] ?? '';
    privacyPolicy = json['privacyPolicy'] ?? '';
    termsAndConditions = json['termsAndConditions'] ?? '';
    minimumAmountDeposit = json['minimum_amount_deposit'] ?? "";
    minimumAmountWithdraw = json['minimum_amount_withdraw'] ?? "";
    aboutApp = json['aboutApp'] ?? '';
    customerAppColor = json['customerAppColor'] ?? '';
    appName = json['appName'] ?? '';
    secondsForOrderCancel = json['secondsForOrderCancel'];
    restaurantAppColor = json['restaurantAppColor'] ?? '';
    driverAppColor = json['driverAppColor'] ?? '';
    isVendorDocumentVerification = json['isVendorDocumentVerification'];
    isDriverDocumentVerification = json['isDriverDocumentVerification'];
    isSelfDelivery = json['isSelfDelivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jsonFileURL'] = jsonFileURL ?? "";
    data['notification_senderId'] = notificationServerKey ?? "";
    data['googleMapKey'] = googleMapKey ?? "";
    data['minimum_amount_deposit'] = minimumAmountDeposit ?? "";
    data['minimum_amount_withdraw'] = minimumAmountWithdraw ?? "";
    data['privacyPolicy'] = privacyPolicy ?? "";
    data['termsAndConditions'] = termsAndConditions ?? "";
    data['aboutApp'] = aboutApp ?? "";
    data['customerAppColor'] = customerAppColor ?? "";
    data['appName'] = appName ?? "";
    data['secondsForOrderCancel'] = secondsForOrderCancel ?? "60";
    data['restaurantAppColor'] = restaurantAppColor ?? "";
    data['driverAppColor'] = driverAppColor ?? "";
    data['isVendorDocumentVerification'] = isVendorDocumentVerification;
    data['isDriverDocumentVerification'] = isDriverDocumentVerification;
    data['isSelfDelivery'] = isSelfDelivery;
    return data;
  }
}
