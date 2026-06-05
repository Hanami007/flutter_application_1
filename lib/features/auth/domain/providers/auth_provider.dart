import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';

// Auth State Provider
final authStateProvider = StateProvider<AuthState>((ref) {
  return const AuthState.initial();
});

// Current User Provider
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, User?>((ref) {
  return CurrentUserNotifier();
});

class CurrentUserNotifier extends StateNotifier<User?> {
  CurrentUserNotifier() : super(null);

  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  void updateUser(User user) {
    state = user;
  }
}

// Auth Repository Provider (mock for now)
final authRepositoryProvider = Provider((ref) {
  return AuthRepository();
});

class AuthRepository {
  Future<User> loginWithEmail(String email, String password) async {
    // TODO: Implement Supabase login
    throw UnimplementedError();
  }

  Future<User> registerWithEmail(String email, String password) async {
    // TODO: Implement Supabase registration
    throw UnimplementedError();
  }

  Future<User> loginWithGoogle() async {
    // TODO: Implement Google login
    throw UnimplementedError();
  }

  Future<void> logout() async {
    // TODO: Implement logout
  }

  Future<User?> getCurrentUser() async {
    // TODO: Implement get current user
    return null;
  }
}
