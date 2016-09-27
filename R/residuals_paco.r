#' Return Procrustes residuals from a paco object
#'
#' Takes the Procrustes object from vegan::procrustes of the global superimpostion and pulls out either the residual matrix of superimposition or the residual of each individual interaction (link between host and parasite). 
#' @param object An obejct of class `procrustes' as returned from PACo (and internally the vegan::procrustes function). In a PACo output this is D$proc.
#' @param type Whether the whole residual matrix (matrix) or the residuals per interaction (interaction) is desired.
#' @return If type='interaction', returns a named vector of the Procrustes residuals where names are the interactions. If type='matrix', returns a matrix of residuals from Procrustes superimposition.
#' @export
#' @examples
#' data(gopherlice)
#' library(ape)
#' gdist <- cophenetic(gophertree)
#' ldist <- cophenetic(licetree)
#' D <- prepare_paco_data(gdist, ldist, gl_links)
#' D <- add_pcoord(D, correction='cailliez')
#' D <- PACo(D, nperm=100, seed=42, method='r0', correction='cailliez')
#' residuals.paco(D$proc)
residuals_paco <- function (object, type = "interaction") {
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
