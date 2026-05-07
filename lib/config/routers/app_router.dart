import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resq_app/features/admin/presentation/screens/admin_dashboard_screen.dart';

import 'package:resq_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:resq_app/features/auth/presentation/screens/login.dart';
import 'package:resq_app/features/auth/presentation/screens/otp_screen.dart';
import 'package:resq_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:resq_app/features/auth/presentation/screens/signup.dart';
import 'package:resq_app/features/driver_emergency/data/models/driver_request_model.dart';
import 'package:resq_app/features/driver_emergency/presentation/cubit/driver_emergency_cubit.dart';
import 'package:resq_app/features/emergency/domain/usecase/create_emergency_usecase.dart';
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
import 'package:resq_app/features/profile/presentation/screens/account_screen.dart';
import 'package:resq_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:resq_app/features/profile/presentation/screens/support_screen.dart';
import 'package:resq_app/features/profile/presentation/screens/terms_screen.dart';
import 'package:resq_app/features/profile/presentation/edit_profile/edit_profile_bloc.dart';

import 'package:resq_app/features/splash/presentation/view/splash.dart';

/// EMERGENCY IMPORTS
import 'package:resq_app/features/emergency/data/repositories/emergency_repository_impl.dart';
import 'package:resq_app/features/emergency/presentation/bloc/emergency_bloc.dart';

import 'route_names.dart';

const bool skipAuth = false;

final GoRouter appRouter = GoRouter(
  initialLocation: skipAuth ? Routes.driverHome : "/auth-gate",

  routes: [
    /// SPLASH
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    /// LOGIN
    GoRoute(path: Routes.login, builder: (context, state) => LoginScreen()),

    /// SIGNUP
    GoRoute(path: Routes.signup, builder: (context, state) => SignupScreen()),

    /// HOME
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            /// PROFILE BLOC
            BlocProvider(
              create: (context) => ProfileBloc(
                ProfileRepositoryImpl(ProfileRemoteDataSourceImpl()),
              )..add(GetProfileEvent()),
            ),

            /// EMERGENCY BLOC
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

    /// FORGET PASSWORD
    GoRoute(
      path: Routes.forgetPassword,
      builder: (context, state) => const ForgetPasswordScreen(),
    ),

    /// OTP
    GoRoute(
      path: Routes.otp,
      builder: (context, state) {
        final data = state.extra as Map;

        return OtpScreen(email: data["email"], purpose: data["purpose"]);
      },
    ),

    /// RESET PASSWORD
    GoRoute(
      path: Routes.resetPassword,
      builder: (context, state) {
        final data = state.extra as Map;

        return ResetPasswordScreen(email: data["email"], otp: data["otp"]);
      },
    ),

    /// ACCOUNT
    GoRoute(
      path: Routes.acount,
      builder: (context, state) {
        return AccountScreen();
      },
    ),

    /// EDIT PROFILE
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

    /// SUPPORT
    GoRoute(
      path: Routes.support,
      builder: (context, state) => const SupportScreen(),
    ),

    /// TERMS
    GoRoute(
      path: Routes.terms,
      builder: (context, state) => const TermsScreen(),
    ),

    /// DRIVER HOME
    GoRoute(
      path: Routes.driverHome,
      builder: (context, state) {
        return const DriverHomeScreen();
      },
    ),

    GoRoute(
      path: '/driverRequestDetails',
      builder: (context, state) {
        final request = state.extra as DriverRequestModel;

        return BlocProvider.value(
          value: context.read<DriverEmergencyCubit>(),
          child: DriverRequestDetailsScreen(
            request: request, // 🔥 بدل requestId
          ),
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
            /// ✅ Emergency Bloc
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

    // ADMIN HOME
    GoRoute(
      path: "/admin",
      builder: (context, state) => const AdminMainScreen(),
    ),
  ],
);
