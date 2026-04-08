import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resq_app/config/routers/route_names.dart';
import 'package:resq_app/core/storage/token_storage.dart';
import 'package:resq_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:resq_app/features/profile/presentation/widgets/profile_item_card.dart';
import 'package:resq_app/features/profile/presentation/widgets/theme_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07142A),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              const ProfileHeader(),

              const SizedBox(height: 30),

              ProfileItemCard(
                icon: Icons.person,
                title: "Account",
                subtitle: "Manage personal information",
                onTap: () {
                  // Navigate to Account Screen
                  context.push(
                    Routes.acount,
                    extra: context.read<ProfileBloc>(),
                  );
                },
              ),

              const SizedBox(height: 20),

              const ThemeCard(),

              const SizedBox(height: 20),

              ProfileItemCard(
                icon: Icons.info,
                title: "Support and Information",
                subtitle: "Contact support or view help center",
                onTap: () {
                  // Navigate to Support Screen
                  context.push(Routes.support);
                },
              ),

              const SizedBox(height: 20),

              ProfileItemCard(
                icon: Icons.description,
                title: "Terms and Policies",
                subtitle: "View privacy policy and terms of service",
                onTap: () {
                  // Navigate to Terms Screen
                  context.push(Routes.terms);
                },
              ),

              const SizedBox(height: 20),

              ProfileItemCard(
                icon: Icons.logout,
                title: "Log Out",
                subtitle: "Sign out from the account",
                color: Colors.red,
                onTap: () async {
                  final tokenStorage = TokenStorage();

                  /// مسح التوكن
                  await tokenStorage.clear();

                  /// مسح role
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove("role");

                  context.go(Routes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
