# Architecture

Deep dive into how the SDD framework is structured. For quick start, see the [main README](../README.md).

---

## Where the SDD Framework Fits

The SDD framework sits between basic sub-agent patterns and full Agent Teams runtimes:

```mermaid
graph TB
    subgraph "Level 1 — Basic Subagents"
        L1_Lead["Lead Agent"]
        L1_Sub1["Sub-agent 1"]
        L1_Sub2["Sub-agent 2"]
        L1_Lead -->|"fire & forget"| L1_Sub1
        L1_Lead -->|"fire & forget"| L1_Sub2
    end

    subgraph "Level 2 — Agent Teams Lite ⭐"
        L2_Orch["Orchestrator<br/>(delegate-only)"]
        L2_Explore["Explorer"]
        L2_Propose["Proposer"]
        L2_Spec["Spec Writer"]
        L2_Design["Designer"]
        L2_Tasks["Task Planner"]
        L2_Apply["Implementer"]
        L2_Verify["Verifier"]
        L2_Archive["Archiver"]

        L2_Orch -->|"DAG phase"| L2_Explore
        L2_Orch -->|"DAG phase"| L2_Propose
        L2_Orch -->|"parallel"| L2_Spec
        L2_Orch -->|"parallel"| L2_Design
        L2_Orch -->|"DAG phase"| L2_Tasks
        L2_Orch -->|"batched"| L2_Apply
        L2_Orch -->|"DAG phase"| L2_Verify
        L2_Orch -->|"DAG phase"| L2_Archive

        L2_Store[("Pluggable Store<br/>engram | openspec | none")]
        L2_Registry[("Skill Registry<br/>auto-discover coding skills<br/>+ project conventions")]
        L2_Spec -.->|"persist"| L2_Store
        L2_Design -.->|"persist"| L2_Store
        L2_Apply -.->|"persist"| L2_Store
        L2_Orch -.->|"resolves once"| L2_Registry
        L2_Orch -.->|"pre-resolved paths"| L2_Explore
        L2_Orch -.->|"pre-resolved paths"| L2_Apply
        L2_Orch -.->|"pre-resolved paths"| L2_Verify
    end

    subgraph "Level 3 — Full Agent Teams"
        L3_Orch["Orchestrator"]
        L3_A1["Agent A"]
        L3_A2["Agent B"]
        L3_A3["Agent C"]
        L3_Queue[("Shared Task Queue<br/>claim / heartbeat")]

        L3_Orch -->|"manage"| L3_Queue
        L3_A1 <-->|"claim & report"| L3_Queue
        L3_A2 <-->|"claim & report"| L3_Queue
        L3_A3 <-->|"claim & report"| L3_Queue
        L3_A1 <-.->|"peer comms"| L3_A2
        L3_A2 <-.->|"peer comms"| L3_A3
    end

    style L2_Orch fill:#4CAF50,color:#fff,stroke:#333
    style L2_Store fill:#2196F3,color:#fff,stroke:#333
    style L2_Registry fill:#9C27B0,color:#fff,stroke:#333
    style L3_Queue fill:#FF9800,color:#fff,stroke:#333
```

---

## Capability Comparison

| Capability | Basic Subagents | Agent Teams Lite | Full Agent Teams |
|---|:---:|:---:|:---:|
| Delegate-only lead | — | ✅ | ✅ |
| DAG-based phase orchestration | — | ✅ | ✅ |
| Parallel phases (spec ∥ design) | — | ✅ | ✅ |
| Structured result envelope | — | ✅ | ✅ |
| Pluggable artifact store | — | ✅ | ✅ |
| **Skill auto-discovery** | — | ✅ | ✅ |
| Shared task queue with claim/heartbeat | — | — | ✅ |
| Teammate ↔ teammate communication | — | — | ✅ |
| Dynamic work stealing | — | — | ✅ |

---

## System Architecture

```
┌──────────────────────────────────────────────────────────┐
│  ORCHESTRATOR (coordinator — never does real work)         │
│                                                           │
│  Responsibilities:                                        │
│  • Delegate ALL tasks to sub-agents (not just SDD)        │
│  • Launch sub-agents via Task tool                        │
│  • Show summaries to user                                 │
│  • Ask for approval between phases                        │
│  • Track state: which artifacts exist, what's next        │
│  • Suggest SDD for substantial features/refactors         │
│                                                           │
│  Context usage: MINIMAL (only state + summaries)          │
└──────────────┬───────────────────────────────────────────┘
               │
               │ Task(subagent_type: 'general', prompt: 'Read skill...')
               │
    ┌──────────┴──────────────────────────────────────────┐
    │                                                      │
    ▼          ▼          ▼         ▼         ▼           ▼
┌────────┐┌────────┐┌────────┐┌────────┐┌────────┐┌────────┐
│EXPLORE ││PROPOSE ││  SPEC  ││ DESIGN ││ TASKS  ││ APPLY  │ ...
│        ││        ││        ││        ││        ││        │
│ Fresh  ││ Fresh  ││ Fresh  ││ Fresh  ││ Fresh  ││ Fresh  │
│context ││context ││context ││context ││context ││context │
└───┬────┘└───┬────┘└───┬────┘└───┬────┘└───┬────┘└───┬────┘
    │         │         │         │         │         │
    └─────────┴─────────┴────┬────┴─────────┴─────────┘
                             │
              (receive pre-resolved skill paths
               from the orchestrator's launch prompt)
                             │
                 ┌───────────▼───────────┐      ┌────────────────────┐
                 │    SUB-AGENT USES     │      │   SKILL REGISTRY   │
                 │   skills as directed  │      │                    │
                 │ • React, TDD, etc.   │      │ • Your coding      │
                 │ • Project conventions │      │   skills + paths   │
                 └───────────────────────┘      │ • Project conven- │
                                                │   tions (agents.md)│
                           ORCHESTRATOR ────────▶ resolves once/session
                                                └────────────────────┘
```

---

## The Dependency Graph

```
                    proposal
                   (root node)
                       │
         ┌─────────────┴─────────────┐
         │                           │
         ▼                           ▼
      specs                       design
   (requirements                (technical
    + scenarios)                 approach)
         │                           │
         └─────────────┬─────────────┘
                       │
                       ▼
                    tasks
                (implementation
                  checklist)
                       │
                       ▼
                    apply
                (write code)
                       │
                       ▼
                    verify
               (quality gate)
                       │
                       ▼
                   archive
              (merge specs,
               close change)
```

---

## Sub-Agent Result Contract

Each sub-agent must return a structured envelope with these fields:

| Field | Description |
|-------|-------------|
| `status` | `success`, `partial`, or `blocked` |
| `executive_summary` | 1-3 sentence summary of what was done |
| `detailed_report` | (optional) Full phase output, or omit if already inline |
| `artifacts` | List of artifact keys/paths written |
| `next_recommended` | The next SDD phase to run, or "none" |
| `risks` | Risks discovered, or "None" |

Example:

```markdown
**Status**: success
**Summary**: Proposal created for `{change-name}`. Defined scope, approach, and rollback plan.
**Artifacts**: Engram `sdd/{change-name}/proposal` | `openspec/changes/{change-name}/proposal.md`
**Next**: sdd-spec or sdd-design
**Risks**: None
```

`executive_summary` is intentionally short. `detailed_report` can be as long as needed for complex architecture work.

---

## Project Structure

```
dotfiles/
├── README.md                          ← Project overview and quick start
├── CLAUDE.md                          ← Project-level instructions for Claude Code
├── sync-skills.sh                     ← Syncs skills/ to claude/ and opencode/ packages
│
├── skills/                            ← 24 skills + shared conventions (canonical source)
│   ├── _shared/                       ← Shared conventions (referenced by all skills)
│   │   ├── persistence-contract.md    ← Mode resolution, sub-agent context protocol
│   │   ├── engram-convention.md       ← Deterministic naming & recovery
│   │   └── openspec-convention.md     ← File paths, directory structure, config reference
│   ├── sdd-init/SKILL.md             ← Bootstraps project + builds skill registry
│   ├── sdd-explore/SKILL.md
│   ├── sdd-propose/SKILL.md
│   ├── sdd-spec/SKILL.md
│   ├── sdd-design/SKILL.md
│   ├── sdd-tasks/SKILL.md
│   ├── sdd-apply/SKILL.md            ← v2.0: TDD workflow support
│   ├── sdd-verify/SKILL.md           ← v2.0: Real test execution + spec compliance matrix
│   ├── sdd-archive/SKILL.md
│   ├── skill-registry/SKILL.md       ← Scans skills + conventions
│   ├── issue-creation/SKILL.md       ← GitHub issue creation workflow
│   ├── branch-pr/SKILL.md            ← Branch + pull request workflow
│   ├── skill-creator/SKILL.md        ← Creates new AI skills
│   ├── pr-review/SKILL.md            ← GitHub PR/Issue review
│   ├── django-ninja/SKILL.md         ← Django Ninja API patterns
│   ├── django-components/SKILL.md    ← django-components patterns
│   ├── django-pytest/SKILL.md        ← Django testing with pytest
│   ├── htmx/SKILL.md                 ← HTMX integration patterns
│   ├── alpinejs/SKILL.md             ← Alpine.js patterns
│   ├── huey/SKILL.md                 ← Huey async task patterns
│   ├── tailwind-4/SKILL.md           ← Tailwind CSS v4 patterns
│   ├── playwright/SKILL.md           ← Playwright e2e testing
│   └── pytest/SKILL.md               ← Pytest patterns
│
├── claude/                            ← Stow package: Claude Code config
│   └── .claude/                       ← Settings, CLAUDE.md, MCP configs
│
├── opencode/                          ← Stow package: OpenCode config
│   └── .config/opencode/              ← Commands, plugins, AGENTS.md
│
├── gga/                               ← Stow package: GGA AI code review
│   └── .config/gga/                   ← Config and AGENTS.md
│
├── git/                               ← Stow package: Global git config
│
├── hypr/                              ← Stow package: Hyprland monitors config
│
├── starship/                          ← Stow package: Starship prompt config
│
└── docs/                              ← Deep-dive documentation
    ├── architecture.md                ← This file: system design and structure
    ├── persistence.md                 ← Artifact store modes
    └── token-economics.md             ← Token cost analysis and delegation savings

# Generated in target projects (not in this repo):
.atl/
└── skill-registry.md                  ← Auto-generated skill catalog for sub-agents
```
