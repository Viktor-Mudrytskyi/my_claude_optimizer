# Critical Rules

| #   | Rule                     | Details                                                   |
| --- | ------------------------ | --------------------------------------------------------- |
| 1   | NO print()               | Use `AppLogger`                                           |
| 2   | NO setState()            | All state via `BaseCubitImpl` + sealed states              |
| 3   | Domain = Pure Dart       | ZERO Flutter/Drift imports in `domain/`                   |
| 4   | Sealed + Equatable       | All states and entities — `props` with ALL fields         |
| 5   | Barrel-only imports      | Cross-feature: `import 'features/X/X.dart'` only          |
| 6   | ALL strings localized    | `LocaleKeys.*.tr()` — ZERO literal UI strings             |
| 7   | Colors via tokens        | `context.colorTokens` — NO hardcoded `CColors` in widgets |
| 8   | NO Navigator             | `context.pop()` / `context.push()` from GoRouter          |
| 9   | Cubit → UseCase          | Never import Repository directly to Cubit                 |
| 10  | DI order                 | factories → datasource → repository → usecases → cubits   |
| 11  | File suffixes            | ONLY: `_screen`, `_component`, `_widget`, `_listener`     |
| 12  | Functions ≤20 lines      | Single responsibility, split complex logic                |
| 13  | NO `_build*()` methods   | Extract to separate widget/component classes              |
| 14  | buildWhen on BlocBuilder | Always specify for performance                            |
| 15  | const constructors       | Use `const` in `build()` wherever possible                |
