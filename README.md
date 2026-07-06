# Ocari 🎵

> Learn to play the 12-hole ocarina visually and intuitively.

Ocari is a mobile app designed for musicians and enthusiasts who want to master the 12-hole ocarina. Through an intuitive interface, it displays exact real-time finger positions for every note in your favorite songs — inspired by the Simply Piano experience, adapted for the ocarina.

---

## Key Features

- **Real-Time Visual Guide** — Interactive finger position visualization for 12-hole ocarinas, faithful to standard fingering conventions.
- **Song Library** — Includes iconic tracks from video games, anime, and classical music.
- **Speed Control** — Adjust playback tempo to practice at your own pace (×0.5, ×0.75, ×1).
- **Upcoming Notes Mode** — Anticipate position changes with a timeline of upcoming notes.
- **Personal Progress** — Track practiced songs and session statistics.

---

## Tech Stack

| Layer            | Technology    |
| ---------------- | ------------- |
| Mobile           | Flutter (Dart)|
| State Management | Riverpod      |
| Navigation       | go_router     |
| Backend / Auth   | Supabase      |
| Audio            | just_audio    |
| CI/CD            | GitHub Actions|

---

## Project Structure

```
lib/
├── core/
│   ├── theme/          # AppTheme, AppColors, AppTextStyles
│   ├── services/       # AudioService
│   ├── router/         # go_router — routes and redirects
│   └── widgets/        # Reusable components
├── features/
│   ├── auth/           # Login, registration, session
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── songs/          # Song list and details
│   ├── progress/       # Per-song user progress
│   └── player/         # Player + animated ocarina
└── main.dart
```

---

## Running the Project Locally

### Prerequisites

- Flutter SDK `>=3.18.0`
- Dart `>=3.3.0 <4.0.0`
- A [Supabase](https://supabase.com) account (free tier)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/your-username/ocari.git
cd ocari

# 2. Install dependencies
flutter pub get

# 3. Configure environment variables
cp .env.example .env
# Edit .env with your Supabase credentials

# 4. Run the app
flutter run --dart-define-from-file=.env
```

### Environment Variables

Create a `.env` file in the project root (never commit it to the repository):

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

---

## Development Workflow

This project follows the branching strategy below:

```
main        ← production (merge only from develop via PR)
develop     ← integration (base branch for features)
feature/*   ← one branch per issue
```

### Commit Convention

Comments must comply with the following rules [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(player): add hole animation for D4 note
fix(auth): fix redirect on logout
chore(ci): update Flutter version in GitHub Actions
docs(readme): add installation instructions
```

### Creating a Feature Branch

```bash
git checkout develop
git pull origin develop
git checkout -b feature/07-login-email
```

---

## Roadmap

### Sprint 0 — Foundation

- [x] Initialize base Flutter application
- [x] Folder structure and architecture
- [x] Supabase configuration
- [x] Base navigation with go_router
- [x] Auth (login, registration, Google Sign-In)
- [x] Design system and base components
- [x] CI/CD with GitHub Actions

### Sprint 1 — Player

- [x] Song list screen
- [X] Player with animated ocarina (CustomPainter)
- [X] Audio → note → fingering synchronization
- [X] Playback speed control

### Sprint 2 — Tutorials and content _(in progress)_
- [X] Fix: centred and responsive note track in landscape mode
- [ ] Onboarding system — explanation of colours and how to read the track
- [ ] Interactive step-by-step tutorial within the player
- [ ] Practice mode — short exercises by colour/note before playing songs
- [ ] Import sheet music

### Sprint 3 — Polish and Launch

- [ ] User progress and statistics
- [ ] App Store and Google Play preparation

---

## License

MIT © 2025 — Ocari
