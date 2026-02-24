# Development History and Rationale

Last updated: 2026-02-24

## Purpose

This document captures what was changed in this repository, why those
changes were made, and how the current behavior should be understood by
both human contributors and AI coding agents.

## Project Snapshot

- Project type: R package + Shiny app (`zenodoMap`)
- Main app entry points:
  - Package runtime:
    [`zenodoMap::run_app()`](https://rkrug.github.io/zenodoMap/reference/run_app.md)
  - Deployment entry script: `app.R`
- Core areas:
  - API fetch: `R/api.R`
  - Records and relation parsing: `R/records.R`, `R/relations.R`,
    `R/identifiers.R`
  - Graph build: `R/graph.R`
  - App behavior: `R/server.R`, `R/ui.R`

## What Was Done and Why

### 1. Verification baseline and cleanup

Changes: - Ran `make test` and `make check`. - Removed stale nested
cassette files under `tests/testthat/tests/...`. - Added
`inst/zenodo_records_*.rds` to `.gitignore`.

Why: - Establish a clean quality baseline before changing behavior. -
Remove test artifacts that were not part of the active test path. -
Prevent accidental committing of generated local record dumps.

### 2. Reliability fixes in helpers and tests

Changes: - `build_query(NULL)` now returns `NULL` instead of erroring. -
[`build_api_url()`](https://rkrug.github.io/zenodoMap/reference/build_api_url.md)
now returns base URL without trailing `?` when no params exist. -
Re-enabled VCR fetch assertions and fixed VCR directory resolution via
`testthat::test_path(...)`.

Why: - Helpers should be stable for programmatic use. - URL construction
should not emit malformed/noisy output. - VCR tests must actually
validate behavior and run reliably in testthat execution context.

### 3. Relation filter correctness in graph generation

Changes: - Added deterministic relation selection resolution (including
`"All"` toggle behavior). - Graph building now uses the resolved
relation selection from the same reactive cycle. - Added regression
tests for relation semantics and relation-filtered graph output.

Why: - Previously there was a mismatch between checkbox state and the
relation set actually used to build the graph. - Users must see exactly
the links implied by the active filter selection.

### 4. UI redesign for usability

Changes: - Reworked UI visual design with stronger typography, card
layout, and better hierarchy. - Split controls into tabs: - `Data` -
`Explore` - `Settings` (physics controls moved here)

Why: - The previous control area mixed common and advanced options. -
Separation improves discoverability and reduces cognitive load for
normal workflows.

### 5. Table and graph synchronization improvements

Changes: - Improved node-to-table synchronization: - Jump to target
DataTable page. - Select row. - Scroll row into visible area. -
Normalized ID matching to robustly handle numeric/string differences.

Why: - Selecting a node should deterministically highlight and reveal
the corresponding metadata row. - DataTables frequently requires
explicit pagination navigation before row selection is visible.

### 6. Viewport-based layout behavior

Changes: - App main row now sizes relative to viewport height. -
Controls and graph panel are constrained to same available height. -
Metadata table and status panel use internal scrolling to avoid
uncontrolled page growth.

Why: - Prevent one panel from expanding and collapsing the useful graph
area. - Keep core interaction surfaces visible without excessive page
scrolling.

### 7. Concept DOI mapping option for versioned links

Changes: - Added Explore toggle: `map_versioned_to_concept`. - Added
[`build_version_to_concept_map()`](https://rkrug.github.io/zenodoMap/reference/build_version_to_concept_map.md)
in `R/records.R`. - Updated relation extraction and graph build to
optionally map versioned record IDs to concept IDs. - Added tests to
cover this behavior.

Why: - Zenodo often includes both versioned DOIs and concept DOIs. - For
many exploration tasks, concept-level linking produces cleaner, less
fragmented graphs.

## Current Behavior Summary

- By default, versioned relation targets behave as before.
- If `Map versioned DOIs to concept IDs` is enabled:
  - Relation targets are remapped to concept IDs when mapping is known
    in loaded records.
  - Relation filters and graph generation both apply that mapping
    consistently.

## Testing and Quality Notes

- Current automated status (latest local run):
  - `make test`: passing
  - `make check`: passing except environment note
    (`unable to verify current time`)
- Existing tests are primarily unit/fixture-level. Interactive UI
  behavior is validated manually.

## Contributor Guidance

- Keep input IDs stable unless server logic is updated in the same
  change.
- For UI callbacks, assume DataTables may require explicit page changes
  before selection is visible.
- For relation/graph changes, always add or update tests in:
  - `tests/testthat/test_relations.R`
  - `tests/testthat/test_graph.R`
- If you add contributor docs intended for repo users but not package
  bundles, add them to `.Rbuildignore`.
