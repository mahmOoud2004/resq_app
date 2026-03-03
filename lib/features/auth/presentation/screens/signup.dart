import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resq_app/config/routers/route_names.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/core/utils/validators.dart';
import 'package:resq_app/features/auth/presentation/cubit/signup/signup_cubit.dart';
import 'package:resq_app/features/auth/presentation/cubit/signup/signup_state.dart';
import 'package:resq_app/features/auth/presentation/widgets/build_puttom.dart';
import 'package:resq_app/features/auth/presentation/widgets/build_text_field.dart';
import 'package:resq_app/features/auth/presentation/widgets/id_upload.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  File? idImage;
  String? selectedRole;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    idController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Account created successfully")),
            );
            context.go(Routes.otp, extra: emailController.text.trim());
          }

          if (state is SignupError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      const Text(
                        "ResQ",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text("Create Account"),
                      const SizedBox(height: 30),

                      AppTextField(
                        hint: "First Name",
                        controller: firstNameController,
                        validator: (v) =>
                            Validators.required(v ?? "", "First name"),
                      ),

                      const SizedBox(height: 15),

                      AppTextField(
                        hint: "Last Name",
                        controller: lastNameController,
                        validator: (v) =>
                            Validators.required(v ?? "", "Last name"),
                      ),

                      const SizedBox(height: 15),

                      AppTextField(
                        hint: "Email",
                        controller: emailController,
                        validator: (v) {
                          final r = Validators.required(v ?? "", "Email");
                          if (r != null) return r;
                          return Validators.email(v!);
                        },
                      ),

                      const SizedBox(height: 15),

                      AppTextField(
                        hint: "Phone Number",
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (v) {
                          final r = Validators.required(v ?? "", "Phone");
                          if (r != null) return r;
                          return Validators.phone(v!);
                        },
                      ),

                      const SizedBox(height: 15),

                      AppTextField(
                        hint: "ID Number",
                        controller: idController,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          final r = Validators.required(v ?? "", "ID");
                          if (r != null) return r;
                          return Validators.idNumber(v!);
                        },
                      ),

                      const SizedBox(height: 15),

                      AppTextField(
                        hint: "Password",
                        controller: passwordController,
                        isPassword: true,
                        validator: (v) {
                          final r = Validators.required(v ?? "", "Password");
                          if (r != null) return r;
                          return Validators.password(v!);
                        },
                      ),

                      const SizedBox(height: 15),

                      AppTextField(
                        hint: "Confirm Password",
                        controller: confirmPasswordController,
                        isPassword: true,
                        validator: (v) => Validators.confirmPassword(
                          passwordController.text,
                          v ?? "",
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// Upload ID
                      IdUploadField(
                        onImageSelected: (image) {
                          idImage = image;
                        },
                      ),

                      const SizedBox(height: 20),

                      /// ROLE SELECTION
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Select Account Type",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(child: _roleButton("user", "User")),
                          const SizedBox(width: 12),
                          Expanded(child: _roleButton("driver", "Driver")),
                        ],
                      ),

                      const SizedBox(height: 25),

                      state is SignupLoading
                          ? const CircularProgressIndicator()
                          : AppButton(
                              text: "Create Account",
                              onTap: () {
                                if (!_formKey.currentState!.validate()) return;

                                if (idImage == null) {
                                  _showMsg("Upload your personal ID");
                                  return;
                                }

                                if (selectedRole == null) {
                                  _showMsg("Select account type");
                                  return;
                                }

                                context.read<SignupCubit>().register(
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                  email: emailController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  idNumber: idController.text.trim(),
                                  password: passwordController.text.trim(),
                                  idImage: idImage!,
                                  role: selectedRole!,
                                );
                              },
                            ),

                      const SizedBox(height: 20),

                      Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
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
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _roleButton(String role, String title) {
    final selected = selectedRole == role;

    return GestureDetector(
      onTap: () => setState(() => selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.fieldColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
