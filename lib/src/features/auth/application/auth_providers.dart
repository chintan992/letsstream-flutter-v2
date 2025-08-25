import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Expose FirebaseAuth instance via Riverpod
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Stream of auth state changes (User? is null when signed out)
final authStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});

class AuthActions {
  final FirebaseAuth _auth;
  AuthActions(this._auth);

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception('Sign-in aborted');
    }

    // Obtain the auth details from the request
    final googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    // Also disconnect GoogleSignIn to ensure full sign-out on Android/web
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
  }
}

final authActionsProvider = Provider<AuthActions>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return AuthActions(auth);
});

