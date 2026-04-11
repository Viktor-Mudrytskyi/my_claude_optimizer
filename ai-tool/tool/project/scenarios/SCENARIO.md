# Scenarios

## Purpose

Scenarios are pre-defined instruction sequences that streamline recurring tasks. Instead of spending tokens analyzing what steps to take each time, a scenario provides the exact sequence upfront.

## Why

Every task can be broken down into a chain of single processes executed sequentially. Without scenarios, the model re-derives this chain from scratch each time — wasting tokens and risking inconsistency. Scenarios encode proven sequences so execution is direct and repeatable.

## Structure

- All scenarios live in `scenarios/`.
- Each scenario is a `.md` file describing one task type.
- `scenarios/registry.json` is the index — it maps keywords to scenarios so the right one can be selected quickly based on the user's request.

### Scenario file format

```markdown
---
name: <scenario-name>
description: <One-line summary of when to use this scenario.>
---

## Trigger

<Keywords or patterns that indicate this scenario applies.>

## Sequence

1. <Step 1 — which skill/agent to invoke and with what input>
2. <Step 2>
3. ...
n. Finish.

## Loop conditions

<If any step can fail and should retry an earlier step, describe the condition here.>

## Notes

<Edge cases, prerequisites, or constraints.>
```

### registry.json format

```json
[
  {
    "name": "<scenario-name>",
    "file": "<filename>.md",
    "keywords": ["keyword1", "keyword2", "..."],
    "description": "<One-line summary>"
  }
]
```

## Example

**Task:** "Fix bug in login screen"

**Scenario sequence:**
1. Launch discover agent to find related files.
2. Using `flutter-dev` skill, implement the fix.
3. Using `flutter-review` skill, review the changes.
4. If review fails — go back to step 2.
5. Finish.

## How to use

1. Match the user's request against `registry.json` keywords.
2. Load the matched scenario file.
3. Execute the sequence step by step.
4. Handle loop conditions if a step signals failure.
