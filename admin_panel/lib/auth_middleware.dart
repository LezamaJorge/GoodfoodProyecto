import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

import 'app/routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Use a synchronous check for login status
    bool isLoggedIn = FirebaseAuth.instance.currentUser == null?false:true; // This should be updated elsewhere in your app
    if (!isLoggedIn && route != Routes.LOGIN_PAGE) {
      return const RouteSettings(name: Routes.LOGIN_PAGE);
    }
    return null;
  }
}
