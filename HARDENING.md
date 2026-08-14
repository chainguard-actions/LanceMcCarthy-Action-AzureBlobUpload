<!-- markdownlint-disable -->

# Hardening Report: LanceMcCarthy--Action-AzureBlobUpload/v3.12.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **LanceMcCarthy--Action-AzureBlobUpload/v3.12.0** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple workflow files reference actions using mutable tags instead of full 40-character commit SHAs. This exposes the workflow to supply-chain attacks if the tag is moved. Affected references: codeql-analysis.yml uses actions/checkout@v6, github/codeql-action/init@v4, github/codeql-action/autobuild@v4, github/codeql-action/analyze@v4; issue_tests.yml uses actions/checkout@v6, actions/setup-node@v6, actions/upload-artifact@v7, actions/download-artifact@v7; main_pr.yml uses actions/checkout@v6, actions/setup-node@v6, actions/upload-artifact@v7, actions/download-artifact@v8; main_release.yml uses actions/checkout@v6, actions/setup-node@v6, actions/upload-artifact@v7, actions/download-artifact@v8.

Locations:

- `.github/workflows/codeql-analysis.yml:19`
- `.github/workflows/codeql-analysis.yml:23`
- `.github/workflows/codeql-analysis.yml:27`
- `.github/workflows/codeql-analysis.yml:30`
- `.github/workflows/issue_tests.yml:10`
- `.github/workflows/issue_tests.yml:12`
- `.github/workflows/issue_tests.yml:18`
- `.github/workflows/issue_tests.yml:36`
- `.github/workflows/main_pr.yml:30`
- `.github/workflows/main_pr.yml:32`
- `.github/workflows/main_pr.yml:40`
- `.github/workflows/main_pr.yml:57`
- `.github/workflows/main_release.yml:29`
- `.github/workflows/main_release.yml:31`
- `.github/workflows/main_release.yml:39`
- `.github/workflows/main_release.yml:55`

### missing-permissions (severity: medium)

None of the workflow files define a top-level `permissions:` key, and no individual job defines its own `permissions:` block. Without explicit permissions, workflows inherit the default repository permissions (which may include write access), violating the principle of least privilege.

Locations:

- `.github/workflows/codeql-analysis.yml:1`
- `.github/workflows/issue_tests.yml:1`
- `.github/workflows/main_pr.yml:1`
- `.github/workflows/main_release.yml:1`

### script-injection (severity: high)

Sub-rule (a): `${{ runner.temp }}` is interpolated directly inside `run:` shell command strings. Any `${{ ... }}` expression directly inside a run: block is a script-injection risk because the value is substituted into the shell command string before the shell parses it. Offending lines in main_pr.yml: `mkdir -p ${{runner.temp}}/my-data` and `do echo "Test file $i" > ${{runner.temp}}/my-data/file_$i.txt;` (Linux job), and `New-Item -ItemType Directory -Force -Path "${{runner.temp}}/my-data"` and `Out-File "${{runner.temp}}/my-data/file_$_.txt"` (Windows job). Same pattern repeated in main_release.yml.

Locations:

- `.github/workflows/main_pr.yml:63`
- `.github/workflows/main_pr.yml:65`
- `.github/workflows/main_pr.yml:97`
- `.github/workflows/main_pr.yml:98`
- `.github/workflows/main_release.yml:62`
- `.github/workflows/main_release.yml:64`
- `.github/workflows/main_release.yml:96`
- `.github/workflows/main_release.yml:97`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions, script-injection

**Notes:**

Fixed all four workflow files:

1. unpinned-uses: Pinned all mutable tag references to full 40-char SHAs with tag comments preserved: actions/checkout@v6→d23441a4, actions/setup-node@v6→249970729, actions/upload-artifact@v7→043fb46d, actions/download-artifact@v7→37930b1c, actions/download-artifact@v8→3e5f45b2, github/codeql-action/{init,autobuild,analyze}@v4→7188fc36.

2. missing-permissions: Added top-level `permissions:` blocks to all four files. codeql-analysis.yml gets `contents: read` + `security-events: write` (required for CodeQL to upload results); the other three get `contents: read` only.

3. script-injection: In main_pr.yml and main_release.yml, moved `${{ runner.temp }}` out of `run:` shell strings into step-level `env:` blocks as `RUNNER_TEMP`. Bash steps now use `"$RUNNER_TEMP/..."` and PowerShell steps use `"$env:RUNNER_TEMP/..."`. The `source_folder:` action input values still use `${{runner.temp}}` since those are YAML action inputs (not shell-interpreted strings) and are not subject to shell injection.

