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

**MANDATORY GATE — do NOT skip to execution.** Every task must map to a scenario before any work begins.

1. Read `tool/project/scenarios/registry.json`.
2. Match the task against scenario keywords.
   - **Match found** — load the scenario `.md` file from `tool/project/scenarios/` and proceed to Phase 3.
   - **No match** — you MUST create a new scenario before proceeding:
     1. Break the task into a sequence of discrete steps. Each step must name a specific skill or agent that performs it.
     2. Write a new scenario `.md` file in `tool/project/scenarios/` following the format in `tool/project/scenarios/SCENARIO.md`.
     3. Register it in `tool/project/scenarios/registry.json` with relevant keywords.
     4. Proceed to Phase 3 with the new scenario.

**You must have a scenario loaded before moving to Phase 3. Executing a task without a scenario is not allowed.**

---

## Phase 3: Prepare Skills and Agents

**MANDATORY GATE — do NOT skip to execution.** Every skill and agent referenced in the scenario must exist before you start Phase 4. See `SKILLS-AND-AGENTS.md` for guidance on when to create a skill vs an agent and how to compose them.

1. Extract the list of every skill and agent name referenced in the scenario's Sequence section.
2. For each one, check if it exists:
   - Tool-level skills: `tool/skills/<name>/SKILL.md`
   - Project-level skills: `tool/project/skills/<name>/SKILL.md`
   - Project-level agents: `tool/project/agents/<name>/AGENT.md`
3. If a required skill or agent does NOT exist, you MUST create it before proceeding:
   - Use `tool/skills/create-skill` to scaffold new skills. The skill must contain concrete instructions derived from the project rules and architecture — not a generic placeholder.
   - Use `tool/skills/create-agent` to scaffold new agents.
   - Place project-specific skills in `tool/project/skills/`.
   - Place project-specific agents in `tool/project/agents/`.
4. After creation, re-read the scenario and verify every referenced skill/agent now has a file. Only then proceed to Phase 4.

**You must have all skills and agents ready before executing. Starting Phase 4 with missing skills/agents is not allowed.**

---

## Phase 4: Execute the Scenario

Run the scenario sequence efficiently. See `SKILLS-AND-AGENTS.md` for parallel vs sequential execution patterns.

1. Walk through the scenario steps in order.
2. Where steps are independent of each other, launch agents in parallel to save time.
3. Where steps depend on prior output, execute them sequentially.
4. Handle loop conditions defined in the scenario — if a step fails and the scenario specifies a retry, go back to the indicated step.
5. Continue until the scenario reaches its finish step.

---

## Phase 5: Verify Changes

After execution is complete, verify that all changes comply with the project rules and architecture.

1. Load all rules from `tool/project/rules/*.md`.
2. Review every file created or modified during Phase 4.
3. Check each file against the loaded rules.
4. If any rule violation or analysis issue is found — fix it immediately, then re-run this phase.
5. Only proceed to Phase 6 when all checks pass.

**You must not skip this phase. Moving to Phase 6 with known rule violations is not allowed.**

---

## Phase 6: Self-Update

After the task is complete, check whether the work changed the project in ways that require updating the AI tool's own knowledge.

1. Review what was changed during the task.
2. Determine if any of the following need updating:
   - `tool/project/ARCHITECTURE.md` — if new modules, layers, or structural patterns were introduced.
   - `tool/project/STACK.md` — if new dependencies or technologies were added.
   - `tool/project/rules/*.md` — if the task revealed or established new coding rules.
   - `tool/project/skills/*.md` — if an existing skill's behavior should change based on what was learned.
   - `tool/project/scenarios/` — if the scenario used should be refined based on how execution went.
   - `tool/skills/`, `BOOTSTRAP.md`, or `TOOL.md` — if the task revealed improvements to the AI tool's own operating flow or capabilities. Use the `update-tool` skill for these changes.
3. Apply the necessary updates so future tasks benefit from what was learned.
4. **Update the changelog.** If any files inside `ai-tool/` were created, modified, or deleted during the task, run the `update-changelog` skill to log those changes in `ai-tool/CHANGELOG.md`.
5. If nothing needs updating and no ai-tool files changed, skip this phase.
