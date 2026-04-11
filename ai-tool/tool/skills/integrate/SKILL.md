---
name: integrate
description: Processes files from ai-tool/integrate/, classifies them, places content into ai-tool/tool/project/, merges similar documents, and cleans up.
---

## Inputs

| Name | Required | Description                                                                |
| ---- | -------- | -------------------------------------------------------------------------- |
| —    | —        | No inputs. The skill reads all files found in `ai-tool/integrate/` folder. |

## Behavior

1. **Scan** `ai-tool/integrate/` for all files (any depth). If the folder is empty, report "Nothing to integrate" and stop.

2. **For each file**, read it and classify it into one of the following categories:

   | Category         | Target location                                        | How to detect                                                                                                                                          |
   | ---------------- | ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
   | **Skill**        | `ai-tool/tool/project/skills/<name>/SKILL.md`          | Has SKILL.md-style frontmatter (`name`, `description`) and sections like `## Behavior`, `## Output`, or the user explicitly names the file as a skill. |
   | **Rule**         | `ai-tool/tool/project/rules/<name>.md`                 | Content describes coding conventions, linting overrides, naming rules, or style guidelines.                                                            |
   | **Architecture** | `ai-tool/tool/project/ARCHITECTURE.md`                 | Content describes layers, patterns, folder structure, state management, navigation, or data flow for the project.                                      |
   | **Stack**        | `ai-tool/tool/project/STACK.md`                        | Content describes languages, frameworks, dependencies, platforms, or build tooling.                                                                    |
   | **Project info** | `ai-tool/tool/project/PROJECT.md` or a sub-file        | Content describes project-level information that does not fit the other categories (e.g. roadmap, team conventions, environment setup).                 |
   | **Unknown**      | —                                                      | Cannot confidently classify.                                                                                                                           |

3. **Determine intent.** Check whether the file contains an explicit instruction about what to do with its content. Look for directives like:
   - "Add this rule …"
   - "Create a skill that …"
   - "Update architecture to …"
   - "Replace the stack section …"

   If no explicit instruction is found, **ask the user** what to do with the file before proceeding. Present the file name, a brief content summary, and the detected category as context.

4. **Check for merge candidates.** Before placing content, scan existing files in `ai-tool/tool/project/` for documents or skills that cover a similar topic. If a merge candidate is found:
   - Present both files (existing and incoming) with a brief summary of each.
   - **Ask the user** whether to merge them into one file or keep them separate.
   - If merging, combine the content intelligently — deduplicate, unify structure, keep the best of both.

5. **Place the content.**
   - **Skill** — Validate that the content follows the SKILL.md template structure (see `ai-tool/tool/skills/create-skill/TEMPLATE.md`). If it does not, reshape it to match the template before writing, preserving the original intent. Write to `ai-tool/tool/project/skills/<name>/SKILL.md`. Supporting files (references, examples) go alongside in the same skill directory.
   - **Rule** — Derive a kebab-case file name from the rule topic. If a rule file on the same topic already exists, merge the new rules into it rather than overwriting.
   - **Architecture / Stack / Project info** — If the target file already exists, merge the new content into the existing file intelligently (update or add sections, do not duplicate). If it does not exist, create it.
   - **Unknown** — Skip and report; do not write anything.

6. **Enforce the 150-line limit.** After writing or merging any file, check its line count. If a file exceeds 150 lines:
   - Split it into logical sub-files (e.g. by section or topic).
   - Create an index file that references the sub-files.
   - Each resulting file must be ≤150 lines.

7. **Delete the processed file** from `ai-tool/integrate/` after it has been successfully placed. Leave unknown/skipped files in place.

8. **Report** a summary listing each file processed, its detected category, where it was placed, and whether it was merged, created fresh, or split.

## Output

- Files created or updated inside `ai-tool/tool/project/`.
- Processed files removed from `ai-tool/integrate/`.
- A summary message listing all actions taken.

## Constraints

- All output goes into `ai-tool/tool/project/` — never write outside this directory (except deleting from `ai-tool/integrate/`).
- Never modify the project source code.
- No file may exceed **150 lines**. Split if necessary.
- When merging into an existing file, preserve all existing content that is still valid — only add or update, never silently remove sections.
- Always **ask before merging** similar documents or skills. Never auto-merge.
- Skills must conform to the TEMPLATE.md structure. Reshape if needed but never lose intent.
- If classification is ambiguous and no explicit instruction is present, always ask the user rather than guessing.
- File names in target locations use kebab-case.
- Process files one at a time in alphabetical order for predictable results.

## Examples

### Example: Merging similar skills

**Incoming:** `ai-tool/integrate/flutter-bloc-patterns.md` (skill about Cubit/BLoC usage)
**Existing:** `ai-tool/tool/project/skills/flutter-clean-architecture/SKILL.md` (already covers Cubit patterns)

**Result:**

- Detected as **Skill**. Found merge candidate: `flutter-clean-architecture`.
- Asked user: "Incoming `flutter-bloc-patterns` overlaps with existing `flutter-clean-architecture` (both cover Cubit patterns). Merge into one skill or keep separate?"
- If merge: combined into `flutter-clean-architecture/SKILL.md`, checked line limit, split references into sub-files if needed.

### Example: File exceeding 150 lines after merge

**Incoming:** `ai-tool/integrate/data-layer-rules.md` (80 lines of data layer rules)
**Existing:** `ai-tool/tool/project/rules/critical-rules.md` (90 lines)

**Result:**

- Merged content totals 160 lines — exceeds 150-line limit.
- Split into `rules/critical-rules.md` (general rules) and `rules/data-layer-rules.md` (data-specific rules).
- Both files ≤150 lines.

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
