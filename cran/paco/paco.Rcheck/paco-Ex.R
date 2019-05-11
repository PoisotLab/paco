pkgname <- "paco"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('paco')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
cleanEx()
nameEx("PACo")
### * PACo

flush(stderr()); flush(stdout())

### Name: PACo
### Title: Performs PACo analysis.
### Aliases: PACo

### ** Examples

data(gopherlice)
require(ape)
gdist <- cophenetic(gophertree)
ldist <- cophenetic(licetree)
D <- prepare_paco_data(gdist, ldist, gl_links)
D <- add_pcoord(D)
D <- PACo(D, nperm=10, seed=42, method="r0")
print(D$gof)



cleanEx()
nameEx("add_pcoord")
### * add_pcoord

flush(stderr()); flush(stdout())

### Name: add_pcoord
### Title: Principal Coordinates analysis of phylogenetic distance matrices
### Aliases: add_pcoord

### ** Examples

data(gopherlice)
library(ape)
gdist <- cophenetic(gophertree)
ldist <- cophenetic(licetree)
D <- prepare_paco_data(gdist, ldist, gl_links)
D <- add_pcoord(D)



cleanEx()
nameEx("paco_links")
### * paco_links

flush(stderr()); flush(stdout())

### Name: paco_links
### Title: Contribution of individual links
### Aliases: paco_links

### ** Examples

data(gopherlice)
require(ape)
gdist <- cophenetic(gophertree)
ldist <- cophenetic(licetree)
D <- prepare_paco_data(gdist, ldist, gl_links)
D <- add_pcoord(D)
D <- PACo(D, nperm=10, seed=42, method="r0")
D <- paco_links(D)



cleanEx()
nameEx("prepare_paco_data")
### * prepare_paco_data

flush(stderr()); flush(stdout())

### Name: prepare_paco_data
### Title: Prepares the data (distance matrices and association matrix) for
###   PACo analysis
### Aliases: prepare_paco_data

### ** Examples

data(gopherlice)
library(ape)
gdist <- cophenetic(gophertree)
ldist <- cophenetic(licetree)
D <- prepare_paco_data(gdist, ldist, gl_links)



cleanEx()
nameEx("residuals_paco")
### * residuals_paco

flush(stderr()); flush(stdout())

### Name: residuals_paco
### Title: Return Procrustes residuals from a paco object
### Aliases: residuals_paco

### ** Examples

data(gopherlice)
library(ape)
gdist <- cophenetic(gophertree)
ldist <- cophenetic(licetree)
D <- prepare_paco_data(gdist, ldist, gl_links)
D <- add_pcoord(D, correction='cailliez')
D <- PACo(D, nperm=100, seed=42, method='r0')
residuals_paco(D$proc)



### * <FOOTER>
###
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
