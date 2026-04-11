`STACK.md` what technologies, versions this project uses.
`ARCHITECTURE.md` what architecture the project uses.
`rules/*.md` specific rules the project follows.

# Stack

## Languages

- Dart ^3.11.3 (via SDK constraint)
- Kotlin (Android, JVM target 17)
- Swift (iOS/macOS runners)
- C++ (Windows/Linux runners)

## Frameworks

- Flutter (stable channel, revision 2c9eb20)

## Key Dependencies

- flutter (sdk) — core framework
- equatable ^2.0.7 — value equality for entities and states
- flutter_bloc ^9.1.0 — state management (Cubit pattern)
- dartz ^0.10.1 — functional programming (Either type for error handling)
- flutter_lints ^6.0.0 — lint rules (dev)
- flutter_test (sdk) — testing framework (dev)

## Target Platforms

- Android
- iOS
- Web
- macOS
- Linux
- Windows

## Build & Tooling

- Gradle (Kotlin DSL) — Android build
- Xcode — iOS/macOS build
- CMake — Linux/Windows build
- flutter_lints — static analysis
