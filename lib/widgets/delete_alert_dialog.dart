import 'package:flutter/material.dart';

AlertDialog buildDeleteDialog(BuildContext dialogCtx, VoidCallback onDelete) {
  return AlertDialog(
    title: const Text('Delete Task'),
    content: const Text('Are you sure you want to delete this task?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(dialogCtx).pop(),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () async {
          onDelete();
          Navigator.of(dialogCtx).pop();
        },
        child: const Text('Delete', style: TextStyle(color: Colors.red)),
      ),
    ],
  );
}
