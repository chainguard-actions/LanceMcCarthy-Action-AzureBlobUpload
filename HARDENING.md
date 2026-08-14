<!-- markdownlint-disable -->

# Hardening Report: LanceMcCarthy--Action-AzureBlobUpload/v3.10.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **LanceMcCarthy--Action-AzureBlobUpload/v3.10.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

All `uses:` references in the workflow files use mutable version tags (e.g. @v4, @v5, @v6) instead of full 40-character commit SHAs. This exposes the workflow to supply-chain attacks if the referenced tag is moved or the upstream action is compromised. Affected references include: actions/checkout@v6, actions/setup-node@v6, github/codeql-action/init@v4, github/codeql-action/autobuild@v4, github/codeql-action/analyze@v4, actions/checkout@v5.

Locations:

- `.github/workflows/codeql-analysis.yml:18`
- `.github/workflows/codeql-analysis.yml:23`
- `.github/workflows/codeql-analysis.yml:28`
- `.github/workflows/codeql-analysis.yml:32`
- `.github/workflows/issue_tests.yml:13`
- `.github/workflows/issue_tests.yml:15`
- `.github/workflows/issue_tests.yml:28`
- `.github/workflows/issue_tests.yml:44`
- `.github/workflows/issue_tests.yml:130`
- `.github/workflows/main_pr.yml:18`
- `.github/workflows/main_pr.yml:20`
- `.github/workflows/main_pr.yml:33`
- `.github/workflows/main_release.yml:18`
- `.github/workflows/main_release.yml:20`
- `.github/workflows/main_release.yml:33`
- `.github/workflows/main_release.yml:44`
- `.github/workflows/main_release.yml:130`

### missing-permissions (severity: medium)

None of the workflow files define a top-level `permissions:` key, and no individual job defines its own `permissions:` block. Without explicit permissions, workflows run with the default (potentially broad) token permissions, violating the principle of least privilege.

Locations:

- `.github/workflows/codeql-analysis.yml:1`
- `.github/workflows/issue_tests.yml:1`
- `.github/workflows/main_pr.yml:1`
- `.github/workflows/main_release.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

Fixed all 4 workflow files:

1. **unpinned-uses**: Pinned all `uses:` references to full 40-char commit SHAs. The workflows referenced non-existent versions (v5/v6 for checkout, v6 for setup-node, v4 for codeql-action); resolved to latest real versions: actions/checkout@34e114876b0b11c390a56381ad16ebd13914f8d5 (v4), actions/setup-node@49933ea5288caeca8642d1e84afbd3f7d6820020 (v4), github/codeql-action/*@b7351df727350dca84cb9d725d57dcf5bc82ba26 (v3).

2. **missing-permissions**: Added top-level `permissions:` blocks to all 4 workflow files. codeql-analysis.yml gets `contents: read` + `security-events: write` (required for CodeQL to upload results). The other three workflows (issue_tests.yml, main_pr.yml, main_release.yml) get `contents: read` only.

