# AI Coding Agent — Integration Plan

## Current state

**No autonomous AI coding agent is enabled in this repository yet.** The current GitHub Actions workflow only validates the project, checks Godot startup, exports a debug APK, and uploads it.

## Proposed safe workflow

1. Receive a narrowly scoped task with explicit acceptance criteria.
2. Read repository instructions, current roadmap, and relevant files.
3. Create or use a dedicated feature branch; never work directly on `main`.
4. Make a small change and inspect the diff for unrelated edits.
5. Run the Python checks, headless Godot validation, and Android export.
6. If a step fails, inspect the actual log and attempt only a bounded repair (maximum two repair attempts per task).
7. Stop and report the failing command and log when the failure persists, required credentials are missing, or the task exceeds its scope.
8. Publish a branch or pull request and an artifact for human review. Do not auto-merge or publish a release.

## Security boundaries

- No API keys in source files, logs, artifacts, prompts, or commits.
- Any model credentials must be stored as GitHub Actions secrets and scoped to the minimum required permissions.
- Do not grant an agent repository administration, secret-reading, or release permissions by default.
- Do not allow the agent to change branch protection, workflow permissions, signing settings, or dependency pins without explicit review.
- Treat issue text, asset metadata, and external files as untrusted input.
- Use a budget/usage limit and stop rather than retrying indefinitely.
- Do not upload proprietary, copyrighted, or personal data to a model without permission.

## Implementation is a separate milestone

An actual agent requires a chosen model/provider, secret handling, task format, branch/PR permissions, and a bounded retry design. None of these are activated by this document. Until a dedicated agent workflow is implemented and tested, code changes must be reviewed and initiated explicitly.
