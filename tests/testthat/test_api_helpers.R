test_that("build_api_url assembles query parameters", {
  url <- build_api_url("climate", "ipbes", size = 5, page = 2)
  expect_true(grepl("communities=ipbes", url))
  expect_true(grepl("size=5", url))
  expect_true(grepl("page=2", url))
  expect_true(grepl("q=climate", url))
})

test_that("build_api_url returns base URL when all params are empty", {
  url <- build_api_url("", NULL, NULL, NULL)
  expect_equal(url, "https://zenodo.org/api/records")
})

test_that("build_query handles NULL and blank values", {
  expect_null(build_query(NULL))
  expect_null(build_query(""))
  expect_equal(build_query(" climate "), "climate")
})
