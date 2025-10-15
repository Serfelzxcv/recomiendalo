import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomiendalo/shared/models/user_mode.dart';

final userModeProvider =
    AsyncNotifierProvider<UserModeNotifier, UserMode>(UserModeNotifier.new);

class UserModeNotifier extends AsyncNotifier<UserMode> {
  @override
  FutureOr<UserMode> build() => UserMode.employer;

  Future<void> toggleMode() async {
    final current = state.asData?.value ?? UserMode.employer;

    state = const AsyncLoading(); // no hace falta <UserMode>
    await Future.delayed(const Duration(milliseconds: 400));

    final next = current == UserMode.employer
        ? UserMode.colaborator
        : UserMode.employer;

    state = AsyncData(next); // no hace falta <UserMode>
  }
}
