#' Principal Coordinates analysis of phylogenetic distance matrices
#'
#' Translates the distance matrices of 'host' and 'parasite' phylogenies into Principal Coordinates, as needed for Procrustes superimposition.
#' @param D A list with objects H, P, and HP, as returned by \code{paco::prepare_paco_data}.
#' @param correction In some cases, phylogenetic distance matrices are non-Euclidean which generates negative eigenvalues when those matrices are translated into Principal Coordinates. There are several methods to correct negative eigenvalues. Correction options available here are "cailliez", "lingoes", and "none". The "cailliez" and "lingoes" corrections add a constant to the eigenvalues to make them non-negative. Default is "none". 
#' @return The list that was input as the argument `D' with four new elements; the Principal Coordinates of the `host' distance matrix and the Principal Coordinates of the `parasite' distance matrix, as well as, a `correction' object stating the correction used for negative eigenvalues and a `note' object stating whether or not negative eigenvalues were present and therefore corrected.
#' @note To find the Principal Coordinates of each distance matrix, we internally a modified version of the function \code{ape::pcoa} that uses \code{vegan::eigenvals} and zapsmall
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
if(correction == 'none'){
	H_PCo <- coordpcoa(D$H, correction) #Performs PCo of Host distances
	P_PCo <- coordpcoa(D$P, correction) #Performs PCo of Parasite distances
	H_PCoVec <- H_PCo$vectors
	P_PCoVec <- P_PCo$vectors
	D$H_PCo <- H_PCoVec[HP_bin[,1],] #Adjust Host PCo vectors
	D$P_PCo <- P_PCoVec[HP_bin[,2],] #Adjust Parasite PCo vectors
}else{
	H_PCo <- coordpcoa(D$H, correction)
	P_PCo <- coordpcoa(D$P, correction)
	if(H_PCo$note == "There were no negative eigenvalues. No correction was applied"){
		H_PCoVec <- H_PCo$vectors
		D$H_PCo <- H_PCoVec[HP_bin[,1],] #Adjust Host PCo vectors
	}else{
		H_PCoVec <- H_PCo$vectors.cor
		D$H_PCo <- H_PCoVec[HP_bin[,1],] #Adjust Host PCo vectors
	}

	if(P_PCo$note == "There were no negative eigenvalues. No correction was applied"){
		P_PCoVec <- P_PCo$vectors
		D$P_PCo <- P_PCoVec[HP_bin[,2],] #Adjust Host PCo vectors
	}else{
		P_PCoVec <- P_PCo$vectors.cor
		D$P_PCo <- P_PCoVec[HP_bin[,2],] #Adjust Host PCo vectors
	}

}
D$correction <- correction
D$note <- list(H_note=H_PCo$note, P_note=P_PCo$note)
return(D)
}
