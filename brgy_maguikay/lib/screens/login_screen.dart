import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_colors.dart';
import '../models/auth_models.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../widgets/common_widgets.dart';
import 'home_screen.dart';
import 'register_personal_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password.')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthService.login(LoginRequest(email: email, password: password));
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not reach the server. Check your connection.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    // Replace with: Image.asset('assets/logo.png', width: 84)
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: AppColors.gold, width: 3),
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: AppColors.navy,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Manguikay',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: 'Connect',
                            style: TextStyle(color: AppColors.gold),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Official Barangay Portal',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                  children: const [
                    TextSpan(
                      text: 'Your voice,\nyour ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: 'barangay.',
                      style: TextStyle(color: AppColors.gold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Report concerns, track requests, and stay\nupdated with your barangay',
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
              ),
              const SizedBox(height: 24),
              AppTextField(
                label: 'Email address',
                hint: 'name@gmail.com',
                icon: Icons.person_outline,
                keyboardType: TextInputType.emailAddress,
                controller: _emailCtrl,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Password',
                hint: '',
                icon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordCtrl,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot password?',
                    style: GoogleFonts.poppins(
                      color: AppColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GoldButton(
                label: _loading ? 'Please wait...' : 'Continue',
                onPressed: _loading ? () {} : _login,
              ),
              const SizedBox(height: 24),
              BottomAuthLink(
                question: "Don't have an account?",
                action: 'Create an account',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterPersonalScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
