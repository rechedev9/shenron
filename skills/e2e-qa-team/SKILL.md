---
name: e2e-qa-team
description: Run an evidence-based end-to-end QA campaign with exactly 12 specialized subagents in concurrency-safe waves, progressive release gates, defect reproduction, resilience and failure scenarios, and a final adversarial audit. Run only when the user explicitly invokes `$e2e-qa-team`.
---

# E2E QA Team

Verify and report by default. Do not modify application code unless the user separately asks for fixes.

## Invocation boundary

Run only after the user explicitly invokes `$e2e-qa-team`. Do not infer invocation from ordinary QA, testing, verification, release, or exploratory-testing requests.

## 1. Establish the QA contract

Inspect the repository, application, documentation, and test commands. Record:

- Target URL, executable, service, build, commit, and environment
- User journeys and requirements in scope
- Browsers, devices, roles, accounts, and integrations
- Allowed data mutations
- Explicit exclusions
- Stop conditions, release criteria, and rollback expectations

Ask one concise blocking question only when the target or access cannot be discovered safely.

Treat production as non-destructive unless explicitly authorized. Never make real purchases, send real messages, delete user data, weaken security, or expose credentials.

## 2. Baseline before broad testing

- Confirm the intended build can start.
- Record automated-test counts, skips, failures, console errors, server errors, and health checks.
- Prefer the repository's existing browser, API, integration, and device-test stacks.
- Isolate browser profiles, accounts, tenants, ports, fixtures, and mutable data.

## 3. Dispatch exactly 12 specialist charters

Respect the configured concurrency limit and run agents in safe waves. Keep the main agent as coordinator.

1. **Surface mapper** - inventory routes, APIs, roles, journeys, dependencies, and risky state transitions.
2. **Environment and smoke tester** - verify install, build, start, first load, shutdown, restart, health, and obvious errors.
3. **Authentication specialist** - test account creation, sessions, recovery, expiry, multi-tab behavior, and lifecycle.
4. **Primary-journey specialist** - exercise the highest-value happy path and verify durable side effects.
5. **Secondary-flow specialist** - test alternate journeys, navigation, refresh, deep links, saved state, and interruption.
6. **Data and validation specialist** - test boundaries, malformed input, empty states, duplicates, Unicode, time zones, uploads, persistence, and integrity.
7. **Authorization specialist** - test roles, tenant isolation, direct-object access, protected routes, and privilege boundaries.
8. **Resilience specialist** - test dependency and API failures, slow/offline networks, retries, idempotency, concurrency, cancellation, timeouts, and recovery.
9. **Accessibility specialist** - test keyboard use, focus, labels, semantics, dialogs, announcements, contrast, zoom, and reduced motion.
10. **Responsive and compatibility specialist** - test supported viewports, orientation, input modes, browsers, overflow, visual regressions, and touch targets.
11. **Performance and stability specialist** - test cold/warm behavior, responsiveness, long sessions, repeated actions, resource growth, large datasets, and observability.
12. **Adversarial QA auditor** - run last and inspect the contract, raw evidence, test integrity, and reports for missing coverage, reward hacking, weakened tests, contradictions, and escaped defects.

Run agents 1 and 2 first when later charters depend on discovery. Run agents 3-11 in concurrency-safe waves. Run agent 12 only after collecting their evidence.

## 4. Enforce an evidence contract

Every agent must report:

- Tested and untested cases
- Exact commands, URLs, versions, and environment facts
- Reproduction steps with expected and actual behavior
- Screenshots, traces, logs, request/response data, or test output when available
- Severity, impact, reproducibility, and confidence
- Cleanup performed and residual state

Use stable IDs such as `QA-AUTH-001`:

- `P0` - catastrophic security issue, irreversible data loss, or complete outage
- `P1` - critical journey failure, serious authorization defect, or frequent crash
- `P2` - material defect with a workaround or limited scope
- `P3` - minor usability, visual, wording, or compatibility issue

Do not treat absence of observed defects as proof.

## 5. Reproduce and triangulate

After the first 11 reports:

1. Deduplicate findings by root cause.
2. Independently reproduce every P0 and P1 plus representative P2 findings.
3. Separate product defects from harness, environment, fixture, and infrastructure failures.
4. Explore adjacent cases when a finding suggests a broader defect class.
5. Confirm tests were not deleted, skipped, weakened, or silently updated.
6. Confirm evidence belongs to the intended build.

Do not fix defects during verification-only work.

## 6. Apply progressive release gates

Evaluate every supported gate:

1. Build and static checks
2. Startup and health
3. Critical journeys
4. Boundary and negative cases
5. Automated end-to-end suite
6. Accessibility and compatibility
7. Resilience and security boundaries
8. Performance and long-run stability
9. Cross-platform or release-build matrix
10. Canary, telemetry, and rollback readiness

Never convert an unevaluated gate into a pass. Mark it `not tested` or `blocked` with the exact reason.

## 7. Deliver the report

Lead with one verdict:

- `PASS` - agreed gates passed and no release blocker remains
- `CONDITIONAL PASS` - no blocker remains, but named risk requires acceptance
- `FAIL` - one or more release blockers remain
- `INCONCLUSIVE` - access, environment, or evidence prevents a responsible verdict

Include:

1. Target, build, environment, dates, accounts, and scope
2. Verdict and release recommendation
3. Coverage matrix for all 12 charters
4. Gate results with evidence
5. Deduplicated findings by severity
6. Exact reproduction steps and evidence links
7. Test-integrity and baseline comparison
8. Untested areas and residual risk
9. Cleanup and residual state
10. Next actions and retest criteria
