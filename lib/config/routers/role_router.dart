import 'package:flutter/material.dart';

import 'package:resq_app/features/navigation/presentation/screen/main_screen.dart';
import 'package:resq_app/features/home/presentation/screens/driver_home_screen.dart';

class RoleRouter {
  static Widget getHomeByRole(String role) {
    switch (role) {
      case "driver":
        return const DriverHomeScreen();

      case "manager":
      default:
        return const MainScreen();
    }
  }
}
