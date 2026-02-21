import 'package:admin_panel/app/modules/add_onboarding/bindings/add_onboarding_binding.dart';
import 'package:admin_panel/app/modules/add_onboarding/views/add_onboarding_view.dart';
import 'package:admin_panel/app/modules/banner_screen/bindings/banner_screen_binding.dart';
import 'package:admin_panel/app/modules/banner_screen/views/banner_screen_view.dart';
import 'package:admin_panel/app/modules/cancelling_reason/bindings/cancelling_reason_binding.dart';
import 'package:admin_panel/app/modules/cancelling_reason/views/cancelling_reason_view.dart';
import 'package:admin_panel/app/modules/category/bindings/categories_binding.dart';
import 'package:admin_panel/app/modules/category/views/categories_view.dart';
import 'package:admin_panel/app/modules/coupon_screen/bindings/coupon_screen_binding.dart';
import 'package:admin_panel/app/modules/coupon_screen/views/coupon_screen_view.dart';
import 'package:admin_panel/app/modules/cuisine/bindings/cuisine_binding.dart';
import 'package:admin_panel/app/modules/cuisine/views/cuisine_view.dart';
import 'package:admin_panel/app/modules/customer_detail_screen/bindings/customer_detail_screen_binding.dart';
import 'package:admin_panel/app/modules/customer_detail_screen/views/customer_detail_screen_view.dart';
import 'package:admin_panel/app/modules/customer_screen/bindings/customer_screen_binding.dart';
import 'package:admin_panel/app/modules/customer_screen/views/customer_screen_view.dart';
import 'package:admin_panel/app/modules/delivery_boy/bindings/delivery_boy_binding.dart';
import 'package:admin_panel/app/modules/delivery_boy/views/delivery_boy_view.dart';
import 'package:admin_panel/app/modules/delivery_boy_details/bindings/delivery_boy_details_binding.dart';
import 'package:admin_panel/app/modules/delivery_boy_details/views/delivery_boy_details_view.dart';
import 'package:admin_panel/app/modules/document_screen/bindings/document_screen_binding.dart';
import 'package:admin_panel/app/modules/document_screen/views/document_screen_view.dart';
import 'package:admin_panel/app/modules/driver_cancelling_reason/bindings/driver_cancelling_reason_binding.dart';
import 'package:admin_panel/app/modules/driver_cancelling_reason/views/driver_cancelling_reason_view.dart';
import 'package:admin_panel/app/modules/finance_setting/bindings/finance_setting_binding.dart';
import 'package:admin_panel/app/modules/finance_setting/views/finance_setting_view.dart';
import 'package:admin_panel/app/modules/food_detail/bindings/food_detail_binding.dart';
import 'package:admin_panel/app/modules/food_detail/views/food_detail_view.dart';
import 'package:admin_panel/app/modules/foods/bindings/foods_binding.dart';
import 'package:admin_panel/app/modules/foods/views/foods_view.dart';
import 'package:admin_panel/app/modules/order_detail_screen/bindings/order_detail_binding.dart';
import 'package:admin_panel/app/modules/order_detail_screen/views/order_detail_view.dart';
import 'package:admin_panel/app/modules/orders/bindings/orders_binding.dart';
import 'package:admin_panel/app/modules/orders/views/orders_view.dart';
import 'package:admin_panel/app/modules/pauout_request/bindings/payout_request_binding.dart';
import 'package:admin_panel/app/modules/pauout_request/views/payout_request_view.dart';
import 'package:admin_panel/app/modules/policy_setting/bindings/policy_setting_binding.dart';
import 'package:admin_panel/app/modules/policy_setting/views/policy_setting_view.dart';
import 'package:admin_panel/app/modules/restaurant/bindings/restaurant_binding.dart';
import 'package:admin_panel/app/modules/restaurant/views/restaurant_view.dart';
import 'package:admin_panel/app/modules/restaurant_details/bindings/restaurant_details_binding.dart';
import 'package:admin_panel/app/modules/restaurant_details/views/restaurant_details_view.dart';
import 'package:admin_panel/app/modules/sub_category/bindings/sub_categories_binding.dart';
import 'package:admin_panel/app/modules/sub_category/views/sub_categories_view.dart';
import 'package:admin_panel/app/modules/verify_document_screen/bindings/verify_delivery_boy_screen_binding.dart';
import 'package:admin_panel/app/modules/verify_document_screen/views/verify_delivery_boy_screen_view.dart';
import 'package:admin_panel/app/modules/new_join_restaurant_screen/bindings/new_restaurant_join_request_screen_binding.dart';
import 'package:admin_panel/app/modules/new_join_restaurant_screen/views/new_restaurant_join_request_view.dart';
import 'package:admin_panel/app/restaurant_offer_screen/views/restaurant_offer_screen_view.dart';
import 'package:admin_panel/auth_middleware.dart';
import 'package:get/get.dart';
import '../modules/admin_profile/bindings/admin_profile_binding.dart';
import '../modules/admin_profile/views/admin_profile_view.dart';
import '../modules/app_settings/bindings/app_settings_binding.dart';
import '../modules/app_settings/views/app_settings_view.dart';
import '../modules/contact_us/bindings/contact_us_binding.dart';
import '../modules/contact_us/views/contact_us_view.dart';
import '../modules/dashboard_screen/bindings/dashboard_screen_binding.dart';
import '../modules/dashboard_screen/views/dashboard_screen_view.dart';
import '../modules/error_screen/bindings/error_screen_binding.dart';
import '../modules/error_screen/views/error_screen_view.dart';
import '../modules/general_setting/bindings/general_setting_binding.dart';
import '../modules/general_setting/views/general_setting_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/language/bindings/language_binding.dart';
import '../modules/language/views/language_view.dart';
import '../modules/login_page/bindings/login_page_binding.dart';
import '../modules/login_page/views/login_page_view.dart';
import '../modules/owner/bindings/owner_binding.dart';
import '../modules/owner/views/owner_view.dart';
import '../modules/owner_details_screen/bindings/owner_detail_binding.dart';
import '../modules/owner_details_screen/views/owner_details_view.dart';
import '../modules/setting_screen/bindings/setting_screen_binding.dart';
import '../modules/setting_screen/views/setting_screen_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.LOGIN_PAGE,
      page: () => const LoginPageView(),
      binding: LoginPageBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.DASHBOARD_SCREEN,
      page: () => const DashboardScreenView(),
      binding: DashboardScreenBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.SETTING_SCREEN,
      page: () => const SettingScreenView(),
      binding: SettingScreenBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.APP_SETTINGS,
      page: () => const AppSettingsView(),
      binding: AppSettingsBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.LANGUAGE,
      page: () => const LanguageView(),
      binding: LanguageBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.GENERAL_SETTING,
      page: () => const GeneralSettingView(),
      binding: GeneralSettingBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.CONTACT_US,
      page: () => const ContactUsView(),
      binding: ContactUsBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.ADMIN_PROFILE,
      page: () => const AdminProfileView(),
      binding: AdminProfileBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.ERROR_SCREEN,
      page: () => const ErrorScreenView(),
      binding: ErrorScreenBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '${Routes.CUSTOMER_DETAIL_SCREEN}/:userId',
      page: () => const CustomerDetailScreenView(),
      binding: CustomerDetailScreenBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.CUSTOMER_SCREEN,
      page: () => const CustomerScreenView(),
      binding: CustomerScreenBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.VERIFY_USER_SCREEN,
      page: () => const VerifyDeliveryBoyScreenView(),
      binding: VerifyDeliveryBoyScreenBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.BANNER_SCREEN,
      page: () => const BannerScreenView(),
      binding: BannerScreenBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.ORDERS,
      page: () => const OrdersView(),
      binding: OrdersBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.FOODS,
      page: () => const FoodsView(),
      binding: FoodsBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.CATEGORY,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.SUB_CATEGORY,
      page: () => const SubCategoryView(),
      binding: SubCategoryBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.RESTAURANT,
      page: () => const RestaurantView(),
      binding: RestaurantBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.CUISINE,
      page: () => const CuisineView(),
      binding: CuisineBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.DELIVERY_BOY,
      page: () => const DeliveryBoyView(),
      binding: DeliveryBoyBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.DOCUMENT_SCREEN,
      page: () => const DocumentScreenView(),
      binding: DocumentScreenBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
        name: _Paths.CANCELLING_REASON,
        page: () => const CancellingReasonView(),
        binding: CancellingReasonBinding(),
        transition: Transition.fadeIn),
    GetPage(
      name: _Paths.RESTAURANT_OFFER_SCREEN,
      page: () => const RestaurantOfferScreenView(),
      binding: BannerScreenBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.DRIVER_CANCELLING_REASON,
      page: () => const DriverCancellingReasonView(),
      binding: DriverCancellingReasonBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: "${Routes.ORDER_DETAIL_SCREEN}/:orderId",
      page: () => const OrderDetailView(),
      binding: OrderDetailBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: "${Routes.DELIVERY_BOY_DETAILS}/:driverId",
      page: () => const DeliveryBoyDetailsView(),
      binding: DeliveryBoyDetailsBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: "${Routes.FOOD_DETAIL}/:productId",
      page: () => const FoodDetailView(),
      binding: FoodDetailBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.COUPON,
      page: () => const CouponScreenView(),
      binding: CouponScreenBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.PAYOUT_REQUEST_SCREEN,
      page: () => const PayoutRequestView(),
      binding: PayoutRequestBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: "${Routes.RESTAURANT_DETAILS}/:restaurantId",
      page: () => const RestaurantDetailsView(),
      binding: RestaurantDetailsBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.FINANCE_SETTING_SCREEN,
      page: () => const FinanceSettingView(),
      binding: FinanceSettingBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.POLICY_SETTING_SCREEN,
      page: () => const PolicySettingView(),
      binding: PolicySettingBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.NEW_RESTAURANT_JOIN_REQUEST,
      page: () => const NewRestaurantJoinRequestScreenView(),
      binding: NewRestaurantJoinRequestBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.OWNER,
      page: () => const OwnerView(),
      binding: OwnerBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: "${Routes.OWNER_DETAIL_SCREEN}/:ownerId",
      page: () => const OwnerDetailsView(),
      binding: OwnerDetailBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.ADD_ONBOARDING,
      page: () => const AddOnboardingView(),
      binding: AddOnboardingBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
  ];
}
