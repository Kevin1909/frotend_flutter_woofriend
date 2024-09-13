import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woofriend/features/auth/domain/domain.dart';
import 'package:woofriend/features/auth/infrastructure/infrastructure.dart';

final userInfoProvider = StateNotifierProvider.autoDispose
    .family<UserNotifier, UserState, String>((ref, userId) {
  final authRepository = AuthRepositoryImpl();

  return UserNotifier(authRepository: authRepository, userId: userId);
});

class UserNotifier extends StateNotifier<UserState> {
  final AuthRepository authRepository;

  UserNotifier({
    required this.authRepository,
    required String userId,
  }) : super(UserState(id: userId)) {
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      state = state.copyWith(isLoading: true);
      final user = await authRepository.getUserById(state.id);
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      // 404 product not found
      print(e);
    }
  }
}

class UserState {
  final String id;
  final User? user;
  final bool isLoading;
  final bool isSaving;

  UserState({
    required this.id,
    this.user,
    this.isLoading = true,
    this.isSaving = false,
  });

  UserState copyWith({
    String? id,
    User? user,
    bool? isLoading,
    bool? isSaving,
  }) =>
      UserState(
        id: id ?? this.id,
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}
