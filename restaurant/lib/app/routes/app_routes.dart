// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const LOGIN_SCREEN = _Paths.LOGIN_SCREEN;
  static const SIGNUP_SCREEN = _Paths.SIGNUP_SCREEN;
  static const SPLASH_SCREEN = _Paths.SPLASH_SCREEN;
  static const INTRO_SCREEN = _Paths.INTRO_SCREEN;
  static const LANDING_SCREEN = _Paths.LANDING_SCREEN;
  static const DASHBOARD_SCREEN = _Paths.DASHBOARD_SCREEN;
  static const PROFILE_SCREEN = _Paths.PROFILE_SCREEN;
  static const MENU_SCREEN = _Paths.MENU_SCREEN;
  static const STATISTIC_SCREEN = _Paths.STATISTIC_SCREEN;
  static const RESTAURANT_SCREEN = _Paths.RESTAURANT_SCREEN;
  static const ADD_RESTAURANT_SCREEN = _Paths.ADD_RESTAURANT_SCREEN;
  static const ADD_MENU_ITEMS_SCREEN = _Paths.ADD_MENU_ITEMS_SCREEN;
  static const EDIT_PROFILE_SCREEN = _Paths.EDIT_PROFILE_SCREEN;
  static const MY_BANK = _Paths.MY_BANK;
  static const ADD_BANK = _Paths.ADD_BANK;
  static const MY_WALLET = _Paths.MY_WALLET;
  static const LANGUAGE_SCREEN = _Paths.LANGUAGE_SCREEN;
  static const ORDER_DETAIL_SCREEN = _Paths.ORDER_DETAIL_SCREEN;
  static const ORDER_SCREEN = _Paths.ORDER_SCREEN;
  static const ALL_ORDERS_SCREEN = _Paths.ALL_ORDERS_SCREEN;
  static const NOTIFICATION_SCREEN = _Paths.NOTIFICATION_SCREEN;
  static const ORDER_STATMENT = _Paths.ORDER_STATMENT;
  static const ADD_DRIVER = _Paths.ADD_DRIVER;
  static const DRIVER_DETAILS = _Paths.DRIVER_DETAILS;
  static const DRIVER_ORDER_ASSIGN = _Paths.DRIVER_ORDER_ASSIGN;
}

abstract class _Paths {
  _Paths._();

  static const HOME = '/home';
  static const LOGIN_SCREEN = '/login-screen';
  static const SIGNUP_SCREEN = '/signup-screen';
  static const SPLASH_SCREEN = '/splash-screen';
  static const INTRO_SCREEN = '/intro-screen';
  static const LANDING_SCREEN = '/landing-screen';
  static const DASHBOARD_SCREEN = '/dashboard-screen';
  static const PROFILE_SCREEN = '/profile-screen';
  static const MENU_SCREEN = '/menu-screen';
  static const STATISTIC_SCREEN = '/statistic-screen';
  static const RESTAURANT_SCREEN = '/restaurant-screen';
  static const ADD_RESTAURANT_SCREEN = '/add-restaurant-screen';
  static const ADD_MENU_ITEMS_SCREEN = '/add-menu-items-screen';
  static const EDIT_PROFILE_SCREEN = '/edit-profile-screen';
  static const MY_BANK = '/my-bank';
  static const ADD_BANK = '/add-bank';
  static const MY_WALLET = '/my-wallet';
  static const LANGUAGE_SCREEN = '/language-screen';
  static const ORDER_DETAIL_SCREEN = '/order-detail-screen';
  static const ORDER_SCREEN = '/order-screen';
  static const ALL_ORDERS_SCREEN = '/all-orders-screen';
  static const NOTIFICATION_SCREEN = '/notification-screen';
  static const ORDER_STATMENT = '/order-statment';
  static const ADD_DRIVER = '/add-driver';
  static const DRIVER_DETAILS = '/driver-details';
  static const DRIVER_ORDER_ASSIGN = '/driver-order-assign';
}
