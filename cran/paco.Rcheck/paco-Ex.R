pkgname <- "paco"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
base::assign(".ExTimings", "paco-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('paco')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
cleanEx()
nameEx("PACo")
### * PACo

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: PACo
### Title: Performs PACo/procustes analysis
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



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("PACo", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("add_pcoord")
### * add_pcoord

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: add_pcoord
### Title: Principle coordinate analysis of phylogenies
### Aliases: add_pcoord

### ** Examples

data(gopherlice)
library(ape)
gdist <- cophenetic(gophertree)
ldist <- cophenetic(licetree)
D <- prepare_paco_data(gdist, ldist, gl_links)
D <- add_pcoord(D)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("add_pcoord", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("prepare_paco_data")
### * prepare_paco_data

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: prepare_paco_data
### Title: Prepare the data Simple wrapper to make sure that the matrices
###   are sorted accordingly
### Aliases: prepare_paco_data

### ** Examples

data(gopherlice)
library(ape)
gdist <- cophenetic(gophertree)
ldist <- cophenetic(licetree)
D <- prepare_paco_data(gdist, ldist, gl_links)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("prepare_paco_data", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
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
