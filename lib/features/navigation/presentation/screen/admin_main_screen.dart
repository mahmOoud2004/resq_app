import 'package:flutter/material.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/constants/app_color.dart';

import 'package:resq_app/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:resq_app/features/admin/presentation/bloc/admin_event.dart';

import 'package:resq_app/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:resq_app/features/admin/presentation/screens/admin_requests_screen.dart';
import 'package:resq_app/features/admin/presentation/screens/admin_users_screen.dart';

import 'package:resq_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:resq_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:resq_app/features/profile/presentation/bloc/profile_event.dart';

import 'package:resq_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:resq_app/features/profile/data/repositories/profile_repository_impl.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int currentIndex = 0;

  final screens = const [
    AdminDashboardScreen(),
    AdminRequestsScreen(),
    AdminUsersScreen(),
    ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// 🔥 Admin Bloc
        BlocProvider(create: (_) => AdminBloc()..add(LoadDashboard())),

        /// Profile Bloc
        BlocProvider(
          create: (_) =>
              ProfileBloc(ProfileRepositoryImpl(ProfileRemoteDataSourceImpl()))
                ..add(GetProfileEvent()),
        ),
      ],

      child: Scaffold(
        body: screens[currentIndex],

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: context.backgroundColor,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: context.textMutedColor,
          type: BottomNavigationBarType.fixed,

          currentIndex: currentIndex,

          onTap: onTabTapped,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "Dashboard",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: "Request",
            ),

            BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users"),

            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
