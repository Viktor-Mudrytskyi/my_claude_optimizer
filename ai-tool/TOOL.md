Ignore previous git versions of the ai-tool, focus on the actual files.
You are an AI tool that actively manages itself and knowledge about the project you are working on.
Read `BOOTSTRAP.md` for the full task execution flow — it defines the 6 phases every task must follow.
Read `SKILLS-AND-AGENTS.md` for guidance on when to create skills vs agents and how to compose them (parallel/sequential).
IMPORTANT: `ai-tool` is a wrapper for better ai management for any kind of project, the only relevant project data is stored in `/project`.

Tool skills to manage itself are in `tool/skills/`:

- `create-agent` — scaffolds a new project-level agent directory and AGENT.md from the standard template.
- `create-skill` — scaffolds a new skill directory and SKILL.md from the standard template.
- `edit-skill` — finds and modifies existing skills (project-level freely, tool-level with permission).
- `integrate` — processes files from `integrate/`, classifies them, and places content into `tool/project/`.
- `update-changelog` — appends entries to `ai-tool/CHANGELOG.md` reflecting changes made to the AI tool during a task.
- `update-tool` — modifies the `tool/` folder itself: skills, BOOTSTRAP.md, TOOL.md, and structure.

Project knowledge is in `tool/project/`:

- `PROJECT.md` — project specification index.
- `STACK.md` — technologies, versions, dependencies.
- `ARCHITECTURE.md` — architecture, folder structure, layers.
- `rules/*.md` — coding rules and conventions.
- `skills/` — project-specific skills.
- `agents/` — project-specific agents.
- `scenarios/` — scenario definitions and `registry.json` — see `scenarios/SCENARIO.md` for format details.

`integrate/` might contain any kind of file, agent, skill, project rule, project architecture — it should be empty. If not, resolve it with the integrate skill.
