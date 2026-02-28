import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/app_assets.dart';
import 'package:to_do_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:to_do_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:to_do_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:to_do_app/features/home/presentation/screens/home_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authViewModel = AuthViewModel();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: SafeArea(
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
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Eng', style: AppTextStyles.lang),
                            SizedBox(width: 6),
                            Icon(Icons.chevron_right, color: AppColors.primary),
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
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 28),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Email is required'
                                    : null,
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
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
                                    (v == null || v.trim().isEmpty)
                                    ? 'Password is required'
                                    : null,
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      ForgotPasswordScreen.routeName,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text(
                                    'Forgot Password?',
                                    style: AppTextStyles.forgotPassword,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 54,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState?.validate() !=
                                        true)
                                      return;
                                    setState(() => _isLoading = true);
                                    try {
                                      await _authViewModel.signIn(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text
                                            .trim(),
                                      );
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.all(16),
                                          padding: EdgeInsets.all(16),
                                          duration: Duration(seconds: 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(16),
                                            ),
                                          ),
                                          elevation: 4,
                                          content: Text("Login successful"),
                                        ),
                                      );
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        HomeScreen.routeName,
                                        (route) => false,
                                      );
                                    } catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(e.toString()),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                          margin: const EdgeInsets.all(16),
                                          padding: const EdgeInsets.all(16),
                                          duration: const Duration(seconds: 2),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(16),
                                            ),
                                          ),
                                          elevation: 4,
                                        ),
                                      );
                                    } finally {
                                      if (mounted)
                                        setState(() => _isLoading = false);
                                    }
                                  },
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'SIGN IN',
                                          style: AppTextStyles.button,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account? ",
                                    style: AppTextStyles.bottomText,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        SignUpScreen.routeName,
                                      );
                                    },
                                    child: const Text(
                                      'Sign up',
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
    );
  }
}
