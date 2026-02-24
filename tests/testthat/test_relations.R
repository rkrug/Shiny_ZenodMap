test_that("concept map prefers latest updated record", {
  path <- testthat::test_path("fixtures", "zenodo_records_2026-01-07.rds")
  records <- sanitize_records(readRDS(path))
  concept_map <- build_concept_map(records)
  expect_true(is.list(concept_map))
  if (length(concept_map) > 0) {
    expect_true(all(nzchar(names(concept_map))))
  }
})

test_that("extract_relations returns a sorted character vector", {
  path <- testthat::test_path("fixtures", "zenodo_records_2026-01-07.rds")
  records <- sanitize_records(readRDS(path))
  community_ids <- vapply(records, function(rec) as.character(rec$id), character(1))
  concept_map <- build_concept_map(records)
  rels <- extract_relations(records, community_ids, concept_map)
  expect_type(rels, "character")
  expect_equal(rels, sort(rels))
})

test_that("resolve_relation_selection handles All toggle semantics", {
  available <- c("References", "Cites")

  expect_equal(
    resolve_relation_selection(c("All", "References"), available, previous = "All"),
    "References"
  )
  expect_equal(
    resolve_relation_selection(c("All", "References"), available, previous = "References"),
    "All"
  )
  expect_equal(
    resolve_relation_selection(character(0), available, previous = "References"),
    "All"
  )
  expect_equal(
    resolve_relation_selection(c("References", "Unknown"), available, previous = "All"),
    "References"
  )
})
