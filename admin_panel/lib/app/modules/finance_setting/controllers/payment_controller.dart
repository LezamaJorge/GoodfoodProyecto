import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/payment_method_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  // paypal
  Rx<TextEditingController> paypalNameController = TextEditingController().obs;
  Rx<TextEditingController> paypalClientKeyController = TextEditingController().obs;
  Rx<TextEditingController> paypalSecretKeyController = TextEditingController().obs;
  Rx<Status> isPaypalActive = Status.active.obs;
  Rx<Status> isPaypalSandBox = Status.active.obs;

  // payStack
  Rx<TextEditingController> payStackNameController = TextEditingController().obs;
  Rx<TextEditingController> payStackSecretKeyController = TextEditingController().obs;
  Rx<Status> isPayStackActive = Status.active.obs;

  // razorpay
  Rx<TextEditingController> razorpayNameController = TextEditingController().obs;
  Rx<TextEditingController> razorpayKeyController = TextEditingController().obs;
  Rx<TextEditingController> razorpaySecretController = TextEditingController().obs;
  Rx<Status> isRazorpayActive = Status.active.obs;
  Rx<Status> isRazorPaySandBox = Status.active.obs;

  // stripe
  Rx<TextEditingController> stripeNameController = TextEditingController().obs;
  Rx<TextEditingController> clientPublishableKeyController = TextEditingController().obs;
  Rx<TextEditingController> stripeSecretKeyController = TextEditingController().obs;
  Rx<Status> isStripeActive = Status.active.obs;
  Rx<Status> isStripeSandBox = Status.active.obs;

  // mercadoPogo
  Rx<TextEditingController> mercadoPogoNameController = TextEditingController().obs;
  Rx<TextEditingController> mercadoPogoAccessTokenController = TextEditingController().obs;
  Rx<Status> isMercadoPogoActive = Status.active.obs;

  // payFast
  Rx<TextEditingController> payFastNameController = TextEditingController().obs;
  Rx<TextEditingController> payFastMerchantKeyController = TextEditingController().obs;
  Rx<TextEditingController> payFastMerchantIDController = TextEditingController().obs;
  Rx<TextEditingController> payFastReturnUrlController = TextEditingController().obs;
  Rx<TextEditingController> payFastNotifyUrlController = TextEditingController().obs;
  Rx<TextEditingController> payFastCancelUrlController = TextEditingController().obs;
  Rx<Status> isPayFastSandBox = Status.active.obs;
  Rx<Status> isPayFastActive = Status.active.obs;

  // flutterWave
  Rx<TextEditingController> flutterWaveNameController = TextEditingController().obs;
  Rx<TextEditingController> flutterWavePublicKeyKeyController = TextEditingController().obs;
  Rx<TextEditingController> flutterWaveSecretKeyKeyController = TextEditingController().obs;
  Rx<Status> isFlutterWaveActive = Status.active.obs;
  Rx<Status> isFlutterWaveSandBox = Status.active.obs;

  //Midtrans
  Rx<TextEditingController> midTransNameController = TextEditingController().obs;
  Rx<TextEditingController> midTransIdController = TextEditingController().obs;
  Rx<TextEditingController> midTransClientKeyController = TextEditingController().obs;
  Rx<TextEditingController> midTransSecretKeyController = TextEditingController().obs;
  Rx<Status> isMidTransActive = Status.active.obs;
  Rx<Status> isMidTransSandBox = Status.active.obs;

  //Xendit
  Rx<TextEditingController> xenditNameController = TextEditingController().obs;
  Rx<TextEditingController> xenditSecretKeyController = TextEditingController().obs;
  Rx<Status> isXenditActive = Status.active.obs;
  Rx<Status> isXenditSandBox = Status.active.obs;

  //cash
  Rx<TextEditingController> cashNameController = TextEditingController().obs;
  Rx<Status> isCashActive = Status.active.obs;

  //wallet
  Rx<TextEditingController> walletNameController = TextEditingController().obs;
  Rx<Status> isWalletActive = Status.active.obs;

  Rx<PaymentModel> paymentModel = PaymentModel().obs;

  RxString title = "Payment".tr.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    isLoading(true);
    await getPaymentData();
    isLoading(false);
    super.onInit();
  }

  Future<void> getPaymentData() async {
    await FireStoreUtils.getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;

        //Midtrans
        if (value.midtrans != null) {
          midTransNameController.value.text = paymentModel.value.midtrans!.name!;
          midTransClientKeyController.value.text = paymentModel.value.midtrans!.midtransClientKey!;
          midTransSecretKeyController.value.text = paymentModel.value.midtrans!.midtransSecretKey!;
          midTransIdController.value.text = paymentModel.value.midtrans!.midtransId!;
          isMidTransActive.value = paymentModel.value.midtrans!.isActive == true ? Status.active : Status.inactive;
          isMidTransSandBox.value = paymentModel.value.midtrans!.isSandbox == true ? Status.active : Status.inactive;
        }

        //Xendit
        if (value.xendit != null) {
          xenditNameController.value.text = paymentModel.value.xendit!.name!;
          xenditSecretKeyController.value.text = paymentModel.value.xendit!.xenditSecretKey!;
          isXenditActive.value = paymentModel.value.xendit!.isActive == true ? Status.active : Status.inactive;
          isXenditSandBox.value = paymentModel.value.xendit!.isSandbox == true ? Status.active : Status.inactive;
        }

        //paypal
        if (value.paypal != null) {
          paypalNameController.value.text = paymentModel.value.paypal!.name!;
          paypalClientKeyController.value.text = paymentModel.value.paypal!.paypalClient!;
          paypalSecretKeyController.value.text = paymentModel.value.paypal!.paypalSecret!;
          isPaypalActive.value = paymentModel.value.paypal!.isActive == true ? Status.active : Status.inactive;
          isPaypalSandBox.value = paymentModel.value.paypal!.isSandbox == true ? Status.active : Status.inactive;
        }
        //razorpay
        if (value.paypal != null) {
          razorpayNameController.value.text = paymentModel.value.razorpay!.name!;
          razorpayKeyController.value.text = paymentModel.value.razorpay!.razorpayKey!;
          razorpaySecretController.value.text = paymentModel.value.razorpay!.razorpaySecret!;
          isRazorpayActive.value = paymentModel.value.razorpay!.isActive == true ? Status.active : Status.inactive;
          isRazorPaySandBox.value = paymentModel.value.razorpay!.isSandbox == true ? Status.active : Status.inactive;
        }

        //stripe
        if (value.strip != null) {
          stripeNameController.value.text = paymentModel.value.strip!.name!;
          clientPublishableKeyController.value.text = paymentModel.value.strip!.clientPublishableKey!;
          stripeSecretKeyController.value.text = paymentModel.value.strip!.stripeSecret!;
          isStripeActive.value = paymentModel.value.strip!.isActive == true ? Status.active : Status.inactive;
          isStripeSandBox.value = paymentModel.value.strip!.isSandbox == true ? Status.active : Status.inactive;
        }

        //payStack
        if (value.payStack != null) {
          payStackNameController.value.text = paymentModel.value.payStack!.name!;
          payStackSecretKeyController.value.text = paymentModel.value.payStack!.payStackSecret!;
          isPayStackActive.value = paymentModel.value.payStack!.isActive == true ? Status.active : Status.inactive;
          // isPayStackSandBox.value = paymentModel.value.payStack!.isSandbox == true ? Status.active : Status.inactive;
        }

        //mercadoPogo
        if (value.paypal != null) {
          mercadoPogoNameController.value.text = paymentModel.value.mercadoPago!.name!;
          mercadoPogoAccessTokenController.value.text = paymentModel.value.mercadoPago!.mercadoPagoAccessToken!;
          isMercadoPogoActive.value = paymentModel.value.mercadoPago!.isActive == true ? Status.active : Status.inactive;
        }

        //payFast
        if (value.paypal != null) {
          payFastNameController.value.text = paymentModel.value.payFast!.name!;
          payFastMerchantKeyController.value.text = paymentModel.value.payFast!.merchantKey!;
          payFastMerchantIDController.value.text = paymentModel.value.payFast!.merchantId!;
          payFastReturnUrlController.value.text = paymentModel.value.payFast!.returnUrl!;
          payFastNotifyUrlController.value.text = paymentModel.value.payFast!.notifyUrl!;
          payFastCancelUrlController.value.text = paymentModel.value.payFast!.cancelUrl!;
          isPayFastActive.value = paymentModel.value.payFast!.isActive == true ? Status.active : Status.inactive;
          isPayFastSandBox.value = paymentModel.value.payFast!.isSandbox == true ? Status.active : Status.inactive;
        }

        //flutterWave
        if (value.paypal != null) {
          flutterWaveNameController.value.text = paymentModel.value.flutterWave!.name!;
          flutterWavePublicKeyKeyController.value.text = paymentModel.value.flutterWave!.publicKey!;
          flutterWaveSecretKeyKeyController.value.text = paymentModel.value.flutterWave!.secretKey!;
          // flutterWavePublicKeyKeyController.value.text = paymentModel.value.flutterWave!.flutterWaveKey!;
          isFlutterWaveActive.value = paymentModel.value.flutterWave!.isActive == true ? Status.active : Status.inactive;
          isFlutterWaveSandBox.value = paymentModel.value.flutterWave!.isSandBox == true ? Status.active : Status.inactive;
        }

        //cash
        if (value.cash != null) {
          cashNameController.value.text = paymentModel.value.cash!.name!;
          isCashActive.value = paymentModel.value.cash!.isActive == true ? Status.active : Status.inactive;
        } else {}

        //wallet
        if (value.wallet != null) {
          walletNameController.value.text = paymentModel.value.wallet!.name!;
          isWalletActive.value = paymentModel.value.wallet!.isActive == true ? Status.active : Status.inactive;
        }
      }
    });
  }

  Future savePayment() async {
    // PayPal
    if (paypalNameController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("PayPal name is required.".tr);
    } else if (paypalClientKeyController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("PayPal Client Key is required.".tr);
    } else if (paypalSecretKeyController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("PayPal Secret Key is required.".tr);
    }

    //Midtrans
    else if (midTransNameController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Please Add MidTrans Name".tr);
    } else if (midTransClientKeyController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Please Add MidTrans Client Key".tr);
    } else if (midTransSecretKeyController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Please Add MidTrans Secret Key");
    } else if (midTransIdController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Please Add MidTrans Id");
    }

    //Xendit
    else if (xenditNameController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Please Add Xendit Name".tr);
    } else if (xenditSecretKeyController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Please Add Xendit Secret Key");
    }

    // PayStack
    else if (payStackNameController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("PayStack name is required.".tr);
    } else if (payStackSecretKeyController.value.text.isEmpty) {
      return ShowToastDialog.errorToast(" PayStack Secret Key is required.".tr);
    }

    // Razorpay (Eazopay)
    else if (razorpayNameController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Razorpay name is required.".tr);
    } else if (razorpayKeyController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Razorpay Key is required.".tr);
    } else if (razorpaySecretController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Razorpay Secret Key is required.".tr);
    }

    // Stripe
    else if (stripeNameController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Stripe name is required.".tr);
    } else if (clientPublishableKeyController.value.text.isEmpty) {
      return ShowToastDialog.errorToast(" Stripe Publishable Key is required.".tr);
    } else if (stripeSecretKeyController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Stripe Secret Key is required.".tr);
    }

    // MercadoPago
    else if (mercadoPogoNameController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Mercado Pago name is required.".tr);
    } else if (mercadoPogoAccessTokenController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Mercado Pago Access Token is required.".tr);
    }

    // PayFast
    else if (payFastNameController.value.text.isEmpty) {
      return ShowToastDialog.errorToast(" PayFast name is required.".tr);
    } else if (payFastMerchantKeyController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("PayFast Merchant Key is required.".tr);
    } else if (payFastMerchantIDController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("PayFast Merchant ID is required.".tr);
    } else if (payFastReturnUrlController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("PayFast Return URL is required.".tr);
    } else if (payFastNotifyUrlController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("PayFast Notify URL is required.".tr);
    } else if (payFastCancelUrlController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("PayFast Cancel URL is required.".tr);
    }

    // FlutterWave
    else if (flutterWaveNameController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("FlutterWave name is required.".tr);
    } else if (flutterWavePublicKeyKeyController.value.text.isEmpty) {
      return ShowToastDialog.errorToast(" FlutterWave Public Key is required.".tr);
    } else if (flutterWaveSecretKeyKeyController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("FlutterWave Secret Key is required.".tr);
    }

    // Cash
    else if (cashNameController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Cash payment name is required.".tr);
    }

    // Wallet
    else if (walletNameController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Wallet payment name is required.".tr);
    }

    // If all conditions are met, save the payment details
    else {
      Constant.waitingLoader();

      //Xendit
      paymentModel.value.xendit ??= Xendit();
      paymentModel.value.xendit!
        ..name = xenditNameController.value.text
        ..xenditSecretKey = xenditSecretKeyController.value.text
        ..isActive = isXenditActive.value == Status.active ? true : false
        ..isSandbox = isXenditSandBox.value == Status.active ? true : false;

      //MidTrans
      paymentModel.value.midtrans ??= Midtrans();
      paymentModel.value.midtrans!
        ..name = midTransNameController.value.text
        ..midtransClientKey = midTransClientKeyController.value.text
        ..midtransSecretKey = midTransSecretKeyController.value.text
        ..midtransId = midTransIdController.value.text
        ..isActive = isMidTransActive.value == Status.active ? true : false
        ..isSandbox = isMidTransSandBox.value == Status.active ? true : false;

      // PayPal
      paymentModel.value.paypal?.name = paypalNameController.value.text;
      paymentModel.value.paypal?.paypalClient = paypalClientKeyController.value.text;
      paymentModel.value.paypal?.paypalSecret = paypalSecretKeyController.value.text;
      paymentModel.value.paypal?.isActive = isPaypalActive.value == Status.active ? true : false;
      paymentModel.value.paypal?.isSandbox = isPaypalSandBox.value == Status.active ? true : false;

      // PayStack
      paymentModel.value.payStack?.name = payStackNameController.value.text;
      paymentModel.value.payStack?.payStackSecret = payStackSecretKeyController.value.text;
      paymentModel.value.payStack?.isActive = isPayStackActive.value == Status.active ? true : false;

      // Razorpay
      paymentModel.value.razorpay?.name = razorpayNameController.value.text;
      paymentModel.value.razorpay?.razorpayKey = razorpayKeyController.value.text;
      paymentModel.value.razorpay?.razorpaySecret = razorpaySecretController.value.text;
      paymentModel.value.razorpay?.isActive = isRazorpayActive.value == Status.active ? true : false;
      paymentModel.value.razorpay?.isSandbox = isRazorPaySandBox.value == Status.active ? true : false;

      // Stripe
      paymentModel.value.strip?.name = stripeNameController.value.text;
      paymentModel.value.strip?.clientPublishableKey = clientPublishableKeyController.value.text;
      paymentModel.value.strip?.stripeSecret = stripeSecretKeyController.value.text;
      paymentModel.value.strip?.isActive = isStripeActive.value == Status.active ? true : false;
      paymentModel.value.strip?.isSandbox = isStripeSandBox.value == Status.active ? true : false;

      // MercadoPago
      paymentModel.value.mercadoPago?.name = mercadoPogoNameController.value.text;
      paymentModel.value.mercadoPago?.mercadoPagoAccessToken = mercadoPogoAccessTokenController.value.text;
      paymentModel.value.mercadoPago?.isActive = isMercadoPogoActive.value == Status.active ? true : false;

      // PayFast
      paymentModel.value.payFast?.name = payFastNameController.value.text;
      paymentModel.value.payFast?.merchantKey = payFastMerchantKeyController.value.text;
      paymentModel.value.payFast?.merchantId = payFastMerchantIDController.value.text;
      paymentModel.value.payFast?.returnUrl = payFastReturnUrlController.value.text;
      paymentModel.value.payFast?.notifyUrl = payFastNotifyUrlController.value.text;
      paymentModel.value.payFast?.cancelUrl = payFastCancelUrlController.value.text;
      paymentModel.value.payFast?.isActive = isPayFastActive.value == Status.active ? true : false;
      paymentModel.value.payFast?.isSandbox = isPayFastSandBox.value == Status.active ? true : false;

      // FlutterWave
      paymentModel.value.flutterWave?.name = flutterWaveNameController.value.text;
      paymentModel.value.flutterWave?.publicKey = flutterWavePublicKeyKeyController.value.text;
      paymentModel.value.flutterWave?.secretKey = flutterWaveSecretKeyKeyController.value.text;
      paymentModel.value.flutterWave?.isActive = isFlutterWaveActive.value == Status.active ? true : false;
      paymentModel.value.flutterWave?.isSandBox = isFlutterWaveSandBox.value == Status.active ? true : false;

      // Cash
      paymentModel.value.cash?.name = cashNameController.value.text;
      paymentModel.value.cash?.isActive = isCashActive.value == Status.active ? true : false;

      // Wallet
      paymentModel.value.wallet?.name = walletNameController.value.text;
      paymentModel.value.wallet?.isActive = isWalletActive.value == Status.active ? true : false;

      await FireStoreUtils.setPayment(paymentModel.value).then((value) {
        Get.back();
        ShowToastDialog.successToast("Payment status updated successfully.".tr);
      });
    }
  }
}
