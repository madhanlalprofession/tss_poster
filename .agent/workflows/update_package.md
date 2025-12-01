---
description: Update package version, documentation, and publish to GitHub
---

1. Update `pubspec.yaml` with the new version number.
2. Update `CHANGELOG.md` with the new version and a list of changes.
3. Update `README.md` installation instructions to reference the new version (e.g., `tss_poster: ^x.x.x`).
4. Run `flutter pub get` to ensure `pubspec.lock` is updated.
// turbo
5. Commit all changes with a message like "chore: bump version to x.x.x".
// turbo
6. Push changes to GitHub using `git push`.
