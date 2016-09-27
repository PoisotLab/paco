#' Prepares the data (distance matrices and association matrix) for PACo analysis
#'
#' Simple wrapper to make sure that the matrices are sorted accordingly and to group them together into a paco object (effectively a list) that is then passed to the remaining steps of PACo analysis.
#' @param H Host distance matrix. This is the distance matrix upon which the other will be superimposed. We term this the host matrix in reference to the original cophylogeny studies between parasites and their hosts, where parasite evolution was thought to track host evolution hence why the parasite matrix is superimposed on the host. 
#' @param P Parasite distance matrix. The distance matrix that will be superimposed on the host matrix. As mentioned above, this is the group that is assumed to track the evolution of the other. 
#' @param HP Host-parasite association matrix, hosts in rows. This should be a binary matrix. If host species aren't in the rows, the matrix will be translated internally. 
#' @return A list with objects H, P, HP to be passed to further functions for PACo analysis.
#' @export
#' @examples 
#' data(gopherlice)
#' library(ape)
#' gdist <- cophenetic(gophertree)
#' ldist <- cophenetic(licetree)
#' D <- prepare_paco_data(gdist, ldist, gl_links)
prepare_paco_data <- function(H, P, HP)
{
   if(NROW(H) != NCOL(H))
      stop("H should be a square matrix")
   if(NROW(P) != NCOL(P))
      stop("P should be a square matrix")
   if(NROW(H) != NROW(HP)){
      warning("The HP matrix should have hosts in rows. It has been translated.")
      HP <- t(HP)
   }
   if (!(NROW (H) %in% dim(HP)))
     stop ("The number of species in H and HP don't match")
   if (!(NROW (P) %in% dim(HP)))
     stop ("The number of species in P and HP don't match")
   if (!all(rownames(HP) %in% rownames (H)))
     stop ("The species names H and HP don't match")
   if (!all(colnames(HP) %in% rownames (P)))
     stop ("The species names P and HP don't match")
   H <- H[rownames(HP),rownames(HP)]
   P <- P[colnames(HP),colnames(HP)]
   HP[HP>0] <- 1
   D <- list(H=H, P=P, HP=HP)
   class(D) <- "paco"
   return(D)
}
