import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estados posibles
enum UserMode { employer, colaborator }

class UserModeNotifier extends AsyncNotifier<UserMode> {
  @override
  FutureOr<UserMode> build() {
    return UserMode.employer;
  }

  Future<void> toggleMode() async {
    // Conservar el valor actual antes de pasar a loading
    final current = state.value ?? UserMode.employer;
    state = const AsyncLoading<UserMode>();

    await Future.delayed(const Duration(milliseconds: 450));

    final next = current == UserMode.employer
        ? UserMode.colaborator
        : UserMode.employer;

    state = AsyncData<UserMode>(next);
  }
}

final userModeProvider =
    AsyncNotifierProvider<UserModeNotifier, UserMode>(UserModeNotifier.new);
