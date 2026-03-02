import 'package:flutter/material.dart';

AlertDialog buildDeleteDialog(BuildContext context, VoidCallback onDelete) {
  return AlertDialog(
    title: const Text('Delete Task'),
    content: const Text('Are you sure you want to delete this task?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          onDelete();
          Navigator.pop(context);
        },
        child: const Text('Delete', style: TextStyle(color: Colors.red)),
      ),
    ],
  );
}
