import 'package:flutter/material.dart';

const Color kTeal = Color(0xFF20A9C3);
const Color kNavy = Color(0xFF001C46);

class AuthCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const AuthCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      decoration: BoxDecoration(
        color: kTeal,
        image: const DecorationImage(
          image: AssetImage('assets/images/auth/pattern.png'),
          fit: BoxFit.cover,
          opacity: 0.25,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          ...children,
        ],
      ),
    );
  }
}

class LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  const LabeledField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 4),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(icon, color: kTeal),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const PrimaryButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kNavy,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final IconData icon;
  const SocialIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: kNavy, size: 24),
    );
  }
}
