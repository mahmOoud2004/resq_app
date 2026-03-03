import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resq_app/config/routers/route_names.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/core/storage/token_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  /// ✅ فحص هل المستخدم مسجل دخول ولا لا
  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await TokenStorage().getToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      /// المستخدم مسجل دخول
      context.go(Routes.home);
    } else {
      /// المستخدم مش مسجل
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradient1, AppColors.gradient2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Text(
            "ResQ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
