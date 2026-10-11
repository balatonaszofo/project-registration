[CmdletBinding()]
param([string]$ProfileRoot = $env:USERPROFILE, [switch]$EnableAutomaticSetup)
$ErrorActionPreference = 'Stop'
$pluginSource = $PSScriptRoot
$profilePath = [IO.Path]::GetFullPath($ProfileRoot)
$pluginDestination = Join-Path $profilePath '.codex/plugins/project-registration'
$marketplaceFile = Join-Path $profilePath '.agents/plugins/marketplace.json'
$instructionsFile = Join-Path $profilePath '.codex/AGENTS.md'
$skillNames = @('register-project', 'start-project')
$manifest = Get-Content -LiteralPath (Join-Path $pluginSource 'plugin.json') -Raw | ConvertFrom-Json
if ($manifest.name -ne 'project-registration') { throw 'Unexpected plugin manifest.' }
foreach ($skillName in $skillNames) {
    if (-not (Test-Path -LiteralPath (Join-Path $pluginSource "skills/$skillName/SKILL.md"))) { throw "Missing skill: $skillName" }
    $destination = Join-Path $profilePath ".codex/skills/$skillName"
    if ((Test-Path -LiteralPath $destination) -and -not (Test-Path -LiteralPath (Join-Path $destination '.project-registration-owned'))) {
        throw "Existing independent skill $skillName; no files changed. Install through the plugin directory instead."
    }
}
if (Test-Path -LiteralPath $marketplaceFile) {
    $marketplace = Get-Content -LiteralPath $marketplaceFile -Raw | ConvertFrom-Json
    if (-not $marketplace.name -or -not $marketplace.PSObject.Properties['plugins']) { throw 'Unsupported marketplace; no files changed.' }
} else {
    $marketplace = [pscustomobject]@{ name = 'personal-local-plugins'; interface = @{ displayName = 'Personal Local Plugins' }; plugins = @() }
}
$entry = [pscustomobject]@{
    name = 'project-registration'
    source = @{ source = 'local'; path = './.codex/plugins/project-registration' }
    policy = @{ installation = 'AVAILABLE'; authentication = 'ON_INSTALL' }
    category = 'Productivity'
}
$existingEntry = @($marketplace.plugins | Where-Object { $_.name -eq $entry.name })
if ($existingEntry.Count -gt 0 -and $existingEntry[0].source.path -ne $entry.source.path) { throw 'Different plugin source registered; no files changed.' }
New-Item -ItemType Directory -Path $pluginDestination -Force | Out-Null
foreach ($file in @('plugin.json', 'README.md', 'LICENSE')) {
    Copy-Item -LiteralPath (Join-Path $pluginSource $file) -Destination (Join-Path $pluginDestination $file) -Force
}
foreach ($skillName in $skillNames) {
    foreach ($destination in @((Join-Path $pluginDestination "skills/$skillName"), (Join-Path $profilePath ".codex/skills/$skillName"))) {
        New-Item -ItemType Directory -Path $destination -Force | Out-Null
        Copy-Item -Path (Join-Path $pluginSource "skills/$skillName/*") -Destination $destination -Recurse -Force
        Set-Content -LiteralPath (Join-Path $destination '.project-registration-owned') -Value $manifest.version -Encoding utf8
    }
}
if ($existingEntry.Count -eq 0) {
    $marketplace.plugins = @($marketplace.plugins) + @($entry)
    New-Item -ItemType Directory -Path (Split-Path $marketplaceFile) -Force | Out-Null
    if (Test-Path -LiteralPath $marketplaceFile) { Copy-Item -LiteralPath $marketplaceFile -Destination ($marketplaceFile + '.before-project-registration.bak') -Force }
    $marketplace | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $marketplaceFile -Encoding utf8
}
if ($EnableAutomaticSetup) {
    $instructions = if (Test-Path -LiteralPath $instructionsFile) { Get-Content -LiteralPath $instructionsFile -Raw } else { '' }
    if (-not $instructions.Contains('<!-- project-registration:auto -->')) {
        if (Test-Path -LiteralPath $instructionsFile) { Copy-Item -LiteralPath $instructionsFile -Destination ($instructionsFile + '.before-project-registration.bak') -Force }
        $block = @'
<!-- project-registration:auto -->
When substantive new build or design work starts in an automatically generated projectless local chat, apply the installed start-project skill. Reuse existing projects. Skip advice-only questions and workspaces whose AGENTS.md defines a purpose. Apply register-project to save the folder through Windows app controls; pause for the user's folder trust action. Continue the requested work after setup.
<!-- /project-registration:auto -->
'@
        Set-Content -LiteralPath $instructionsFile -Value ($instructions.TrimEnd() + "`n" + $block + "`n") -Encoding utf8
    }
}
Write-Output "Installed project-registration $($manifest.version) into $profilePath"
Write-Output 'Reload Codex to discover the skills and local marketplace entry.'
