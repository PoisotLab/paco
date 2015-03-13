#' Contribution of individual links
#' @param D A list returned by proc_analysis
#' @param .parallel if \code{TRUE}, calculate the jacknife contribution in parallel using the backend provided by foreach
#' @param .progress name of the progress bar to use, see \code{\link[plyr]{create_progress_bar}}. Options include "text" and "tk". It only works when \code{.parallel = FALSE}
#' @return A list with added object jacknife, containing the mean and upper CI values for each link
#' @export
paco_links <- function(D, .parallel = FALSE, .progress = "none")
{
   HP.ones <- which(D$HP > 0, arr.ind=TRUE)
   SQres.jackn <- matrix(rep(NA, sum(D$HP)^2), sum(D$HP))# empty matrix of jackknifed squared residuals
   colnames(SQres.jackn) <- paste(rownames(D$proc$X),rownames(D$proc$Yrot), sep="-") #colnames identify the H-P link
   t.critical = qt(0.975,sum(D$HP)-1) #Needed to compute 95% confidence intervals.
   nlinks <- sum(D$HP)
   
   # If the user wants a progress bar load plyr
   if (.progress != "none") require (plyr)
   # Otherwise progress bar none is borrowed from plyr without loading the package
   if (.progress == "none") progress_none <- function () plyr::progress_none ()
   
   # In parallel
   if (.parallel & exists ("foreach")) {
     foreach (i=1:nlinks, .combine = rbind) %dopar% single_paco_link (D, HP.ones, i)
   } else {
   # In sequence 
     if (.parallel & !exists ("foreach")) warning ("No parallel backend registered. Executing sequentially instead.")
     pb <- plyr::create_progress_bar (.progress)
     pb$init (nlinks)
     for(i in c(1:nlinks)) 
     {
       res.Proc.ind <- single_paco_link (D, HP.ones, i)
       SQres.jackn[i, ] <- res.Proc.ind   #Append residuals to matrix of jackknifed squared residuals
       pb$step ()
     } 
     pb$term ()
   }
   
   SQres.jackn <- SQres.jackn^2 #Jackknifed residuals are squared
   SQres <- (residuals(D$proc))^2 # Vector of original square residuals
   #jackknife calculations:
   SQres.jackn <- SQres.jackn*(-(sum(D$HP)-1))
   SQres <- SQres*sum(D$HP)
   SQres.jackn <- t(apply(SQres.jackn, 1, "+", SQres)) #apply jackknife function to matrix
   phi.mean <- apply(SQres.jackn, 2, mean, na.rm = TRUE) #mean jackknife estimate per link
   phi.UCI <- apply(SQres.jackn, 2, sd, na.rm = TRUE) #standard deviation of estimates
   phi.UCI <- phi.mean + t.critical * phi.UCI/sqrt(sum(D$HP))
   D$jackknife <- list(mean = phi.mean, upper = phi.UCI)
   return(D)
}

#PACo setting the ith link = 0
single_paco_link <- function (D, HP.ones, i) {
  HP_ind <- D$HP
  HP_ind[HP.ones[i,1],HP.ones[i,2]]=0
  PACo.ind <- add_pcoord(list(H=D$H, P=D$P, HP=HP_ind))
  Proc.ind <- vegan::procrustes(X=PACo.ind$H_PCo, Y=PACo.ind$P_PCo) 
  res.Proc.ind <- c(residuals(Proc.ind))
  res.Proc.ind <- append(res.Proc.ind, NA, after= i-1)
}
