import 'package:get/get.dart';

import '../modules/add_bank/bindings/add_bank_binding.dart';
import '../modules/add_bank/views/add_bank_view.dart';
import '../modules/add_driver/bindings/add_driver_bindings.dart';
import '../modules/add_driver/views/add_driver_views.dart';
import '../modules/add_menu_item_screen/bindings/add_menu_item_screen_binding.dart';
import '../modules/add_menu_item_screen/views/add_menu_item_screen_view.dart';
import '../modules/add_restaurant_screen/bindings/add_restaurant_screen_binding.dart';
import '../modules/add_restaurant_screen/views/add_restaurant_screen_view.dart';
import '../modules/all_orders/bindings/all_orders_binding.dart';
import '../modules/all_orders/views/all_orders_view.dart';
import '../modules/dashboard_screen/bindings/dashboard_screen_binding.dart';
import '../modules/dashboard_screen/views/dashboard_screen_view.dart';
import '../modules/driver_details/bindings/driver_details_bindings.dart';
import '../modules/driver_details/views/driver_details_views.dart';
import '../modules/driver_order_assign/bindings/driver_order_assign_binding.dart';
import '../modules/driver_order_assign/views/driver_order_assign_view.dart';
import '../modules/edit_profile_screen/bindings/edit_profile_screen_binding.dart';
import '../modules/edit_profile_screen/views/edit_profile_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/intro_screen/bindings/intro_screen_binding.dart';
import '../modules/intro_screen/views/intro_screen_view.dart';
import '../modules/landing_screen/bindings/landing_screen_binding.dart';
import '../modules/landing_screen/views/landing_screen_view.dart';
import '../modules/language_screen/bindings/language_screen_binding.dart';
import '../modules/language_screen/views/language_screen_view.dart';
import '../modules/login_screen/bindings/login_screen_binding.dart';
import '../modules/login_screen/views/login_screen_view.dart';
import '../modules/menu_screen/bindings/menu_screen_binding.dart';
import '../modules/menu_screen/views/menu_screen_view.dart';
import '../modules/my_bank/bindings/my_bank_binding.dart';
import '../modules/my_bank/views/my_bank_view.dart';
import '../modules/my_wallet/bindings/my_wallet_binding.dart';
import '../modules/my_wallet/views/my_wallet_view.dart';
import '../modules/notification_screen/bindings/notification_screen_binding.dart';
import '../modules/notification_screen/views/notification_screen_view.dart';
import '../modules/order_detail_screen/bindings/order_detail_screen_binding.dart';
import '../modules/order_detail_screen/views/order_detail_screen_view.dart';
import '../modules/order_screen/bindings/order_screen_binding.dart';
import '../modules/order_screen/views/order_screen_view.dart';
import '../modules/profile_screen/bindings/profile_screen_binding.dart';
import '../modules/profile_screen/views/profile_screen_view.dart';
import '../modules/restaurant_screen/bindings/restaurant_screen_binding.dart';
import '../modules/restaurant_screen/views/restaurant_screen_view.dart';
import '../modules/signup_screen/bindings/signup_screen_binding.dart';
import '../modules/signup_screen/views/signup_screen_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/statement_screen/bindings/statement_binding.dart';
import '../modules/statement_screen/views/statement_view.dart';
import '../modules/statistic_screen/bindings/statistic_screen_binding.dart';
import '../modules/statistic_screen/views/statistic_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_SCREEN,
      page: () => LoginScreenView(),
      binding: LoginScreenBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP_SCREEN,
      page: () => SignupScreenView(),
      binding: SignupScreenBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.INTRO_SCREEN,
      page: () => const IntroScreenView(),
      binding: IntroScreenBinding(),
    ),
    GetPage(
      name: _Paths.LANDING_SCREEN,
      page: () => const LandingScreenView(),
      binding: LandingScreenBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD_SCREEN,
      page: () => const DashboardScreenView(),
      binding: DashboardScreenBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_SCREEN,
      page: () => const ProfileScreenView(),
      binding: ProfileScreenBinding(),
    ),
    GetPage(
      name: _Paths.MENU_SCREEN,
      page: () => const MenuScreenView(),
      binding: MenuScreenBinding(),
    ),
    GetPage(
      name: _Paths.STATISTIC_SCREEN,
      page: () => const StatisticScreenView(),
      binding: StatisticScreenBinding(),
    ),
    GetPage(
      name: _Paths.RESTAURANT_SCREEN,
      page: () => RestaurantScreenView(),
      binding: RestaurantScreenBinding(),
    ),
    GetPage(
      name: _Paths.ADD_RESTAURANT_SCREEN,
      page: () => const AddRestaurantScreenView(),
      binding: AddRestaurantScreenBinding(),
    ),
    GetPage(
      name: _Paths.ADD_MENU_ITEMS_SCREEN,
      page: () => const AddMenuItemsScreenView(),
      binding: AddMenuItemScreenBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE_SCREEN,
      page: () => const EditProfileScreenView(),
      binding: EditProfileScreenBinding(),
    ),
    GetPage(
      name: _Paths.MY_BANK,
      page: () => const MyBankView(),
      binding: MyBankBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BANK,
      page: () => const AddBankView(),
      binding: AddBankBinding(),
    ),
    GetPage(
      name: _Paths.MY_WALLET,
      page: () => const MyWalletView(),
      binding: MyWalletBinding(),
    ),
    GetPage(
      name: _Paths.LANGUAGE_SCREEN,
      page: () => const LanguageScreenView(),
      binding: LanguageScreenBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAIL_SCREEN,
      page: () => const OrderDetailScreenView(),
      binding: OrderDetailScreenBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_SCREEN,
      page: () => const OrderScreenView(),
      binding: OrderScreenBinding(),
    ),
    GetPage(
      name: _Paths.ALL_ORDERS_SCREEN,
      page: () => const AllOrdersView(),
      binding: AllOrdersBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_SCREEN,
      page: () => const NotificationScreenView(),
      binding: NotificationScreenBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_STATMENT,
      page: () => const StatementView(),
      binding: StatementBinding(),
    ),
    GetPage(
      name: _Paths.ADD_DRIVER,
      page: () => const AddDriverView(),
      binding: AddDriverBinding(),
    ),
    GetPage(
      name: _Paths.DRIVER_DETAILS,
      page: () => const DriverDetailsViews(),
      binding: DriverDetailsBindings(),
    ),
    GetPage(
      name: _Paths.DRIVER_ORDER_ASSIGN,
      page: () => const DriverOrderAssignView(),
      binding: DriverOrderAssignBinding(),
    ),
  ];
}
