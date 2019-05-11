#' Performs PACo analysis. 
#'
#' Two sets of Principal Coordinates are superimposed by Procrustes superimposition. The sum of squared residuals of this superimposition give an indication of how congruent the two datasets are. For example, in a biological system the two sets of Principal Coordinates can be composed from the phylogenetic distance matrices of two interacting groups. The congruence measured by PACo indicates how concordant the two phylogenies are based on observed ecological interactions between them.
#' @param D A list of class \code{paco} as returned by \code{paco::add_pcoord} which includes Principal Coordinates for both phylogenetic distance matrices.
#' @param nperm The number of permutations to run. In each permutation, the network is randomized following the \code{method} argument and phylogenetic congruence between phylogenies is reassessed.
#' @param seed An integer with which to begin the randomizations. If the same seed is used the randomizations will be the same and results reproducible. If \code{NA} a random seed is chosen.
#' @param method The method with which to permute association matrices: "r0", "r1", "r2", "c0", "swap", "quasiswap", "backtrack", "tswap", "r00". Briefly, "r00" produces the least conservative null model as it only maintains total fill (i.e., total number of interactions). "r0" and "c0" maintain the row sums and column sums, respectively, as well as the total number of interactions. "backtracking" and any of the "swap" algorithms conserve the total number of interactions in the matrix, as well as both row and column sums. Finally, "r1" and "r2" conserve the row sums, the total number of interactions, and randomize based on observed interaction frequency. See \code{vegan::commsim} for more details.
#' @param symmetric Logical. Whether or not to use the symmetric Procrustes statistic, or not. When \code{TRUE}, the symmetric statistic is used. When \code{FALSE}, the asymmetric is used. A decision on which to use is based on whether one group is assumed to track the evolution of the other, or not.
#' @param proc.warnings Logical. Make any warnings from the Procrustes superimposition callable. If \code{TRUE}, any warnings are viewable with the \code{warnings()} command. If \code{FALSE}, warnings are internally suppressed. Default is TRUE 
#' @param shuffled Logical. Return the Procrustes sum of squared residuals for every permutation of the network. When \code{TRUE}, the Procrustes statistic of all permutations is returned as a vector. When \code{FALSE}, they are not returned.
#' @return A \code{paco} object that now includes (alongside the Principal Coordinates and input distance matrices) the PACo sum of sqaured residuals, a p-value for this statistic, and the PACo statistics for each randomisation of the network if shuffled=TRUE in the PACo call.
#' @note Any call of PACo in which the distance matrices have differing dimensions (i.e., different numbers of tips of the two phylogenies) will produce warnings from the \code{vegan::procrustes} function. These warnings require no action by the user but are merely letting the user know that, as the distance matrices had differing dimensions, their Principal Coordinates have differing numbers of columns. \code{vegan::procrustes} deals with this internally by adding columns of zeros to the smaller of the two until the are the same size.
#' @export
#' @examples
#' data(gopherlice)
#' require(ape)
#' gdist <- cophenetic(gophertree)
#' ldist <- cophenetic(licetree)
#' D <- prepare_paco_data(gdist, ldist, gl_links)
#' D <- add_pcoord(D)
#' D <- PACo(D, nperm=10, seed=42, method="r0")
#' print(D$gof)

PACo <- function(D, nperm=1000, seed=NA, method="r0", symmetric = FALSE, proc.warnings=TRUE, shuffled=FALSE)
{
   correction <- D$correction
   method <- match.arg(method, c("r0", "r1", "r2", "r00", "c0", "swap", "tswap", "backtrack", "quasiswap"))
   if(!("H_PCo" %in% names(D))) D <- add_pcoord(D, correction=correction)
   if(proc.warnings==TRUE){
      proc <- vegan::procrustes(X=D$H_PCo, Y=D$P_PCo, symmetric= symmetric)
   }else{
      proc <- suppressWarnings(vegan::procrustes(X=D$H_PCo, Y=D$P_PCo, symmetric= symmetric))
   }
   Nlinks <- sum(D$HP)
   ## Goodness of fit
   m2ss <- proc$ss
   pvalue <- 0
   if(!is.na(seed)) set.seed(seed)
   # Create randomised matrices
   null_model <- vegan::nullmodel (D$HP, method)
   randomised_matrices <- stats::simulate (null_model, nsim = nperm)
   if(shuffled==TRUE){
      rands <- c()
      for(n in c(1:nperm))
      {
         permuted_HP <- randomised_matrices[, , n]
         permuted_HP <- permuted_HP[rownames(D$HP),colnames(D$HP)]
         perm_D <- list(H=D$H, P=D$P, HP=permuted_HP)
         perm_paco <- add_pcoord(perm_D, correction=correction)
         if(proc.warnings==TRUE){
            perm_proc_ss <- vegan::procrustes(X=perm_paco$H_PCo, Y=perm_paco$P_PCo, symmetric= symmetric)$ss
         }else{
            perm_proc_ss <- suppressWarnings(vegan::procrustes(X=perm_paco$H_PCo, Y=perm_paco$P_PCo, symmetric= symmetric)$ss)
         }
         if(perm_proc_ss <= m2ss) pvalue <- pvalue + 1
         rands <- c(rands, perm_proc_ss) 
      }
   }else{
      for(n in c(1:nperm))
      {
         permuted_HP <- randomised_matrices[, , n]
         permuted_HP <- permuted_HP[rownames(D$HP),colnames(D$HP)]
         perm_D <- list(H=D$H, P=D$P, HP=permuted_HP)
         perm_paco <- add_pcoord(perm_D, correction=correction)
         if(proc.warnings==TRUE){
            perm_proc_ss <- vegan::procrustes(X=perm_paco$H_PCo, Y=perm_paco$P_PCo, symmetric= symmetric)$ss
         }else{
            perm_proc_ss <- suppressWarnings(vegan::procrustes(X=perm_paco$H_PCo, Y=perm_paco$P_PCo, symmetric= symmetric)$ss)
         }
         if(perm_proc_ss <= m2ss) pvalue <- pvalue + 1
      }
   }
   pvalue <- pvalue / nperm
   D$proc <- proc
   D$gof <- list(p=pvalue, ss=m2ss, n=nperm)
   D$method <- method
   D$symmetric <- symmetric
   D$correction <- correction
   if(exists('rands')==TRUE) D$shuffled <- rands
   return(D)
}
