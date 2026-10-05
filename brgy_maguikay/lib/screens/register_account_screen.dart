import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_colors.dart';
import '../models/auth_models.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../widgets/common_widgets.dart';
import 'home_screen.dart';

class RegisterAccountScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final String contactNo;
  final String? purok;

  const RegisterAccountScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.contactNo,
    this.purok,
  });

  @override
  State<RegisterAccountScreen> createState() => _RegisterAccountScreenState();
}

class _RegisterAccountScreenState extends State<RegisterAccountScreen> {
  PlatformFile? _pickedFile;
  bool _loading = false;

  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: false,
    );
    if (result == null) return;

    final file = result.files.single;
    if (file.size > 5 * 1024 * 1024) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File is too large. Max size is 5 MB.')),
      );
      return;
    }
    setState(() => _pickedFile = file);
  }

  Future<void> _submit() async {
    final password = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a password.')),
      );
      return;
    }
    if (password != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }

    // NOTE: the API's RegisterRequest (as used by AuthController.Register)
    // only takes FullName, Email, Password and an optional ContactNo. It has
    // no fields yet for username, Purok/Zone, or a proof-of-residency file,
    // so those three aren't sent — they're only kept here on-device for now.
    // Confirm the real RegisterRequest DTO with your API teammate if that's
    // meant to change.
    setState(() => _loading = true);
    try {
      await AuthService.register(
        RegisterRequest(
          fullName: widget.fullName,
          email: widget.email,
          password: password,
          contactNo: widget.contactNo.isEmpty ? null : widget.contactNo,
        ),
      );
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackLink('Back to personal information'),
              const SizedBox(height: 20),
              const CreateAccountHeader(
                subtitle: 'Set up your account and verify your residency.',
              ),
              const SizedBox(height: 16),
              const StepProgress(step: 2),
              const SizedBox(height: 22),
              Text(
                'Account information',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Username',
                hint: 'Choose a username',
                icon: Icons.person_outline,
                controller: _usernameCtrl,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Password',
                hint: '',
                icon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordCtrl,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Confirm password',
                hint: '',
                icon: Icons.lock_outline,
                isPassword: true,
                controller: _confirmCtrl,
              ),
              const SizedBox(height: 22),
              Text(
                'Proof of residency',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Upload a valid document (e.g. barangay certificate, utility bill, etc.)',
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickDocument,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  decoration: BoxDecoration(
                    color: AppColors.navyLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _pickedFile == null
                            ? Icons.cloud_upload_outlined
                            : Icons.description_outlined,
                        color: AppColors.gold,
                        size: 36,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _pickedFile?.name ?? 'Upload document',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'JPG, PNG or PDF  |  Max 5 MB',
                        style: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              GoldButton(
                label: _loading ? 'Please wait...' : 'Submit registration',
                onPressed: _loading ? () {} : _submit,
              ),
              const SizedBox(height: 20),
              BottomAuthLink(
                question: 'Already have an account?',
                action: 'Log in',
                onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
