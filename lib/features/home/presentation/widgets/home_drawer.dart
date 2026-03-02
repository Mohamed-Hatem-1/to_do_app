import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:to_do_app/widgets/add_task_bottom_sheet.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../main.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authViewModel = AuthViewModel();
    final username = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!
        : (user?.email?.split('@').first ?? 'User');
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $username',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 18),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.person_outline_rounded),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, ProfileScreen.routeName);
                },
              ),

              SwitchListTile(
                secondary: const Icon(Icons.dark_mode_outlined),
                title: const Text('Dark Mode'),
                value: MyApp.themeController.isDark,
                onChanged: (_) => MyApp.themeController.toggle(),
              ),

              ListTile(
                leading: const Icon(Icons.add_circle_outline_rounded),
                title: const Text('Add Task'),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const AddTaskBottomSheet(),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text('Logout'),
                onTap: () async {
                  await authViewModel.signOut();
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
              ),

              const Spacer(),

              Text(
                'ToDo List',
                style: TextStyle(
                  color: AppColors.primary.withOpacity(0.9),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
