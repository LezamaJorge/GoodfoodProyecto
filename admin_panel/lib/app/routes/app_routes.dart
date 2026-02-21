// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const LOGIN_PAGE = _Paths.LOGIN_PAGE;
  static const DASHBOARD_SCREEN = _Paths.DASHBOARD_SCREEN;
  static const SETTING_SCREEN = _Paths.SETTING_SCREEN;
  static const PROFILE_SETUP = _Paths.PROFILE_SETUP;
  static const CURRENCY = _Paths.CURRENCY;
  static const APP_SETTINGS = _Paths.APP_SETTINGS;
  static const LANGUAGE = _Paths.LANGUAGE;
  static const GENERAL_SETTING = _Paths.GENERAL_SETTING;
  static const CONTACT_US = _Paths.CONTACT_US;
  static const ADMIN_PROFILE = _Paths.ADMIN_PROFILE;
  static const ERROR_SCREEN = _Paths.ERROR_SCREEN;
  static const SPLASH_SCREEN = _Paths.SPLASH_SCREEN;
  static const CUSTOMER_DETAIL_SCREEN = _Paths.CUSTOMER_DETAIL_SCREEN;
  static const CUSTOMER_SCREEN = _Paths.CUSTOMER_SCREEN;
  static const VERIFY_USER_SCREEN = _Paths.VERIFY_USER_SCREEN;
  static const BANNER_SCREEN = _Paths.BANNER_SCREEN;
  static const ORDERS = _Paths.ORDERS;
  static const FOODS = _Paths.FOODS;
  static const CATEGORY = _Paths.CATEGORY;
  static const SUB_CATEGORY = _Paths.SUB_CATEGORY;
  static const RESTAURANT = _Paths.RESTAURANT;
  static const CUISINE = _Paths.CUISINE;
  static const DELIVERY_BOY = _Paths.DELIVERY_BOY;
  static const DOCUMENT_SCREEN = _Paths.DOCUMENT_SCREEN;
  static const CANCELLING_REASON = _Paths.CANCELLING_REASON;
  static const TAX = _Paths.TAX;
  static const DELIVERY_BOY_DETAILS = _Paths.DELIVERY_BOY_DETAILS;
  static const DRIVER_CANCELLING_REASON = _Paths.DRIVER_CANCELLING_REASON;
  static const ORDER_DETAIL_SCREEN = _Paths.ORDER_DETAIL_SCREEN;
  static const FOOD_DETAIL = _Paths.FOOD_DETAIL;
  static const COUPON = _Paths.COUPON;
  static const RESTAURANT_DETAILS = _Paths.RESTAURANT_DETAILS;
  static const PAYOUT_REQUEST_SCREEN = _Paths.PAYOUT_REQUEST_SCREEN;
  static const FINANCE_SETTING_SCREEN = _Paths.FINANCE_SETTING_SCREEN;
  static const POLICY_SETTING_SCREEN = _Paths.POLICY_SETTING_SCREEN;
  static const RESTAURANT_OFFER_SCREEN = _Paths.RESTAURANT_OFFER_SCREEN;
  static const NEW_RESTAURANT_JOIN_REQUEST = _Paths.NEW_RESTAURANT_JOIN_REQUEST;
  static const OWNER = _Paths.OWNER;
  static const OWNER_DETAIL_SCREEN = _Paths.OWNER_DETAIL_SCREEN;
  static const ADD_ONBOARDING = _Paths.ADD_ONBOARDING;

}

abstract class _Paths {
  _Paths._();

  static const HOME = '/home';
  static const LOGIN_PAGE = '/login-page';
  static const DASHBOARD_SCREEN = '/dashboard';
  static const SETTING_SCREEN = '/setting';
  static const PROFILE_SETUP = '/profile-setup';
  static const CURRENCY = '/currency';
  static const APP_SETTINGS = '/app-settings';
  static const LANGUAGE = '/language';
  static const GENERAL_SETTING = '/general-setting';
  static const CONTACT_US = '/contact-us';
  static const ADMIN_PROFILE = '/admin-profile';
  static const ERROR_SCREEN = '/page-not-found';
  static const SPLASH_SCREEN = '/splash';
  static const CUSTOMER_DETAIL_SCREEN = '/customer-details';
  static const CUSTOMER_SCREEN = '/customers';
  static const VERIFY_USER_SCREEN = '/verify-user';
  static const BANNER_SCREEN = '/banner';
  static const ORDERS = '/orders';
  static const FOODS = '/foods';
  static const CATEGORY = '/category';
  static const SUB_CATEGORY = '/sub-category';
  static const RESTAURANT = '/restaurant';
  static const CUISINE = '/cuisine';
  static const DELIVERY_BOY = '/delivery-boy';
  static const DOCUMENT_SCREEN = '/document';
  static const CANCELLING_REASON = '/cancelling-reason';
  static const TAX = '/tax';
  static const DELIVERY_BOY_DETAILS = '/delivery-boy-details';
  static const DRIVER_CANCELLING_REASON = '/delivery-cancelling-details';
  static const ORDER_DETAIL_SCREEN = '/order-details';
  static const FOOD_DETAIL = '/food-details';
  static const COUPON = '/coupon';
  static const RESTAURANT_DETAILS = '/restaurant-details';
  static const PAYOUT_REQUEST_SCREEN = '/payout-request-details';
  static const FINANCE_SETTING_SCREEN = '/finance-setting-details';
  static const POLICY_SETTING_SCREEN = '/policy-setting-details';
  static const RESTAURANT_OFFER_SCREEN = '/restaurant-offer';
  static const NEW_RESTAURANT_JOIN_REQUEST = '/new-restaurant-join-request';
  static const OWNER = '/owner';
  static const OWNER_DETAIL_SCREEN = '/owner-details';
  static const ADD_ONBOARDING = '/add-onboarding';
}
