import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resq_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:resq_app/features/auth/presentation/screens/login.dart';
import 'package:resq_app/features/auth/presentation/screens/otp_screen.dart';
import 'package:resq_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:resq_app/features/auth/presentation/screens/signup.dart';
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
import 'route_names.dart';

const bool skipAuth = false;

final GoRouter appRouter = GoRouter(
  initialLocation: skipAuth ? Routes.home : Routes.splash,

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

    /// HOME + PROFILE BLOC
    GoRoute(
      path: Routes.home,
      builder: (context, state) => BlocProvider(
        create: (context) =>
            ProfileBloc(ProfileRepositoryImpl(ProfileRemoteDataSourceImpl()))
              ..add(GetProfileEvent()),
        child: const MainScreen(),
      ),
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
        final bloc = state.extra as ProfileBloc;

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
  ],
);
