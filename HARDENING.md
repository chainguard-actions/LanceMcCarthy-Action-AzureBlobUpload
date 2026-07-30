<!-- markdownlint-disable -->

# Hardening Report: LanceMcCarthy--Action-AzureBlobUpload/v3.17.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **LanceMcCarthy--Action-AzureBlobUpload/v3.17.0** was hardened automatically. 0 finding(s) were identified and resolved across 1 iteration(s).

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions, script-injection

**Notes:**

Fixed all findings across 4 workflow files:

1. unpinned-uses: Pinned all 7 action references to full SHA digests (actions/checkout@v7→3d3c42e5, actions/setup-node@v7→82076278, actions/upload-artifact@v7→043fb46d, actions/download-artifact@v8→3e5f45b2, github/codeql-action/{init,autobuild,analyze}@v4→f205ea1c). Tag comments preserved for readability.

2. missing-permissions: Added top-level `permissions: contents: read` to issue_tests.yml, main_pr.yml, and main_release.yml. Added `permissions: contents: read` + `security-events: write` to codeql-analysis.yml (security-events write is required for CodeQL to upload SARIF results).

3. script-injection: Replaced `${{runner.temp}}` inside `run:` shell strings with `$RUNNER_TEMP` (bash) and `$env:RUNNER_TEMP` (PowerShell) in both main_pr.yml and main_release.yml (Linux_TempDir_Test and Windows_TempDir_Test jobs). The `source_folder:` action input values using `${{runner.temp}}` were left as-is since those are YAML `with:` parameters passed to the action, not shell command strings.

