# Shenron Architecture

## Design goal

Shenron converts a human-approved implementation plan into a reviewed candidate commit. It separates probabilistic agent work through Git isolation, independent evidence gathering, immutable commit identities, bounded retries, and a durable coordinator-owned memory.

## Control plane

The coordinator is the control plane. It owns:

- Delivery contract
- Implementation memory
- Git topology
- Candidate SHA selection
- Review-round state
- Agent dispatch
- Finding deduplication
- Final integration and cleanup

Agents never coordinate shared Git state directly.

## Data plane

Four worktrees form the execution plane:

| Worktree | Responsibility | Mutation |
|---|---|---|
| Implementer | Produce the first candidate | Owned branch |
| Reviewer A | Independent adversarial verification | Read-only |
| Reviewer B | Independent adversarial verification | Read-only |
| Corrector | Address accepted findings | Owned correction branch |

Runtime state such as browser profiles, test accounts, ports, and databases requires separate isolation. Git worktrees isolate files and branches, not external dependencies.

## State machine

```text
CONTRACTED
    |
    v
IMPLEMENTING
    |
    v
REVIEWING <-------------------+
    |                         |
    +-- both approve --> FINAL_VERIFY --> APPROVED
    |                         |
    +-- reject --------> CORRECTING
    |                         |
    +-- round budget exhausted --> BLOCKED
```

Terminal states are `APPROVED`, `BLOCKED`, `FAILED`, and `CANCELLED`.

## Implementation memory

The implementation memory lives under the repository's shared Git directory:

```text
<git-common-dir>/shenron/runs/<run-id>/implementation-memory.md
```

This makes one memory visible to all worktrees without dirtying user branches.

The coordinator is the sole writer. The file records:

- Repository, base SHA, and current candidate SHA
- Delivery contract and exclusions
- Worktree ownership
- Current state and round
- Decisions and assumptions
- Review ledger
- Findings and resolution status
- Verification evidence
- Risks, blockers, and exact next action

On resume, the coordinator reconciles memory against Git and filesystem state before doing work.

## Review integrity

Reviewer independence is a system invariant:

- Both reviewers inspect the same frozen SHA.
- Neither sees the other's conclusions before submitting.
- The implementer's persuasion is excluded from the review packet.
- Each reviewer selects verification methods based on risk.
- Every verdict cites positive evidence and untested areas.
- Any new correction commit invalidates every previous approval.

The gate is conjunctive: `A approves AND B approves`.

## Correction loop

The corrector receives deduplicated findings only after both reviews complete. It creates a new candidate SHA, which starts a fresh review round.

The loop is bounded. The default budget is three review rounds. Exhaustion produces `BLOCKED` and requires human direction; the coordinator never relaxes the gate.

## QA escalation

The 12-agent QA campaign is a separate release gate. It is explicit because of its cost and broad runtime impact.

When invoked, it runs after Shenron's dual approval and before authorized integration. Its final adversarial auditor checks evidence quality, test integrity, missing coverage, and contradictory conclusions.

## Safety properties

- No moving branch name is accepted as review identity.
- Reviewers cannot mutate candidate code.
- Shared memory has one writer.
- Correction cannot begin before both reviews finish.
- Integration cannot exceed the delivery contract.
- Worktree cleanup is limited to verified run-owned paths.
- Secrets and raw chain-of-thought never enter implementation memory.

## Known limits

- Independent agents can share model blind spots.
- Approval does not prove absence of defects.
- Worktrees do not isolate external services.
- Review quality depends on the acceptance contract and accessible evidence.
- The default round budget is a safety bound, not an optimization guarantee.
