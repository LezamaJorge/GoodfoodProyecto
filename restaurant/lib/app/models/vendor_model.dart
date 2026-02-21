// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant/app/models/add_address_model.dart';
import 'package:restaurant/app/models/positions_model.dart';

class VendorModel {
  String? id;
  String? ownerId;
  String? vendorType;
  String? ownerFullName;
  String? vendorName;
  List<OpeningHoursModel>? openingHoursList;
  AddAddressModel? address;
  String? logoImage;
  String? coverImage;
  String? cuisineId;
  String? cuisineName;
  String? userType;
  bool? active;
  bool? isOnline;
  bool? isSelfDelivery;
  Timestamp? createdAt;
  List<dynamic>? likedUser;
  String? reviewSum;
  String? reviewCount;
  Positions? position;

  @override
  String toString() {
    return 'VendorModel{id: $id, ownerId: $ownerId, ownerFullName: $ownerFullName, vendorType: $vendorType, openingHoursList: $openingHoursList, address: $address, vendorName: $vendorName, logoImage: $logoImage, coverImage: $coverImage, cuisineId: $cuisineId, cuisineName: $cuisineName, userType: $userType, active: $active, isOnline: $isOnline, isSelfDelivery: $isSelfDelivery,createdAt: $createdAt, likedUser: $likedUser, reviewSum: $reviewSum, reviewCount: $reviewCount}';
  }

  VendorModel({
    this.id,
    this.ownerId,
    this.ownerFullName,
    this.vendorName,
    this.openingHoursList,
    this.vendorType,
    this.logoImage,
    this.coverImage,
    this.cuisineId,
    this.cuisineName,
    this.userType,
    this.active,
    this.isOnline,
    this.isSelfDelivery,
    this.address,
    this.createdAt,
    this.likedUser,
    this.reviewSum,
    this.reviewCount,
    this.position,
  });

  VendorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['ownerId'];
    ownerFullName = json['ownerFullName'];
    vendorName = json['vendorName'];
    if (json['openingHoursList'] != null) {
      openingHoursList = List<OpeningHoursModel>.from(json['openingHoursList'].map((x) => OpeningHoursModel.fromJson(x)));
    }
    position = json['position'] != null ? Positions.fromJson(json['position']) : Positions();
    vendorType = json['vendorType'];
    logoImage = json['logoImage'];
    coverImage = json['coverImage'];
    cuisineId = json['cuisineId'];
    cuisineName = json['cuisineName'];
    userType = json['userType'];
    active = json['active'];
    isOnline = json['isOnline'];
    isSelfDelivery = json['isSelfDelivery'];
    address = json['address'] != null ? AddAddressModel.fromJson(json['address']) : AddAddressModel();
    createdAt = json['createdAt'];
    likedUser = json['likedUser'] ?? [];
    reviewSum = json['reviewSum'] ?? "0.0";
    reviewCount = json['reviewCount'] ?? "0.0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? "";
    data['ownerId'] = ownerId ?? "";
    data['ownerFullName'] = ownerFullName ?? "";
    data['vendorName'] = vendorName ?? "";
    if (openingHoursList != null) {
      data['openingHoursList'] = openingHoursList!.map((x) => x.toJson()).toList();
    }
    data['vendorType'] = vendorType ?? "";
    data['logoImage'] = logoImage;
    data['coverImage'] = coverImage;
    data['cuisineId'] = cuisineId;
    data['cuisineName'] = cuisineName;
    data['likedUser'] = likedUser;
    data['userType'] = userType ?? "";
    data['active'] = active ?? false;
    data['isOnline'] = isOnline ?? false;
    data['isSelfDelivery'] = isSelfDelivery ?? false;
    data['createdAt'] = createdAt ?? Timestamp.now();
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (position != null) {
      data['position'] = position!.toJson();
    }
    data['reviewSum'] = reviewSum;
    data['reviewCount'] = reviewCount;
    return data;
  }
}

class OpeningHoursModel {
  String? day;
  bool? isOpen;
  String? openingHours;
  String? closingHours;

  OpeningHoursModel({
    this.day,
    this.isOpen,
    this.openingHours,
    this.closingHours,
  });

  @override
  String toString() {
    return 'OpeningHoursModel{day: $day, isOpen: $isOpen, openingHours: $openingHours, closingHours: $closingHours}';
  }

  OpeningHoursModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    isOpen = json['isOpen'];
    openingHours = json['openingHours'];
    closingHours = json['closingHours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day ?? "";
    data['isOpen'] = isOpen ?? true;
    data['openingHours'] = openingHours ?? "";
    data['closingHours'] = closingHours ?? "";
    return data;
  }
}
