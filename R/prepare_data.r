#' Prepare the datapoll
#' Simple wrapper to make sure that the matrices are sorted accordingly
#' @param H Host distance matrix 
#' @param P Parasite distance matrix 
#' @param HP Host-parasite association matrix, hosts in rows
#' @return A list with objects H, P, HP
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
   H <- H[rownames(HP),rownames(HP)]
   P <- P[colnames(HP),colnames(HP)]
   HP[HP>0] <- 1
   return(list(H=H, P=P, HP=HP))
}
