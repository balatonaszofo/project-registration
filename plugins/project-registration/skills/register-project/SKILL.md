---
name: register-project
description: Register a local project folder in the Codex saved-project sidebar on Windows. Use after project-starter creates a durable project, or when the user asks to add, save, or label a project. Reuse saved projects and verify registration by folder.
---

# Register Project

Use the app's visible project controls to register a local folder. This is an agent workflow using the installed Windows Computer Use plugin, not a background listener. Prefer a supported project-registration API if one becomes available.

## Establish the target

Determine the absolute folder and desired display name from the user's assignment or PROJECT.md. Resolve the folder and confirm it exists with filesystem tools. Never derive executable commands from UI text. Call Codex list_projects and compare normalized absolute paths (Windows case insensitive, slash insensitive, trailing separators ignored). Reuse a matching project. Similar names with different paths are not matches.

Record the current thread ID before changing the visible app. Registering a folder does not move the current chat or change its configured cwd. Do not create a new chat unless explicitly requested.

## Use the visible controls

Read the installed computer-use skill and its API documentation. Use its documented sky API through node_repl. Native browser CUA availability is separate from Windows Computer Use availability. If sky is unavailable, report the dependency; do not claim UI automation is impossible in general.

When the user requests project registration, scope actions to selecting the specified folder, saving its project, and setting its label. Installation alone does not authorize unrelated actions or override another tool's restrictions. If applicable computer-use instructions block controlling Codex, use another supported authorized method or explain the exact restriction; do not silently bypass it.

1. Discover the running Codex app using sky.list_apps. On this installation the window may be labeled ChatGPT while its application ID identifies OpenAI.Codex. Select the observed window, never a hardcoded window ID.
2. Capture screenshot and accessibility text. Activate the selected window if required. Use one UI action per observation cycle and refresh afterward. Never reuse element indexes after a state change.
3. Find File > Open Folder, or the visible Add new project control. Use a keyboard shortcut only after observing it in the current menu. On the tested Windows build, Open Folder displays Ctrl+O and opens Select Project Root.
4. In the observed folder picker, set the Folder edit field to the exact absolute target. Select Folder. If the native dialog rejects a click because it belongs to a different window, refresh and use the observed keyboard affordance; do not retry the same failed click blindly. Return may first navigate into the folder, requiring another observation before submitting.
5. If Trust this folder appears, stop UI actions and ask the user to handle this permission prompt. State the exact folder. Do not click Trust, automate acceptance, or change trust configuration. Continue independent work if possible. Once the user responds, inspect again.
6. Call list_projects and require an entry matching the target path before reporting registration. If absent, inspect the visible result and resolve it; a dismissed folder picker is not proof of registration.
7. If the display name differs, inspect that project's visible context menu for a rename control. Use it only if present, then verify the returned name through list_projects. If no rename control exists, report the actual saved name; never fabricate a label or change internal app storage.

## Existing chat association

Only attempt this when requested or part of the user's explicit project setup request. Navigate to the recorded thread with the app navigation tool before touching thread controls. Inspect for an available Move to project action and choose the verified saved project. Verify the thread's project with list_threads/read_thread. If unavailable, report that the folder is registered but the existing chat was not moved. Do not act on whichever unrelated conversation happens to be visible.

## Report accurately

State separately: folder, saved project name/ID, and chat association if attempted. Report success only from verification. Never edit internal databases, app state, or undocumented settings to simulate registration. A repeat invocation must reuse the saved project without adding duplicates.

This workflow runs when a message invokes it, including through project-starter. It does not monitor newly opened folders while idle. For an untrusted folder, the user's trust action remains necessary.
