import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Estados posibles
enum UserMode { employer, colaborator }

class UserModeNotifier extends StateNotifier<AsyncValue<UserMode>> {
  UserModeNotifier() : super(const AsyncValue.data(UserMode.employer));

  Future<void> toggleMode() async {
    state = const AsyncValue.loading();

    await Future.delayed(const Duration(milliseconds: 450));

    state = AsyncValue.data(
      state.value == UserMode.employer
          ? UserMode.colaborator
          : UserMode.employer,
    );
  }
}

final userModeProvider =  StateNotifierProvider<UserModeNotifier, AsyncValue<UserMode>>((ref) => UserModeNotifier(),);
