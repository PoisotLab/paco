#' Get procrustes residuals from a paco object
#' @param D a list with the data
#' @param type Wether the whole residual matrix (\code{matrix}) or the residuals per interaction (\code{interaction}) is desired
#' @export

residuals.paco <- function (D, type = "interaction") {
  
  type <- match.arg(type, c("matrix", "interaction"))
  
  if (!exists ("proc", D)) stop ("Procrustes object 'proc' not found")
  
  distance <- D$proc$X - D$proc$Yrot
  rownames (distance) <- paste(rownames(D$proc$X),rownames(D$proc$Yrot), sep="-") #colnames identify the H-P link
  
  if (type == "matrix") {
    return (distance)
  } else if (type == "interaction") {
    resid <- apply(distance^2, 1, sum)
    resid <- sqrt(resid)
    return (resid)
  } else {
    stop("Invalid residual type")
  }
}