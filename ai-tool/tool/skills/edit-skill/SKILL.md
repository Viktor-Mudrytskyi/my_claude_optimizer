---
name: edit-skill
description: Finds and modifies existing skills based on a user request. Freely edits project skills, asks permission before touching tool skills.
---

## Inputs

| Name    | Required | Description                                                        |
| ------- | -------- | ------------------------------------------------------------------ |
| request | yes      | The user's description of what they want changed in which skill(s) |

## Behavior

1. **Parse the request.** Understand what the user wants changed — it may be a content update, structural fix, rename, split, merge, or deletion.

2. **Find affected skills.** Scan both skill locations for candidates:
   - `ai-tool/tool/project/skills/` — project-level skills
   - `ai-tool/tool/skills/` — tool-level skills

   Read each `SKILL.md` and compare its name, description, and content against the user's request. Build a list of skills that need changes.

3. **Present findings.** Before making any edits, show the user:
   - Which skill(s) were identified as needing changes.
   - What specific changes would be made to each.
   - Whether the skill is project-level or tool-level.

   If no matching skills are found, report that and stop.

4. **Apply changes based on skill location.**

   | Location                         | Permission       |
   | -------------------------------- | ---------------- |
   | `ai-tool/tool/project/skills/`   | Edit directly    |
   | `ai-tool/tool/skills/`           | **Ask the user** before every edit — these are tool-level skills that affect how the AI tool itself operates |

5. **Edit the skill.** Make the requested changes while preserving:
   - SKILL.md template structure (frontmatter, Inputs, Behavior, Output, Constraints, Examples).
   - Existing content not affected by the change.
   - Supporting files (references, examples) — update if affected, leave alone if not.

6. **Enforce the 150-line limit.** If an edit causes a file to exceed 150 lines, split it into logical sub-files.

7. **Report** what was changed, in which files, and whether anything was split.

## Output

- Modified skill files inside `ai-tool/tool/project/skills/` or `ai-tool/tool/skills/`.
- A summary of all changes made.

## Constraints

- Never modify files outside of the two skill directories.
- Never modify the project source code.
- Always present identified skills and proposed changes before editing.
- Always **ask permission** before modifying any skill in `ai-tool/tool/skills/`.
- Edits to `ai-tool/tool/project/skills/` can proceed without extra confirmation.
- Preserve SKILL.md template structure — do not break the format.
- No file may exceed **150 lines**. Split if necessary.
- If the request is ambiguous about which skill to edit, list candidates and ask the user to clarify.

## Examples

### Example: Updating a project skill

**Request:** "Add a constraint to flutter-clean-architecture that entities must have documentation comments"

**Result:**

- Found `ai-tool/tool/project/skills/flutter-clean-architecture/SKILL.md` — project-level skill.
- Proposed change: add `- All entity classes must have documentation comments (///) on the class and public fields.` to the relevant section.
- Applied directly. Reported change.

### Example: Modifying a tool skill

**Request:** "Change integrate to also handle pattern files"

**Result:**

- Found `ai-tool/tool/skills/integrate/SKILL.md` — tool-level skill.
- Proposed change: add **Pattern** row to the classification table with target `ai-tool/tool/project/patterns/<name>.md`.
- Asked user: "This modifies `integrate`, a tool-level skill. Proceed with adding Pattern category?"
- Applied only after user confirmation.

### Example: Ambiguous request

**Request:** "Update the cubit section"

**Result:**

- Found two candidates:
  1. `ai-tool/tool/project/skills/flutter-clean-architecture/SKILL.md` — has a Cubit section
  2. `ai-tool/tool/project/skills/flutter-clean-architecture/references/CUBIT_PATTERN.md` — dedicated Cubit reference
- Asked user: "Which file should I update — the main skill or the Cubit reference? And what specifically should change?"
