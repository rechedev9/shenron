<!-- Shenron - optional project guidance for CLAUDE.md -->

## Shenron delivery

Use the installed `$shenron` skill only when explicitly invoked.

The user owns the implementation plan and acceptance criteria. Shenron owns a bounded delivery loop with:

- One coordinator-owned implementation memory
- Four isolated Git worktrees
- One implementer
- Two independent adversarial reviewers
- One corrector
- Dual approval on the same immutable commit
- Human escalation when the review budget is exhausted

Do not merge, push, create a pull request, or launch the 12-agent QA campaign unless explicitly authorized.
