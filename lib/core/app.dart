import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../pages/auth/login_page.dart';

class BajNemoApp extends StatelessWidget {
  const BajNemoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'BAJ-NEMO',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    home: const LoginPage(),
  );
}
