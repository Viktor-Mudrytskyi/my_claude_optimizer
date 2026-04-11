---
name: analyze-project
description: Analyzes the project codebase and fills the ai-tool/tool/project/ folder with STACK.md, ARCHITECTURE.md, and rules/*.md.
---

## Inputs

| Name         | Required | Description                                                                      |
| ------------ | -------- | -------------------------------------------------------------------------------- |
| project_path | no       | Path to the project root. Defaults to the repository root, excluding `ai-tool/`. |

## Behavior

1. Identify the project root. If `project_path` is not provided, use the repository root and exclude `ai-tool/` from analysis.
2. **Discover the stack.** Scan for dependency/config files (`pubspec.yaml`, `package.json`, `build.gradle`, `Podfile`, `CMakeLists.txt`, `Gemfile`, `requirements.txt`, `go.mod`, etc.). Read them to extract:
   - Languages and their versions/SDK constraints.
   - Frameworks (e.g. Flutter, React, Spring).
   - Key dependencies and their versions.
   - Target platforms (iOS, Android, web, desktop, etc.).
   - Build tools, linters, and test frameworks.
3. **Discover the architecture.** Read the source tree structure and key entry-point files to determine:
   - Overall architectural pattern (e.g. clean architecture, MVC, BLoC, MVVM).
   - Layer/module structure and their responsibilities.
   - Navigation approach.
   - State management approach.
   - Data flow (API clients, repositories, local storage).
   - Folder structure convention and what each top-level source directory contains.
4. **Discover project rules.** Scan for:
   - Linter/analyzer config files (`analysis_options.yaml`, `.eslintrc`, etc.) — summarize non-default rules.
   - Code style conventions visible in the codebase (naming, file organization, import ordering).
   - Any CI/CD or contribution guidelines.
5. **Write `ai-tool/tool/project/STACK.md`.** Format:

   ```
   # Stack

   ## Languages
   - <language> <version/constraint>

   ## Frameworks
   - <framework> <version>

   ## Key Dependencies
   - <dep> <version> — <purpose>

   ## Target Platforms
   - <platform>

   ## Build & Tooling
   - <tool> — <purpose>
   ```

6. **Write `ai-tool/tool/project/ARCHITECTURE.md`.** Format:

   ```
   # Architecture

   ## Pattern
   <Description of the architectural pattern.>

   ## Folder Structure
   <Tree or table showing top-level source directories and their purpose.>

   ## Layers
   <Description of each layer/module and its responsibility.>

   ## State Management
   <Approach used.>

   ## Navigation
   <Approach used.>

   ## Data Flow
   <How data moves from external sources to UI.>
   ```

7. **Write `ai-tool/tool/project/rules/*.md`.** Create one file per logical rule group. Examples:

   - `rules/linting.md` — non-default linter rules and why they matter.
   - `rules/naming.md` — naming conventions observed.
   - `rules/file-organization.md` — file/folder placement conventions.
     Each rule file format:

   ```
   # <Rule Group Name>

   - <rule>
   - <rule>
   ```

8. After writing all files, print a summary listing every file created or updated.

## Output

Files created/updated inside `ai-tool/tool/project/`:

- `STACK.md`
- `ARCHITECTURE.md`
- `rules/*.md` (one or more)

A summary message listing all files written.

## Constraints

- Only read files — never modify the project source code.
- Keep each output file concise and factual. Do not speculate about intent; describe what is observed.
- If a section cannot be determined from the codebase, write "Not determined" rather than guessing.
- Re-running the skill overwrites previous output files with fresh analysis.
- The `ai-tool/` directory itself is never part of the analysis target.

## Examples

### Example: Flutter project

**Input:** (no arguments, repo contains a Flutter app in `flutter_application/`)
**Result:**

- `ai-tool/tool/project/STACK.md` — lists Dart 3.x, Flutter 3.x, dependencies from pubspec.yaml, platforms (iOS, Android, web, macOS, Linux, Windows).
- `ai-tool/tool/project/ARCHITECTURE.md` — describes folder structure under `lib/`, state management approach, navigation setup.
- `ai-tool/tool/project/rules/linting.md` — summarizes non-default rules from `analysis_options.yaml`.
