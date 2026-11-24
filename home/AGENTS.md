# global agent instructions

- Never use the em dash "—". Use plain dash "-" instead
- When writing commit messages, NEVER auto-add your agent name as co-author
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- For one-off or infrequent operational work, start with the simplest direct end-to-end path. Do not build wrappers, control planes, policy layers, custom verifiers, or automation unless the direct path exposes a concrete blocker or repeated need that justifies the added machinery.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible.
  This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
  If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
  If you see one, even if it is not caused by what you are working on right now, still get it fixed.
- Lead with the answer. Give a measurement for every evaluative word or cut it. No framing phrases, closing aphorisms, or narration of steps.
- Before using "dynamic workflows", "ultra code" or any harness feature that immediately spawns a large swarm of subagents, always explain the tradeoffs and ask the user for explicit approval.
- When delegating to subagents, spawn each one as an agent in its own Herdr pane via the `herdr` skill, so I can watch and steer it. This instruction counts as my explicit request to use Herdr. For more than 4 subagents, first create a dedicated Herdr tab for the group and put their panes there, so the current tab stays readable. Outside Herdr (`HERDR_ENV` is not `1`), fall back to the harness's native subagents.
- When a review or iteration with me is long (multi-section plans, designs, large diffs, reports, several decisions with real tradeoffs), present it through the `lavish` skill and iterate on my feedback there. Keep short reviews and single questions in chat.
- Create Git worktrees as sparse checkouts limited to the directories the task needs, especially in large monorepos: `git worktree add --no-checkout <path> <branch>`, then `git -C <path> sparse-checkout set <dirs...>`, then `git -C <path> checkout`. Widen later with `sparse-checkout add`. Do not use `herdr worktree create`; it always checks out everything. Start subagent panes in the worktree with `herdr pane split --cwd <path>`.
- My personal knowledge vault is `~/ObsidianVault` (Obsidian, git, qmd search). From any project, saving a learning or answering "what do my notes say" goes through the `obsidian-*` skills, after reading `~/ObsidianVault/AGENTS.md`. Sanitize work learnings before writing them (no customer data, PII, account IDs or names).

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
