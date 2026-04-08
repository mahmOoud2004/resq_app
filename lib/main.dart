import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resq_app/config/routers/app_router.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF07142A),
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
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF07142A),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 44, 46, 49),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF07142A),
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
