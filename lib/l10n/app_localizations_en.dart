// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get name => 'Name';

  @override
  String get appTitle => 'To Do App';

  @override
  String get signIn => 'SIGN IN';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get haveAccount => 'Have an account?';

  @override
  String get changeLanguage => 'Language';

  @override
  String hello(Object name) {
    return 'Hello, $name';
  }

  @override
  String get changeName => 'Change Name';

  @override
  String get changePassword => 'Change Password';
}
