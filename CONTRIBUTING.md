# Contributing to Ocari

## Workflow

1. Pick an issue from the board and move it to **In Progress**
2. Create a branch from `develop`:

   ```bash
   git checkout develop && git pull origin develop
   git checkout -b feature/XX-short-name
   ```

3. Develop and commit following the commit convention
4. Open a PR targeting `develop` — never directly to `main`
5. CI must pass before merging

## Commit Convention

We use [Conventional Commits](https://www.conventionalcommits.org/). The format is:

```
<type>(<scope>): <short description in lowercase and in english>
```

### Allowed Types

| Type       | When to use it                            |
| ---------- | ----------------------------------------- |
| `feat`     | New user-facing functionality             |
| `fix`      | Bug fix                                   |
| `refactor` | Internal change without functional impact |
| `chore`    | Dependencies, CI/CD, configuration        |
| `docs`     | Documentation only                        |
| `test`     | Add or fix tests                          |
| `style`    | Formatting, spacing, no logic changes     |

### Real Examples from This Project

```bash
feat(player): add hole animation for D4 note
feat(auth): implement email and password login
fix(router): fix redirect when session expires
chore(ci): add flutter analyze step to pipeline
docs(readme): add installation instructions
test(auth): add unit tests for AuthNotifier
refactor(songs): extract SongCard to independent widget
```

### Recommended Scopes

`auth` · `player` · `songs` · `router` · `theme` · `ci` · `readme`

## Branch Naming

```
feature/07-login-email
feature/11-app-theme
fix/router-redirect-bug
chore/update-flutter-version
```

The number at the beginning corresponds to the GitHub issue number.

## What NOT to Do

- Do not commit directly to `main` or `develop`
- Do not upload the `.env` file with credentials
- Do not mix multiple issues in a single PR
