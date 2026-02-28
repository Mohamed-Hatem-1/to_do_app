import 'package:flutter/material.dart';
import 'package:to_do_app/features/auth/presentation/screens/login_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/view_models/auth_view_model.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile-screen';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = AuthViewModel();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: const Color(0xFF1F2937),
              ),
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  'assets/images/rafiki.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 64),
              _SettingRow(title: 'Name', onTap: () {}),
              _SettingRow(title: 'Change Password', onTap: () {}),
              _SettingRow(title: 'Change Language', onTap: () {}),
              const SizedBox(height: 18),
              TextButton(
                onPressed: () async {
                  await authViewModel.signOut();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: AppColors.primary,
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}
