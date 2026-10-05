import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_colors.dart';
import '../widgets/common_widgets.dart';
import 'register_account_screen.dart';

class RegisterPersonalScreen extends StatefulWidget {
  const RegisterPersonalScreen({super.key});

  @override
  State<RegisterPersonalScreen> createState() => _RegisterPersonalScreenState();
}

class _RegisterPersonalScreenState extends State<RegisterPersonalScreen> {
  final _puroks = List.generate(7, (i) => 'Purok ${i + 1}');
  String? _selectedPurok;

  // Text controllers
  final _fullNameCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _contactCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _continueToAccount() {
    // Check full name
    if (_fullNameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name.')),
      );
      return;
    }

    // Check Purok
    if (_selectedPurok == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your Purok / Zone.')),
      );
      return;
    }

    // Check contact number
    if (_contactCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your contact number.')),
      );
      return;
    }

    // Check email
    if (_emailCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address.')),
      );
      return;
    }

    // Go to Step 2
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterAccountScreen(
          fullName: _fullNameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          contactNo: _contactCtrl.text.trim(),
          purok: _selectedPurok,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackLink('Back to login'),

              const SizedBox(height: 20),

              const CreateAccountHeader(
                subtitle: "Let's get started with you basic information.",
              ),

              const SizedBox(height: 16),

              const StepProgress(step: 1),

              const SizedBox(height: 22),

              Text(
                'Personal Information',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 14),

              // FULL NAME
              AppTextField(
                label: 'Full name',
                hint: 'Enter your full name',
                icon: Icons.person_outline,
                controller: _fullNameCtrl,
              ),

              const SizedBox(height: 16),

              // PUROK / ZONE
              const FieldLabel('Purok / Zone'),

              Container(
                decoration: fieldDecoration(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPurok,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.dark,
                    ),
                    dropdownColor: Colors.white,
                    hint: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.dark,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Select your Purok / Zone',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.hint,
                          ),
                        ),
                      ],
                    ),
                    items: _puroks.map((p) {
                      return DropdownMenuItem<String>(
                        value: p,
                        child: Text(
                          p,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.dark,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPurok = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // CONTACT NUMBER
              AppTextField(
                label: 'Contact number',
                hint: '09XX XXX XXXX',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                controller: _contactCtrl,
              ),

              const SizedBox(height: 16),

              // EMAIL
              AppTextField(
                label: 'Email address',
                hint: 'name@gmail.com',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                controller: _emailCtrl,
              ),

              const SizedBox(height: 28),

              // CONTINUE BUTTON
              GoldButton(
                label: 'Continue',
                trailing: Icons.arrow_forward,
                onPressed: _continueToAccount,
              ),

              const SizedBox(height: 20),

              // LOGIN LINK
              BottomAuthLink(
                question: 'Already have an account?',
                action: 'Log in',
                onTap: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
