import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock authentication providers for when Firebase is not available
// This provides a basic structure that can be replaced with local authentication later

// Mock auth state provider - always returns null (not signed in)
final authStateProvider = StreamProvider((ref) {
  return Stream.value(null); // Always return null (not signed in)
});

// Mock auth actions provider
class AuthActions {
  Future<void> signInWithGoogle() async {
    // Mock implementation - could be replaced with local authentication
    throw Exception('Authentication not available - Firebase has been removed');
  }

  Future<void> signOut() async {
    // Mock implementation - no-op since we're not signed in
  }
}

final authActionsProvider = Provider<AuthActions>((ref) {
  return AuthActions();
});
