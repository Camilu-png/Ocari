# AGENT.md — Ocari

Context guide for AI agents working on this repository.

---

## About This Project

Ocari is a Flutter mobile app for learning to play the 12-hole ocarina.
Inspired by Simply Piano: it plays a song while showing in real time
which holes to press on an illustrated ocarina.

Stack: Flutter · Dart · Riverpod · go_router · Supabase · just_audio

---

## Project Structure

```
lib/
├── core/
│   ├── theme/        # AppTheme, AppColors, AppTextStyles
│   ├── services/     # AudioService and other services
│   ├── router/       # go_router — routes and redirects
│   └── widgets/      # Reusable components (OcariButton, etc.)
├── features/
│   ├── auth/         # Login, registration, session (Supabase Auth)
│   ├── songs/        # Song list and detail
│   ├── player/       # Player + animated ocarina (CustomPainter)
│   └── progress/     # Per-song user progress
└── main.dart
```

> **Note:** The canonical, detailed folder structure with sub-layers is documented in [`lib/README.md`](lib/README.md). The diagram above is a simplified overview; refer to `lib/README.md` for the full architecture.

Each feature follows three layers: `data/` → `domain/` → `presentation/`.
Dependencies always flow inward. `presentation` knows `domain`,
but `domain` never knows `presentation` or `data`.

---

## Code Conventions

### Naming

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables and functions: `camelCase`
- Riverpod providers: suffix `Provider` or `Notifier` depending on type
- Screens: suffix `Screen` — e.g. `LoginScreen`, `SongsScreen`
- Reusable widgets: prefix `Ocari` — e.g. `OcariButton`, `OcariTextField`

### State Management

Use Riverpod with code generation (`@riverpod`).

- Remote data (auth, songs): `AsyncNotifier`
- Complex synchronous state (player): `Notifier`
- Streams (audio sync): `StreamProvider`
- Repositories and services: simple `Provider`

Never use `setState` outside truly local widgets.
Never put business logic inside a widget.

### Models

All domain models are immutable with `freezed`.
Always include `fromJson` / `toJson` with `json_serializable`.
After modifying a model, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Imports

Order: dart → flutter → external packages → internal imports.
Use relative imports within the same feature.
Use absolute imports (`package:ocari/...`) between features.

---

## Database (Supabase)

Three main tables:

| Table                | Description                                                |
| -------------------- | ---------------------------------------------------------- |
| `profiles`           | Extends `auth.users`. Public user data.                    |
| `songs`              | Song catalog. `notes_json` field stores note array.        |
| `user_song_progress` | Per-user/song progress. Unique on (user_id, song_id).      |

Row Level Security enabled on all tables.
Never query `auth.users` directly — use `profiles`.
Credentials go in environment variables, never hardcoded:

```bash
flutter run --dart-define-from-file=.env
```

---

## Routes

| Route              | Screen       | Auth Required |
| ------------------ | ------------ | ------------- |
| `/login`           | LoginScreen  | No            |
| `/songs`           | SongsScreen  | Yes           |
| `/player/:songId`  | PlayerScreen | Yes           |

Redirect logic is in `core/router/app_router.dart`:
no session → `/login`, with session → `/songs`.

---

## Ocarina — Domain-Specific Knowledge

The 12-hole ocarina has the following hole layout:

- 4 top holes (index, middle, ring, pinky of the right hand, read left to right)
- 4 bottom holes (pinky, ring, middle, index of the left hand, read left to right)
- 2 middle holes (left middle, right ring)
- 2 sub-holes at the back (thumbs)

The fingering for each note is in `assets/data/fingerings.json`.
Format: `{ "note": "D5", "top": [1,1,1,1], "bot": [1,1,1,1], "inter":[0,0], "sub": [1,1] }`
where `1 = pressed`, `0 = open`.

The 12-hole ocarina range is A4 → F6 (18 notes in Bb tuning).

---

## The Most Complex Screen: PlayerScreen

The player has 4 elements that must stay synchronized:

1. **Audio** — `just_audio` plays the song file
2. **Notes track** — horizontal list that advances with time
3. **Animated ocarina** — `CustomPainter` draws holes according to the active note
4. **Position** — `audioPositionProvider` (StreamProvider) bridges audio and UI

Synchronization flow: `position in ms` → find active note in `notes_json` →
update `PlayerNotifier` → rebuild `OcarinaCanvas` and `NotesTrack`.

---

## Common Commands

```bash
# Run the app
flutter run --dart-define-from-file=.env

# Static analysis (must pass without warnings before every PR)
flutter analyze

# Tests
flutter test

# Generate code (freezed + riverpod)
dart run build_runner build --delete-conflicting-outputs

# Clean build
flutter clean && flutter pub get
```

---

## Workflow

- Base branch for features: `develop` (never directly to `main`)
- Branch naming: `feature/XX-description` where XX is the issue number
- Commits: Conventional Commits — `feat(player): ...`, `fix(auth): ...`
- PR always targets `develop`, CI must pass before merging
- When finishing an issue: move it to "Done" on the GitHub Project

---

## What NOT to Do

- Do not hardcode colors outside `core/theme/app_theme.dart`
- Do not query Supabase directly from a widget
- Do not commit the `.env` file to the repository
- Do not commit directly to `main` or `develop`
- Do not mix more than one issue in a single PR
- Do not use `setState` for state affecting more than one widget
