// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get name => 'الاسم';

  @override
  String get appTitle => 'تطبيق المهام';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get haveAccount => 'لديك حساب؟';

  @override
  String get changeLanguage => 'اللغة';

  @override
  String hello(Object name) {
    return 'أهلًا، $name';
  }

  @override
  String get changeName => 'تغيير الاسم';

  @override
  String get changePassword => 'تغيير كلمة المرور';
}
