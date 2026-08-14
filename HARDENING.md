<!-- markdownlint-disable -->

# Hardening Report: LanceMcCarthy--Action-AzureBlobUpload/v3.9.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **LanceMcCarthy--Action-AzureBlobUpload/v3.9.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

All workflow files use mutable tag-based refs instead of pinned 40-character SHA commit hashes, making them vulnerable to supply-chain attacks if the referenced action tags are moved. Failing references include: actions/checkout@v6, actions/setup-node@v6, github/codeql-action/init@v4, github/codeql-action/autobuild@v4, github/codeql-action/analyze@v4, and actions/checkout@v5.

Locations:

- `.github/workflows/codeql-analysis.yml:24`
- `.github/workflows/codeql-analysis.yml:28`
- `.github/workflows/codeql-analysis.yml:32`
- `.github/workflows/codeql-analysis.yml:35`
- `.github/workflows/issue_tests.yml:13`
- `.github/workflows/issue_tests.yml:15`
- `.github/workflows/issue_tests.yml:30`
- `.github/workflows/issue_tests.yml:47`
- `.github/workflows/issue_tests.yml:113`
- `.github/workflows/main_pr.yml:19`
- `.github/workflows/main_pr.yml:21`
- `.github/workflows/main_pr.yml:35`
- `.github/workflows/main_release.yml:19`
- `.github/workflows/main_release.yml:21`
- `.github/workflows/main_release.yml:35`
- `.github/workflows/main_release.yml:48`
- `.github/workflows/main_release.yml:115`

### missing-permissions (severity: medium)

None of the workflow files define a top-level `permissions:` key, and no individual job within any of these files defines a `permissions:` key either. Without explicit permissions, workflows run with the default (potentially broad) token permissions, violating the principle of least privilege.

Locations:

- `.github/workflows/codeql-analysis.yml:1`
- `.github/workflows/issue_tests.yml:1`
- `.github/workflows/main_pr.yml:1`
- `.github/workflows/main_release.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

Fixed all 4 workflow files: (1) Pinned all action references to full 40-char SHA hashes with tag comments preserved: actions/checkout@v6→d23441a4, actions/checkout@v5→fbc6f399, actions/setup-node@v6→24997072, github/codeql-action/{init,autobuild,analyze}@v4→7188fc36. (2) Added top-level permissions blocks to all 4 workflows: codeql-analysis.yml gets 'contents: read' + 'security-events: write' (required for CodeQL to upload SARIF results); the other three get 'contents: read' only.

