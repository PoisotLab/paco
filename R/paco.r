#' paco
#' @param D A list with objects H, P, and HP, returned by pre_pac
#' @return The input list with added objects for the principal coordinates of the objects
#' @export
paco <- function(D)
{ 
   H_PCo <- pcoa(D$H, correction="cailliez")$vectors #Performs PCo of Host distances 
   P_PCo <- pcoa(D$P, correction="cailliez")$vectors #Performs PCo of Parasite distances
   D$H_PCo <- H_PCo[D$HP[,1],] #Adjust Host PCo vectors 
   D$P_PCo <- P_PCo[D$HP[,2],]  #Adjust Parasite PCo vectors
   return(D)
}
