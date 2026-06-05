import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_core;
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

// Auth Repository Provider
final authRepositoryProvider = Provider((ref) {
  return AuthRepository();
});

class AuthRepository {
  bool get _isSupabaseConfigured {
    try {
      supabase_core.Supabase.instance.client;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<User> loginWithEmail(String email, String password) async {
    if (!_isSupabaseConfigured) {
      return User(
        id: '9999ee9d-ff46-4cb4-972c-f68482bf4f17',
        email: email,
        fullName: 'Guest User (Mock)',
        createdAt: DateTime.now(),
      );
    }

    final client = supabase_core.Supabase.instance.client;
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final sbUser = response.user;
    if (sbUser == null) {
      throw Exception('User was null after sign-in.');
    }

    // Try to load the user profile from the database
    try {
      final profile = await client
          .from('users')
          .select()
          .eq('id', sbUser.id)
          .maybeSingle();

      if (profile != null) {
        return User(
          id: sbUser.id,
          email: sbUser.email ?? '',
          fullName: profile['full_name'] as String?,
          phoneNumber: profile['phone_number'] as String?,
          address: profile['address'] as String?,
          profileImageUrl: profile['profile_image_url'] as String?,
          isEmailVerified: sbUser.emailConfirmedAt != null,
          createdAt: DateTime.tryParse(sbUser.createdAt),
          updatedAt: sbUser.updatedAt != null ? DateTime.tryParse(sbUser.updatedAt!) : null,
        );
      }
    } catch (_) {}

    final metadata = sbUser.userMetadata ?? {};
    return User(
      id: sbUser.id,
      email: sbUser.email ?? '',
      fullName: metadata['full_name'] as String? ?? metadata['name'] as String?,
      phoneNumber: sbUser.phone,
      profileImageUrl: metadata['avatar_url'] as String? ?? metadata['picture'] as String?,
      isEmailVerified: sbUser.emailConfirmedAt != null,
      createdAt: DateTime.tryParse(sbUser.createdAt),
      updatedAt: sbUser.updatedAt != null ? DateTime.tryParse(sbUser.updatedAt!) : null,
    );
  }

  Future<User> registerWithEmail(
    String email,
    String password, {
    String? fullName,
    String? phoneNumber,
    String? address,
  }) async {
    if (!_isSupabaseConfigured) {
      return User(
        id: '9999ee9d-ff46-4cb4-972c-f68482bf4f17',
        email: email,
        fullName: fullName ?? 'Mock Registrant',
        phoneNumber: phoneNumber,
        address: address,
        createdAt: DateTime.now(),
      );
    }

    final client = supabase_core.Supabase.instance.client;
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: {
        if (fullName != null) 'full_name': fullName,
      },
    );
    final sbUser = response.user;
    if (sbUser == null) {
      throw Exception('User registration failed.');
    }

    // Insert user profile into public users table
    try {
      await client.from('users').insert({
        'id': sbUser.id,
        'email': email,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'address': address,
        'auth_id': sbUser.id,
      });
    } catch (e) {
      debugPrint('Failed to insert user profile: $e');
    }

    return User(
      id: sbUser.id,
      email: sbUser.email ?? '',
      fullName: fullName,
      phoneNumber: phoneNumber,
      address: address,
      isEmailVerified: sbUser.emailConfirmedAt != null,
      createdAt: DateTime.tryParse(sbUser.createdAt),
      updatedAt: sbUser.updatedAt != null ? DateTime.tryParse(sbUser.updatedAt!) : null,
    );
  }

  Future<void> logout() async {
    if (_isSupabaseConfigured) {
      final client = supabase_core.Supabase.instance.client;
      await client.auth.signOut();
    }
  }

  Future<User?> getCurrentUser() async {
    if (!_isSupabaseConfigured) {
      return null;
    }

    final client = supabase_core.Supabase.instance.client;
    final sbUser = client.auth.currentUser;
    if (sbUser == null) {
      return null;
    }

    // Try to load the user profile from the database
    try {
      final profile = await client
          .from('users')
          .select()
          .eq('id', sbUser.id)
          .maybeSingle();

      if (profile != null) {
        return User(
          id: sbUser.id,
          email: sbUser.email ?? '',
          fullName: profile['full_name'] as String?,
          phoneNumber: profile['phone_number'] as String?,
          address: profile['address'] as String?,
          profileImageUrl: profile['profile_image_url'] as String?,
          isEmailVerified: sbUser.emailConfirmedAt != null,
          createdAt: DateTime.tryParse(sbUser.createdAt),
          updatedAt: sbUser.updatedAt != null ? DateTime.tryParse(sbUser.updatedAt!) : null,
        );
      }
    } catch (e) {
      debugPrint('Failed to fetch user profile: $e');
    }

    final metadata = sbUser.userMetadata ?? {};
    return User(
      id: sbUser.id,
      email: sbUser.email ?? '',
      fullName: metadata['full_name'] as String? ?? metadata['name'] as String?,
      phoneNumber: sbUser.phone,
      profileImageUrl: metadata['avatar_url'] as String? ?? metadata['picture'] as String?,
      isEmailVerified: sbUser.emailConfirmedAt != null,
      createdAt: DateTime.tryParse(sbUser.createdAt),
      updatedAt: sbUser.updatedAt != null ? DateTime.tryParse(sbUser.updatedAt!) : null,
    );
  }
}
