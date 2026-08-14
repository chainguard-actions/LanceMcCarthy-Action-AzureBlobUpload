<!-- markdownlint-disable -->

# Hardening Report: LanceMcCarthy--Action-AzureBlobUpload/v3.11.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **LanceMcCarthy--Action-AzureBlobUpload/v3.11.0** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

All four workflow files reference external actions using mutable version tags (@v6, @v4, @v7) instead of pinned 40-character commit SHAs. This exposes the workflow to supply-chain attacks if the upstream tag is moved or compromised. Affected references include: actions/checkout@v6, actions/setup-node@v6, actions/upload-artifact@v7, actions/download-artifact@v7, github/codeql-action/init@v4, github/codeql-action/autobuild@v4, github/codeql-action/analyze@v4.

Locations:

- `.github/workflows/codeql-analysis.yml:18`
- `.github/workflows/codeql-analysis.yml:22`
- `.github/workflows/codeql-analysis.yml:26`
- `.github/workflows/codeql-analysis.yml:29`
- `.github/workflows/issue_tests.yml:14`
- `.github/workflows/issue_tests.yml:16`
- `.github/workflows/issue_tests.yml:22`
- `.github/workflows/issue_tests.yml:78`
- `.github/workflows/issue_tests.yml:81`
- `.github/workflows/main_pr.yml:20`
- `.github/workflows/main_pr.yml:22`
- `.github/workflows/main_pr.yml:29`
- `.github/workflows/main_pr.yml:43`
- `.github/workflows/main_release.yml:20`
- `.github/workflows/main_release.yml:22`
- `.github/workflows/main_release.yml:29`
- `.github/workflows/main_release.yml:43`

### missing-permissions (severity: medium)

None of the four workflow files define a top-level 'permissions:' key, and no individual job defines its own 'permissions:' block. Without explicit permissions, workflows inherit the default repository token permissions, which may be broader than necessary (e.g. write access to contents). Each workflow should declare minimal required permissions.

Locations:

- `.github/workflows/codeql-analysis.yml:1`
- `.github/workflows/issue_tests.yml:1`
- `.github/workflows/main_pr.yml:1`
- `.github/workflows/main_release.yml:1`

### script-injection (severity: high)

Sub-rule (a): ${{ runner.temp }} expressions are interpolated directly inside run: shell command strings. Any ${{ ... }} expression inside a run: block is a script-injection risk because the value is substituted into the shell command string before the shell parses it. The safe alternative is to use the $RUNNER_TEMP environment variable instead. Offending lines include: `mkdir -p ${{runner.temp}}/my-data`, `do echo "Test file $i" > ${{runner.temp}}/my-data/file_$i.txt`, `New-Item -ItemType Directory -Force -Path "${{runner.temp}}/my-data"`, and `Out-File "${{runner.temp}}/my-data/file_$_.txt"`.

Locations:

- `.github/workflows/main_pr.yml:49`
- `.github/workflows/main_pr.yml:51`
- `.github/workflows/main_pr.yml:72`
- `.github/workflows/main_pr.yml:73`
- `.github/workflows/main_release.yml:49`
- `.github/workflows/main_release.yml:51`
- `.github/workflows/main_release.yml:71`
- `.github/workflows/main_release.yml:72`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions, script-injection

**Notes:**

Fixed all four workflow files:

1. unpinned-uses: Pinned all external action references to full 40-char commit SHAs with tag comments:
   - actions/checkout@v6 → d23441a48e516b6c34aea4fa41551a30e30af803
   - actions/setup-node@v6 → 249970729cb0ef3589644e2896645e5dc5ba9c38
   - actions/upload-artifact@v7 → 043fb46d1a93c77aae656e7c1c64a875d1fc6a0a
   - actions/download-artifact@v7 → 37930b1c2abaa49bbe596cd826c3c89aef350131
   - github/codeql-action/{init,autobuild,analyze}@v4 → e4fba868fa4b1b91e1fdab776edc8cfbe6e9fb81

2. missing-permissions: Added top-level permissions blocks to all four files. codeql-analysis.yml gets 'contents: read' + 'security-events: write' (required for CodeQL to upload results). The other three get 'contents: read' only.

3. script-injection: Replaced ${{runner.temp}} in run: shell blocks with $RUNNER_TEMP (bash) and $env:RUNNER_TEMP (PowerShell). The ${{runner.temp}} references in action 'with:' input blocks are not shell commands and were left as-is.

