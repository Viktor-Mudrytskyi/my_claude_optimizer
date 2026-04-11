---
name: integrate
description: Processes files from ai-tool/integrate/, classifies them, moves content to the correct location in ai-tool/tool/, and cleans up.
---

## Inputs

| Name | Required | Description                                                                |
| ---- | -------- | -------------------------------------------------------------------------- |
| —    | —        | No inputs. The skill reads all files found in `ai-tool/integrate/` folder. |

## Behavior

1. **Scan** `ai-tool/integrate/` for all files (any depth). If the folder is empty, report "Nothing to integrate" and stop.

2. **For each file**, read it and classify it into one of the following categories:

   | Category         | Target location                                 | How to detect                                                                                                                                          |
   | ---------------- | ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
   | **Skill**        | `ai-tool/tool/skills/<name>/SKILL.md`           | Has SKILL.md-style frontmatter (`name`, `description`) and sections like `## Behavior`, `## Output`, or the user explicitly names the file as a skill. |
   | **Rule**         | `ai-tool/tool/project/rules/<name>.md`          | Content describes coding conventions, linting overrides, naming rules, or style guidelines.                                                            |
   | **Architecture** | `ai-tool/tool/project/ARCHITECTURE.md`          | Content describes layers, patterns, folder structure, state management, navigation, or data flow for the project.                                      |
   | **Stack**        | `ai-tool/tool/project/STACK.md`                 | Content describes languages, frameworks, dependencies, platforms, or build tooling.                                                                    |
   | **Project info** | `ai-tool/tool/project/PROJECT.md` or a sub-file | Content describes project-level information that does not fit the other categories (e.g. roadmap, team conventions, environment setup).                |
   | **Unknown**      | —                                               | Cannot confidently classify.                                                                                                                           |

3. **Determine intent.** Check whether the file contains an explicit instruction about what to do with its content. Look for directives like:
   - "Add this rule …"
   - "Create a skill that …"
   - "Update architecture to …"
   - "Replace the stack section …"

   If no explicit instruction is found, **ask the user** what to do with the file before proceeding. Present the file name, a brief content summary, and the detected category as context.

4. **Place the content.**
   - **Skill** — Validate that the content follows the SKILL.md template structure (see `ai-tool/tool/skills/create-skill/TEMPLATE.md`). If it does, write it to `ai-tool/tool/skills/<name>/SKILL.md`. If it does not, reshape it to match the template before writing, preserving the original intent.
   - **Rule** — Derive a kebab-case file name from the rule topic. If a rule file on the same topic already exists, merge the new rules into it rather than overwriting.
   - **Architecture / Stack / Project info** — If the target file already exists, merge the new content into the existing file intelligently (update or add sections, do not duplicate). If it does not exist, create it.
   - **Unknown** — Skip and report; do not write anything.

5. **Delete the processed file** from `ai-tool/integrate/` after it has been successfully placed. Leave unknown/skipped files in place.

6. **Report** a summary listing each file processed, its detected category, where it was placed, and whether it was merged or created fresh.

## Output

- Files created or updated inside `ai-tool/tool/`.
- Processed files removed from `ai-tool/integrate/`.
- A summary message listing all actions taken.

## Constraints

- Never modify files outside of `ai-tool/tool/` (except deleting from `ai-tool/integrate/`).
- Never modify the project source code.
- When merging into an existing file, preserve all existing content that is still valid — only add or update, never silently remove sections.
- Skills must conform to the TEMPLATE.md structure. Reshape if needed but never lose intent.
- If classification is ambiguous and no explicit instruction is present, always ask the user rather than guessing.
- File names in target locations use kebab-case.
- Process files one at a time in alphabetical order for predictable results.

## Examples

### Example: A rule file with explicit instruction

**File:** `ai-tool/integrate/no-dynamic.md`

```markdown
Add this rule to the project linting rules:

- Avoid using `dynamic` type. Always specify concrete types or generics.
```

**Result:**

- Detected as **Rule** (content describes a coding convention, explicit "Add this rule" instruction).
- Merged into `ai-tool/tool/project/rules/linting.md`.
- Deleted `ai-tool/integrate/no-dynamic.md`.

### Example: A new skill definition

**File:** `ai-tool/integrate/deploy-skill.md`

```markdown
---
name: deploy
description: Builds and deploys the Flutter app to the specified target.
---

## Behavior

1. Run `flutter build` for the given platform.
2. Deploy the artifact.

## Output

Deployment result message.

## Constraints

- Only deploy to staging unless explicitly told otherwise.
```

**Result:**

- Detected as **Skill** (has SKILL.md frontmatter and structure).
- Written to `ai-tool/tool/skills/deploy/SKILL.md` (reshaped to include missing `## Inputs` and `## Examples` sections).
- Deleted `ai-tool/integrate/deploy-skill.md`.

### Example: Ambiguous file with no instruction

**File:** `ai-tool/integrate/notes.md`

```markdown
We should consider switching to Riverpod for state management.
The current approach won't scale past 10 screens.
```

**Result:**

- Detected as **Unknown** (could be architecture feedback, project info, or a personal note — no explicit instruction).
- Asked the user: "Found `notes.md` — it discusses state management concerns. Should I update ARCHITECTURE.md, add it as project info, or skip it?"
- Action depends on user response.
