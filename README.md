<p align="center">
  <img src="assets/shenron-hero.png" alt="Shenron adversarial delivery loop" width="720">
</p>

<h1 align="center">Shenron</h1>

<p align="center">
  <strong>High-assurance multi-agent software delivery.<br>
  Four isolated worktrees. Two independent adversarial approvals. One durable implementation memory.</strong>
</p>

<p align="center">
  <a href="docs/architecture.md">Architecture</a> ·
  <a href="skills/shenron/SKILL.md">Delivery skill</a> ·
  <a href="skills/e2e-qa-team/SKILL.md">12-agent QA</a>
</p>

---

Shenron starts after a human has defined the implementation plan. It coordinates delivery without imposing a planning methodology:

```text
Human-approved plan
        |
        v
Implementer worktree
        |
        v
Frozen candidate commit
        |
        +--------------------+
        v                    v
Adversarial reviewer A   Adversarial reviewer B
        |                    |
        +---------+----------+
                  v
          Dual-approval gate
             |          |
          reject       approve
             |          |
             v          v
       Corrector     Final checks
             |          |
             +----> next candidate
```

Every run maintains a coordinator-owned `implementation-memory.md` containing the delivery contract, worktree ownership, immutable candidate SHAs, decisions, review verdicts, evidence, risks, and exact next action.

## Core guarantees

- **Human-owned intent** - Shenron never invents requirements to keep moving.
- **Four isolated worktrees** - implementation, two read-only reviews, and correction never share mutable state.
- **Independent adversarial review** - reviewers do not see each other's conclusions.
- **Verification is risk-driven** - reviewers choose appropriate evidence; tests are not assumed to prove every kind of correctness.
- **Dual approval on one SHA** - approvals apply only to the exact commit reviewed.
- **Bounded correction loop** - three rounds by default, then human escalation.
- **Durable memory** - one implementation memory survives worktrees, interruptions, and context compaction.
- **Safe integration** - no merge, push, pull request, or external mutation unless authorized.

## Included skills

### `$shenron`

Implements a substantial feature through:

1. A human-approved delivery contract
2. A durable implementation memory
3. Four role-owned Git worktrees
4. One implementer
5. Two independent adversarial reviewers
6. One corrector
7. Dual approval or bounded human escalation

### `$e2e-qa-team`

Runs an optional, explicit release campaign with exactly 12 specialist charters covering:

- Surface and environment mapping
- Authentication and authorization
- Primary and secondary journeys
- Data validation and integrity
- Resilience and dependency failures
- Accessibility and compatibility
- Performance and long-run stability
- Final adversarial QA audit

The QA campaign is intentionally not launched implicitly because it is expensive. Invoke it explicitly for large, sensitive, or release-critical changes.

## Install

### Windows / PowerShell

```powershell
git clone https://github.com/rechedev9/shenron
cd shenron
.\install.ps1 -Target codex
```

Targets: `codex`, `claude`, or `both`.

### macOS / Linux

```bash
git clone https://github.com/rechedev9/shenron
cd shenron
./install.sh --target codex
```

The installers back up an existing Shenron skill before replacing it.

## Use

Define the plan and acceptance criteria, then invoke:

```text
$shenron Implement the approved plan for <feature>.
Repository: <path>
Acceptance criteria: <criteria>
Maximum review rounds: 3
Integration policy: candidate branch only
```

For a full release QA campaign:

```text
$e2e-qa-team Verify the approved candidate end to end.
```

## Repository structure

```text
shenron/
  skills/
    shenron/
      SKILL.md
      agents/openai.yaml
      references/
    e2e-qa-team/
      SKILL.md
      agents/openai.yaml
  docs/
    architecture.md
  scripts/
    validate_skills.py
  install.ps1
  install.sh
```

## What Shenron is not

- It is not a requirements or specification methodology.
- It is not an unbounded autonomous coding loop.
- It does not equate a green test suite with correctness.
- It does not claim that adversarial approval proves the absence of defects.
- It does not submit changes or mutate external systems without authorization.

## License

Business Source License 1.1. The change license and date are defined in [LICENSE](LICENSE).
