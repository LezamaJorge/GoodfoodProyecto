// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentModel {
  String? id;
  String? name;
  bool? active;

  DocumentModel({
    this.id,
    this.name,
    this.active,
  });

  DocumentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['active'] = active;
    return data;
  }
}

class RestaurantDocumentsModel {
  String? ownerId;
  String? vendorId;
  String? ownerName;
  String? vendorName;
  String? ownerEmail;
  Timestamp? createAt;

  List<VerifyDocumentModel>? verifyDocument;

  RestaurantDocumentsModel({this.ownerId, this.vendorId, this.verifyDocument, this.createAt, this.ownerName, this.vendorName, this.ownerEmail});

  RestaurantDocumentsModel.fromJson(Map<String, dynamic> json) {
    ownerId = json['ownerId'];
    vendorId = json['vendorId'];
    ownerName = json['ownerName'];
    vendorName = json['vendorName'];
    ownerEmail = json['ownerEmail'];
    createAt = json['createAt'] ?? Timestamp.now();
    if (json['verifyDocument'] != null) {
      verifyDocument = <VerifyDocumentModel>[];
      json['verifyDocument'].forEach((v) {
        verifyDocument!.add(VerifyDocumentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ownerId'] = ownerId;
    data['vendorId'] = vendorId;
    data['ownerName'] = ownerName;
    data['vendorName'] = vendorName;
    data['ownerEmail'] = ownerEmail;
    data['createAt'] = createAt;
    if (verifyDocument != null) {
      data['verifyDocument'] = verifyDocument!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VerifyDocumentModel {
  String? documentId;
  String? documentImage;
  bool? isVerify;

  VerifyDocumentModel({this.documentId, this.documentImage, this.isVerify});

  VerifyDocumentModel.fromJson(Map<String, dynamic> json) {
    documentId = json['documentId'];
    documentImage = json['documentImage'];
    isVerify = json['isVerify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['documentId'] = documentId;
    data['documentImage'] = documentImage;
    data['isVerify'] = isVerify;
    return data;
  }
}
