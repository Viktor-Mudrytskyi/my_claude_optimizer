# Architecture

## Pattern

Default Flutter starter project. No architectural pattern is established yet — the app consists of a single file with a minimal widget tree.

## Folder Structure

```
flutter_application/
├── lib/
│   └── main.dart          # App entry point and sole widget
├── android/               # Android platform runner
├── ios/                   # iOS platform runner
├── web/                   # Web platform runner
├── macos/                 # macOS platform runner
├── linux/                 # Linux platform runner
├── windows/               # Windows platform runner
├── pubspec.yaml           # Dependencies and project metadata
└── analysis_options.yaml  # Linter configuration
```

## Layers

Not determined. The project has a single `main.dart` with no layer separation.

## State Management

Not determined. No state management solution is in use. The sole widget is a `StatelessWidget`.

## Navigation

Not determined. No navigation is configured. The app uses a single `MaterialApp` with a hardcoded `home` screen.

## Data Flow

Not determined. No data sources, API clients, repositories, or local storage are present.
