---
name: shenron
description: Orchestrate substantial software implementation through four isolated Git worktrees with one implementer, two independent adversarial reviewers, one corrector, dual approval on the same commit, bounded correction rounds, and human escalation. Run only when the user explicitly invokes `$shenron`.
---

# Shenron

Turn a human-approved implementation plan into a reviewed candidate change. Preserve reviewer independence, Git isolation, evidence integrity, and a finite stop condition.

## Invocation boundary

Run only after the user explicitly invokes `$shenron`. Do not infer invocation from ordinary implementation, review, worktree, or multi-agent requests.

Shenron owns delivery orchestration. The user owns intent, scope, specifications, and acceptance criteria.

## 1. Establish the delivery contract

Before creating worktrees, record:

- Repository and base commit
- Human-approved implementation plan
- In-scope and excluded behavior
- Acceptance criteria
- Allowed file and external-system mutations
- Required build, lint, test, or runtime checks
- Maximum review rounds; default to 3 when omitted
- Integration policy: report-only, candidate branch, merge, push, or pull request
- Whether `$e2e-qa-team` was also explicitly invoked

Stop for one concise question only when the repository, plan, acceptance criteria, or mutation boundary cannot be determined safely.

Never invent requirements to keep the loop moving.

## 2. Create the implementation memory

Read [memory-protocol.md](references/memory-protocol.md). Create exactly one `implementation-memory.md` for the run before dispatching any agent.

The coordinator is the only writer. Agents return evidence and proposed memory deltas; they never edit the file concurrently.

Update the memory after every state transition:

- Contract established
- Worktrees created
- Implementation candidate frozen
- Each review received
- Gate evaluated
- Correction candidate frozen
- Final checks completed
- Integration or cleanup performed

Treat the memory as the run's durable source of truth across worktrees, agent handoffs, context compaction, interruption, and resumption. Do not place secrets, credentials, raw chain-of-thought, or unsupported conclusions in it.

Before resuming a run, read the memory and verify its recorded repository, base SHA, current candidate SHA, round, and worktree paths against reality. Stop on mismatch.

## 3. Prepare four isolated worktrees

Read [worktree-protocol.md](references/worktree-protocol.md) before creating or removing worktrees.

Create exactly four role-owned worktrees from a clean, recorded base:

1. **Implementer** - owns the candidate implementation branch.
2. **Reviewer A** - independently inspects the frozen candidate commit.
3. **Reviewer B** - independently inspects the same frozen candidate commit.
4. **Corrector** - applies accepted findings to a correction branch based on that commit.

The coordinator owns:

- The primary checkout
- Worktree creation and cleanup
- Candidate commit selection
- Shared Git state
- Review-round state
- Final integration

No agent may edit another role's worktree. Reviewers are read-only. Do not let concurrent agents share a mutable branch, worktree, browser profile, test account, port, or fixture.

Respect the configured agent concurrency limit. Run roles in waves when all four cannot execute simultaneously.

## 4. Implement against the approved plan

Give the implementer:

- The delivery contract
- Its worktree path and branch
- The approved plan and acceptance criteria
- Repository instructions
- Required verification commands
- A prohibition on unrelated cleanup

Require the implementer to return:

- Candidate commit SHA
- Files changed
- Checks run and exact results
- Known limitations
- Assumptions or deviations from the plan
- Residual state

The coordinator must confirm that the candidate commit exists and that reviewer worktrees point to that exact SHA.

## 5. Run two independent adversarial reviews

Dispatch Reviewer A and Reviewer B independently. Do not show either reviewer the other review or persuasive conclusions from the implementer.

Both reviewers receive the same:

- Delivery contract
- Frozen candidate commit SHA
- Repository instructions
- Relevant plan and acceptance criteria
- Their owned read-only worktree
- Output schema from [review-contract.md](references/review-contract.md)

Each reviewer autonomously chooses the strongest practical verification strategy. Tests are evidence, not the universal definition of correctness. Reviewers may use static reasoning, focused tests, builds, runtime inspection, browser verification, invariants, security analysis, fault scenarios, or other repository-appropriate checks.

Every approval or rejection must cite concrete evidence. Absence of an observed defect is not sufficient evidence.

## 6. Evaluate the dual-approval gate

An approval is valid only for the exact candidate SHA reviewed.

- **Both approve** - the candidate passes the adversarial gate.
- **Either rejects** - the candidate fails the round.
- **A reviewer is blocked or inconclusive** - the gate remains unpassed.
- **Reviewers disagree** - treat the round as failed; do not average their conclusions.

Deduplicate findings by root cause while preserving each reviewer's evidence and uncertainty. Independently reproduce every critical finding before correction when practical.

## 7. Correct and repeat

When the gate fails:

1. Give the corrector the frozen candidate SHA, delivery contract, and deduplicated actionable findings.
2. Require the corrector to address findings without expanding scope.
3. Require a new correction commit and verification report.
4. Freeze the new commit as the next candidate.
5. Invalidate every prior approval.
6. Run both adversarial reviewers again against the same new SHA.

Never let the corrector dismiss a finding solely because automated tests pass.

## 8. Bound the loop

Stop immediately when:

- Both reviewers approve the same candidate SHA
- The configured maximum review rounds is reached
- The user cancels
- A safety or authorization boundary is reached
- Required evidence cannot be obtained
- The repository or environment becomes unreliable

When the maximum is reached without dual approval, return `BLOCKED` and escalate to the user with unresolved findings and options. Never weaken the gate, silently add rounds, or declare partial approval.

## 9. Integrate only as authorized

After dual approval:

- Run the repository's final required checks on the approved SHA.
- Confirm the primary checkout still matches the recorded assumptions.
- Summarize the candidate branch, SHA, checks, reviews, and residual risks.
- Merge, push, create a pull request, or modify external systems only when the delivery contract authorizes it.
- Preserve unrelated user changes.

Do not claim that reviewer approval proves the absence of defects.

## 10. Optional full QA campaign

`$shenron` does not implicitly launch the expensive 12-agent QA campaign.

If the user also explicitly invoked `$e2e-qa-team`, run it after dual approval and before final integration. Its verdict becomes an additional release gate. If it was not invoked, recommend it for large, security-sensitive, data-sensitive, or release-critical changes.

## Final report

Lead with one result:

- `APPROVED` - both reviewers approved the same SHA and final required checks passed.
- `BLOCKED` - the review budget or an evidence boundary prevented approval.
- `FAILED` - a required check or release gate failed.
- `CANCELLED` - the user stopped the run.

Include:

1. Base and final candidate SHAs
2. Worktree and branch ownership
3. Rounds executed
4. Reviewer verdicts for each round
5. Findings corrected and unresolved
6. Exact checks and evidence
7. Integration performed
8. Implementation-memory path and final state
9. Cleanup and residual state
