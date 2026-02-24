# Changelog

## zenodoMap 0.1.0

### New features

- Added a modernized Shiny UI with a clearer layout and dedicated
  control tabs: `Data`, `Explore`, and `Settings`.
- Added an `Explore` option to map versioned Zenodo DOI targets to
  concept IDs. This allows graph links to be visualized at concept level
  when enabled.
- Added helper utilities for concept mapping workflows, including
  [`build_version_to_concept_map()`](https://rkrug.github.io/zenodoMap/reference/build_version_to_concept_map.md).

### Bug fixes

- Fixed relation filter application so graph construction uses the
  resolved, current selection consistently in the same reactive cycle.
- Improved relation selector behavior around `"All"` to avoid ambiguous
  mixed states.
- Improved node-to-metadata-table synchronization: selecting a graph
  node now reliably selects the corresponding table row and navigates to
  the correct table page.
- Fixed helper edge cases:
  - `build_query(NULL)` now returns `NULL` instead of erroring.
  - [`build_api_url()`](https://rkrug.github.io/zenodoMap/reference/build_api_url.md)
    now returns the base URL cleanly when no parameters are set.

### Testing and maintenance

- Expanded test coverage for:
  - relation selection semantics,
  - graph relation filtering and node grouping,
  - version-to-concept mapping behavior.
- Repaired VCR test path configuration using
  [`testthat::test_path()`](https://testthat.r-lib.org/reference/test_path.html)
  for more robust cassette resolution.
- Removed stale nested cassette artifacts from old test paths.
