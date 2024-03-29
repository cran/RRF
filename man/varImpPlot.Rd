\name{varImpPlot}
\alias{varImpPlot}
\title{Variable Importance Plot}
\description{
  Dotchart of variable importance as measured by a Random Forest
}
\usage{
varImpPlot(x, sort=TRUE, n.var=min(30, nrow(x$importance)),
           type=NULL, class=NULL, scale=TRUE, 
           main=deparse(substitute(x)), ...) 
}
\arguments{
  \item{x}{An object of class \code{RRF}.}
  \item{sort}{Should the variables be sorted in decreasing order of
    importance?}
  \item{n.var}{How many variables to show? (Ignored if
    \code{sort=FALSE}.)}
  \item{type, class, scale}{arguments to be passed on to
    \code{\link{importance}}}
  \item{main}{plot title.}
  \item{...}{Other graphical parameters to be passed on to
    \code{\link{dotchart}}.}
}
\value{
  Invisibly, the importance of the variables that were plotted.
}
\seealso{
  \code{\link{RRF}}, \code{\link{importance}}
}
\examples{
set.seed(4543)
data(mtcars)
mtcars.rf <- RRF(mpg ~ ., data=mtcars, ntree=1000, keep.forest=FALSE,
                          importance=TRUE)
varImpPlot(mtcars.rf)
}
\author{Andy Liaw \email{andy_liaw@merck.com}}
\keyword{regression}
\keyword{classif}
\keyword{tree}
