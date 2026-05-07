import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resq_app/config/routers/app_router.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF0A1931),
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'resQ App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,

        /// 🌌 الخلفية
        scaffoldBackgroundColor: const Color(0xFF0A1931),

        /// 🔵 اللون الأساسي
        primaryColor: const Color(0xFF3B82F6),

        /// 🔝 AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),

          iconTheme: IconThemeData(color: Colors.white),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF0A1931),
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey), // زي الأول
          labelStyle: TextStyle(color: Colors.grey),
        ),

        /// 🧊 Cards
        cardColor: const Color(0xFF112240),

        /// 🔘 Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),

        /// ✍️ Text
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),

          /// 👇 ده بيأثر على TextField
          titleMedium: TextStyle(color: Colors.white),
        ),

        /// 🔽 Bottom Nav
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0A1931),
          selectedItemColor: Color(0xFF3B82F6),
          unselectedItemColor: Colors.white38,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),

        /// ✨ Cursor بس (من غير ما نغير شكل التكست فيلد)
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF3B82F6),
        ),
      ),

      routerConfig: appRouter,
    );
  }
}
