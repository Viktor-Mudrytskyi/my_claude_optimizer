# Architecture

## Pattern

Clean Architecture (Uncle Bob) with feature-based modularization.

## Folder Structure

```
flutter_application/
├── lib/
│   └── main.dart              # App entry point
├── android/                   # Android platform runner
├── ios/                       # iOS platform runner
├── web/                       # Web platform runner
├── macos/                     # macOS platform runner
├── linux/                     # Linux platform runner
├── windows/                   # Windows platform runner
├── pubspec.yaml               # Dependencies and project metadata
└── analysis_options.yaml      # Linter configuration
```

### Feature module structure

```
lib/features/<feature>/
├── di.dart                    # DI mixin (mixin XDI on DIModule)
├── <feature>.dart             # Barrel export
├── domain/                    # Pure Dart — ZERO Flutter/Drift imports
│   ├── entities/              # Equatable business objects
│   ├── failures/              # Sealed failure classes
│   ├── repositories/          # Abstract interfaces
│   └── usecases/              # Single operations (extends Usecase<T,P>)
├── data/
│   ├── datasources/local/     # operations/ + changelog/ + factories/ + mappers/
│   ├── models/                # DTOs with toEntity()/fromEntity()
│   └── repositories/          # Implements domain interfaces
└── presentation/
    ├── cubit/                 # BaseCubitImpl<S>, sealed states + Equatable
    ├── screens/               # Full-screen widgets (*_screen.dart)
    ├── components/            # Smart UI with BlocBuilder (*_component.dart)
    └── widgets/               # Dumb UI (*_widget.dart)
```

## Layers

| Layer              | Responsibility                                          | Dependencies                          |
| ------------------ | ------------------------------------------------------- | ------------------------------------- |
| **Domain**         | Entities, value objects, repository interfaces, usecases | NONE (only dartz for Either type)     |
| **Data**           | Models, datasources, repository implementations         | Domain interfaces, Drift, Changelog   |
| **Presentation**   | Screens, widgets, cubits, state classes                  | Flutter, Domain entities, UseCases    |
| **Infrastructure** | Database config, routing, network, app bootstrap         | Flutter, Drift, external packages     |

## State Management

flutter_bloc (Cubit pattern). All state via `BaseCubitImpl` + sealed state classes. No `setState()`.

## Navigation

GoRouter. Use `context.pop()` / `context.push()` — no direct `Navigator` usage.

## Data Flow

UseCase-driven: UI (Cubit) → UseCase → Repository interface (domain) → Repository implementation (data) → Datasource → Drift (SQLite). Error handling via `dartz Either<Failure, T>`.
