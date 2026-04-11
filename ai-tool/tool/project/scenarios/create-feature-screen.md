---
name: create-feature-screen
description: Create a new feature screen with full Clean Architecture scaffolding (domain, data, presentation layers).
---

## Trigger

User asks to create a new screen, page, feature, or view with business logic.

## Sequence

1. Load project context: ARCHITECTURE.md, STACK.md, rules/, and flutter-clean-architecture skill.
2. Identify the feature name and required entities from the user's request.
3. Create domain layer: entities, repository interface, use case(s).
4. Create data layer: repository implementation (mock or real datasource).
5. Create presentation layer: cubit, sealed states, screen, widgets.
6. Wire into main.dart or routing (BlocProvider + screen reference).
7. Run `flutter analyze` to verify no issues.
8. If analysis fails — go back to step that introduced the issue and fix.
9. Finish.

## Loop conditions

Step 7 failure → return to the step that caused the issue (identified from analyzer output).

## Notes

- For mock/placeholder features, skip datasource/mapper/changelog sub-layers and use a simple repository impl with `Future.delayed`.
- Ensure domain layer has ZERO Flutter imports.
- All states must be sealed + Equatable.
- Cubit must use BaseCubit and executeUseCase pattern.
