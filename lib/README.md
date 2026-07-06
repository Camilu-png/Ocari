# Ocari Architecture

Ocari follows a **Feature-first with Clean Layers** architecture, combining organization by functionality with separation of concerns across layers.

## Folder Structure

```
lib/
├── core/                        # Shared code across the app
│   ├── theme/                   # AppTheme, AppColors, AppTextStyles
│   ├── services/                # AudioService and other services
│   ├── router/                  # go_router configuration
│   └── widgets/                 # Reusable components (OcariButton, etc.)
│
├── features/                    # Each feature is a self-contained module
│   ├── auth/                    # Authentication and session
│   │   ├── data/
│   │   │   ├── repositories/    # Concrete implementation (Supabase)
│   │   │   └── datasources/     # Direct API calls
│   │   ├── domain/
│   │   │   ├── models/          # Business entities (User, etc.)
│   │   │   └── repositories/    # Interfaces (abstract contracts)
│   │   └── presentation/
│   │       ├── screens/         # LoginScreen, RegisterScreen
│   │       ├── widgets/         # Auth-specific widgets
│   │       └── providers/       # Riverpod providers for this feature
│   │
│   ├── songs/                   # Song library
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── models/          # Song, Difficulty, Fingering
│   │   └── presentation/
│   │       ├── screens/         # SongsScreen
│   │       ├── widgets/         # SongCard, DifficultyBadge
│   │       └── providers/
│   │
│   ├── player/                  # Player with animated ocarina
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── models/          # PlayerState, Note, FingeringMap
│   │   └── presentation/
│   │       ├── screens/         # PlayerScreen
│   │       ├── widgets/         # OcarinaCanvas, NotesTrack, TransportBar
│   │       └── providers/       # playerProvider, audioProvider
│   │
│   └── progress/                # Per-song user progress
│       ├── data/
│       ├── domain/
│       │   └── models/          # UserProgress, SessionStats
│       └── presentation/
│           ├── screens/         # ProgressScreen
│           └── providers/       # progressProvider
│
└── main.dart
```

## The Three Layers of Each Feature

### `presentation/` — UI and Local State
Everything the user sees and interacts with. **Riverpod providers** live here and bridge the UI with the domain. Screens and widgets only consume providers — they never call repositories directly.

### `domain/` — Business Rules
The core of the feature. Contains **models** (pure Dart entities, no Flutter or Supabase dependency) and **repository interfaces** (abstract contracts). This layer knows nothing about the database or the UI.

### `data/` — Data Access
Implements the contracts defined in `domain/`. Contains actual Supabase calls, JSON fingering file reads, and local cache management.

## State Management — Riverpod

See [`core/STATE_MANAGEMENT.md`](./core/STATE_MANAGEMENT.md) for the full decision record and usage examples.

## Golden Rules

1. **Dependencies always flow inward:** `presentation` may know `domain`, but `domain` never knows `presentation` or `data`.
2. **One provider per responsibility** — avoid providers that do too much.
3. **No business logic in widgets** — all logic goes in the provider or the domain layer.
4. **Immutable models** — use `freezed` for all domain entities.
