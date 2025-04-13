import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vpay/features/auth/domain/auth_repository.dart';
import 'package:vpay/shared/models/user_model.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState.initial()) {
    _init();
  }


  Future<void> _init() async {
    final user = await _repository.getCurrentUser();
    if (user != null) {
      state = AuthState.authenticated(user);
    } else {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> signIn(String email, String password) async {
    state = AuthState.loading();
    try {
      await _repository.signIn(email: email, password: password);
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user);
      }
    } catch (e) {     
       if (e is AuthException && e.message.contains('duplicate key value violates unique constraint')) {
        state = AuthState.error("The user already exists");
      }else{
        state = AuthState.error("Error in login, please check your credentials");
      }
    }
  }

  Future<void> signUp(String email, String password, String fullName) async {
    state = AuthState.loading();
    try {
      await _repository.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      await signIn(email, password);
    } catch (e) {   
        if (e is AuthException && e.message.contains('duplicate key value violates unique constraint')) {
        state = AuthState.error("The email is already registered");
      }else{
        state = AuthState.error("Error in register, please try again");
      }
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
      state = AuthState(isLoading: true);
      try {
        await signUp(email, password, "new user");
      } catch (e) {
           state = AuthState(isLoading: false, error: 'Error in register, please try again');
      }
    }

  Future<void> signOut() async {
    try {
      await _repository.signOut();
      state = AuthState.unauthenticated();
    } catch (e) {   
      state = AuthState.error("Error in logout, please try again");
    }
  }

   Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _repository.sendPasswordResetEmail(email);
    } catch (e) {
      state = AuthState.error("Error sending password reset email");
    }
  }

  Future<void> signInWithGoogle() async {
    try {
       await _repository.signInWithGoogle();
    } catch (e) {
        state = AuthState.error("Error in login with Google, please try again");
    }
  }

  Future<void> signInWithFacebook() async {
    try {
        await _repository.signInWithFacebook();
    } catch (e) {
         state = AuthState.error("Error in login with Facebook, please try again");
    }
  }
}

class AuthState {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  AuthState({
    required this.isLoading,
    this.user,
    this.error,
  });

  factory AuthState.initial() => AuthState(isLoading: false);
  factory AuthState.loading() => AuthState(isLoading: true);
  factory AuthState.authenticated(UserModel user) => 
      AuthState(isLoading: false, user: user);
  factory AuthState.unauthenticated() => AuthState(isLoading: false);
  factory AuthState.error(String error) => 
      AuthState(isLoading: false, error: error);
}

