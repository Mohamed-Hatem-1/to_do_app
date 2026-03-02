import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/core/theme/theme_controller.dart';
import 'package:to_do_app/core/utils/auth_gate.dart';
import 'package:to_do_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:to_do_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';
import 'package:to_do_app/features/home/presentation/screens/home_screen.dart';
import 'package:to_do_app/features/profile/presentation/screens/change_name_screen.dart';
import 'package:to_do_app/features/profile/presentation/screens/change_password_screen.dart';
import 'package:to_do_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:to_do_app/features/task/presentation/screens/task_screen.dart';
import 'package:to_do_app/firebase_options.dart';
import 'package:to_do_app/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:to_do_app/core/utils/local_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final themeController = ThemeController();
  static final localeController = LocaleController();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final VoidCallback _themeListener;
  late final VoidCallback _localeListener;

  @override
  void initState() {
    super.initState();

    MyApp.localeController.init(defaultLocale: const Locale('en'));

    _themeListener = () {
      if (mounted) setState(() {});
    };
    _localeListener = () {
      if (mounted) setState(() {});
    };
    MyApp.themeController.addListener(_themeListener);
    MyApp.localeController.addListener(_localeListener);
  }

  @override
  void dispose() {
    MyApp.themeController.removeListener(_themeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: MyApp.localeController.locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.theme,
      darkTheme: ThemeData.dark(),
      themeMode: MyApp.themeController.mode,

      home: const AuthGate(),
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        ForgotPasswordScreen.routeName: (context) =>
            const ForgotPasswordScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        TaskScreen.routeName: (context) => TaskScreen(
          task: ModalRoute.of(context)!.settings.arguments as TaskModel,
        ),
        ChangeNameScreen.routeName: (context) => const ChangeNameScreen(),
        ChangePasswordScreen.routeName: (context) =>
            const ChangePasswordScreen(),
      },
    );
  }
}
