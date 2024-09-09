import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woofriend/features/BL_woofriend/domain/domain.dart';

import '../../../../auth/presentation/providers/providers.dart';
import '../../../infrastructure/infrastructure.dart';

final animalsRepositoryProvider = Provider<AnimalsRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final animalsRepository =
      AnimalsRepositoryImpl(AnimalsDatasourceImpl(accessToken: accessToken));

  return animalsRepository;
});
