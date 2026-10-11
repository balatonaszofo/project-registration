---
name: start-project
description: Create and save a named local project when substantive build or design work starts in a projectless Codex chat. Reuse existing projects and register new folders with register-project on Windows.
---

# Start Project

Apply when the user asks to build a durable artifact in an automatically generated projectless workspace. Advice-only questions, existing repositories, saved projects, and folders whose AGENTS.md defines a purpose do not trigger a new project. Respect user-specified names and destinations.

1. Read workspace instructions and call list_projects. Reuse an existing project that owns the work; do not create duplicates.
2. Infer a concise working name unless supplied. Honor the destination; otherwise resolve a Projects directory under the current user's home from the environment. Never hardcode a personal path. Use a lowercase hyphenated folder name; avoid Windows device names, trailing dots/spaces, separators and shell metacharacters.
3. Check collisions. Reuse a matching folder or choose a descriptive suffix for an unrelated collision. Obtain required filesystem permissions. Never overwrite existing project files or move the whole generated workspace.
4. Create the folder, PROJECT.md with goal, scope, source thread if known, status and next step, and a concise AGENTS.md pointing to PROJECT.md. Copy only inspected task-owned artifacts if needed, retaining originals. Scaffold applications or initialize Git only when the assignment calls for it.
5. Name the current chat with the app tool when available. Read the sibling skill at ../register-project/SKILL.md and apply it to save the folder in the sidebar. Verify the actual folder and saved label. Pause at folder trust prompts for the user.
6. Continue the original assignment using explicit absolute paths and workdir. Registration alone does not move the chat or change its configured cwd. Only attempt chat association through observed controls if authorized; report it separately.

Finish the requested artifact, not just setup. If dependencies are unavailable, preserve the folder and explain the specific remaining step.
