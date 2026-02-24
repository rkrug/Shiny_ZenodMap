# Extract relation types present between community records

Extract relation types present between community records

## Usage

``` r
extract_relations(
  records,
  community_ids = NULL,
  concept_map = NULL,
  map_versioned_to_concept = FALSE,
  version_to_concept_map = NULL
)
```

## Arguments

- records:

  List of Zenodo records.

- community_ids:

  Character vector of community record ids.

- concept_map:

  Optional map of concept id to record id.

- map_versioned_to_concept:

  Logical; map versioned ids to concept ids.

- version_to_concept_map:

  Optional map of record id to concept id.

## Value

Character vector of relation labels.
