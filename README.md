# Mistral Vibe Superpowers

A collection of skills and agents for Mistral Vibe, migrated from the Claude Code Superpowers project.

## Overview

This repository contains skills and agents that implement the Superpowers methodology for Mistral Vibe. These were originally developed for Claude Code and have been adapted to work with Mistral Vibe's skill and agent system.

## Skills

The following skills are available:

### Core Workflow Skills

| Skill                           | Description                                                               | User Invocable |
| ------------------------------- | ------------------------------------------------------------------------- | -------------- |
| **brainstorming**               | Explores user intent, requirements and design before implementation       | Yes            |
| **writing-plans**               | Creates detailed implementation plans from specs                          | Yes            |
| **executing-plans**             | Executes implementation plans with review checkpoints                     | Yes            |
| **subagent-driven-development** | Fast iteration with two-stage review (spec compliance, then code quality) | Yes            |
| **dispatching-parallel-agents** | Concurrent subagent workflows for independent tasks                       | Yes            |

### Testing Skills

| Skill                       | Description                  | User Invocable |
| --------------------------- | ---------------------------- | -------------- |
| **test-driven-development** | RED-GREEN-REFACTOR TDD cycle | Yes            |

### Debugging Skills

| Skill                              | Description                                        | User Invocable |
| ---------------------------------- | -------------------------------------------------- | -------------- |
| **systematic-debugging**           | 4-phase root cause process                         | Yes            |
| **verification-before-completion** | Ensure it's actually fixed before claiming success | Yes            |

### Collaboration Skills

| Skill                              | Description                                 | User Invocable |
| ---------------------------------- | ------------------------------------------- | -------------- |
| **requesting-code-review**         | Pre-review checklist                        | Yes            |
| **receiving-code-review**          | Responding to feedback with technical rigor | Yes            |
| **finishing-a-development-branch** | Merge/PR decision workflow                  | Yes            |

### Git Skills

| Skill                   | Description                   | User Invocable |
| ----------------------- | ----------------------------- | -------------- |
| **using-git-worktrees** | Parallel development branches | Yes            |

### Meta Skills

| Skill                 | Description                                | User Invocable |
| --------------------- | ------------------------------------------ | -------------- |
| **using-superpowers** | Introduction to the skills system          | No             |
| **writing-skills**    | Create new skills following best practices | Yes            |

## Agents

The following agents are available:

### Review Agents

| Agent                     | Type     | Description                                                                                        |
| ------------------------- | -------- | -------------------------------------------------------------------------------------------------- |
| **code-reviewer**         | Subagent | Reviews completed project steps against original plans and coding standards                        |
| **spec-reviewer**         | Subagent | Reviews implementation against the original spec/plan. Confirms code matches spec exactly.         |
| **code-quality-reviewer** | Subagent | Reviews code quality: patterns, error handling, type safety, organization, test coverage, security |

### Development Agents

| Agent                  | Type     | Description                                                                                                      |
| ---------------------- | -------- | ---------------------------------------------------------------------------------------------------------------- |
| **subagent-developer** | Subagent | Executes implementation plans by dispatching subagents per task with two-stage review                            |
| **implementer**        | Subagent | Implements a single task from a plan using TDD. Reports status: DONE, DONE_WITH_CONCERNS, NEEDS_CONTEXT, BLOCKED |

## Installation

To use these skills and agents with Mistral Vibe:

1. **Skills**: Place this repository's `skills` directory in one of Mistral Vibe's skill discovery paths:
   - Global: `~/.vibe/skills/`
   - Local project: `.vibe/skills/`
   - Or configure `skill_paths` in your `config.toml`

2. **Agents**: Place this repository's `agents` directory contents in `~/.vibe/agents/`

### Quick Setup

```bash
# Clone or copy this repository
mkdir -p ~/.vibe
cp -r /path/to/mistral-superpowers/.vibe* ~/.vibe
```

## Usage

### Using Skills

Skills can be invoked automatically by Mistral Vibe based on context, or manually:

```
Use the brainstorming skill to explore this idea.
```

Or Mistral Vibe will automatically detect when a skill should be used based on the conversation context.

### Using Agents

Agents can be selected using the `--agent` flag:

```bash
vibe --agent code-reviewer
```

Or selected interactively with `Shift+Tab` in interactive mode.

## Workflow

The typical Superpowers workflow:

1. **Brainstorming** → Design specification
2. **Writing Plans** → Implementation plan
3. **Subagent-Driven Development** (using `subagent-developer` agent) or **Executing Plans** → Implementation
4. **Test-Driven Development** → Throughout implementation (used by `implementer` agent)
5. **Spec Review** (using `spec-reviewer` agent) → Verify against plan
6. **Code Quality Review** (using `code-quality-reviewer` agent) → Verify code standards
7. **Requesting Code Review** → Review against plan
8. **Finishing a Development Branch** → Integration

## License

MIT License - see LICENSE file for details.

## Original Project

These skills and agents were migrated from [obra/superpowers](https://github.com/obra/superpowers), the Claude Code Superpowers project by Jesse Vincent and Prime Radiant.

## Contributing

Contributions are welcome! Please ensure:

- Skills follow the Mistral Vibe skill format (YAML frontmatter)
- Agents follow the Mistral Vibe agent format (TOML)
- All content preserves the original intent and functionality

## Compatibility

Tested with Mistral Vibe. Compatible with the Agent Skills specification.
