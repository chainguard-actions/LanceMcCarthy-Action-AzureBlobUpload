<!-- markdownlint-disable -->

# Hardening Report: LanceMcCarthy--Action-AzureBlobUpload/v3.8.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **LanceMcCarthy--Action-AzureBlobUpload/v3.8.0** was hardened automatically. 8 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

All `uses:` references in this workflow use mutable tag refs instead of pinned 40-character SHA commit hashes, making the workflow vulnerable to supply-chain attacks if the referenced action tags are moved. Failing refs: `actions/checkout@v6`, `github/codeql-action/init@v4`, `github/codeql-action/autobuild@v4`, `github/codeql-action/analyze@v4`.

Locations:

- `.github/workflows/codeql-analysis.yml:16`
- `.github/workflows/codeql-analysis.yml:20`
- `.github/workflows/codeql-analysis.yml:25`
- `.github/workflows/codeql-analysis.yml:29`

### unpinned-uses (severity: high)

All `uses:` references in this workflow use mutable tag refs instead of pinned 40-character SHA commit hashes. Failing refs: `actions/checkout@v6`, `actions/setup-node@v6`.

Locations:

- `.github/workflows/issue_tests.yml:12`
- `.github/workflows/issue_tests.yml:14`
- `.github/workflows/issue_tests.yml:27`
- `.github/workflows/issue_tests.yml:37`
- `.github/workflows/issue_tests.yml:83`

### unpinned-uses (severity: high)

All `uses:` references in this workflow use mutable tag refs instead of pinned 40-character SHA commit hashes. Failing refs: `actions/checkout@v6`, `actions/setup-node@v6`.

Locations:

- `.github/workflows/main_pr.yml:15`
- `.github/workflows/main_pr.yml:17`
- `.github/workflows/main_pr.yml:32`

### unpinned-uses (severity: high)

All `uses:` references in this workflow use mutable tag refs instead of pinned 40-character SHA commit hashes. Failing refs: `actions/checkout@v6`, `actions/setup-node@v6`, `actions/checkout@v5`.

Locations:

- `.github/workflows/main_release.yml:15`
- `.github/workflows/main_release.yml:17`
- `.github/workflows/main_release.yml:32`
- `.github/workflows/main_release.yml:83`
- `.github/workflows/main_release.yml:122`

### missing-permissions (severity: medium)

This workflow file has no top-level `permissions:` key and no job-level `permissions:` key on any job. Without explicit permissions, the workflow inherits the default (potentially broad) repository permissions. Add a top-level `permissions:` block with the minimum required scopes (e.g., `contents: read`).

Locations:

- `.github/workflows/codeql-analysis.yml:1`

### missing-permissions (severity: medium)

This workflow file has no top-level `permissions:` key and no job-level `permissions:` key on any job. Without explicit permissions, the workflow inherits the default (potentially broad) repository permissions. Add a top-level `permissions:` block with the minimum required scopes.

Locations:

- `.github/workflows/issue_tests.yml:1`

### missing-permissions (severity: medium)

This workflow file has no top-level `permissions:` key and no job-level `permissions:` key on any job. Without explicit permissions, the workflow inherits the default (potentially broad) repository permissions. Add a top-level `permissions:` block with the minimum required scopes.

Locations:

- `.github/workflows/main_pr.yml:1`

### missing-permissions (severity: medium)

This workflow file has no top-level `permissions:` key and no job-level `permissions:` key on any job. Without explicit permissions, the workflow inherits the default (potentially broad) repository permissions. Add a top-level `permissions:` block with the minimum required scopes.

Locations:

- `.github/workflows/main_release.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

Fixed all 4 workflow files:

1. codeql-analysis.yml: Pinned actions/checkout@v6, github/codeql-action/init@v4, github/codeql-action/autobuild@v4, github/codeql-action/analyze@v4 to full SHAs. Added permissions block (contents: read, security-events: write).

2. issue_tests.yml: Pinned actions/checkout@v6 and actions/setup-node@v6 to full SHAs. Added permissions block (contents: read).

3. main_pr.yml: Pinned actions/checkout@v6 and actions/setup-node@v6 to full SHAs. Added permissions block (contents: read).

4. main_release.yml: Pinned actions/checkout@v6, actions/setup-node@v6, and actions/checkout@v5 to full SHAs. Added permissions block (contents: read).

All SHAs were resolved via lookup_action_sha. Tag comments preserved for readability.

