context ("gopherlice example")

run_example <- function (H, P, HP) {
  D <- prepare_paco_data(H, P, HP)
  D <- add_pcoord(D)
  D <- PACo(D, nperm = 10, seed = 42, method="r0")
  return (D$gof)
}

test_that ("paco example works as expected", {
  
  data(gopherlice)
  library(ape)
  gdist <- cophenetic(gophertree)
  ldist <- cophenetic(licetree)
  
  expect_equal (run_example (gdist, ldist, gl_links)$p, 0)
  expect_equal (run_example (gdist, ldist, gl_links)$n, 10)
  
})
