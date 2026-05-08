import 'package:flutter/material.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/constants/app_color.dart';

import 'package:resq_app/features/home/presentation/screens/driver_home_screen.dart';
import 'package:resq_app/features/profile/presentation/screens/profile_screen.dart';

import 'package:resq_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:resq_app/features/profile/presentation/bloc/profile_event.dart';

import 'package:resq_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:resq_app/features/profile/data/repositories/profile_repository_impl.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const DriverHomeScreen(),
    // const MapScreen(),
    // const ChatbotPage(),
    const ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProfileBloc(ProfileRepositoryImpl(ProfileRemoteDataSourceImpl()))
            ..add(GetProfileEvent()),
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            // BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.chat_bubble),
            //   label: "Chatbot",
            // ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
