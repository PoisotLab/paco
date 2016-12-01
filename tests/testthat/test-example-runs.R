context ("gopherlice example")

run_example <- function (H, P, HP) {
    D <- prepare_paco_data(H, P, HP)
    D <- add_pcoord(D, correction='none')
    D <- PACo(D, nperm = 10, seed = 42, method="r0", proc.warnings=TRUE)
    D <- PACo(D, nperm = 10, seed = 42, method="r0", proc.warnings=FALSE)
    D <- paco_links(D)
}

test_that ("paco example works as expected", {

    data(gopherlice)
    library(ape)
    gdist <- cophenetic(gophertree)
    ldist <- cophenetic(licetree)

    expect_is (run_example (gdist, ldist, gl_links)$gof$p, "numeric")
    expect_is (run_example (gdist, ldist, gl_links)$gof$n, "numeric")

})

test_that ("using names in coordpcoa works", {

    data(gopherlice)
    library(ape)
    gdist <- cophenetic(gophertree)
    ldist <- cophenetic(licetree)

    D <- prepare_paco_data(gdist, ldist, gl_links)
    paco:::coordpcoa(D, rn=c(1:nrow(D)))

})

test_that ("using shuffling works", {

    data(gopherlice)
    library(ape)
    gdist <- cophenetic(gophertree)
    ldist <- cophenetic(licetree)

    D <- prepare_paco_data(gdist, ldist, gl_links)
    D <- add_pcoord(D, correction="none")
    D <- PACo(D, nperm = 10, seed = 42, method = "r0", shuffled = TRUE)

    expect_is (D$gof$n, "numeric")

}
