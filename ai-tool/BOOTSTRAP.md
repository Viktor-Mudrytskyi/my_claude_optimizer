# Bootstrap — Task Execution Flow

This document defines the end-to-end flow that AI must follow when completing any task. Every task goes through these phases in order.

---

## Phase 1: Load Project Context

Before doing any work, determine what project knowledge is needed for the task.

1. Read `tool/project/PROJECT.md` to understand the project index.
2. Based on the task, load the relevant specs:
   - `tool/project/STACK.md` — if the task involves technology choices or version-specific behavior.
   - `tool/project/ARCHITECTURE.md` — if the task involves structural decisions or file placement.
   - `tool/project/rules/*.md` — if the task involves writing or modifying code.
   - `tool/project/skills/*.md` — if a project-specific skill applies.
3. Load only what the task requires. Do not load everything by default.

---

## Phase 2: Match or Create a Scenario

Every task must map to a scenario — a predefined step-by-step sequence.

1. Read `tool/scenarios/registry.json`.
2. Match the task against scenario keywords.
   - **Match found** — load the scenario `.md` file from `tool/scenarios/` and proceed to Phase 3.
   - **No match** — create a new scenario:
     1. Break the task into a sequence of discrete steps (skills, agents, actions).
     2. Write a new scenario `.md` file in `tool/scenarios/` following the format in `tool/scenarios/SCENARIO.md`.
     3. Register it in `tool/scenarios/registry.json` with relevant keywords.
     4. Proceed to Phase 3 with the new scenario.

---

## Phase 3: Prepare Skills and Agents

The scenario's sequence references skills and agents. Ensure they all exist before execution.

1. For each step in the scenario, check if the required skill or agent exists:
   - Tool-level skills live in `tool/skills/`.
   - Project-level skills live in `tool/project/skills/`.
   - Project-level agents live in `tool/project/agents/`.
2. If a required skill or agent does not exist, create it and only then get to the task itslef:
   - Use `tool/skills/create-skill` to scaffold new skills.
   - Place project-specific skills in `tool/project/skills/`.
   - Place project-specific agents in `tool/project/agents/`.
3. Once all skills and agents are confirmed available, proceed to Phase 4.

---

## Phase 4: Execute the Scenario

Run the scenario sequence efficiently.

1. Walk through the scenario steps in order.
2. Where steps are independent of each other, launch agents in parallel to save time.
3. Where steps depend on prior output, execute them sequentially.
4. Handle loop conditions defined in the scenario — if a step fails and the scenario specifies a retry, go back to the indicated step.
5. Continue until the scenario reaches its finish step.

---

## Phase 5: Self-Update

After the task is complete, check whether the work changed the project in ways that require updating the AI tool's own knowledge.

1. Review what was changed during the task.
2. Determine if any of the following need updating:
   - `tool/project/ARCHITECTURE.md` — if new modules, layers, or structural patterns were introduced.
   - `tool/project/STACK.md` — if new dependencies or technologies were added.
   - `tool/project/rules/*.md` — if the task revealed or established new coding rules.
   - `tool/project/skills/*.md` — if an existing skill's behavior should change based on what was learned.
   - `tool/scenarios/` — if the scenario used should be refined based on how execution went.
   - `tool/skills/`, `BOOTSTRAP.md`, or `TOOL.md` — if the task revealed improvements to the AI tool's own operating flow or capabilities. Use the `update-tool` skill for these changes.
3. Apply the necessary updates so future tasks benefit from what was learned.
4. **Update the changelog.** If any files inside `ai-tool/` were created, modified, or deleted during the task, run the `update-changelog` skill to log those changes in `ai-tool/CHANGELOG.md`.
5. If nothing needs updating and no ai-tool files changed, skip this phase.
