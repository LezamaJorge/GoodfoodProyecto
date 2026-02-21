// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html; // Flutter Web only

import 'package:admin_panel/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class InactivityHandler extends StatefulWidget {
  final Widget child;

  const InactivityHandler({super.key, required this.child});

  @override
  State<InactivityHandler> createState() => _InactivityHandlerState();
}

class _InactivityHandlerState extends State<InactivityHandler> {
  Timer? _inactivityTimer;
  static const Duration _timeout = Duration(minutes: 5);

  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_timeout, _handleInactivity);
  }

  Future<void> _handleInactivity() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.SPLASH_SCREEN);
  }

  void _startMonitoringWebEvents() {
    html.window.onMouseMove.listen((_) => _resetTimer());
    html.window.onClick.listen((_) => _resetTimer());
    html.window.onKeyDown.listen((_) => _resetTimer());
    html.window.onScroll.listen((_) => _resetTimer());
  }

  @override
  void initState() {
    super.initState();
    _resetTimer();
    _startMonitoringWebEvents();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}