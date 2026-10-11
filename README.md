# Project Registration — Windows beta

Create a named local project folder and save it in the Codex sidebar during project setup. Existing saved projects are reused. This skills-based plugin includes **Start Project** and **Register Project**.

## Requirements

- Codex desktop on Windows with local project controls.
- The Windows Computer Use plugin exposing its documented `sky` API through `node_repl`.
- Codex app tools including `list_projects` to verify saved folders.
- Permission to create the selected project folder.

The plugin supplies agent instructions; computer control comes from the separate Computer Use plugin. Availability on another account or desktop build must be checked. Applicable computer-control restrictions still apply: installation does not override them. Users must handle folder trust prompts themselves.

## Install from a release ZIP

Extract the ZIP. In PowerShell, run the installer from the extracted folder:

```powershell
.\install.ps1
```

To also enable automatic setup for substantive new build requests in projectless chats:

```powershell
.\install.ps1 -EnableAutomaticSetup
```

The installer copies the plugin to `%USERPROFILE%\.codex\plugins\project-registration`, adds a local entry to `%USERPROFILE%\.agents\plugins\marketplace.json`, and installs both skills into `%USERPROFILE%\.codex\skills`. Reload Codex, then invoke `$start-project` or `$register-project`. The marketplace entry also exposes the plugin for app installation; choose either direct skills or plugin activation to avoid duplicate skill entries.

Existing marketplace entries and AGENTS.md instructions are preserved. The optional automatic trigger is appended once, with a backup. Independently maintained skills with the same names are never overwritten: if the installer reports a collision, install the plugin through its marketplace instead. `-ProfileRoot` supports an isolated test profile and defaults to the current user's home.

## Install from the repository marketplace

The generated repository contains `.agents/plugins/marketplace.json` and `plugins/project-registration`. Add this repository as a local marketplace through the plugin controls available in your Codex build, then install Project Registration. Its skills can be invoked directly. The automatic AGENTS.md trigger is optional and is provided by the installer above.

## Usage

```text
Use $start-project to build a meeting notes organizer called Meeting Desk.
Use $register-project to save my existing folder C:\Projects\MeetingDesk.
```

Start Project chooses a working name, creates durable project context, invokes Register Project, and continues the assignment. Register Project selects the exact folder through visible controls and confirms the saved path with list_projects. A Trust folder prompt requires your click before verification resumes.

This workflow runs during an agent turn. It does not watch idle chats or folders in the background. Saving a project does not automatically move the current chat or change its working directory. Custom display renaming and chat moves are attempted only through available controls and verified separately.

## Beta validation

One live Windows trial confirmed that selecting a folder and accepting Trust folder saved the exact folder in Codex. The default folder-based label was confirmed. Other Windows installations, custom display renaming, and existing-chat moves remain untested. Installer checks cover repeat installs, existing marketplace/instruction preservation, and skill/source collision refusal using temporary profiles.

## Remove

Remove this plugin in Codex if you activated it there. For direct-skill installation, remove the installer-owned `start-project` and `register-project` folders under `.codex/skills`, the plugin folder under `.codex/plugins`, and only its entry in the personal marketplace. If enabled, remove the marked `project-registration:auto` block from `.codex/AGENTS.md`. Keep unrelated entries and instructions. Do not restore old backups over newer changes without reviewing them.

## Publishing

The repository and ZIP are suitable for sharing as a beta after review. Public directory publication requires a verified developer identity, completed listing metadata and OpenAI review. Approval and compatibility are not established by this local beta. See [plugin packaging](https://developers.openai.com/plugins/build/plugins) and [submission](https://developers.openai.com/plugins/deploy/submission).

Licensed under MIT. The separate runtime dependencies retain their own licenses and terms.
