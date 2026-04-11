# File Organization

- All Dart source code lives under `lib/`.
- Platform-specific runners are in their respective directories (`android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/`).
- `lib/core/` contains shared infrastructure: `error/`, `helper/`, `presentation/cubit/`.
- `lib/features/` contains feature modules following Clean Architecture structure.
