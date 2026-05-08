import 'package:flutter/material.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/constants/app_color.dart';

import 'package:resq_app/features/Chatbot/presentation/screens/chatbot_page.dart';
import 'package:resq_app/features/home/presentation/screens/user_home_screen.dart';
import 'package:resq_app/features/map/presentation/screens/map_screen.dart';
import 'package:resq_app/features/profile/presentation/screens/profile_screen.dart';

import 'package:resq_app/features/emergency/presentation/bloc/emergency_bloc.dart';
import 'package:resq_app/features/emergency/domain/usecase/create_emergency_usecase.dart';
import 'package:resq_app/features/emergency/data/repositories/emergency_repository_impl.dart';

import 'package:resq_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:resq_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:resq_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:resq_app/features/profile/data/repositories/profile_repository_impl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const UserHomeScreen(),
    const MapScreen(),
    const ChatbotPage(),
    const ProfileScreen(),
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
        /// Emergency Bloc
        BlocProvider(
          create: (_) {
            final repository = EmergencyRepositoryImpl();
            final useCase = CreateEmergencyUseCase(repository);
            return EmergencyBloc(useCase);
          },
        ),

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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: "Chatbot",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
