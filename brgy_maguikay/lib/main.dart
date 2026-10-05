import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/app_colors.dart';
import 'screens/login_screen.dart';

void main() => runApp(const ManguikayConnectApp());

class ManguikayConnectApp extends StatelessWidget {
  const ManguikayConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ManguikayConnect',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.navy,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      home: const LoginScreen(),
    );
  }
}
