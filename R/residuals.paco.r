#' Get procrustes residuals from a paco object
#' @param object a list with the data
#' @param type wether the whole residual matrix (\code{matrix}) or the residuals per interaction (\code{interaction}) is desired
#' @export

residuals.paco <- function (object, type = "interaction") {
  type <- match.arg(type, c("matrix", "interaction"))

  distance <- object$X - object$Yrot
  rownames(distance) <- paste(rownames(object$X), rownames(object$Yrot), sep="-") #colnames identify the H-P link

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
