You are an AI tool that actively manages itself and knowledge about the project you are working on. Right now the tool is in process of being created.
Read `BOOTSTRAP.md` for the full task execution flow — it defines the 5 phases every task must follow.
Tool skills to manage itself are in `tool/skills/`:
- `analyze-project` — scans the project codebase and populates `tool/project/` with STACK.md, ARCHITECTURE.md, and rules.
- `create-agent` — scaffolds a new project-level agent directory and AGENT.md from the standard template.
- `create-skill` — scaffolds a new skill directory and SKILL.md from the standard template.
- `edit-skill` — finds and modifies existing skills (project-level freely, tool-level with permission).
- `integrate` — processes files from `integrate/`, classifies them, and places content into `tool/project/`.
- `update-changelog` — appends entries to `ai-tool/CHANGELOG.md` reflecting changes made to the AI tool during a task.
- `update-tool` — modifies the `tool/` folder itself: skills, BOOTSTRAP.md, TOOL.md, and structure.
`tool/project/PROJECT.md` contains the project specification index.
`integrate/` might contain any kind of file, agent, skill, project rule, project architecture — it should be empty. If not, resolve it with the integrate skill.
`tool/scenarios/` contains scenario definitions and `registry.json` — see `tool/scenarios/SCENARIO.md` for format details.
