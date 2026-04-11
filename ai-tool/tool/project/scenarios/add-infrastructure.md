---
name: add-infrastructure
description: Add or modify infrastructure-level concerns (routing, DI, networking, database config) that span across features.
---

## Trigger

User asks to add routing, dependency injection setup, network layer, database config, or other cross-cutting infrastructure.

## Sequence

1. Load project context: ARCHITECTURE.md, STACK.md, rules/, and flutter-clean-architecture skill.
2. Identify the infrastructure concern and required dependencies.
3. Add dependencies to `pubspec.yaml` and run `flutter pub get`.
4. Create infrastructure files under `lib/core/` or appropriate location per ARCHITECTURE.md.
5. Update `main.dart` to integrate the new infrastructure.
6. Update existing screens/features to use the new infrastructure where applicable.
7. Run `flutter analyze` to verify no issues.
8. If analysis fails — go back to the step that introduced the issue and fix.
9. Finish.

## Loop conditions

Step 7 failure → return to the step that caused the issue (identified from analyzer output).

## Notes

- Infrastructure belongs in `lib/core/` or a dedicated infrastructure directory.
- Routing uses GoRouter — no direct Navigator usage (critical rule #8).
- Keep infrastructure layer separate from feature business logic.
