import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_colors.dart';

BoxDecoration fieldDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  boxShadow: const [
    BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
  ],
);

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

class AppTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(widget.label),
        Container(
          decoration: fieldDecoration(),
          child: TextField(
            controller: widget.controller,
            obscureText: _obscure,
            keyboardType: widget.keyboardType,
            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.dark),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.hint,
              ),
              prefixIcon: Icon(widget.icon, color: AppColors.dark, size: 20),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.dark,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class GoldButton extends StatelessWidget {
  final String label;
  final IconData? trailing;
  final VoidCallback onPressed;

  const GoldButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.navy,
          elevation: 6,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              Icon(trailing, size: 18, color: AppColors.navy),
            ],
          ],
        ),
      ),
    );
  }
}

class BottomAuthLink extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback onTap;

  const BottomAuthLink({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Container(height: 1, color: Colors.white.withOpacity(0.35)),
    );
    return Row(
      children: [
        line,
        const SizedBox(width: 10),
        Text(
          question,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: GoogleFonts.poppins(
              color: AppColors.gold,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        line,
      ],
    );
  }
}

class BackLink extends StatelessWidget {
  final String label;
  const BackLink(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class CreateAccountHeader extends StatelessWidget {
  final String subtitle;
  const CreateAccountHeader({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            children: const [
              TextSpan(text: 'Create your '),
              TextSpan(
                text: 'account',
                style: TextStyle(color: AppColors.gold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

/// Step indicator. step = 1 or 2.
class StepProgress extends StatelessWidget {
  final int step;
  const StepProgress({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final track = Colors.white.withOpacity(0.25);

    Widget check() => Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: AppColors.gold,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, size: 13, color: AppColors.navy),
    );

    Widget bar(bool filled) => Expanded(
      child: Container(
        height: 6,
        decoration: BoxDecoration(
          color: filled ? AppColors.gold : track,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step $step of 2',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10),
        ),
        const SizedBox(height: 6),
        if (step == 1)
          Row(children: [bar(true), const SizedBox(width: 4), bar(false)])
        else
          Row(children: [check(), bar(true), check(), bar(true)]),
      ],
    );
  }
}
