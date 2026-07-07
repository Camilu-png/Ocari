# Contributing to Ocari

Thank you for taking the time to contribute! Whether you are reporting a bug, suggesting a new feature, or submitting code — all contributions are welcome.

---

## For Everyone — Reporting Bugs & Requesting Features

You do not need to know how to code to help. Opening a well-written issue is one of the most valuable contributions you can make.

### Before Opening an Issue

- **Search existing issues** — check if someone already reported the same bug or suggested the same feature.
- For bugs: make sure you are running the latest version of the app.

### Reporting a Bug

Use the **Bug Report** template (it will appear automatically when you create a new issue). Include:

- **What happened** vs **what should have happened** — be as specific as you can.
- **Steps to reproduce** — list the exact actions that led to the bug. For example:
  1. Open the app and go to the song list.
  2. Tap on "Saria's Song".
  3. The app crashes.
- **Your device and OS** — e.g. iPhone 15, iOS 18.2 or Samsung Galaxy S24, Android 14.

If you are not sure about something, just write what you know. Incomplete reports are still useful.

### Requesting a Feature

Use the **Feature Request** template. Describe:

- **What you want to achieve** — what problem are you trying to solve?
- **Why it would be useful** — how would it improve your experience with Ocari?
- (Optional) Screenshots, sketches, or references to similar apps.

### Tips for a Great Issue

- Use a clear, descriptive title.
- Add screenshots or screen recordings if possible — a image is worth a thousand words.
- Be respectful and patient. Maintainers are volunteers or working on this in their free time.

---

## For Developers — Development Workflow

This section is for people who want to contribute code.

### Branching Strategy

```
main        ← production (merge only from develop via PR)
develop     ← integration (base branch for features)
feature/*   ← one branch per issue
```

### Creating a Feature Branch

```bash
git checkout develop && git pull origin develop
git checkout -b feature/XX-short-name
```

Replace `XX` with the issue number and `short-name` with a brief description (e.g. `feature/23-login-email`).

### Commit Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short description in lowercase and in english>
```

| Type       | When to use it                            |
| ---------- | ----------------------------------------- |
| `feat`     | New user-facing functionality             |
| `fix`      | Bug fix                                   |
| `refactor` | Internal change without functional impact |
| `chore`    | Dependencies, CI/CD, configuration        |
| `docs`     | Documentation only                        |
| `test`     | Add or fix tests                          |
| `style`    | Formatting, spacing, no logic changes     |

**Examples:**

```
feat(player): add hole animation for D4 note
fix(router): fix redirect when session expires
docs(readme): add installation instructions
```

**Recommended scopes:** `auth` · `player` · `songs` · `router` · `theme` · `ci` · `readme`

### Opening a Pull Request

1. Push your branch and open a PR targeting **`develop`** (never directly to `main`).
2. Fill out the PR template — it includes a checklist to help you.
3. Make sure CI passes (GitHub will run the checks automatically).
4. Request a review if possible.

### What NOT to Do

- Do not commit directly to `main` or `develop`
- Do not upload the `.env` file with credentials
- Do not mix multiple issues in a single PR
