# AI Tool Changelog

## 2026-04-11 (7)

### Added

- `SKILLS-AND-AGENTS.md` — guide on when to create skills vs agents, parallel vs sequential execution patterns, and scenario composition.

### Changed

- `BOOTSTRAP.md` — Phase 3 and Phase 4 now reference `SKILLS-AND-AGENTS.md` for guidance.
- `TOOL.md` — added `SKILLS-AND-AGENTS.md` to the top-level reading list.

---

## 2026-04-11 (6)

### Changed

- `TOOL.md` — updated phase count to 6, removed nonexistent `analyze-project` skill, added `tool/project/` section listing all project knowledge directories.
- `tool/project/PROJECT.md` — added `skills/`, `agents/`, and `scenarios/` entries, clarified descriptions.

---

## 2026-04-11 (5)

### Changed

- `tool/skills/update-tool/SKILL.md` — replaced hardcoded "5 phases" with "all phases" to stay version-independent.
- `tool/skills/integrate/SKILL.md` — replaced Flutter-specific examples with project-agnostic ones (api-client, ORM references).
- `tool/skills/edit-skill/SKILL.md` — replaced Flutter-specific examples with project-agnostic ones (api-client, error-handling references).

---

## 2026-04-11 (4)

### Changed

- `BOOTSTRAP.md` — added Phase 5 (Verify Changes) between execution and self-update. Loads all project rules and checks every modified file for violations before proceeding. Old Phase 5 (Self-Update) renumbered to Phase 6.

---

## 2026-04-11 (3)

### Added

- `tool/project/scenarios/add-infrastructure.md` — scenario for adding cross-cutting infrastructure (routing, DI, networking).

### Updated

- `tool/project/scenarios/registry.json` — registered `add-infrastructure` scenario.
- `tool/project/STACK.md` — added go_router ^15.1.2 dependency.
- `tool/project/ARCHITECTURE.md` — added `core/routing/` to folder structure.

---

## 2026-04-11 (2)

### Added

- `tool/project/scenarios/create-feature-screen.md` — scenario for scaffolding new feature screens with Clean Architecture.
- First entry in `tool/project/scenarios/registry.json`.

### Updated

- `tool/project/STACK.md` — added equatable, flutter_bloc, dartz dependencies.
- `tool/project/rules/file-organization.md` — updated to reflect `lib/core/` and `lib/features/` structure.

---

## 2026-04-11

### Added

- `update-tool` skill — modifies the tool folder itself (skills, BOOTSTRAP.md, TOOL.md, structure)
- `create-agent` skill with AGENT.md template
- `update-changelog` skill — logs changes to the AI tool after each task
- Tool-level skill index in TOOL.md

### Changed

- BOOTSTRAP.md Phase 5 — added bullet for tool self-updates via `update-tool` skill
- BOOTSTRAP.md Phase 5 — added changelog update step
- TOOL.md — added `create-agent` to skill index
