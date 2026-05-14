import 'package:resq_app/core/theme/theme_ext.dart';
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
import 'package:resq_app/features/auth/presentation/widgets/firsraid_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  String? validateInputs() {
    if (phoneController.text.isEmpty) {
      return "Please enter phone number";
    }

    if (phoneController.text.length != 11) {
      return "Phone number must be 11 digits";
    }

    if (idController.text.isEmpty) {
      return "Please enter ID number";
    }

    if (passwordController.text.isEmpty) {
      return "Please enter password";
    }

    return null;
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthCubit(AuthRepository(AuthRemoteDataSource(), TokenStorage())),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go("/auth-gate");
          }

          if (state is AuthNeedsOtp) {
            context.go(
              Routes.otp,
              extra: {
                "email": state.email,
                "purpose": OtpPurpose.signup,
              },
            );
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.backgroundColorDeep,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 24,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      const Text(
                        "ResQ",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Welcome!\nLogin",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      AppTextField(hint: "ID Number", controller: idController),

                      const SizedBox(height: 20),

                      AppTextField(
                        hint: "phone number",
                        controller: phoneController,
                      ),

                      const SizedBox(height: 20),

                      AppTextField(
                        hint: "password",
                        controller: passwordController,
                        isPassword: true,
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.push(Routes.forgetPassword);
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      state is AuthLoading
                          ? const CircularProgressIndicator()
                          : AppButton(
                              text: "Login",
                              onTap: () {
                                final error = validateInputs();

                                if (error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error)),
                                  );
                                  return;
                                }

                                context.read<AuthCubit>().login(
                                  phone: phoneController.text.trim(),
                                  idNumber: idController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              },
                            ),

                      const SizedBox(height: 25),

                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: "create one",
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push(Routes.signup);
                                },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// ====== BUTTONS ======
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const EmergencyNumbersScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: context.surfaceLightColor.withValues(
                                    alpha: 0.74,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: context.borderColor),
                                ),
                                child: Column(
                                  children: const [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Color(0xff2A1A1A),
                                      child: Icon(
                                        Icons.phone,
                                        color: AppColors.primary,
                                        size: 28,
                                      ),
                                    ),

                                    SizedBox(height: 15),

                                    Text(
                                      "Emergency",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      "Numbers",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const FirstAidScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: context.surfaceLightColor.withValues(
                                    alpha: 0.74,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: context.borderColor),
                                ),
                                child: Column(
                                  children: const [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Color(0xff2A1A1A),
                                      child: Icon(
                                        Icons.medical_services,
                                        color: AppColors.primary,
                                        size: 28,
                                      ),
                                    ),

                                    SizedBox(height: 15),

                                    Text(
                                      "First Aid",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      "Instructions",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
