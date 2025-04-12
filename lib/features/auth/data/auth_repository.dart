import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vpay/shared/models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(supabase: Supabase.instance.client);
});

class AuthRepository {
  final SupabaseClient supabase;

  AuthRepository({required this.supabase});

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );

    if (response.user != null) {
      await supabase.from('profiles').insert({
        'id': response.user!.id,
        'email': email,
        'full_name': fullName,
      });
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();
      
      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}

