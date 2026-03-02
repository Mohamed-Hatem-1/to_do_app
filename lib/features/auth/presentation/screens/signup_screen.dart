import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/app_assets.dart';
import 'package:to_do_app/features/auth/presentation/view_models/auth_errors.dart';
import 'package:to_do_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:to_do_app/features/home/presentation/screens/home_screen.dart';
import 'package:to_do_app/l10n/app_localizations.dart';
import 'package:to_do_app/main.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _authViewModel = AuthViewModel();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final langCode = MyApp.localeController.locale?.languageCode ?? 'en';
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AbsorbPointer(
              absorbing: _isLoading,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottomInset),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              MyApp.localeController.toggle();
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    langCode == 'ar' ? 'Ar' : 'Eng',
                                    style: AppTextStyles.lang,
                                  ),
                                  SizedBox(width: 6),
                                  Icon(
                                    Icons.chevron_right,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppAssets.logo,
                                width: MediaQuery.of(context).size.width * 0.45,
                              ),
                              const SizedBox(height: 32),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _nameController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        hintText: t.name,
                                      ),
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Name is required'
                                          : null,
                                    ),
                                    const SizedBox(height: 14),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        hintText: t.email,
                                      ),
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Email is required'
                                          : null,
                                    ),
                                    const SizedBox(height: 14),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        hintText: t.password,
                                        suffixIcon: IconButton(
                                          onPressed: () => setState(
                                            () => _obscurePassword =
                                                !_obscurePassword,
                                          ),
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: AppColors.hint,
                                          ),
                                        ),
                                      ),
                                      validator: (v) =>
                                          (v == null || v.length < 6)
                                          ? 'Password must be 6+ chars'
                                          : null,
                                    ),
                                    const SizedBox(height: 14),
                                    TextFormField(
                                      controller: _confirmPasswordController,
                                      obscureText: _obscureConfirmPassword,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        hintText: t.confirmPassword,
                                        suffixIcon: IconButton(
                                          onPressed: () => setState(
                                            () => _obscureConfirmPassword =
                                                !_obscureConfirmPassword,
                                          ),
                                          icon: Icon(
                                            _obscureConfirmPassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: AppColors.hint,
                                          ),
                                        ),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.isEmpty) {
                                          return 'Confirm password';
                                        }
                                        if (v != _passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      height: 54,
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState
                                                  ?.validate() !=
                                              true)
                                            return;
                                          setState(() => _isLoading = true);
                                          try {
                                            await _authViewModel.signUp(
                                              name: _nameController.text.trim(),
                                              email: _emailController.text
                                                  .trim(),
                                              password: _passwordController.text
                                                  .trim(),
                                            );
                                            if (!mounted) return;
                                            Navigator.of(context).popUntil(
                                              (route) => route.isFirst,
                                            );
                                          } on FirebaseAuthException catch (e) {
                                            if (!mounted) return;
                                            final msg = mapAuthError(e);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(msg),
                                                backgroundColor: Colors.red,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                margin: const EdgeInsets.all(
                                                  16,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                duration: const Duration(
                                                  seconds: 2,
                                                ),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(16),
                                                          ),
                                                    ),
                                                elevation: 4,
                                              ),
                                            );
                                          } catch (e) {
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(e.toString()),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          } finally {
                                            if (mounted)
                                              setState(
                                                () => _isLoading = false,
                                              );
                                          }
                                        },
                                        child: Text(
                                          t.signUp,
                                          style: AppTextStyles.button,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          t.haveAccount,
                                          style: AppTextStyles.bottomText,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            t.signIn,
                                            style: AppTextStyles.bottomLink,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.25),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
