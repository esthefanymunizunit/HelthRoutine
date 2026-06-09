import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/app_strings.dart';

class AuthDomainException implements Exception {
  final String message;
  AuthDomainException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  static const String _googleWebClientId =
      '916869031451-qf0c2aphc8642kus89sqea4d641jn0hq.apps.googleusercontent.com';
  static bool _isMobileGoogleSignInInitialized = false;

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
    final UserCredential credential;
    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider()
        ..setCustomParameters({'prompt': 'select_account'});
      credential = await _firebaseAuth.signInWithPopup(googleProvider);
    } else {
      await _ensureMobileGoogleSignInInitialized();
      final account = await GoogleSignIn.instance.authenticate();
      final auth = account.authentication;
      final googleFirebaseCredential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );
      credential = await _firebaseAuth.signInWithCredential(
        googleFirebaseCredential,
      );
    }
    final user = credential.user!;
    await _validateDomainOrSignOut(user);
    return user;
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  Future<void> _ensureMobileGoogleSignInInitialized() async {
    if (_isMobileGoogleSignInInitialized) return;
    await GoogleSignIn.instance.initialize(
      serverClientId: _googleWebClientId,
    );
    _isMobileGoogleSignInInitialized = true;
  }

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
