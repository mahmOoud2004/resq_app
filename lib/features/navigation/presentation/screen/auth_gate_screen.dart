import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:resq_app/config/routers/route_names.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';
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
    _checkUser();
  }

  Future<void> _checkUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final savedRole = prefs.getString("role");

      if (token == null || token.isEmpty) {
        _go(Routes.login);
        return;
      }

      if (savedRole != null && savedRole.trim().isNotEmpty) {
        await _navigateByRole(savedRole);
        return;
      }

      final user = await profileApi.getProfile();
      final role = user.role.trim();
      await prefs.setString("role", role);
      await _navigateByRole(role);
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      AppLogger.error(
        'Auth gate failed.',
        name: 'AuthGate',
        error: error,
        stackTrace: stackTrace,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("token");
      await prefs.remove("role");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appException.userMessage)),
        );
      }
      _go(Routes.login);
    }
  }

  Future<void> _navigateByRole(String role) async {
    final normalizedRole = role.toLowerCase().trim();
    if (normalizedRole == "user") {
      await _checkMedicalProfileAndNavigate();
      return;
    }

    if (normalizedRole == "driver") {
      _go("/driver-main");
      return;
    }

    if (normalizedRole == "admin") {
      _go("/admin");
      return;
    }

    _go(Routes.login);
  }

  Future<void> _checkMedicalProfileAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final hasMedicalProfile = prefs.containsKey('medical_profile_data');
    _go(hasMedicalProfile ? Routes.home : Routes.medicalInfo);
  }

  void _go(String route) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.go(route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
