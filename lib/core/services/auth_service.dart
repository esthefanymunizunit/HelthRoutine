import 'package:firebase_auth/firebase_auth.dart';

import '../constants/app_strings.dart';

class AuthDomainException implements Exception {
  final String message;
  AuthDomainException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    await _validateDomainOrSignOut(user);
    return user;
  }

  Future<User> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _ensureDomainAllowed(email);
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    await _validateDomainOrSignOut(user);
    return user;
  }

  Future<User> signInWithGoogle() async {
    final googleProvider = GoogleAuthProvider()
      ..setCustomParameters({'prompt': 'select_account'});
    final credential = await _firebaseAuth.signInWithPopup(googleProvider);
    final user = credential.user!;
    await _validateDomainOrSignOut(user);
    return user;
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  void _ensureDomainAllowed(String email) {
    if (!email.toLowerCase().endsWith(AppStrings.authAllowedDomainSuffix)) {
      throw AuthDomainException(AppStrings.authErrorInvalidDomain);
    }
  }

  Future<void> _validateDomainOrSignOut(User user) async {
    final email = user.email;
    if (email == null ||
        !email.toLowerCase().endsWith(AppStrings.authAllowedDomainSuffix)) {
      await _firebaseAuth.signOut();
      throw AuthDomainException(AppStrings.authErrorInvalidDomain);
    }
  }
}
