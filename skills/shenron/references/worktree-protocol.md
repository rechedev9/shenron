# Worktree Isolation Protocol

The coordinator owns all Git topology and cleanup.

The implementation memory is the authoritative registry of every role-owned path, branch, and candidate SHA.

## Preconditions

- Resolve and record the repository root as an absolute path.
- Require a clean primary checkout or explicitly preserve unrelated changes outside the run.
- Record the base commit SHA.
- Create a unique run ID.
- Place temporary worktrees under one explicit run directory, never the repository root, home directory, or a broad shared directory.
- Resolve every path before mutation and verify it remains inside that run directory.

## Ownership

| Role | Mode | May commit | May change shared Git state |
|---|---|---:|---:|
| Coordinator | Primary checkout | Only for authorized integration | Yes |
| Implementer | Owned branch and worktree | Yes | No |
| Reviewer A | Detached, read-only candidate | No | No |
| Reviewer B | Detached, read-only candidate | No | No |
| Corrector | Owned correction branch and worktree | Yes | No |

## Candidate lifecycle

1. Create the implementer branch from the recorded base.
2. Let the implementer commit the candidate.
3. Freeze and record the candidate SHA.
4. Attach both reviewer worktrees to that exact SHA in detached mode.
5. If correction is required, create a new corrector branch from the rejected candidate SHA.
6. Freeze the correction commit as a new candidate.
7. Recreate or safely reattach clean reviewer worktrees to the new SHA.
8. Treat all approvals of previous SHAs as invalid.

Never use a moving branch name as the review identity.

## Safety rules

- Do not use `git reset --hard` or checkout-based cleanup against a worktree containing user changes.
- Do not force-push.
- Do not delete branches or worktrees outside the verified run directory.
- Do not let agents create additional worktrees without coordinator approval.
- Do not merge into the user's branch until the delivery contract authorizes it.
- Before removing a run worktree, prove it is clean and its path is inside the verified run directory.
- If cleanup cannot be proven safe, leave the worktree in place and report it.

## Concurrency

- Implementation precedes review.
- Reviewer A and Reviewer B may run concurrently because they are read-only and isolated.
- Correction starts only after both reviews are collected.
- A new review round starts only after the correction commit is frozen.
- Browser profiles, test accounts, ports, databases, and fixtures must be isolated separately; Git worktrees alone do not isolate runtime state.
