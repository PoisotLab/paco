#' Contribution of individual links
#' @param D
#' @export
link_contribution <- function(D)
{
   HP.ones <- which(D$HP > 0, arr.in=TRUE)
   SQres.jackn <- matrix(rep(NA, sum(D$HP)^2), sum(D$HP))# empty matrix of jackknifed squared residuals
   colnames(SQres.jackn) <- paste(rownames(D$proc$X),rownames(D$proc$Yrot), sep="-") #colnames identify the H-P link
   t.critical = qt(0.975,sum(D$HP)-1) #Needed to compute 95% confidence intervals.
   for(i in c(1:sum(D$HP))) #PACo setting the ith link = 0
   {
      HP_ind <- D$HP
      HP_ind[HP.ones[i,1],HP.ones[i,2]]=0
      PACo.ind <- paco(D$H, D$P, HP_ind)
      Proc.ind <- procrustes(PACo.ind$H_PCo, PACo.ind$P_PCo) 
      res.Proc.ind <- c(residuals(Proc.ind))
      res.Proc.ind <- append(res.Proc.ind, NA, after= i-1)
      SQres.jackn[i, ] <- res.Proc.ind   #Append residuals to matrix of jackknifed squared residuals
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
   D$jacknife <- list(mean = phi.mean, upper = phi.UCI)
   return(D)
}
