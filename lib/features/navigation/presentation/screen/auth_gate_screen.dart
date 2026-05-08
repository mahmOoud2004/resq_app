import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resq_app/features/navigation/presentation/screen/driver_main_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:resq_app/config/routers/route_names.dart';
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
    debugPrint("🚀 AuthGate started");
    checkUser();
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");
    final savedRole = prefs.getString("role");

    debugPrint("🔑 TOKEN FROM PREFS: $token");
    debugPrint("👤 ROLE FROM PREFS: $savedRole");

    /// لو مفيش توكن
    if (token == null || token.isEmpty) {
      debugPrint("❌ No token -> redirect to LOGIN");

      if (!mounted) return;
      context.go(Routes.login);
      return;
    }

    /// لو الرول محفوظ
    if (savedRole != null && savedRole.isNotEmpty) {
      debugPrint("✅ Using saved role: $savedRole");
      navigateByRole(savedRole);
      return;
    }

    /// غير كدا هجيب الرول من الـ API
    try {
      debugPrint("🌐 Fetching profile from API...");

      final user = await profileApi.getProfile();
      final role = user.role;

      debugPrint("🎯 ROLE FROM API: $role");

      await prefs.setString("role", role);

      navigateByRole(role);
    } catch (e) {
      debugPrint("🔥 PROFILE ERROR: $e");

      await prefs.remove("token");
      await prefs.remove("role");

      if (!mounted) return;
      context.go(Routes.login);
    }
  }

  void navigateByRole(String role) {
    if (!mounted) return;

    final normalizedRole = role.toLowerCase().trim();

    debugPrint("➡️ NAVIGATE BY ROLE: $normalizedRole");

    Future.microtask(() {
      /// USER
      if (normalizedRole == "user") {
        debugPrint("👤 OPEN USER HOME");
        _checkMedicalProfileAndNavigate();
      }
      /// DRIVER
      else if (normalizedRole == "driver") {
        debugPrint("🚑 OPEN DRIVER HOME");
        context.go("/driver-main");
      }
      /// ADMIN
      else if (normalizedRole == "admin") {
        debugPrint("🛠 OPEN ADMIN PANEL");
        context.go("/admin");
      }
      /// fallback
      else {
        debugPrint("⚠️ UNKNOWN ROLE -> LOGIN");
        context.go(Routes.login);
      }
    });
  }

  Future<void> _checkMedicalProfileAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    // Assuming we use SharedPreferences key 'medical_profile_data'
    // as defined in MedicalProfileStorage
    final hasMedicalProfile = prefs.containsKey('medical_profile_data');
    
    if (!mounted) return;
    
    if (!hasMedicalProfile) {
      debugPrint("🩺 FIRST TIME: OPEN MEDICAL INFO");
      context.go(Routes.medicalInfo);
    } else {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
