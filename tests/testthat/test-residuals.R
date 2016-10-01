context ("residuals")

run_example <- function (H, P, HP) {
  D <- prepare_paco_data(H, P, HP)
  D <- add_pcoord(D, correction='none')
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
  expect_error (residuals_paco(D$proc))
})

test_that ("residuals give out the expected type", {
  expect_is (residuals_paco(D$proc), "numeric")
  expect_is (residuals_paco(D$proc, type = "interaction"), "numeric")
  expect_is (residuals_paco(D$proc, type = "matrix"), "matrix")
})

test_that ("residuals are named", {
  expect_is (names (residuals_paco(D$proc)), "character")
  expect_is (names (residuals_paco(D$proc, type = "matrix")), "NULL")
  expect_is (rownames (residuals_paco(D$proc, type = "matrix")), "character")
})
