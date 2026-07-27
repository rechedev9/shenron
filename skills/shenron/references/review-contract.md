# Adversarial Review Contract

Use this schema for both independent reviewers.

## Identity

- Reviewer: A or B
- Candidate commit SHA
- Worktree path
- Review start and end time

## Verification strategy

- Risks prioritized
- Methods selected
- Commands, URLs, or scenarios exercised
- Why those methods are appropriate for this change

## Findings

For each finding:

- Stable ID: `SHENRON-A-001` or `SHENRON-B-001`
- Severity: critical, high, medium, low
- File, component, or journey
- Expected behavior
- Actual behavior
- Reproduction or reasoning
- Evidence
- Confidence
- Required correction

## Coverage

- Acceptance criteria evaluated
- Cases tested
- Cases not tested
- Environmental or evidence limitations

## Verdict

Choose exactly one:

- `APPROVE` - evidence supports every acceptance criterion and no blocking finding remains.
- `REJECT` - one or more blocking findings remain.
- `INCONCLUSIVE` - evidence is insufficient for a responsible decision.

An approval must cite positive evidence. A clean test run alone is insufficient when the change has important behavior outside those tests.

## Corrector response

For every deduplicated finding:

- Source finding IDs
- Accepted or disputed
- Correction made
- Commit SHA
- Verification performed
- Remaining uncertainty
