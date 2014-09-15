#' paco
#' @param D A list with objects H, P, and HP, returned by pre_pac
#' @return The input list with added objects for the principal coordinates of the objects
#' @export
paco <- function(D)
{ 
   HP_bin <- which(D$HP > 0, arr.in=TRUE)
   H_PCo <- pcoa(D$H, correction="cailliez")$vectors #Performs PCo of Host distances 
   P_PCo <- pcoa(D$P, correction="cailliez")$vectors #Performs PCo of Parasite distances
   D$H_PCo <- H_PCo[HP_bin[,1],] #Adjust Host PCo vectors 
   D$P_PCo <- P_PCo[HP_bin[,2],]  #Adjust Parasite PCo vectors
   return(D)
}
