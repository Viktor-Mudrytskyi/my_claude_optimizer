---
name: update-tool
description: Updates the ai-tool/tool/ folder — modifies TOOL.md, BOOTSTRAP.md, tool-level skills, and structural files based on a user request.
---

## Inputs

| Name    | Required | Description                                                                 |
| ------- | -------- | --------------------------------------------------------------------------- |
| request | yes      | The user's description of what should change in the tool folder.            |
| scope   | no       | Limits changes to a specific area: `skills`, `bootstrap`, `tool-md`, `all`. Defaults to `all`. |

## Behavior

1. **Parse the request.** Understand what the user wants changed — it may be adding a new tool-level skill, modifying an existing one, updating BOOTSTRAP.md phases, changing TOOL.md, restructuring the tool folder, or any combination.

2. **Inventory current state.** Read the relevant files to understand what exists:
   - `ai-tool/TOOL.md` — the tool's root instruction file.
   - `ai-tool/BOOTSTRAP.md` — the task execution flow (all phases).
   - `ai-tool/tool/skills/` — all tool-level skill directories and their SKILL.md files.
   - `ai-tool/tool/project/scenarios/` — scenario definitions and registry.

3. **Plan changes.** Before editing anything, produce a change plan listing:
   - Which files will be created, modified, or deleted.
   - A brief description of each change.
   - Whether any existing content will be removed or restructured.

4. **Confirm with the user.** Present the change plan and wait for approval. The tool folder is the AI's core operating system — no changes are applied without explicit user consent.

5. **Apply changes.** After approval, execute the plan:
   - **New skill** — use the `create-skill` template structure. Write to `ai-tool/tool/skills/<name>/SKILL.md`.
   - **Skill modification** — edit the existing SKILL.md in place, preserving template structure.
   - **BOOTSTRAP.md changes** — update phases, add/remove/reorder steps. Preserve the numbered-phase structure.
   - **TOOL.md changes** — update the root instruction file. Keep it concise and focused on directing the AI to BOOTSTRAP.md and the tool folder.
   - **Structural changes** — create/move/delete directories or files as needed.
   - **Skill deletion** — remove the skill's entire directory from `ai-tool/tool/skills/`.

6. **Cross-reference check.** After applying changes, verify consistency:
   - If a skill was added or renamed, check that BOOTSTRAP.md or TOOL.md references it correctly (if applicable).
   - If BOOTSTRAP.md phases changed, check that existing skills still align with the flow.
   - If a skill was deleted, check no other skill or scenario references it.

7. **Enforce the 150-line limit.** No file may exceed 150 lines. Split if necessary.

8. **Report** a summary of all changes made, files affected, and any cross-reference issues found and fixed.

## Output

- Files created, modified, or deleted inside `ai-tool/tool/` and `ai-tool/TOOL.md` / `ai-tool/BOOTSTRAP.md`.
- A summary listing every action taken.

## Constraints

- **Always confirm before applying.** The tool folder controls AI behavior — never modify it silently.
- Only modify files inside `ai-tool/tool/`, `ai-tool/TOOL.md`, and `ai-tool/BOOTSTRAP.md`. Never touch the project source code or `ai-tool/tool/project/` (that is the domain of other skills).
- Preserve the SKILL.md template structure when creating or editing skills.
- No file may exceed **150 lines**. Split if necessary.
- When deleting a skill, remove the entire directory, not just SKILL.md.
- Do not modify `ai-tool/tool/project/` contents — use `integrate`, `edit-skill`, or `analyze-project` for that.
- File and directory names use kebab-case.

## Examples

### Example: Adding a new tool-level skill

**Request:** "Add a tool skill called `validate-project` that checks project files for consistency"

**Result:**

- Change plan: create `ai-tool/tool/skills/validate-project/SKILL.md` with scaffolded content.
- User approved.
- Created the skill following TEMPLATE.md structure.
- Cross-reference check: no BOOTSTRAP.md or TOOL.md updates needed.
- Reported: created 1 file.

### Example: Updating BOOTSTRAP.md

**Request:** "Add a Phase 0 that checks for a .env file before running any task"

**Result:**

- Change plan: modify `ai-tool/BOOTSTRAP.md` — insert Phase 0 before existing Phase 1, renumber all subsequent phases.
- User approved.
- Updated BOOTSTRAP.md. All phases renumbered (1→2, 2→3, etc.).
- Cross-reference check: no skills reference phases by number — no issues.
- Reported: modified 1 file.

### Example: Restructuring tool skills

**Request:** "Merge create-skill and edit-skill into a single manage-skill"

**Result:**

- Change plan: create `ai-tool/tool/skills/manage-skill/SKILL.md` combining both behaviors, delete `create-skill/` and `edit-skill/` directories.
- User approved.
- Created `manage-skill/SKILL.md`, deleted both old directories.
- Cross-reference check: BOOTSTRAP.md Phase 3 references "create-skill" — updated to "manage-skill".
- Reported: created 1 file, deleted 2 directories, updated 1 file.
