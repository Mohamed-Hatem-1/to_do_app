import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/change-password-screen';
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _cleanError(Object e) {
    final s = e.toString();
    return s.replaceFirst('Exception: ', '');
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final email = user.email;
      if (email == null || email.isEmpty) {
        throw Exception('No email found for this user');
      }

      final oldPass = _oldPasswordController.text;
      final newPass = _newPasswordController.text;

      final cred = EmailAuthProvider.credential(
        email: email,
        password: oldPass,
      );
      await user.reauthenticateWithCredential(cred);

      await user.updatePassword(newPass);
      await user.reload();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully ✅'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String msg = e.message ?? 'Something went wrong';
      if (e.code == 'wrong-password') msg = 'Old password is incorrect';
      if (e.code == 'weak-password') msg = 'New password is too weak';
      if (e.code == 'requires-recent-login') {
        msg = 'Please sign in again then try changing password';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_cleanError(e)), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: _isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _oldPasswordController,
                      obscureText: _obscureOld,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _obscureOld = !_obscureOld),
                          icon: Icon(
                            _obscureOld
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Old password is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: _obscureNew,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _obscureNew = !_obscureNew),
                          icon: Icon(
                            _obscureNew
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'New password is required';
                        }
                        if (v.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        if (v == _oldPasswordController.text) {
                          return 'New password must be different from old password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please confirm the new password';
                        }
                        if (v != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _changePassword,
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_isLoading) ...[
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.25)),
            ),
            const Positioned.fill(
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ],
      ),
    );
  }
}
