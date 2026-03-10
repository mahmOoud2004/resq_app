import 'package:go_router/go_router.dart';
import 'package:resq_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:resq_app/features/auth/presentation/screens/login.dart';
import 'package:resq_app/features/auth/presentation/screens/otp_screen.dart';
import 'package:resq_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:resq_app/features/auth/presentation/screens/signup.dart';
import 'package:resq_app/features/navigation/presentation/screen/main_screen.dart';
import 'package:resq_app/features/profile/presentation/screens/account_screen.dart';
import 'package:resq_app/features/profile/presentation/screens/support_screen.dart';
import 'package:resq_app/features/profile/presentation/screens/terms_screen.dart';
import 'package:resq_app/features/splash/presentation/view/splash.dart';
import 'route_names.dart';

const bool skipAuth = true;

final GoRouter appRouter = GoRouter(
  // initialLocation: Routes.splash,
  initialLocation: skipAuth ? Routes.home : Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(path: Routes.login, builder: (context, state) => LoginScreen()),

    GoRoute(path: Routes.signup, builder: (context, state) => SignupScreen()),

    GoRoute(path: Routes.home, builder: (context, state) => const MainScreen()),

    GoRoute(
      path: Routes.forgetPassword,
      builder: (context, state) => const ForgetPasswordScreen(),
    ),

    /// OTP SCREEN
    GoRoute(
      path: Routes.otp,
      builder: (context, state) {
        final data = state.extra as Map;

        return OtpScreen(email: data["email"], purpose: data["purpose"]);
      },
    ),

    /// RESET PASSWORD SCREEN
    GoRoute(
      path: Routes.resetPassword,
      builder: (context, state) {
        final data = state.extra as Map;

        return ResetPasswordScreen(email: data["email"], otp: data["otp"]);
      },
    ),
    GoRoute(
      path: Routes.acount,
      builder: (context, state) => const AccountScreen(),
    ),

    GoRoute(
      path: Routes.support,
      builder: (context, state) => const SupportScreen(),
    ),

    GoRoute(
      path: Routes.terms,
      builder: (context, state) => const TermsScreen(),
    ),
  ],
);
