<!-- markdownlint-disable -->

# Hardening Report: LanceMcCarthy--Action-AzureBlobUpload/v3.15.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **LanceMcCarthy--Action-AzureBlobUpload/v3.15.0** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple workflow files reference GitHub Actions using mutable tags instead of full 40-character SHA commit hashes, making them vulnerable to supply-chain attacks. Unpinned references found:
- codeql-analysis.yml: actions/checkout@v7, github/codeql-action/init@v4, github/codeql-action/autobuild@v4, github/codeql-action/analyze@v4
- main_pr.yml: actions/checkout@v7, actions/setup-node@v6, actions/upload-artifact@v7, actions/download-artifact@v8
- main_release.yml: actions/checkout@v7, actions/setup-node@v6, actions/upload-artifact@v7, actions/download-artifact@v8
- issue_tests.yml: actions/checkout@v7, actions/setup-node@v6, actions/upload-artifact@v7, actions/download-artifact@v8

Locations:

- `.github/workflows/codeql-analysis.yml:24`
- `.github/workflows/codeql-analysis.yml:28`
- `.github/workflows/codeql-analysis.yml:32`
- `.github/workflows/codeql-analysis.yml:35`
- `.github/workflows/main_pr.yml:29`
- `.github/workflows/main_pr.yml:31`
- `.github/workflows/main_pr.yml:38`
- `.github/workflows/main_pr.yml:52`
- `.github/workflows/main_release.yml:29`
- `.github/workflows/main_release.yml:31`
- `.github/workflows/main_release.yml:38`
- `.github/workflows/main_release.yml:52`
- `.github/workflows/issue_tests.yml:11`
- `.github/workflows/issue_tests.yml:14`
- `.github/workflows/issue_tests.yml:21`
- `.github/workflows/issue_tests.yml:35`

### missing-permissions (severity: medium)

None of the workflow files define a top-level `permissions:` block, and no individual jobs define job-level permissions. Without explicit permissions, workflows run with the default (potentially broad) token permissions. All four workflow files are affected: codeql-analysis.yml, main_pr.yml, main_release.yml, and issue_tests.yml.

Locations:

- `.github/workflows/codeql-analysis.yml:1`
- `.github/workflows/main_pr.yml:1`
- `.github/workflows/main_release.yml:1`
- `.github/workflows/issue_tests.yml:1`

### script-injection (severity: high)

Sub-rule (a): The expression `${{runner.temp}}` is interpolated directly inside `run:` shell command blocks. Although `runner.temp` is GitHub-controlled, any `${{ ... }}` expression inside a `run:` block is a script-injection risk because the value is substituted by the YAML template engine before the shell ever sees it, bypassing shell quoting. The safe alternative is to use the pre-set environment variable `$RUNNER_TEMP` instead.

Affected steps in main_pr.yml (Linux job 'Generate temp files for upload test'):
  `mkdir -p ${{runner.temp}}/my-data`
  `do echo "Test file $i" > ${{runner.temp}}/my-data/file_$i.txt;`
Affected steps in main_pr.yml (Windows job 'Generate temp files for upload test'):
  `New-Item -ItemType Directory -Force -Path "${{runner.temp}}/my-data"`
  `... | Out-File "${{runner.temp}}/my-data/file_$_.txt"`
Same patterns repeated in main_release.yml.

Locations:

- `.github/workflows/main_pr.yml:57`
- `.github/workflows/main_pr.yml:59`
- `.github/workflows/main_pr.yml:77`
- `.github/workflows/main_pr.yml:78`
- `.github/workflows/main_release.yml:57`
- `.github/workflows/main_release.yml:59`
- `.github/workflows/main_release.yml:77`
- `.github/workflows/main_release.yml:78`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions, script-injection

**Notes:**

Fixed all three findings across four workflow files:

1. unpinned-uses: Pinned all action references to full 40-char SHAs with tag comments preserved: actions/checkout@v7→3d3c42e5, actions/setup-node@v6→249970729c, actions/upload-artifact@v7→043fb46d, actions/download-artifact@v8→3e5f45b2, github/codeql-action/{init,autobuild,analyze}@v4→e4fba868.

2. missing-permissions: Added top-level `permissions: contents: read` to main_pr.yml, main_release.yml, and issue_tests.yml. Added `permissions: contents: read` + `security-events: write` to codeql-analysis.yml (CodeQL requires security-events write permission).

3. script-injection: Replaced ${{runner.temp}} in run: shell blocks with $RUNNER_TEMP (bash/Linux) and $env:RUNNER_TEMP (PowerShell/Windows) in main_pr.yml and main_release.yml. The remaining ${{runner.temp}} references in with: input blocks are not shell injection risks and were left as-is.

