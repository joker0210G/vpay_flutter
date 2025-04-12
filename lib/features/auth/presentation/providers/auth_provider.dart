import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vpay/features/auth/data/auth_repository.dart';
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
      state = AuthState.error(e.toString());
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
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _repository.signOut();
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
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

