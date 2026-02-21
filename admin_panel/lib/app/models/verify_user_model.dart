// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:admin_panel/app/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class VerifyUserModel {
  Timestamp? createAt;
  String? userEmail;
  String? userId;
  String? userName;
  String? selfieImage;
  String? isVerify;
  String? reason;


  VerifyUserModel({
    this.createAt,
    this.userEmail,
    this.userId,
    this.userName,
    this.selfieImage,
    this.isVerify,
    this.reason,
  });

  @override
  String toString() {
    return 'VerifyUserModel{createAt: $createAt, userEmail: $userEmail, userId: $userId, userName: $userName, selfieImage: $selfieImage, isVerify: $isVerify, reason: $reason}';
  }

  factory VerifyUserModel.fromRawJson(String str) => VerifyUserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyUserModel.fromJson(Map<String, dynamic> json) => VerifyUserModel(
    createAt: json["createAt"] != null ? json["createAt"] as Timestamp : null,
    userEmail: json["userEmail"],
    userId: json["userId"],
    userName: json["userName"],
    selfieImage: json["selfieImage"],
    isVerify: json["isVerify"] ?? Constant.statusPending,
    reason: json["reason"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "createAt": createAt,
    "userEmail": userEmail,
    "userId": userId,
    "userName": userName,
    "selfieImage": selfieImage,
    "isVerify": isVerify?? Constant.statusPending,
    "reason": reason ?? "",
  };
}
