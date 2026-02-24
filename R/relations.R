#' Extract relation types present between community records
#'
#' @param records List of Zenodo records.
#' @param community_ids Character vector of community record ids.
#' @param concept_map Optional map of concept id to record id.
#' @param map_versioned_to_concept Logical; map versioned ids to concept ids.
#' @param version_to_concept_map Optional map of record id to concept id.
#' @return Character vector of relation labels.
extract_relations <- function(
  records,
  community_ids = NULL,
  concept_map = NULL,
  map_versioned_to_concept = FALSE,
  version_to_concept_map = NULL
) {
  relations <- unique(unlist(lapply(records, function(rec) {
    related <- rec$metadata$related_identifiers
    if (is.null(related) || length(related) == 0) {
      return(character(0))
    }
    rels <- vapply(related, function(ri) {
      rel <- ri$relation %||% ""
      ident <- ri$identifier %||% ""
      zenodo_id <- zenodo_id_from_identifier(ident)
      if (
        map_versioned_to_concept &&
          !is.null(version_to_concept_map) &&
          !is.na(zenodo_id) &&
          zenodo_id %in% names(version_to_concept_map)
      ) {
        zenodo_id <- version_to_concept_map[[zenodo_id]]
      } else if (!is.null(concept_map) && !is.na(zenodo_id) && zenodo_id %in% names(concept_map)) {
        zenodo_id <- concept_map[[zenodo_id]]
      }
      if (!is.null(community_ids) && (is.na(zenodo_id) || !(zenodo_id %in% community_ids))) {
        return("")
      }
      rel
    }, character(1))
    rels[rels != ""]
  })))
  sort(relations)
}

#' Resolve effective relation selection from UI state
#'
#' @param selected Current selected relation values.
#' @param available Available relation choices (without `All`).
#' @param previous Previously applied selection.
#' @return Character vector of effective selections.
resolve_relation_selection <- function(selected, available, previous = "All") {
  choices <- c("All", available)
  current <- selected
  if (is.null(current) || length(current) == 0) {
    current <- "All"
  }
  current <- unique(current[current %in% choices])
  if (length(current) == 0) {
    current <- "All"
  }

  prev <- previous
  if (is.null(prev) || length(prev) == 0) {
    prev <- "All"
  }
  prev <- unique(prev)

  if ("All" %in% current && length(current) > 1) {
    if ("All" %in% prev) {
      # User added one or more specific relations while "All" was active.
      current <- setdiff(current, "All")
    } else {
      # User selected "All" while specific relations were active.
      current <- "All"
    }
  }

  if (length(current) == 0) {
    current <- "All"
  }
  current
}
