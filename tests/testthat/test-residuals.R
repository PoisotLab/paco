context ("residuals")

run_example <- function (H, P, HP) {
  D <- prepare_paco_data(H, P, HP)
  D <- add_pcoord(D)
  D <- PACo(D, nperm = 10, seed = 42, method="r0")
  D <- paco_links (D)
}

data(gopherlice)
library(ape)
gdist <- cophenetic(gophertree)
ldist <- cophenetic(licetree)
D <- run_example (gdist, ldist, gl_links)


test_that ("there is an error if there is no procrustes object", {
  D$proc <- NULL
  expect_error (residuals (D))
})

test_that ("residuals give out the expected type", {
  expect_is (residuals (D), "numeric")
  expect_is (residuals (D, type = "interaction"), "numeric")
  expect_is (residuals (D, type = "matrix"), "matrix")
})

test_that ("residuals are named", {
  expect_is (names (residuals (D)), "character")
  expect_is (names (residuals (D, type = "matrix")), "NULL")
  expect_is (rownames (residuals (D, type = "matrix")), "character")
})