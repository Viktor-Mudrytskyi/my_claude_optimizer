---
name: update-changelog
description: Appends an entry to ai-tool/CHANGELOG.md reflecting changes made to the AI tool itself during the current task.
---

## Inputs

| Name    | Required | Description                                                                                      |
| ------- | -------- | ------------------------------------------------------------------------------------------------ |
| changes | yes      | A list of what changed in the ai-tool folder during the task (files created, modified, deleted).  |

## Behavior

1. **Read `ai-tool/CHANGELOG.md`.** If it does not exist, create it with the header structure shown below.

2. **Determine the current date** from system context.

3. **Check for an existing section** with today's date.
   - If a section for today exists, append new entries under it.
   - If not, create a new date section at the top of the log (below the header).

4. **Classify each change** into one of these categories:
   - **Added** — new skills, agents, scenarios, rules, or files.
   - **Changed** — modifications to existing skills, agents, scenarios, rules, BOOTSTRAP.md, or TOOL.md.
   - **Removed** — deleted skills, agents, scenarios, rules, or files.

5. **Write entries.** Each entry is a single bullet under its category. Keep entries concise — one line per change, describing *what* changed, not *why*.

6. **Save** the updated `ai-tool/CHANGELOG.md`.

## Format

```markdown
# AI Tool Changelog

## YYYY-MM-DD

### Added
- <entry>

### Changed
- <entry>

### Removed
- <entry>
```

- Omit empty categories (e.g. if nothing was removed, skip the `### Removed` section).
- Date sections are in reverse chronological order (newest first).

## Output

- Updated `ai-tool/CHANGELOG.md` with new entries.
- A brief confirmation of what was logged.

## Constraints

- Only log changes to `ai-tool/` contents — never log project source code changes.
- One bullet per change. No multi-line entries.
- Do not duplicate entries — if the same change is already logged under today's date, skip it.
- Do not rewrite or remove existing entries. The changelog is append-only.
- No file may exceed **150 lines**. If the changelog grows past 150 lines, archive older entries into `ai-tool/CHANGELOG-archive.md` and keep only the most recent entries in `CHANGELOG.md`.

## Examples

### Example: New skill added

**Input:** changes=["Created tool/skills/create-agent/SKILL.md", "Created tool/skills/create-agent/TEMPLATE.md"]

**Result:**

```markdown
## 2026-04-11

### Added
- `create-agent` skill with AGENT.md template
```

### Example: Multiple change types

**Input:** changes=["Modified BOOTSTRAP.md Phase 5", "Created tool/skills/update-changelog/SKILL.md", "Deleted tool/project/rules/old-rule.md"]

**Result:**

```markdown
## 2026-04-11

### Added
- `update-changelog` skill

### Changed
- BOOTSTRAP.md Phase 5 — added changelog update step

### Removed
- `tool/project/rules/old-rule.md`
```
