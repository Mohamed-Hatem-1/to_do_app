import 'package:flutter/material.dart';
import 'package:to_do_app/features/profile/presentation/screens/profile_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const card1 = Color(0xFFE83E8C);
    const card2 = Color(0xFFF48FB1);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/app_icon.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    },
                    icon: const Icon(Icons.person_outline_rounded),
                    color: const Color(0xFF1F2937),
                    iconSize: 40,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 120),
                  children: const [
                    TaskCard(
                      title: 'Design UI App',
                      description: 'Make To-DO UI Design for  NTI.',
                      createdAtText: 'Created at 1 Sept 2021',
                      backgroundColor: card1,
                      showClock: true,
                    ),
                    SizedBox(height: 12),
                    TaskCard(
                      title: 'Make UI Design',
                      description:
                          'Make Ui design for the mini project post figma link to the trello using ...',
                      createdAtText: 'Created at 1 Sept 2021',
                      backgroundColor: card2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MiniFab(
            icon: Icons.tune_rounded,
            onTap: () {
              
            },
          ),
          const SizedBox(height: 14),
          FloatingActionButton(
            backgroundColor: AppColors.primary,
            onPressed: () {
              
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _MiniFab extends StatelessWidget {
  const _MiniFab({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: Container(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
