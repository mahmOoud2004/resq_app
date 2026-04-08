import 'package:flutter/material.dart';
import 'package:resq_app/features/navigation/presentation/screen/driver_main_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:resq_app/features/home/presentation/screens/manger_home_screen.dart';
import 'package:resq_app/features/home/presentation/screens/driver_home_screen.dart';
import 'package:resq_app/features/navigation/presentation/screen/main_screen.dart';
import 'package:resq_app/features/profile/data/datasources/profile_remote_datasource.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  final ProfileRemoteDataSourceImpl profileApi = ProfileRemoteDataSourceImpl();

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      /// نقرأ role المخزن
      final savedRole = prefs.getString("role");

      /// لو موجود → افتح مباشرة
      if (savedRole != null) {
        navigateByRole(savedRole);
        return;
      }

      /// لو مش موجود → نجيب profile من السيرفر
      final user = await profileApi.getProfile();
      final role = user.role;

      /// نخزن role
      await prefs.setString("role", role);

      navigateByRole(role);
    } catch (e) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  void navigateByRole(String role) {
    /// USER
    if (role == "user") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
    /// DRIVER
    else if (role == "driver") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DriverMainScreen()),
      );
    }
    /// MANAGER
    else if (role == "manager") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ManagerHomeScreen()),
      );
    }
    /// fallback
    else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
