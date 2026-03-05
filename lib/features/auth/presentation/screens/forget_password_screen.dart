import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resq_app/config/routers/route_names.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/core/storage/token_storage.dart';
import 'package:resq_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:resq_app/features/auth/data/repositories/auth_repository.dart';
import 'package:resq_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:resq_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:resq_app/features/auth/presentation/cubit/otp/otp_purpose.dart';
import 'package:resq_app/features/auth/presentation/widgets/build_puttom.dart';
import 'package:resq_app/features/auth/presentation/widgets/build_text_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailOrPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthCubit(AuthRepository(AuthRemoteDataSource(), TokenStorage())),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthNeedsOtp) {
            context.push(
              Routes.otp,
              extra: {
                "email": state.email,
                "purpose": OtpPurpose.resetPassword,
              },
            );
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
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
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator();
                    }

                    return AppButton(
                      text: "Send Code",
                      onTap: () {
                        final email = emailOrPhoneController.text.trim();

                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Enter your email")),
                          );
                          return;
                        }

                        context.read<AuthCubit>().forgotPassword(email);
                      },
                    );
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
        ),
      ),
    );
  }
}
