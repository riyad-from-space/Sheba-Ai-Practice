
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheba_ai/data/repositories/auth_repositories.dart';

import '../../data/models/user_model.dart';

class AuthState {
  final bool isLoading;
  final UserModel? user;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.isLoading = false,
    this.user,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository) : super(AuthState());

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final request = LoginRequest(username: username, password: password);
    final result = await _authRepository.login(request);
    
    result.when(
      success: (response) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
        );
        // Fetch user profile after successful login
        getProfile();
      },
      failure: (error, statusCode) {
        state = state.copyWith(
          isLoading: false,
          error: error,
          isAuthenticated: false,
        );
      },
    );
  }

  Future<void> register(String username, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final request = RegisterRequest(
      username: username,
      email: email,
      password: password,
      password2: password,
    );
    
    final result = await _authRepository.register(request);
    
    result.when(
      success: (user) {
        state = state.copyWith(isLoading: false, user: user);
      },
      failure: (error, statusCode) {
        state = state.copyWith(isLoading: false, error: error);
      },
    );
  }

  Future<void> getProfile() async {
    final result = await _authRepository.getProfile();
    
    result.when(
      success: (user) {
        state = state.copyWith(user: user);
      },
      failure: (error, statusCode) {
        state = state.copyWith(error: error);
      },
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = AuthState(); // Reset to initial state
  }

  Future<void> checkAuthStatus() async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    if (isLoggedIn) {
      state = state.copyWith(isAuthenticated: true);
      await getProfile();
    }
  }
}