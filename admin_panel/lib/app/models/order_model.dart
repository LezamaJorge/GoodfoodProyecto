// ignore_for_file: depend_on_referenced_packages
import 'package:admin_panel/app/models/add_address_model.dart';
import 'package:admin_panel/app/models/admin_commission_model.dart';
import 'package:admin_panel/app/models/cart_model.dart';
import 'package:admin_panel/app/models/coupon_model.dart';
import 'package:admin_panel/app/models/tax_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        this.cancelledBy,
        this.deliveryCharge,
        this.cancelledReason,
      });

  @override
  String toString() {
    return 'BookingModel{id: $id, customerId: $customerId, vendorId: $vendorId, driverId: $driverId, orderStatus: $orderStatus, foods: $items, customerAddress: $customerAddress, vendorAddress: $vendorAddress, preparationTime: $preparationTime, paymentType: $paymentType, paymentStatus: $paymentStatus, discount: $discount, totalAmount: $totalAmount, subTotal: $subTotal, deliveryInstruction: $deliveryInstruction, cookingInstruction: $cookingInstruction, adminCommission: $adminCommission, createdAt: $createdAt, coupon: $coupon, taxList: $taxList, requestDriverID: $rejectedDriverIds, cancelledBy: $cancelledBy, cancelledReason: $cancelledReason}';
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
    paymentStatus = json['paymentStatus'];
    discount = json['discount'];
    totalAmount = json['totalAmount'];
    subTotal = json['subTotal'];
    deliveryInstruction = json['deliveryInstruction'];
    cookingInstruction = json['cookingInstruction'];
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
    cancelledBy = json['cancelledBy'];
    deliveryCharge = json['deliveryCharge'];
    cancelledReason = json['cancelledReason'];
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
    data['discount'] = discount;
    data['totalAmount'] = totalAmount;
    data['subTotal'] = subTotal;
    data['deliveryInstruction'] = deliveryInstruction;
    data['cookingInstruction'] = cookingInstruction;
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
    data['cancelledBy'] = cancelledBy;
    data['deliveryCharge'] = deliveryCharge;
    data['cancelledReason'] = cancelledReason;
    return data;
  }
}
