// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyDriverModel {
  Timestamp? createAt;
  String? driverEmail;
  String? driverId;
  String? driverName;
  List<VerifyDocumentModel>? verifyDocument;

  VerifyDriverModel({
    this.createAt,
    this.driverEmail,
    this.driverId,
    this.driverName,
    this.verifyDocument,
  });

  @override
  String toString() {
    return 'VerifyDriverModel{createAt: $createAt, driverEmail: $driverEmail, driverId: $driverId, driverName: $driverName, verifyDocument: $verifyDocument}';
  }

  VerifyDriverModel.fromJson(Map<String, dynamic> json) {
    createAt = json['createAt'] != null ? Timestamp.fromMillisecondsSinceEpoch(json['createAt'].millisecondsSinceEpoch) : null;
    driverEmail = json['driverEmail'];
    driverId = json['driverId'];
    driverName = json['driverName'];
    if (json['verifyDocument'] != null) {
      verifyDocument = <VerifyDocumentModel>[];
      json['verifyDocument'].forEach((v) {
        verifyDocument!.add(VerifyDocumentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createAt'] = createAt;
    data['driverEmail'] = driverEmail;
    data['driverId'] = driverId;
    data['driverName'] = driverName;
    if (verifyDocument != null) {
      data['verifyDocument'] = verifyDocument!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VerifyDocumentModel {
  String? documentId;
  List<dynamic>? documentImage;
  bool? isVerify;
  bool? isTwoSide;

  VerifyDocumentModel({this.documentId, required this.documentImage, this.isVerify, this.isTwoSide});

  VerifyDocumentModel.fromJson(Map<String, dynamic> json) {
    documentId = json['documentId'];
    documentImage = json["documentImage"] ?? [];
    isVerify = json['isVerify'];
    isTwoSide = json['isTwoSide'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['documentId'] = documentId;
    data['documentImage'] = documentImage ?? [];

    data['isVerify'] = isVerify;
    data['isTwoSide'] = isTwoSide;
    return data;
  }

  VerifyDocumentModel copyWith({
    String? documentId,
    List<dynamic>? documentImage,
    bool? isVerify,
  }) {
    return VerifyDocumentModel(
      documentId: documentId ?? this.documentId,
      documentImage: documentImage ?? this.documentImage,
      isVerify: isVerify ?? this.isVerify,
    );
  }
}

