// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:developer';
import 'dart:io';
import 'dart:math' as maths;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart' as razor_pay_flutter;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:restaurant/app/models/bank_detail_model.dart';
import 'package:restaurant/app/models/owner_model.dart';
import 'package:restaurant/app/models/payment_method_model.dart';
import 'package:restaurant/app/models/payment_model/stripe_failed_model.dart';
import 'package:restaurant/app/models/transaction_log_model.dart';
import 'package:restaurant/app/models/wallet_transaction_model.dart';
import 'package:restaurant/app/modules/my_wallet/views/widgets/complete_add_money.dart';
import 'package:restaurant/app/payments/flutter_wave/flutter_wave.dart';
import 'package:restaurant/app/payments/marcado_pago/mercado_pago_screen.dart';
import 'package:restaurant/app/payments/pay_fast/pay_fast_screen.dart';
import 'package:restaurant/app/payments/pay_stack/pay_stack_screen.dart';
import 'package:restaurant/app/payments/pay_stack/pay_stack_url_model.dart';
import 'package:restaurant/app/payments/pay_stack/paystack_url_generator.dart';
import 'package:restaurant/app/payments/paypal/paypal_payment.dart';
import 'package:restaurant/app/payments/xendit/xendit_payment_screen.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:uuid/uuid.dart';
import '../../../payments/midtrans/midtrans_payment_screen.dart';
import '../../../payments/xendit/xendit_model.dart';

class MyWalletController extends GetxController {
  TextEditingController amountController = TextEditingController(text: Constant.minimumAmountToDeposit);
  TextEditingController withdrawalAmountController = TextEditingController(text: Constant.minimumAmountToWithdrawal);
  TextEditingController withdrawalNoteController = TextEditingController();
  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  RxString selectedPaymentMethod = "".obs;
  razor_pay_flutter.Razorpay _razorpay = razor_pay_flutter.Razorpay();
  Rx<OwnerModel> ownerModel = OwnerModel().obs;
  Rx<BankDetailsModel> selectedBankMethod = BankDetailsModel().obs;
  RxList<WalletTransactionModel> walletTransactionList = <WalletTransactionModel>[].obs;
  RxList<BankDetailsModel> bankDetailsList = <BankDetailsModel>[].obs;
  RxInt selectedTabIndex = 0.obs;
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  RxList<String> addMoneyTagList = <String>['50', '100', '200', '500'].obs;
  RxList<String> withdrawMoneyTagList = <String>[].obs;

  RxString selectedAddAmountTags = Constant.minimumAmountToDeposit.obs;
  RxString selectedWithDrawTags = Constant.minimumAmountToWithdrawal.obs;
  Rx<TransactionLogModel> transactionLogModel = TransactionLogModel().obs;

  @override
  void onInit() {
    getPayments();
    withdrawalAmountController.addListener(_onWithdrawalAmountChanged);
    generateDefaultAmountsForWithdraw();
    super.onInit();
  }

  void generateDefaultAmountsForWithdraw() {
    try {
      int baseAmount = int.parse(Constant.minimumAmountToWithdrawal);
      withdrawMoneyTagList.value = [1, 2, 3, 5, 10].map((multiplier) => (baseAmount * multiplier).toString()).toList();
    } catch (e, stack) {
      developer.log("Error generating default withdrawal amounts: $e", stackTrace: stack);
      withdrawMoneyTagList.clear();
    }
  }

  @override
  void onClose() {
    _razorpay.clear();
    withdrawalAmountController.removeListener(_onWithdrawalAmountChanged);
    amountController.dispose();
    withdrawalAmountController.dispose();
    super.onClose();
  }

  void _onWithdrawalAmountChanged() {
    try {
      if (addMoneyTagList.contains(withdrawalAmountController.text)) {
        selectedWithDrawTags.value = withdrawalAmountController.text;
      } else {
        selectedWithDrawTags.value = "";
      }
    } catch (e, stack) {
      developer.log("Error in withdrawal amount listener: $e", stackTrace: stack);
      selectedWithDrawTags.value = "";
    }
  }

  Future<void> getPayments() async {
    try {
      await FireStoreUtils().getPayment().then((value) {
        if (value != null) {
          paymentModel.value = value;

          if (paymentModel.value.strip?.isActive == true) {
            Stripe.publishableKey = paymentModel.value.strip!.clientPublishableKey ?? "";
            Stripe.merchantIdentifier = 'Go4Food';
            Stripe.instance.applySettings();
          }

          if (paymentModel.value.paypal?.isActive == true) {}

          if (paymentModel.value.flutterWave?.isActive == true) {
            setRef();
          }
        }
      });

      await getWalletTransactions();
      await getProfileData();
      await getBankDetails();
    } catch (e, stack) {
      developer.log("Error loading payment settings: $e", stackTrace: stack);
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> getBankDetails() async {
    try {
      bankDetailsList.clear();
      var value = await FireStoreUtils.getBankDetailList(FireStoreUtils.getCurrentUid());
      if (value != null) {
        bankDetailsList.addAll(value);
        if (bankDetailsList.isNotEmpty) {
          selectedBankMethod.value = bankDetailsList[0];
        }
      }
    } catch (e, stack) {
      developer.log("Error fetching bank details: $e", stackTrace: stack);
    }
  }

  Future<void> getWalletTransactions() async {
    try {
      var value = await FireStoreUtils.getWalletTransaction();
      walletTransactionList.value = value ?? [];
    } catch (e, stack) {
      developer.log("Error fetching wallet transactions: $e", stackTrace: stack);
    }
  }

  Future<void> getProfileData() async {
    try {
      var uid = FireStoreUtils.getCurrentUid();
      if (uid != null) {
        var value = await FireStoreUtils.getOwnerProfile(uid);
        if (value != null) {
          ownerModel.value = value;
        }
      }
    } catch (e, stack) {
      developer.log("Error fetching profile data: $e", stackTrace: stack);
    }
  }

  Future<void> setTransactionLog({
    required String transactionId,
    dynamic transactionLog,
    required bool isCredit,
  }) async {
    try {
      transactionLogModel.value.amount = amountController.text;
      transactionLogModel.value.transactionId = transactionId;
      transactionLogModel.value.id = transactionId;
      transactionLogModel.value.transactionLog = transactionLog.toString();
      transactionLogModel.value.isCredit = isCredit;
      transactionLogModel.value.createdAt = Timestamp.now();
      transactionLogModel.value.userId = FireStoreUtils.getCurrentUid();
      transactionLogModel.value.paymentType = selectedPaymentMethod.value;
      transactionLogModel.value.type = 'wallet';

      await FireStoreUtils.setTransactionLog(transactionLogModel.value);
    } catch (e, stack) {
      developer.log("Error setting transaction log: $e", stackTrace: stack);
    }
  }

  Future<void> completeOrder(String transactionId) async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);

      WalletTransactionModel transactionModel = WalletTransactionModel(
        id: Constant.getUuid(),
        amount: amountController.value.text,
        createdDate: Timestamp.now(),
        paymentType: selectedPaymentMethod.value,
        transactionId: transactionId,
        userId: FireStoreUtils.getCurrentUid(),
        isCredit: true,
        type: Constant.owner,
        note: "Wallet Top up",
      );

      bool? success = await FireStoreUtils.setWalletTransaction(transactionModel);
      if (success!) {
        await FireStoreUtils.updateOwnerWallet(amount: amountController.value.text, ownerID: Constant.ownerModel!.id.toString());
        await getProfileData();
        await getWalletTransactions();
      }

      ShowToastDialog.closeLoader();
      ShowToastDialog.toast("Amount added to your wallet.".tr);
    } catch (e, stack) {
      developer.log("Error completing order: $e", stackTrace: stack);
      ShowToastDialog.closeLoader();
    }
  }

  // ::::::::::::::::::::::::::::::::::::::::::::Stripe::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> stripeMakePayment({required String amount}) async {
    try {
      Map<String, dynamic>? paymentIntentData = await createStripeIntent(amount: amount);

      if (paymentIntentData == null || paymentIntentData.containsKey("error")) {
        Get.back();
        ShowToastDialog.toast("Something went wrong. Please contact support.".tr);
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          allowsDelayedPaymentMethods: false,
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
            currencyCode: "USD",
          ),
          style: ThemeMode.system,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: AppThemeData.primary300,
            ),
          ),
          merchantDisplayName: 'Go4Food',
        ),
      );

      displayStripePaymentSheet(
        amount: amount,
        clientSecret: paymentIntentData['client_secret'],
      );
    } catch (e, stack) {
      developer.log("Error during Stripe payment: $e", stackTrace: stack);
      Get.back();
    }
  }

  Future<void> displayStripePaymentSheet({required String amount, required String clientSecret}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((_) async {
        ShowToastDialog.toast("Payment completed successfully.".tr);

        try {
          final paymentIntent = await Stripe.instance.retrievePaymentIntent(clientSecret);
          await completeOrder(paymentIntent.id);
          await setTransactionLog(
            isCredit: true,
            transactionId: paymentIntent.id,
            transactionLog: paymentIntent,
          );
        } catch (e) {
          ShowToastDialog.toast("Failed to retrieve payment details.".tr);
        }
      });
    } on StripeException catch (e) {
      try {
        final errorData = StripePayFailedModel.fromJson(jsonDecode(jsonEncode(e)));
        ShowToastDialog.toast(errorData.error.message);
      } catch (parseError) {
        ShowToastDialog.toast("Payment failed.".tr);
      }
    } catch (e, stack) {
      developer.log("Error displaying Stripe payment sheet: $e", stackTrace: stack);
    }
  }

  Future<dynamic> createStripeIntent({required String amount}) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': "USD",
        'payment_method_types[]': 'card',
        "description": "Stripe Payment",
        "shipping[name]": ownerModel.value.firstName,
        "shipping[address][line1]": "510 Townsend St",
        "shipping[address][postal_code]": "98140",
        "shipping[address][city]": "San Francisco",
        "shipping[address][state]": "CA",
        "shipping[address][country]": "US",
      };

      var stripeSecret = paymentModel.value.strip?.stripeSecret ?? '';
      if (stripeSecret.isEmpty) {
        throw Exception("Stripe secret is not available.");
      }

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $stripeSecret',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Stripe API call failed'};
      }
    } catch (e, stack) {
      developer.log("Error creating Stripe intent: $e", stackTrace: stack);
      return {'error': e.toString()};
    }
  }

  // ::::::::::::::::::::::::::::::::::::::::::::PayPal::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<void> payPalPayment({required String amount}) async {
    try {
      ShowToastDialog.closeLoader();

      await Get.to(() => PaypalPayment(
            onFinish: (result) {
              try {
                if (result != null) {
                  Get.back();
                  ShowToastDialog.toast("Payment successful!".tr);

                  completeOrder(result['orderId']);
                  setTransactionLog(isCredit: true, transactionId: result['orderId'], transactionLog: result);
                } else {
                  ShowToastDialog.toast("Payment was cancelled or failed.".tr);
                }
              } catch (e) {
                ShowToastDialog.toast("Something went wrong during payment handling.".tr);
              }
            },
            price: amount,
            currencyCode: "USD",
            title: "Add Money",
            description: "Add Balance in Wallet",
          ));
    } catch (e, stack) {
      developer.log("Error during PayPal payment: $e", stackTrace: stack);
    }
  }

  // ::::::::::::::::::::::::::::::::::::::::::::RazorPay::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<void> razorpayMakePayment({required String amount}) async {
    try {
      var options = {
        'key': paymentModel.value.razorpay!.razorpayKey,
        "razorPaySecret": paymentModel.value.razorpay!.razorpaySecret,
        'amount': double.parse(amount) * 100,
        "currency": "INR",
        'name': ownerModel.value.firstName,
        "isSandBoxEnabled": paymentModel.value.razorpay!.isSandbox,
        'external': {
          'wallets': ['paytm']
        },
        'send_sms_hash': true,
        'prefill': {'contact': ownerModel.value.phoneNumber, 'email': ownerModel.value.email},
      };

      _razorpay.open(options);
      _razorpay.on(razor_pay_flutter.Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
        _handlePaymentSuccess(response);
      });
      _razorpay.on(razor_pay_flutter.Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(razor_pay_flutter.Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    } catch (e, stack) {
      developer.log("Error during Razorpay payment: $e", stackTrace: stack);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    try {
      ShowToastDialog.toast("Payment completed successfully.".tr);

      completeOrder(response.paymentId ?? DateTime.now().millisecondsSinceEpoch.toString());
      setTransactionLog(
        isCredit: true,
        transactionId: response.paymentId.toString(),
        transactionLog: {response.paymentId, response.paymentId, response.data, response.orderId, response.signature},
      );

      Get.offAll(const CompleteAddMoneyView());

      _razorpay.clear();
      _razorpay = razor_pay_flutter.Razorpay();
    } catch (e, stack) {
      developer.log("Error handling Razorpay payment success: $e", stackTrace: stack);
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    try {
      ShowToastDialog.toast('Payment failed. Please try again.'.tr);
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    try {} finally {
      ShowToastDialog.closeLoader();
    }
  }

  // ::::::::::::::::::::::::::::::::::::::::::::FlutterWave::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> flutterWaveInitiatePayment({required BuildContext context, required String amount}) async {
    try {
      final url = Uri.parse('https://api.flutterwave.com/v3/payments');
      final headers = {
        'Authorization': 'Bearer ${paymentModel.value.flutterWave!.secretKey}',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        "tx_ref": _ref,
        "amount": amount,
        "currency": "USD",
        "redirect_url": '${Constant.paymentCallbackURL}/success',
        "payment_options": "ussd, card, barter, payattitude",
        "customer": {
          "email": Constant.ownerModel!.email.toString(),
          "phonenumber": Constant.ownerModel!.phoneNumber,
          "name": Constant.ownerModel!.firstName,
        },
        "customizations": {
          "title": "Payment for Services",
          "description": "Payment for XYZ services",
        }
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ShowToastDialog.closeLoader();
        await Get.to(FlutterWaveScreen(initialURl: data['data']['link']))!.then((value) {
          try {
            if (value != null && value is Map<String, dynamic>) {
              if (value["status"] == true) {
                ShowToastDialog.toast("Payment successful!".tr);
                completeOrder(_ref ?? '');
                setTransactionLog(isCredit: true, transactionId: value['transaction_id'], transactionLog: value);
              } else {
                ShowToastDialog.toast("Transaction unsuccessful!".tr);
              }
            } else {
              ShowToastDialog.toast("Transaction unsuccessful!".tr);
            }
          } catch (e, stack) {
            developer.log("Error processing FlutterWave payment result: $e", stackTrace: stack);
          }
        });
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.toast("Failed to initiate payment. Please try again.".tr);
        if (kDebugMode) {}
      }
    } catch (e, stack) {
      developer.log("Error during FlutterWave payment: $e", stackTrace: stack);
      ShowToastDialog.closeLoader();
    }
  }

  String? _ref;

  void setRef() {
    try {
      maths.Random numRef = maths.Random();
      int year = DateTime.now().year;
      int refNumber = numRef.nextInt(20000);

      if (Platform.isAndroid) {
        _ref = "AndroidRef$year$refNumber";
      } else if (Platform.isIOS) {
        _ref = "IOSRef$year$refNumber";
      } else {
        _ref = "WEBRef$year$refNumber";
      }
    } catch (e, stack) {
      developer.log("Error setting reference: $e", stackTrace: stack);
      _ref = "FallbackRef${DateTime.now().millisecondsSinceEpoch}";
    }
  }

  // ::::::::::::::::::::::::::::::::::::::::::::PayStack::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<void> payStackPayment(String totalAmount) async {
    try {
      final value = await PayStackURLGen.payStackURLGen(
        amount: (double.parse(totalAmount) * 100).toString(),
        currency: "NGN",
        secretKey: paymentModel.value.payStack!.payStackSecret.toString(),
        userModel: ownerModel.value,
      );

      if (value != null) {
        PayStackUrlModel payStackModel = value;

        final result = await Get.to(PayStackScreen(
          secretKey: paymentModel.value.payStack!.payStackSecret.toString(),
          callBackUrl: Constant.paymentCallbackURL.toString(),
          initialURl: payStackModel.data.authorizationUrl,
          amount: totalAmount,
          reference: payStackModel.data.reference,
        ));

        if (result == true) {
          ShowToastDialog.toast("Payment successful!".tr);
          completeOrder(DateTime.now().millisecondsSinceEpoch.toString());
          Get.offAll(const CompleteAddMoneyView());
        } else {
          ShowToastDialog.toast("Transaction unsuccessful!".tr);
        }
      } else {
        ShowToastDialog.toast("Something went wrong. Please contact support.".tr);
      }
    } catch (e, stack) {
      developer.log("Error during Paystack payment: $e", stackTrace: stack);
    }
  }

  // ::::::::::::::::::::::::::::::::::::::::::::Mercado Pago::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<void> mercadoPagoMakePayment({required BuildContext context, required String amount}) async {
    try {
      final result = await makePreference(amount);

      if (result.isNotEmpty && result['status'] == 200) {
        final paymentResult = await Get.to(
          MercadoPagoScreen(initialURl: result['response']['init_point']),
        );

        if (paymentResult == true) {
          ShowToastDialog.toast("Payment successful!".tr);
          completeOrder(DateTime.now().millisecondsSinceEpoch.toString());
          Get.offAll(const CompleteAddMoneyView());
        } else {
          ShowToastDialog.toast("Payment failed.".tr);
        }
      } else {
        ShowToastDialog.toast("Error processing your transaction.".tr);
      }
    } catch (e, stack) {
      developer.log("Error during Mercado Pago payment: $e", stackTrace: stack);
    }
  }

  Future<Map<String, dynamic>> makePreference(String amount) async {
    try {
      final mp = MP.fromAccessToken(paymentModel.value.mercadoPago!.mercadoPagoAccessToken);

      var pref = {
        "items": [
          {"title": "Wallet TopUp", "quantity": 1, "currency_id": "NGN", "unit_price": double.parse(amount)}
        ],
        "payer": {"email": Constant.ownerModel?.email ?? "customer@example.com"},
        "auto_return": "all",
        "back_urls": {"failure": "${Constant.paymentCallbackURL}/failure", "pending": "${Constant.paymentCallbackURL}/pending", "success": "${Constant.paymentCallbackURL}/success"}
      };

      var result = await mp.createPreference(pref);

      return {
        'status': 200,
        'response': result,
      };
    } catch (e, stack) {
      developer.log("Error creating Mercado Pago preference: $e", stackTrace: stack);
      return {
        'status': 500,
        'error': e.toString(),
      };
    }
  }

  // ::::::::::::::::::::::::::::::::::::::::::::Pay Fast::::::::::::::::::::::::::::::::::::::::::::::::::::

  void payFastPayment({required BuildContext context, required String amount}) async {
    try {
      final htmlData = await PayStackURLGen.getPayHTML(
        payFastSettingData: paymentModel.value.payFast!,
        amount: amount.toString(),
        userModel: ownerModel.value,
      );

      if (htmlData.isEmpty) {
        ShowToastDialog.toast("Unable to generate payment request. Please try again.".tr);
        return;
      }

      final bool isDone = await Get.to(
        PayFastScreen(htmlData: htmlData, payFastSettingData: paymentModel.value.payFast!),
      );

      Get.back();

      if (isDone) {
        ShowToastDialog.toast("Payment completed successfully.".tr);
        completeOrder(DateTime.now().millisecondsSinceEpoch.toString());
        Get.offAll(const CompleteAddMoneyView());
      } else {
        ShowToastDialog.toast("Payment failed.".tr);
      }
    } catch (e, stack) {
      developer.log("Error during PayFast payment: $e", stackTrace: stack);
      Get.back();
      if (kDebugMode) {}
    }
  }

  // :::::::::::::::::::::::::::::::::::::::::::: Xendit ::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> xenditPayment({required BuildContext context, required String amount}) async {
    await createXenditInvoice(amount: double.parse(amount)).then((value) {
      if (value != null) {
        Get.to(
          () => XenditPaymentScreen(
            apiKey: Constant.paymentModel!.xendit!.xenditSecretKey.toString(),
            transId: value.id,
            invoiceUrl: value.invoiceUrl,
          ),
        )!
            .then((value) {
          if (value == true) {
            ShowToastDialog.toast("Payment completed successfully.".tr);
            completeOrder(DateTime.now().millisecondsSinceEpoch.toString());
            Get.offAll(const CompleteAddMoneyView());
          } else {
            log("====>Payment Faild");
          }
        });
      }
    });
  }

  Future<XenditModel?> createXenditInvoice({required num amount}) async {
    const url = 'https://api.xendit.co/v2/invoices';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(Constant.paymentModel!.xendit!.xenditSecretKey.toString()),
    };

    final body = jsonEncode({
      'external_id': const Uuid().v1(),
      'amount': amount,
      'payer_email': Constant.ownerModel!.email.toString(),
      'description': 'Wallet Topup',
      'currency': 'IDR',
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return XenditModel.fromJson(jsonDecode(response.body));
      } else {
        log("❌ Xendit Error: ${response.body}");
        return null;
      }
    } catch (e) {
      log("⚠️ Exception: $e");
      return null;
    }
  }

  String generateBasicAuthHeader(String apiKey) {
    String credentials = '$apiKey:';
    String base64Encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $base64Encoded';
  }

// :::::::::::::::::::::::::::::::::::::::::::: MidTrans ::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<void> midtransPayment({required BuildContext context, required String amount}) async {
    final url = await createMidtransPaymentLink(
      orderId: 'order-${DateTime.now().millisecondsSinceEpoch}',
      amount: double.parse(amount),
      customerEmail: Constant.ownerModel!.email.toString(),
    );

    if (url != null) {
      final result = await Get.to(() => MidtransPaymentScreen(paymentUrl: url));
      if (result == true) {
        ShowToastDialog.toast("Payment completed successfully.".tr);
        completeOrder(DateTime.now().millisecondsSinceEpoch.toString());
        Get.offAll(const CompleteAddMoneyView());
      } else {
        if (kDebugMode) {
          print("Payment Failed or Cancelled");
        }
      }
    }
  }

  Future<String?> createMidtransPaymentLink({required String orderId, required double amount, required String customerEmail}) async {
    final String ordersId = orderId.isNotEmpty ? orderId : const Uuid().v1();

    final Uri url = Uri.parse('https://api.sandbox.midtrans.com/v1/payment-links'); // Use production URL for live

    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(Constant.paymentModel!.midtrans!.midtransSecretKey.toString()),
    };

    final Map<String, dynamic> body = {
      'transaction_details': {'order_id': ordersId, 'gross_amount': amount.toInt()},
      'item_details': [
        {'id': 'item-1', 'name': 'Sample Product', 'price': amount.toInt(), 'quantity': 1},
      ],
      'customer_details': {'first_name': 'John', 'last_name': 'Doe', 'email': customerEmail, 'phone': '081234567890'},
      'redirect_url': 'https://www.google.com?merchant_order_id=$ordersId',
      'usage_limit': 2,
    };

    final response = await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['payment_url'];
    } else {
      if (kDebugMode) {
        print('Error creating payment link: ${response.body}');
      }
      return null;
    }
  }

}
