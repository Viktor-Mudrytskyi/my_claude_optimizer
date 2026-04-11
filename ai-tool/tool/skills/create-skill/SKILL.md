---
name: create-skill
description: Creates a new skill by scaffolding its directory and SKILL.md from the standard template.
---

## Behavior

1. Determine the skill name and description from the user. If not provided, ask.
2. Create directory `ai-tool/tool/skills/<skill-name>/`.
3. Copy `TEMPLATE.md` into that directory as `SKILL.md`.
4. Fill in the frontmatter `name` and `description` fields.
5. Fill in all sections based on the user's requirements.
6. Add any supporting files alongside SKILL.md if needed.

## Rules

- Skill names are lowercase kebab-case.
- Each skill gets its own directory under `ai-tool/tool/skills/`.
- Every skill MUST have a `SKILL.md`. No SKILL.md = not a valid skill.
- SKILL.md MUST follow the structure defined in `TEMPLATE.md` exactly.
- SKILL.md must be self-contained — an AI agent must be able to execute the skill by reading only its SKILL.md.
