import 'package:riverpod/riverpod.dart';
import 'package:woofriend/features/auth/domain/domain.dart';

import 'package:woofriend/features/auth/infrastructure/infrastructure.dart';

import '../../../shared/infrastructure/services/key_value_storage_service.dart';
import '../../../shared/infrastructure/services/key_value_storage_service_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
      authRepository: authRepository,
      keyValueStorageService: keyValueStorageService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }

    // final user = await authRepository.login(email, password);
    // state =state.copyWith(user: user, authStatus: AuthStatus.authenticated)
  }

  Future<bool> registerOrUpdateUser(Map<String, dynamic> user) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      await authRepository.registerUpdateUser(user);
      return true;
    } on CustomError catch (e) {
      logout(e.message);
      return false;
    } catch (e) {
      logout('Error no controlado');
      return false;
    }
  }



  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }



  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.token);
    if (user.roles.contains("user_foundation"))
      state = state.copyWith(isFoundation: true);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
        isFoundation: false,
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final bool isFoundation;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.isFoundation = false,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith({
    AuthStatus? authStatus,
    bool? registeredUser,
    bool? isFoundation,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
        isFoundation: isFoundation ?? this.isFoundation,
      );
}
