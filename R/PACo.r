#' Performs PACo/procustes analysis
#' @param D a list with the data
#' @param nperm Number of permutations
#' @param seed Seed if results need to be reproduced
#' @param margin The margin to sample (1 to sample rows, 2 to sample columns)
#' @export
#' @examples 
#' data(gopherlice)
#' library(ape)
#' gdist <- cophenetic(gophertree)
#' ldist <- cophenetic(licetree)
#' D <- prepare_paco_data(gdist, ldist, gl_links)
#' D <- add_pcoord(D)
#' D <- PACo(D, nperm=10, seed=42)
#' print(D$gof)
PACo <- function(D, nperm=1000, seed=NA, margin=1)
{
   if(!("H_PCo" %in% names(D))) D <- add_pcoord(D)
   proc <- vegan::procrustes(X=D$H_PCo, Y=D$P_PCo)
   Nlinks <- sum(D$HP)
   ## Goodness of fit
   m2ss <- proc$ss
   pvalue <- 0
   if(!is.na(seed)) set.seed(seed)
   for(n in c(1:nperm))
   {
      el <- subset(reshape2::melt(D$HP), value>0)
      el[,margin] <- sample(el[,margin])
      permuted_HP <- reshape2::acast(el, Var1~Var2, length)
      permuted_HP[is.na(permuted_HP)] <- 0
      perm_D <- list(H=D$H, P=D$P, HP=permuted_HP)
      perm_paco <- add_pcoord(perm_D)
      perm_proc_ss <- vegan::procrustes(X=perm_paco$H_PCo, Y=perm_paco$P_PCo)$ss
      if(perm_proc_ss <= m2ss) pvalue <- pvalue + 1
   }
   pvalue <- pvalue / nperm
   D$proc <- proc
   D$gof <- list(p=pvalue, ss=m2ss, n=nperm)
   return(D)
}
