#' Principal Coordinates analysis of phylogenetic distance matrices
#'
#' Translates the distance matrices of 'host' and 'parasite' phylogenies into Principal Coordinates, as needed for Procrustes superimposition.
#' @param D A list with objects H, P, and HP, as returned by \code{paco::prepare_paco_data}.
#' @param correction In some cases, phylogenetic distance matrices are non-Euclidean which generates negative eigenvalues when those matrices are translated into Principal Coordinates. There are several methods to correct negative eigenvalues. Correction options available here are "cailliez", "lingoes", and "none". The "cailliez" and "lingoes" corrections add a constant to the eigenvalues to make them non-negative. Default is "none". 
#' @return The list that was input as the argument `D' with two new elements; the Principal Coordinates of the `host' distance matrix and the Principal Coordinates of the `parasite' distance matrix.
#' @note To find the Principal Coordinates of each distance matrix, we internally use a function, \code{coordpcoa}, that is a modified version of \code{ape::pcoa}, using \code{vegan::eigenvals}.
#' @export
#' @examples
#' data(gopherlice)
#' library(ape)
#' gdist <- cophenetic(gophertree)
#' ldist <- cophenetic(licetree)
#' D <- prepare_paco_data(gdist, ldist, gl_links)
#' D <- add_pcoord(D)
add_pcoord <- function(D, correction='none')
{
HP_bin <- which(D$HP >0, arr.ind=TRUE)
H_PCo <- coordpcoa(D$H, correction)$vectors #Performs PCo of Host distances
P_PCo <- coordpcoa(D$P, correction)$vectors #Performs PCo of Parasite distances
D$H_PCo <- H_PCo[HP_bin[,1],] #Adjust Host PCo vectors
D$P_PCo <- P_PCo[HP_bin[,2],] #Adjust Parasite PCo vectors
D$correction <- correction
return(D)
}
