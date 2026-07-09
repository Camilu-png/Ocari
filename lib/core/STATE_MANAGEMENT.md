# State Management — Riverpod

## Why Riverpod Over Other Options?

| Criteria | Riverpod | BLoC | Provider | GetX |
|---|---|---|---|---|---|
| Learning curve | Medium | High | Low | Low |
| Testability | ★★★★★ | ★★★★★ | ★★★ | ★★ |
| Compile-time safety | ★★★★★ | ★★★★ | ★★★ | ★★ |
| Boilerplate | Low | High | Medium | Very low |
| Scales well with the project | ✓ | ✓ | Limited | Not recommended |
| Suitable for real-time audio/animations | ✓ | ✓ | ✗ | ✗ |

**Riverpod wins** for Ocari because:
- The player needs real-time reactive state (active note → UI → audio), which Riverpod handles with `StreamProvider` without extra boilerplate.
- It is fully testable without Flutter context — critical for testing player logic.
- `AsyncNotifier` simplifies loading state management in auth and songs.
- Compile-time error detection, not runtime.

## Patterns Used in Ocari

### 1. `AsyncNotifier` — for remote data (auth, songs)

```dart
// features/auth/presentation/providers/auth_provider.dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    return ref.watch(authRepositoryProvider).currentUser();
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signIn(email, password),
    );
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }
}
```

### 2. `Notifier` — for complex synchronous state (player)

```dart
// features/player/presentation/providers/player_provider.dart
@riverpod
class PlayerNotifier extends _$PlayerNotifier {
  @override
  PlayerState build() => PlayerState.initial();

  void play()   => state = state.copyWith(isPlaying: true);
  void pause()  => state = state.copyWith(isPlaying: false);
  void setSpeed(double speed) => state = state.copyWith(speed: speed);
  void advanceNote() => state = state.copyWith(
    currentNoteIndex: state.currentNoteIndex + 1,
  );
}
```

### 3. `StreamProvider` — for audio → note synchronization

```dart
// features/player/presentation/providers/audio_sync_provider.dart
@riverpod
Stream<int> audioPosition(AudioPositionRef ref) {
  final player = ref.watch(audioPlayerProvider);
  return player.positionStream.map((pos) => pos.inMilliseconds);
}
```

### 4. Simple `Provider` — for repositories and services

```dart
// features/auth/data/repositories/auth_repository_provider.dart
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return SupabaseAuthRepository(ref.watch(supabaseClientProvider));
}
```

## Naming Convention

| Type | Suffix | Example |
|---|---|---|
| Notifier with complex state | `Notifier` | `PlayerNotifier` |
| Repository provider | `Repository` | `authRepository` |
| Service provider | `Service` | `audioService` |
| StreamProvider | present tense descriptor | `audioPosition` |

## Where Providers Live

Each provider lives in the `presentation/providers/` layer of its feature — **never** in `domain/` or `data/`. Shared infrastructure providers (Supabase client, just_audio) go in `core/`.
