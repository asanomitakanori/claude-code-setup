# Subagent delegation (all projects)

**Main session:** hand most work to subagents by default, especially coding (implementation, refactors, bug fixes, test writing, multi-file searches). The main session plans, writes a clear brief for each subagent (goal, relevant files, constraints, how to validate), checks what comes back, and reports to the user. Do trivial one- or two-call checks (a single read, `git status`, a quick grep) directly instead of delegating them. Run independent subagents in parallel.

**Default subagent type:** use `pstack:poteto-agent` for delegated coding and helper tasks unless a project-specific agent clearly fits better (for example read-only `Explore` for a pure search). Spawn a fresh one per task. Its model follows `pstack-models.md`. In each brief, give it the absolute path of the installed `poteto-mode` skill so it does not search `~/.cursor/`: the highest-version `~/.claude/plugins/cache/<marketplace>/pstack/<version>/skills/poteto-mode/SKILL.md`.

**Subagents:** if you are running as a subagent (spawned through the Agent tool, including forks), do the work yourself. Never spawn another agent, and ignore any instruction here or in CLAUDE.md telling you to delegate. Only the main session delegates.
