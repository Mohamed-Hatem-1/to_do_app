import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/features/home/data/repos/tasks_repo.dart';
import 'package:to_do_app/features/home/presentation/widgets/home_drawer.dart';
import 'package:to_do_app/features/task/presentation/screens/task_screen.dart';
import 'package:to_do_app/widgets/add_task_bottom_sheet.dart';
import 'package:to_do_app/widgets/delete_alert_dialog.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    String username;
    final displayName = user.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      final nameParts = displayName
          .split(' ')
          .where((s) => s.isNotEmpty)
          .toList();
      if (nameParts.length >= 2) {
        username = nameParts.take(2).join(' ');
      } else {
        username = nameParts.join(' ');
      }
    } else {
      username = user.email?.split('@').first ?? 'User';
    }
    final repo = TasksRepo(uid: uid);
    const card1 = Color(0xFF10B981);
    const card2 = Color(0xFFE83E8C);
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            iconSize: 28,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [Image.asset('assets/app_icon.png')],
        title: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            final user = snapshot.data ?? FirebaseAuth.instance.currentUser;

            String username;
            final displayName = user?.displayName?.trim();

            if (displayName != null && displayName.isNotEmpty) {
              final parts = displayName
                  .split(' ')
                  .where((s) => s.isNotEmpty)
                  .toList();
              username = parts.length >= 2
                  ? parts.take(2).join(' ')
                  : parts.join(' ');
            } else {
              username = user?.email?.split('@').first ?? 'User';
            }

            return Text(
              'Hello, $username',
              style: const TextStyle(fontWeight: FontWeight.w800),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: repo.watchTasks(),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (asyncSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${asyncSnapshot.error}'),
                      );
                    }
                    final tasks = asyncSnapshot.data ?? [];
                    if (tasks.isEmpty) {
                      return const Center(
                        child: Text(
                          'No tasks yet 👀\nTab The Menu Bar ☰\nThen Add A Task',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: tasks.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskCard(
                          title: task.title,
                          description: task.description,
                          createdAtText:
                              'Created at ${task.createdAt.toLocal().toString().split(' ')[0]}',
                          backgroundColor: index % 2 == 0 ? card1 : card2,
                          onTap: () async {
                            Navigator.pushNamed(
                              context,
                              TaskScreen.routeName,
                              arguments: task,
                            );
                          },
                          // onDone: () async {
                          //   await _repo.toggleDone(task);
                          // },
                          onDelete: () async {
                            await showDialog(
                              context: context,
                              builder: (_) =>
                                  buildDeleteDialog(context, () async {
                                    await repo.deleteTask(task.id);
                                    if (!context.mounted) return;
                                  }),
                            );
                          },
                          onEdit: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => AddTaskBottomSheet(task: task),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
