---
name: create-agent
description: Creates a new project-level agent by scaffolding its directory and AGENT.md from the standard template.
---

## Inputs

| Name        | Required | Description                                                            |
| ----------- | -------- | ---------------------------------------------------------------------- |
| name        | yes      | Agent name in kebab-case.                                              |
| description | yes      | One-line description of what the agent does.                           |
| purpose     | yes      | What the agent is responsible for and when it should be invoked.       |

## Behavior

1. Determine the agent name, description, and purpose from the user. If not provided, ask.
2. Create directory `ai-tool/tool/project/agents/<agent-name>/`.
3. Copy `TEMPLATE.md` into that directory as `AGENT.md`.
4. Fill in the frontmatter `name` and `description` fields.
5. Fill in all sections based on the user's requirements:
   - **Purpose** — when and why scenarios should invoke this agent.
   - **Inputs** — what data the agent needs to start.
   - **Behavior** — step-by-step instructions the agent follows.
   - **Output** — what it returns (findings, files, structured data).
   - **Constraints** — rules the agent must respect.
6. Add any supporting files alongside AGENT.md if needed (reference docs, examples).

## Output

- A new directory at `ai-tool/tool/project/agents/<agent-name>/` containing `AGENT.md`.
- A confirmation message with the agent name and location.

## Constraints

- Agent names are lowercase kebab-case.
- Each agent gets its own directory under `ai-tool/tool/project/agents/`.
- Every agent MUST have an `AGENT.md`. No AGENT.md = not a valid agent.
- AGENT.md MUST follow the structure defined in `TEMPLATE.md` exactly.
- AGENT.md must be self-contained — the AI must be able to execute the agent by reading only its AGENT.md.
- Agents are project-level by default and live in `tool/project/agents/`, not `tool/skills/`.
- No file may exceed **150 lines**. Split supporting content into separate files if needed.

## Examples

### Example: Creating a discover agent

**Input:** name=`discover`, description="Finds files related to a task by scanning the codebase"

**Result:**

- Created `ai-tool/tool/project/agents/discover/AGENT.md`.
- Frontmatter: `name: discover`, `description: Finds files related to a task by scanning the codebase`.
- Purpose, Behavior, Output, and Constraints filled in based on user requirements.
- Reported: created 1 file at `ai-tool/tool/project/agents/discover/AGENT.md`.

### Example: Creating a review agent

**Input:** name=`code-review`, description="Reviews code changes for quality, style, and correctness"

**Result:**

- Created `ai-tool/tool/project/agents/code-review/AGENT.md`.
- All sections populated. Constraints include "never modify source code, only report findings".
- Reported: created 1 file.
