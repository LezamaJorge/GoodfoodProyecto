// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class HandymanModel {
  String? id;
  String? providerId;
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? countryCode;
  String? category;
  String? subCategory;
  String? phoneNumber;
  String? fcmToken;
  String? userType;
  bool? active;
  String? password;
  String? profileImage;
  String? address;
  bool? isActive;
  Timestamp? createdAt;

  HandymanModel(
      {this.id,
      this.providerId,
      this.firstName,
      this.lastName,
      this.userName,
      this.email,
      this.countryCode,
      this.phoneNumber,
      this.fcmToken,
      this.userType,
      this.password,
      this.category,
      this.subCategory,
      this.profileImage,
      this.isActive,
      this.active,
      this.address,
      this.createdAt});

  HandymanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['providerId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    userName = json['userName'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    fcmToken = json['fcmToken'];
    userType = json['userType'];
    password = json['password'];
    profileImage = json['profileImage'];
    isActive = json['isActive'];
    active = json['active'];
    address = json['address'];
    category = json['category'];
    subCategory = json['subCategory'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? "";
    data['providerId'] = providerId ?? "";
    data['firstName'] = firstName ?? "";
    data['lastName'] = lastName ?? "";
    data['userName'] = userName ?? "";
    data['email'] = email ?? "";
    data['countryCode'] = countryCode ?? "";
    data['phoneNumber'] = phoneNumber ?? "";
    data['fcmToken'] = fcmToken ?? "";
    data['userType'] = userType ?? "";
    data['password'] = password ?? "";
    data['profileImage'] = profileImage ?? "";
    data['address'] = address ?? "";
    data['category'] = category ?? "";
    data['subCategory'] = subCategory ?? "";
    data['active'] = active ?? false;
    data['isActive'] = isActive ?? true;
    data['createdAt'] = createdAt ?? Timestamp.now();
    return data;
  }
}
