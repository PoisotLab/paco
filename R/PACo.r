#' Performs PACo/procustes analysis
#' @param D a list with the data
#' @param nperm Number of permutations
#' @param seed Seed if results need to be reproduced
#' @param method The method to permute matrices with: "r0", "r1", "r2", "c0", "swap", "quasiswap"
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
PACo <- function(D, nperm=1000, seed=NA, method="NA")
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
      permuted_HP <- commsimulator(D$HP, method)
      permuted_HP <- permuted_HP[rownames(D$HP),colnames(D$HP)]
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
