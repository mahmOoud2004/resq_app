import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:resq_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:resq_app/features/auth/presentation/screens/login.dart';
import 'package:resq_app/features/auth/presentation/cubit/otp/otp_purpose.dart';
import 'package:resq_app/features/auth/presentation/screens/otp_screen.dart';
import 'package:resq_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:resq_app/features/auth/presentation/screens/signup.dart';
import 'package:resq_app/features/driver_emergency/data/models/driver_request_model.dart';
import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_cubit.dart';
import 'package:resq_app/features/emergency/data/repositories/emergency_repository_impl.dart';
import 'package:resq_app/features/emergency/domain/usecase/create_emergency_usecase.dart';
import 'package:resq_app/features/emergency/presentation/bloc/emergency_bloc.dart';
import 'package:resq_app/features/home/presentation/screens/driver_home_screen.dart';
import 'package:resq_app/features/home/presentation/widgets_driver/driver_request_details_screen.dart';
import 'package:resq_app/features/navigation/presentation/screen/admin_main_screen.dart';
import 'package:resq_app/features/navigation/presentation/screen/auth_gate_screen.dart';
import 'package:resq_app/features/navigation/presentation/screen/driver_main_screens.dart'
    show DriverMainScreen;
import 'package:resq_app/features/navigation/presentation/screen/main_screen.dart';
import 'package:resq_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:resq_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:resq_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:resq_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:resq_app/features/profile/presentation/edit_profile/edit_profile_bloc.dart';
import 'package:resq_app/features/profile/presentation/screens/account_screen.dart';
import 'package:resq_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:resq_app/features/profile/presentation/screens/support_screen.dart';
import 'package:resq_app/features/profile/presentation/screens/terms_screen.dart';
import 'package:resq_app/features/smart_ai_assistant/data/datasources/gemini_remote_datasource.dart';
import 'package:resq_app/features/smart_ai_assistant/data/datasources/isar_local_datasource.dart';
import 'package:resq_app/features/smart_ai_assistant/data/datasources/ocr_local_datasource.dart';
import 'package:resq_app/features/smart_ai_assistant/data/repositories/smart_assistant_repository_impl.dart';
import 'package:resq_app/features/smart_ai_assistant/domain/entities/ai_analysis_result.dart';
import 'package:resq_app/features/smart_ai_assistant/presentation/cubits/smart_assistant_cubit.dart';
import 'package:resq_app/features/smart_ai_assistant/presentation/screens/analysis_history_screen.dart';
import 'package:resq_app/features/smart_ai_assistant/presentation/screens/assistant_main_screen.dart';
import 'package:resq_app/features/smart_ai_assistant/presentation/screens/assistant_result_screen.dart';
import 'package:resq_app/features/smart_health_notifications/presentation/screens/medical_information_screen.dart'
    as resq_smart_health;
import 'package:resq_app/features/splash/presentation/view/splash.dart';

import 'route_names.dart';

SmartAssistantCubit createSmartAssistantCubit() {
  return SmartAssistantCubit(
    SmartAssistantRepositoryImpl(
      geminiRemoteDataSource: GeminiRemoteDataSource(),
      ocrLocalDataSource: OcrLocalDataSource(),
      isarLocalDataSource: IsarLocalDataSource(),
    ),
  );
}

const bool skipAuth = false;

Map<String, dynamic>? _extraAsMap(Object? extra) {
  if (extra is Map<String, dynamic>) {
    return extra;
  }
  if (extra is Map) {
    return Map<String, dynamic>.from(extra);
  }
  return null;
}

Widget _invalidRouteFallback(String message) {
  return Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: skipAuth ? Routes.driverHome : "/auth-gate",
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(path: Routes.login, builder: (context, state) => LoginScreen()),
    GoRoute(path: Routes.signup, builder: (context, state) => SignupScreen()),
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ProfileBloc(
                ProfileRepositoryImpl(ProfileRemoteDataSourceImpl()),
              )..add(GetProfileEvent()),
            ),
            BlocProvider(
              create: (context) => EmergencyBloc(
                CreateEmergencyUseCase(EmergencyRepositoryImpl()),
              ),
            ),
          ],
          child: const MainScreen(),
        );
      },
    ),
    GoRoute(
      path: Routes.forgetPassword,
      builder: (context, state) => const ForgetPasswordScreen(),
    ),
    GoRoute(
      path: Routes.otp,
      builder: (context, state) {
        final data = _extraAsMap(state.extra);
        final email = data?["email"];
        final purpose = data?["purpose"];
        if (email is! String || purpose is! OtpPurpose) {
          return _invalidRouteFallback('Missing OTP verification details.');
        }
        return OtpScreen(email: email, purpose: purpose);
      },
    ),
    GoRoute(
      path: Routes.resetPassword,
      builder: (context, state) {
        final data = _extraAsMap(state.extra);
        final email = data?["email"];
        final otp = data?["otp"];
        if (email is! String || otp is! String) {
          return _invalidRouteFallback('Missing reset password details.');
        }
        return ResetPasswordScreen(email: email, otp: otp);
      },
    ),
    GoRoute(
      path: Routes.acount,
      builder: (context, state) => AccountScreen(),
    ),
    GoRoute(
      path: Routes.editProfile,
      builder: (context, state) {
        final repository = ProfileRepositoryImpl(ProfileRemoteDataSourceImpl());
        return BlocProvider(
          create: (_) => EditProfileBloc(repository),
          child: const EditProfileScreen(),
        );
      },
    ),
    GoRoute(
      path: Routes.support,
      builder: (context, state) => const SupportScreen(),
    ),
    GoRoute(
      path: Routes.terms,
      builder: (context, state) => const TermsScreen(),
    ),
    GoRoute(
      path: Routes.medicalInfo,
      builder: (context, state) =>
          const resq_smart_health.MedicalInformationScreen(),
    ),
    GoRoute(
      path: Routes.driverHome,
      builder: (context, state) => const DriverHomeScreen(),
    ),
    GoRoute(
      path: Routes.driverRequestDetails,
      builder: (context, state) {
        final request = state.extra;
        if (request is! DriverRequestModel) {
          return _invalidRouteFallback('Unable to open request details.');
        }
        return BlocProvider.value(
          value: context.read<DriverEmergencyCubit>(),
          child: DriverRequestDetailsScreen(request: request),
        );
      },
    ),
    GoRoute(
      path: "/auth-gate",
      builder: (context, state) => const AuthGateScreen(),
    ),
    GoRoute(
      path: "/driver-main",
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => EmergencyBloc(
                CreateEmergencyUseCase(EmergencyRepositoryImpl()),
              ),
            ),
          ],
          child: const DriverMainScreen(),
        );
      },
    ),
    GoRoute(
      path: "/admin",
      builder: (context, state) => const AdminMainScreen(),
    ),
    GoRoute(
      path: Routes.smartAssistantMain,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => createSmartAssistantCubit(),
          child: const SmartAssistantMainScreen(),
        );
      },
    ),
    GoRoute(
      path: Routes.smartAssistantResult,
      builder: (context, state) {
        final result = state.extra;
        if (result is! AiAnalysisResult) {
          return _invalidRouteFallback('Unable to open the analysis result.');
        }
        return BlocProvider(
          create: (context) => createSmartAssistantCubit(),
          child: SmartAssistantResultScreen(result: result),
        );
      },
    ),
    GoRoute(
      path: Routes.analysisHistory,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => createSmartAssistantCubit(),
          child: const AnalysisHistoryScreen(),
        );
      },
    ),
  ],
);
