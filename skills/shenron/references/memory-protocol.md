# Implementation Memory Protocol

Every Shenron run has exactly one durable memory file.

## Location

Resolve the shared Git directory with `git rev-parse --git-common-dir`. Store the file at:

```text
<git-common-dir>/shenron/runs/<run-id>/implementation-memory.md
```

This location is shared by all worktrees, survives branch changes, and does not dirty the user's checkout.

The coordinator must resolve the absolute path and verify it remains beneath the shared Git directory before creating or updating it.

## Ownership

- The coordinator is the sole writer.
- Agents receive the relevant current snapshot.
- Agents return structured facts, evidence links, decisions requested, and proposed deltas.
- The coordinator validates and incorporates those deltas.
- Never allow concurrent writes.

Write updates atomically when the environment supports it: write a sibling temporary file, flush it, then replace the prior memory file.

## Required structure

```markdown
# Shenron Implementation Memory

## Identity
- Run ID:
- Repository:
- Git common directory:
- Base SHA:
- Created:
- Last updated:

## Delivery contract
- Objective:
- Approved plan:
- Acceptance criteria:
- Exclusions:
- Allowed mutations:
- Required checks:
- Maximum review rounds:
- Integration policy:
- Full QA authorized:

## Current state
- Status:
- Round:
- Candidate SHA:
- Candidate branch:
- Next action:
- Coordinator:

## Worktree ownership
| Role | Absolute path | Branch or SHA | Mutable | Status |

## Decisions
| ID | Decision | Rationale | Evidence | Owner | Timestamp |

## Assumptions
| ID | Assumption | Validation status | Evidence |

## Review ledger
| Round | Candidate SHA | Reviewer A | Reviewer B | Gate result |

## Findings
| ID | Round | Severity | Summary | Evidence | Status | Resolution SHA |

## Verification ledger
| Round | Actor | Command or method | Result | Evidence |

## Risks and unknowns
- ...

## Handoff
- Last completed action:
- Exact next action:
- Blockers:
- Residual state:
```

## State values

Use one:

- `CONTRACTED`
- `IMPLEMENTING`
- `REVIEWING`
- `CORRECTING`
- `FINAL_VERIFY`
- `APPROVED`
- `BLOCKED`
- `FAILED`
- `CANCELLED`

## Integrity rules

- Record immutable commit SHAs, not only branch names.
- Timestamp material transitions.
- Link evidence instead of copying large logs.
- Separate observed facts from assumptions.
- Never rewrite prior review verdicts; append a new round.
- Never record approval for a different SHA than the one reviewed.
- Mark superseded findings explicitly.
- Record cleanup failures and leftover worktrees.
- Do not store secrets, access tokens, private keys, customer data, or raw chain-of-thought.
- On resume, reconcile the file with Git and filesystem state before taking action.
