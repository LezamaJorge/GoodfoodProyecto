// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawModel {
  String? id;
  String? ownerId;
  String? note;
  String? paymentStatus;
  String? adminNote;
  String? paymentId;
  String? amount;
  String? type;
  Timestamp? createdDate;
  Timestamp? paymentDate;
  BankDetailsModel? bankDetails;

  WithdrawModel({
    this.id,
    this.ownerId,
    this.note,
    this.paymentStatus,
    this.adminNote,
    this.amount,
    this.type,
    this.paymentId,
    this.createdDate,
    this.paymentDate,
    this.bankDetails,
  });

  @override
  String toString() {
    return 'WithdrawModel{id: $id, ownerId: $ownerId, note: $note, paymentStatus: $paymentStatus, adminNote: $adminNote, amount: $amount, createdDate: $createdDate, paymentDate: $paymentDate, bankDetails: $bankDetails}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ownerId'] = ownerId;
    data['note'] = note;
    data['paymentId'] = paymentId;
    data['type'] = type;
    data['paymentStatus'] = paymentStatus;
    data['adminNote'] = adminNote;
    data['amount'] = amount;
    data['createdDate'] = createdDate;
    data['paymentDate'] = paymentDate;

    if (bankDetails != null) {
      data['bank_details'] = bankDetails!.toJson();
    }
    return data;
  }

  WithdrawModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['ownerId'];
    note = json['note'];
    paymentId = json['paymentId'];
    paymentStatus = json['paymentStatus'];
    adminNote = json['adminNote'];
    amount = json['amount'];
    type = json['type'];
    createdDate = json['createdDate'];
    paymentDate = json['paymentDate'];
    bankDetails = json['bank_details'] != null ? BankDetailsModel.fromJson(json['bank_details']) : null;
  }
}

class BankDetailsModel {
  String? id;
  String? driverId;
  String? holderName;
  String? accountNumber;
  String? swiftCode;
  String? ifscCode;
  String? bankName;
  String? branchCity;
  String? branchCountry;

  BankDetailsModel({
    this.id,
    this.driverId,
    this.holderName,
    this.accountNumber,
    this.swiftCode,
    this.ifscCode,
    this.bankName,
    this.branchCity,
    this.branchCountry,
  });


  @override
  String toString() {
    return 'BankDetailsModel{id: $id, driverId: $driverId, holderName: $holderName, accountNumber: $accountNumber, swiftCode: $swiftCode, ifscCode: $ifscCode, bankName: $bankName, branchCity: $branchCity, branchCountry: $branchCountry}';
  }

  BankDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driverId'];
    holderName = json['holderName'];
    accountNumber = json['accountNumber'];
    swiftCode = json['swiftCode'];
    ifscCode = json['ifscCode'];
    bankName = json['bankName'];
    branchCity = json['branchCity'];
    branchCountry = json['branchCountry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['driverId'] = driverId;
    data['holderName'] = holderName;
    data['accountNumber'] = accountNumber;
    data['swiftCode'] = swiftCode;
    data['ifscCode'] = ifscCode;
    data['bankName'] = bankName;
    data['branchCity'] = branchCity;
    data['branchCountry'] = branchCountry;
    return data;
  }
}
