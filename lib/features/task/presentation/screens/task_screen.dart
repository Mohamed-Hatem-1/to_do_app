import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';
import 'package:to_do_app/features/home/data/repos/tasks_repo.dart';
import 'package:to_do_app/widgets/add_task_bottom_sheet.dart';
import 'package:to_do_app/widgets/delete_alert_dialog.dart';

class TaskScreen extends StatelessWidget {
  static const routeName = '/task-screen';
  final TaskModel task;

  const TaskScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final repo = TasksRepo(uid: FirebaseAuth.instance.currentUser!.uid);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            StreamBuilder<TaskModel>(
              stream: repo.watchTaskById(task.id),
              builder: (context, snapshot) {
                final currentTask = snapshot.data ?? task;
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () async {
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => AddTaskBottomSheet(task: currentTask),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => buildDeleteDialog(context, () async {
                            await repo.deleteTask(currentTask.id);
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          }),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: StreamBuilder<TaskModel>(
          stream: repo.watchTaskById(task.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final t = snapshot.data ?? task;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.description,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const Spacer(),
                  Center(
                    child: Text(
                      'Created on ${t.createdAt.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

