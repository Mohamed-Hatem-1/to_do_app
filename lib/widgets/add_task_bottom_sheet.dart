import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';
import 'package:to_do_app/features/home/data/repos/tasks_repo.dart';
import '../../../../core/constants/app_colors.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key, this.task});
  final TaskModel? task;

  bool get isEdit => task != null;

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _repo = TasksRepo(uid: FirebaseAuth.instance.currentUser!.uid);
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    if (t != null) {
      _titleController.text = t.title;
      _descController.text = t.description;
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isLoading = true);
    try {
      final title = _titleController.text.trim();
      final desc = _descController.text.trim();

      if (widget.isEdit) {
        await _repo.updateTask(
          taskId: widget.task!.id,
          title: title,
          description: desc,
        );
      } else {
        await _repo.addTask(title: title, description: desc);
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 10, 16, 16 + bottomInset),
        decoration: const BoxDecoration(
          color: Color(0xFFF48FB1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 14),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _OutlinedPinkField(
                    hint: 'Title',
                    controller: _titleController,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Title is required'
                        : null,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 12),
                  _OutlinedPinkField(
                    hint: 'Description',
                    controller: _descController,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Description is required'
                        : null,
                    maxLines: 8,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              widget.isEdit ? 'UPDATE TODO' : 'ADD TODO',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlinedPinkField extends StatelessWidget {
  const _OutlinedPinkField({
    required this.hint,
    required this.controller,
    required this.maxLines,
    this.validator,
  });

  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white, width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }
}

class _ActionField extends StatelessWidget {
  const _ActionField({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white, width: 1.2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: Colors.white.withOpacity(0.85)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(icon, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
