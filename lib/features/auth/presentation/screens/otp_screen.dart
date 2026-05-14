import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resq_app/config/routers/route_names.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/features/auth/presentation/cubit/otp/otp_cubit.dart';
import 'package:resq_app/features/auth/presentation/cubit/otp/otp_state.dart';
import 'package:resq_app/features/auth/presentation/cubit/otp/otp_purpose.dart';
import 'package:resq_app/features/auth/presentation/widgets/build_puttom.dart';

class OtpScreen extends StatelessWidget {
  final String email;
  final OtpPurpose purpose;

  OtpScreen({super.key, required this.email, required this.purpose});

  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();
  final controller4 = TextEditingController();

  String getOtp() {
    return controller1.text +
        controller2.text +
        controller3.text +
        controller4.text;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(),
      child: BlocConsumer<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state is OtpSuccess) {
            if (purpose == OtpPurpose.resetPassword) {
              context.go(
                Routes.resetPassword,
                extra: {"email": email, "otp": getOtp()},
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Account verified")));

              context.go(Routes.login);
            }
          }

          if (state is OtpError) {
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        "OTP Verification",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Please enter the 4 digit code\nsent to $email",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.textSecondaryColor,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 35),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          otpBox(controller1, context),
                          otpBox(controller2, context),
                          otpBox(controller3, context),
                          otpBox(controller4, context),
                        ],
                      ),

                      const SizedBox(height: 35),

                      state is OtpLoading
                          ? const CircularProgressIndicator()
                          : AppButton(
                              text: "Verify",
                              onTap: () {
                                final otp = getOtp();

                                if (otp.length < 4) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Enter complete OTP"),
                                    ),
                                  );
                                  return;
                                }

                                if (purpose == OtpPurpose.resetPassword) {
                                  context.read<OtpCubit>().verifyResetOtp(
                                    email: email,
                                    otp: otp,
                                  );
                                } else {
                                  context.read<OtpCubit>().verifySignupOtp(
                                    email: email,
                                    otp: otp,
                                  );
                                }
                              },
                            ),

                      const SizedBox(height: 20),

                      Text.rich(
                        TextSpan(
                          text: "Didn't receive the code? ",
                          style: const TextStyle(color: Colors.white70),
                          children: [
                            TextSpan(
                              text: "Resend OTP",
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Resend OTP is not available yet.",
                                      ),
                                    ),
                                  );
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

  Widget otpBox(TextEditingController controller, BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          color: AppColors.fieldText,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: context.fieldColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
