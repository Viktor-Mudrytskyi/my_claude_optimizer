# Skills and Agents — When to Use What

This document explains when to create skills vs agents, and how to compose them effectively in scenarios.

---

## Skills vs Agents

| Aspect            | Skill                                                       | Agent                                                              |
| ----------------- | ----------------------------------------------------------- | ------------------------------------------------------------------ |
| **What it is**    | A reusable instruction set — a "how to" recipe              | An autonomous worker that executes a goal independently            |
| **Runs as**       | Instructions followed by the main AI in the current context | A separate AI instance with its own context                        |
| **Context**       | Shares the main conversation context                        | Isolated — only sees what you pass to it                           |
| **Best for**      | Deterministic, repeatable procedures                        | Exploratory, open-ended, or parallelizable work                    |
| **Creates files** | Usually yes — code, config, docs                            | May or may not — can return findings instead                       |
| **Examples**      | "How to scaffold a feature module", "How to register DI"    | "Find all files related to authentication", "Review these changes" |

### Create a skill when

- The task follows a **fixed sequence** of steps that rarely changes.
- The output is **predictable** — you know what files or changes will result.
- Multiple scenarios will **reuse** the same procedure.
- The instructions need to encode **project rules** so they're applied consistently.
- You want the main AI to execute it inline, with full conversation context.

### Create an agent when

- The task requires **exploration** — searching, reading, analyzing unknown code.
- The work is **independent** and doesn't need the main conversation context.
- You want to **parallelize** — agents can run simultaneously on separate tasks.
- The task produces **findings or data** that the main AI will use to make decisions.
- The scope is **bounded** — the agent has a clear goal and a clear end state.

### When neither is needed

- If the task is a one-off that won't recur, just execute it directly — no skill or agent required.
- If the task is trivial (rename a variable, fix a typo), creating a skill or agent adds overhead with no benefit.

---

## Parallel vs Sequential Execution

### Run agents in parallel when

- Their work is **independent** — no agent needs another agent's output to start.
- They operate on **different files or areas** of the codebase.
- The combined results will be **merged** at the end, not fed into each other.

**Example — parallel:**

```
1. Launch discover agent → find auth-related files
2. Launch discover agent → find database-related files    (parallel with step 1)
3. Merge findings from both agents
4. Implement changes using project skill
```

### Run agents sequentially when

- A later agent **depends on** an earlier agent's output.
- The work must happen in a **specific order** (e.g. generate code, then review it).
- One agent's findings **determine** what the next agent should do.

**Example — sequential:**

```
1. Launch discover agent → find related files
2. Implement changes using project skill          (needs step 1 output)
3. Launch review agent → check the changes        (needs step 2 output)
4. If review fails → go back to step 2
```

### Mixed parallel and sequential

Most real scenarios combine both. Group independent steps together, then gate on their combined output before the next phase.

**Example — mixed:**

```
1. Launch discover agent → find related files
2. Launch discover agent → find test files          (parallel with step 1)
3. Implement feature using project skill            (needs step 1 + 2)
4. Launch test agent → run tests                    (needs step 3)
5. Launch review agent → review changes             (parallel with step 4)
6. If step 4 or 5 fails → go back to step 3
```

---

## Writing Good Scenarios

When composing skills and agents in a scenario:

1. **Start with discovery** — if the task touches existing code, launch an agent to find relevant files first.
2. **Group independent work** — identify which steps can run in parallel and mark them.
3. **Gate on dependencies** — sequential steps should explicitly state what prior output they need.
4. **Add loop conditions** — if a step can fail (review, tests, analysis), define what step to retry from.
5. **End with verification** — Phase 5 of BOOTSTRAP handles rule verification, but scenarios can add domain-specific checks.
