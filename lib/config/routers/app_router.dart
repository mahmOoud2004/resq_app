import 'package:go_router/go_router.dart';
import 'package:resq_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:resq_app/features/auth/presentation/screens/login.dart';
import 'package:resq_app/features/auth/presentation/screens/otp_screen.dart';
import 'package:resq_app/features/auth/presentation/screens/signup.dart';
import 'package:resq_app/features/home/presentation/screens/home_screen.dart';
import 'package:resq_app/features/splash/presentation/view/splash.dart';

import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.splash,

  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(path: Routes.login, builder: (context, state) => LoginScreen()),

    GoRoute(path: Routes.signup, builder: (context, state) => SignupScreen()),

    GoRoute(path: Routes.home, builder: (context, state) => const HomeScreen()),

    GoRoute(
      path: Routes.forgetPassword,
      builder: (context, state) => ForgetPasswordScreen(),
    ),
    GoRoute(
      path: Routes.otp,
      builder: (context, state) {
        final email = state.extra as String;
        return OtpScreen(email: email);
      },
    ),
  ],
);
