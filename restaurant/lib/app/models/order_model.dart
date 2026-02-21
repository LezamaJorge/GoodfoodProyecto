// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant/app/models/add_address_model.dart';
import 'package:restaurant/app/models/admin_commission.dart';
import 'package:restaurant/app/models/cart_model.dart';
import 'package:restaurant/app/models/coupon_model.dart';
import 'package:restaurant/app/models/tax_model.dart';

class OrderModel {
  String? id;
  String? customerId;
  String? vendorId;
  String? driverId;
  String? orderStatus;
  List<CartModel>? items;
  AddAddressModel? customerAddress;
  AddAddressModel? vendorAddress;
  String? preparationTime;
  String? paymentType;
  bool? paymentStatus;
  String? discount;
  String? transactionPaymentId;
  String? totalAmount;
  String? subTotal;
  String? deliveryInstruction;
  String? cookingInstruction;
  AdminCommission? adminCommission;
  Timestamp? createdAt;
  CouponModel? coupon;
  List<TaxModel>? taxList;
  bool? foodIsReadyToPickup;
  List<dynamic>? rejectedDriverIds;
  String? cancelledBy;
  String? deliveryCharge;
  String? cancelledReason;
  String? deliveryType;
  Timestamp? assignedAt;

  OrderModel(
      {this.id,
      this.customerId,
      this.vendorId,
      this.driverId,
      this.orderStatus,
      this.items,
      this.customerAddress,
      this.vendorAddress,
      this.preparationTime,
      this.createdAt,
      this.paymentType,
      this.paymentStatus,
      this.discount,
      this.coupon,
      this.totalAmount,
      this.subTotal,
      this.deliveryInstruction,
      this.cookingInstruction,
      this.adminCommission,
      this.taxList,
      this.foodIsReadyToPickup,
      this.rejectedDriverIds,
      this.transactionPaymentId,
      this.cancelledReason,
      this.cancelledBy,
      this.deliveryCharge,
      this.deliveryType, this.assignedAt});

  @override
  String toString() {
    return 'OrderModel{id: $id, customerId: $customerId, vendorId: $vendorId, driverId: $driverId, orderStatus: $orderStatus, items: $items, customerAddress: $customerAddress, vendorAddress: $vendorAddress, preparationTime: $preparationTime, paymentType: $paymentType, paymentStatus: $paymentStatus, discount: $discount, totalAmount: $totalAmount, subTotal: $subTotal, deliveryInstruction: $deliveryInstruction, cookingInstruction: $cookingInstruction, adminCommission: $adminCommission, createdAt: $createdAt, coupon: $coupon, taxList: $taxList, requestDriverID: $rejectedDriverIds , deliveryType: $deliveryType, assignedAt:$assignedAt}';
  }

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    vendorId = json['vendorId'];
    driverId = json['driverId'];
    orderStatus = json['orderStatus'];
    preparationTime = json['preparationTime'];
    createdAt = json['createdAt'];
    paymentType = json['paymentType'];
    transactionPaymentId = json['transactionPaymentId'];
    paymentStatus = json['paymentStatus'];
    discount = json['discount'];
    totalAmount = json['totalAmount'];
    subTotal = json['subTotal'];
    deliveryInstruction = json['deliveryInstruction'];
    cookingInstruction = json['cookingInstruction'];
    cancelledReason = json['cancelledReason'];
    cancelledBy = json['cancelledBy'];
    cancelledBy = json['cancelledBy'];
    deliveryCharge = json['deliveryCharge'];
    assignedAt = json['assignedAt'];
    if (json['cartItems'] != null) {
      if (json['cartItems'] is List) {
        items = List<CartModel>.from(json['cartItems'].map((x) => CartModel.fromJson(x)));
      } else {
        items = [];
      }
    } else {
      items = [];
    }
    customerAddress = json['customerAddress'] != null ? AddAddressModel.fromJson(json['customerAddress']) : AddAddressModel();
    vendorAddress = json['vendorAddress'] != null ? AddAddressModel.fromJson(json['vendorAddress']) : AddAddressModel();
    adminCommission = json['adminCommission'] != null ? AdminCommission.fromJson(json['adminCommission']) : null;
    coupon = json['coupon'] != null ? CouponModel.fromJson(json['coupon']) : null;
    if (json['taxList'] != null) {
      taxList = <TaxModel>[];
      json['taxList'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    foodIsReadyToPickup = json['foodIsReadyToPickup'];
    rejectedDriverIds = json['rejectedDriverIds'] ?? [];
    deliveryType = json['deliveryType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customerId'] = customerId;
    data['vendorId'] = vendorId;
    data['driverId'] = driverId;
    data['orderStatus'] = orderStatus;
    data['preparationTime'] = preparationTime;
    data['createdAt'] = createdAt;
    data['paymentType'] = paymentType;
    data['paymentStatus'] = paymentStatus;
    data['transactionPaymentId'] = transactionPaymentId;
    data['discount'] = discount;
    data['totalAmount'] = totalAmount;
    data['subTotal'] = subTotal;
    data['deliveryInstruction'] = deliveryInstruction;
    data['cookingInstruction'] = cookingInstruction;
    data['cancelledReason'] = cancelledReason;
    data['deliveryCharge'] = deliveryCharge;
    data['cancelledBy'] = cancelledBy;
    if (items != null) {
      data['cartItems'] = items!.map((item) => item.toJson()).toList();
    }
    if (customerAddress != null) {
      data['customerAddress'] = customerAddress!.toJson();
    }
    if (vendorAddress != null) {
      data['vendorAddress'] = vendorAddress!.toJson();
    }
    if (adminCommission != null) {
      data['adminCommission'] = adminCommission!.toJson();
    }
    if (coupon != null) {
      data['coupon'] = coupon!.toJson();
    }
    if (taxList != null) {
      data['taxList'] = taxList!.map((v) => v.toJson()).toList();
    }
    data['rejectedDriverIds'] = rejectedDriverIds;
    data['foodIsReadyToPickup'] = foodIsReadyToPickup;
    data['deliveryType'] = deliveryType;
    data['assignedAt'] = assignedAt;
    return data;
  }
}
