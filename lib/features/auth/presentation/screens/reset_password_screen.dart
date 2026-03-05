import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resq_app/config/routers/route_names.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/core/storage/token_storage.dart';
import 'package:resq_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:resq_app/features/auth/data/repositories/auth_repository.dart';
import 'package:resq_app/features/auth/presentation/widgets/build_puttom.dart';
import 'package:resq_app/features/auth/presentation/widgets/build_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> resetPassword() async {
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      _showMsg("Please fill all fields");
      return;
    }

    if (password != confirm) {
      _showMsg("Passwords do not match");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await AuthRepository(
        AuthRemoteDataSource(),
        TokenStorage(),
      ).resetPassword(email: widget.email, password: password, otp: widget.otp);

      _showMsg("Password reset successful");

      context.go(Routes.login);
    } catch (e) {
      _showMsg(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Logo
            const Text(
              "ResQ",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 20),

            /// Title
            const Text(
              "Reset Password",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 10),

            /// Description
            Text(
              "Create a new password for\n${widget.email}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            /// Password
            AppTextField(
              hint: "New Password",
              controller: passwordController,
              isPassword: true,
            ),

            const SizedBox(height: 20),

            /// Confirm Password
            AppTextField(
              hint: "Confirm Password",
              controller: confirmPasswordController,
              isPassword: true,
            ),

            const SizedBox(height: 30),

            /// Reset Button
            AppButton(
              text: "Reset Password",
              isLoading: isLoading,
              onTap: resetPassword,
            ),

            const SizedBox(height: 20),

            /// Back to login
            Text.rich(
              TextSpan(
                text: "Remember your password? ",
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: "Login",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.go(Routes.login);
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
