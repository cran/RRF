\name{combine}
\alias{combine}

\title{Combine Ensembles of Trees}

\description{
Combine two more more ensembles of trees into one.
}

\usage{
combine(...)
}

\arguments{
  \item{...}{two or more objects of class \code{RRF}, to be
    combined into one.}
}

\value{
An object of class \code{RRF}.
}

\note{
The \code{confusion}, \code{err.rate}, \code{mse} and \code{rsq}
components (as well as the corresponding components in the \code{test}
compnent, if exist) of the combined object will be \code{NULL}.  
}

\seealso{\code{\link{RRF}}, \code{\link{grow}}}

\author{Andy Liaw \email{andy_liaw@merck.com}}

\examples{
data(iris)
rf1 <- RRF(Species ~ ., iris, ntree=50, norm.votes=FALSE)
rf2 <- RRF(Species ~ ., iris, ntree=50, norm.votes=FALSE)
rf3 <- RRF(Species ~ ., iris, ntree=50, norm.votes=FALSE)
rf.all <- combine(rf1, rf2, rf3)
print(rf.all)
}

\keyword{regression}
\keyword{classif}
