# PACo

This package implements the functions neeeded to perform `PACo` (Balbuena
et al. 2013) in `R`.

Balbuena, Juan Antonio, Raúl Míguez-Lozano, and Isabel Blasco-Costa. “PACo:
A Novel Procrustes Application to Cophylogenetic Analysis.” *PLoS ONE* 8,
no. 4 (2013): e61048. doi:[10.1371/journal.pone.0061048][doi].

## How to use

~~~ R
library(paco)

# hdist <- host distance matrix
# pdist <- parasite distance matrix
# A <- association matrix

# Step 1 -- generate data
D <- list(H = hdist, P = pdist, HP = A)

# Step 2 -- goodness of fit
D <- proc_analysis(D, seed=42, nperm=1000)

print(D$gof)

# Step 3 -- individual link contribution
D <- link_contribution(D)

print(D$jacknife)
~~~

[doi]: http://dx.doi.org/10.1371/journal.pone.0061048
