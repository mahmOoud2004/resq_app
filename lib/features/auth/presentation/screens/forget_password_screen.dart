import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resq_app/config/routers/route_names.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/features/auth/presentation/widgets/build_puttom.dart';
import 'package:resq_app/features/auth/presentation/widgets/build_text_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final emailOrPhoneController = TextEditingController();

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
              "Forget Password",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 10),

            /// Description
            const Text(
              "Enter your email or phone number\nwe will send you a verification code",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            /// Input
            AppTextField(
              hint: "Email or phone number",
              controller: emailOrPhoneController,
            ),

            const SizedBox(height: 25),

            /// Button
            AppButton(
              text: "Send Code",
              onTap: () {
                context.push(Routes.otp);
              },
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
                        context.pop();
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
