# Gestión de estado — Riverpod

## ¿Por qué Riverpod y no otras opciones?

| Criterio | Riverpod | BLoC | Provider | GetX |
|---|---|---|---|---|
| Curva de aprendizaje | Media | Alta | Baja | Baja |
| Testabilidad | ★★★★★ | ★★★★★ | ★★★ | ★★ |
| Seguridad en tiempo de compilación | ★★★★★ | ★★★★ | ★★★ | ★★ |
| Boilerplate | Bajo | Alto | Medio | Muy bajo |
| Escala bien con el proyecto | ✓ | ✓ | Limitado | No recomendado |
| Adecuado para audio/animaciones en tiempo real | ✓ | ✓ | ✗ | ✗ |

**Riverpod gana** para Ocari porque:
- El reproductor necesita estado reactivo en tiempo real (nota activa → UI → audio), que Riverpod maneja con `StreamProvider` sin boilerplate extra.
- Es completamente testeable sin contexto de Flutter — crítico para testear la lógica del player.
- `AsyncNotifier` simplifica el manejo de estados de carga en auth y canciones.
- Detección de errores en tiempo de compilación, no en runtime.

## Patrones que usamos en Ocari

### 1. `AsyncNotifier` — para datos remotos (auth, canciones)

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

### 2. `Notifier` — para estado sincrónico complejo (reproductor)

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

### 3. `StreamProvider` — para sincronización audio → nota

```dart
// features/player/presentation/providers/audio_sync_provider.dart
@riverpod
Stream<int> audioPosition(AudioPositionRef ref) {
  final player = ref.watch(audioPlayerProvider);
  return player.positionStream.map((pos) => pos.inMilliseconds);
}
```

### 4. `Provider` simple — para repositorios y servicios

```dart
// features/auth/data/repositories/auth_repository_provider.dart
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return SupabaseAuthRepository(ref.watch(supabaseClientProvider));
}
```

## Convención de nombres

| Tipo | Sufijo | Ejemplo |
|---|---|---|
| Notifier con estado complejo | `Notifier` | `PlayerNotifier` |
| Provider de repositorio | `Repository` | `authRepository` |
| Provider de servicio | `Service` | `audioService` |
| StreamProvider | descriptor en presente | `audioPosition` |

## Dónde viven los providers

Cada provider vive en la capa `presentation/providers/` de su feature — **nunca** en `domain/` ni en `data/`. Los providers de infraestructura compartida (cliente Supabase, just_audio) van en `core/`.