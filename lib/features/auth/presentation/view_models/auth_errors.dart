import 'package:firebase_auth/firebase_auth.dart';

String mapAuthError(FirebaseAuthException e) {
  switch (e.code) {
    // Sign in
    case 'user-not-found':
      return 'No user found for that email.';
    case 'wrong-password': // old
    case 'invalid-credential': // new common
    case 'INVALID_LOGIN_CREDENTIALS': // sometimes appears
      return 'Wrong email or password.';

    // Sign up
    case 'email-already-in-use':
      return 'This email is already in use.';
    case 'weak-password':
      return 'The password is too weak (min 6 characters).';

    // General
    case 'invalid-email':
      return 'Invalid email address.';
    case 'too-many-requests':
      return 'Too many attempts. Try again later.';
    case 'network-request-failed':
      return 'Network error. Check your connection.';
    case 'operation-not-allowed':
      return 'Email/password sign-in is not enabled in Firebase.';

    default:
      return e.message ?? 'Authentication failed.';
  }
}