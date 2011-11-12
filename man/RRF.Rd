\name{RRF}
\alias{RRF}
\alias{RRF.formula}
\alias{RRF.default}
\alias{print.RRF}

\title{Feature Selection with Regularized Random Forest}
\description{
  \code{RRF} implements the regularized random forest algorithm. It is based on
  the randomForest R package by Andy Liaw, Matthew Wiener, Leo Breiman and Adele Cutler.
}
\usage{
\method{RRF}{formula}(formula, data=NULL, ..., subset, na.action=na.fail)
\method{RRF}{default}(x, y=NULL,  xtest=NULL, ytest=NULL, ntree=500,
             mtry=if (!is.null(y) && !is.factor(y))
             max(floor(ncol(x)/3), 1) else floor(sqrt(ncol(x))),
             replace=TRUE, classwt=NULL, cutoff, strata,
             sampsize = if (replace) nrow(x) else ceiling(.632*nrow(x)),
             nodesize = if (!is.null(y) && !is.factor(y)) 5 else 1,
             maxnodes = NULL,
             importance=FALSE, localImp=FALSE, nPerm=1,
             proximity, oob.prox=proximity,
             norm.votes=TRUE, do.trace=FALSE,
             keep.forest=!is.null(y) && is.null(xtest), corr.bias=FALSE,
             keep.inbag=FALSE,  coefReg=0.8, flagReg=1, ...)
\method{print}{RRF}(x, ...)
}
\arguments{
  \item{data}{an optional data frame containing the variables in the model.
    By default the variables are taken from the environment which
    \code{RRF} is called from.}
  \item{subset}{an index vector indicating which rows should be used.
    (NOTE: If given, this argument must be named.)}
  \item{na.action}{A function to specify the action to be taken if NAs
    are found.  (NOTE: If given, this argument must be named.)}
  \item{x, formula}{a data frame or a matrix of predictors, or a formula
    describing the model to be fitted (for the
    \code{print} method, an \code{RRF} object).}
  \item{y}{A response vector.  If a factor, classification is assumed,
    otherwise regression is assumed.  If omitted, \code{RRF}
    will run in unsupervised mode.}
  \item{xtest}{a data frame or matrix (like \code{x}) containing
    predictors for the test set.}
  \item{ytest}{response for the test set.}
  \item{ntree}{Number of trees to grow.  This should not be set to too
    small a number, to ensure that every input row gets predicted at
    least a few times. }
  \item{mtry}{Number of variables randomly sampled as candidates at each
    split.  Note that the default values are different for
    classification (sqrt(p) where p is number of variables in \code{x})
    and regression (p/3)}
  \item{replace}{Should sampling of cases be done with or without
    replacement?}
  \item{classwt}{Priors of the classes.  Need not add up to one.
    Ignored for regression.}
  \item{cutoff}{(Classification only)  A vector of length equal to
    number of classes.  The `winning' class for an observation is the
    one with the maximum ratio of proportion of votes to cutoff.
    Default is 1/k where k is the number of classes (i.e., majority vote
    wins).}
  \item{strata}{A (factor) variable that is used for stratified sampling.}
  \item{sampsize}{Size(s) of sample to draw.  For classification, if
    sampsize is a vector of the length the number of strata, then
    sampling is stratified by strata, and the elements of sampsize
    indicate the numbers to be drawn from the strata.}
  \item{nodesize}{Minimum size of terminal nodes.  Setting this number
    larger causes smaller trees to be grown (and thus take less time).
    Note that the default values are different for classification (1)
    and regression (5).}
  \item{maxnodes}{Maximum number of terminal nodes trees in the forest
	can have.  If not given, trees are grown to the maximum possible
	(subject to limits by \code{nodesize}).  If set larger than maximum
	possible, a warning is issued.}
  \item{importance}{Should importance of predictors be assessed? }
  \item{localImp}{Should casewise importance measure be computed?
    (Setting this to \code{TRUE} will override \code{importance}.) }
  \item{nPerm}{Number of times the OOB data are permuted per tree for
    assessing variable importance.  Number larger than 1 gives slightly
    more stable estimate, but not very effective.  Currently only
    implemented for regression.}
  \item{proximity}{Should proximity measure among the rows be
    calculated?}
  \item{oob.prox}{Should proximity be calculated only on ``out-of-bag''
    data?}
  \item{norm.votes}{If \code{TRUE} (default), the final result of votes
    are expressed as fractions.  If \code{FALSE}, raw vote counts are
    returned (useful for combining results from different runs).
    Ignored for regression.}
  \item{do.trace}{If set to \code{TRUE}, give a more verbose output as
    \code{RRF} is run.  If set to some integer, then running
    output is printed for every \code{do.trace} trees.}
  \item{keep.forest}{If set to \code{FALSE}, the forest will not be
    retained in the output object.  If \code{xtest} is given, defaults
    to \code{FALSE}.}
  \item{corr.bias}{perform bias correction for regression?  Note:
    Experimental.  Use at your own risk.}
  \item{keep.inbag}{Should an \code{n} by \code{ntree} matrix be
    returned that keeps track of which samples are ``in-bag'' in which
    trees (but not how many times, if sampling with replacement)}
  \item{coefReg}{the coefficient(s) of regularization. A smaller coefficient may lead to a smaller feature subset, i.e. there are fewer variables with non-zero importance scores. coefReg must be either a single value (all 
  variables have the same coefficient) or a numeric vector of length equal to the number of predictor variables. default: 0.8}
  \item{flagReg}{1: with regularization; 0: without regularization. default: 1}	
  \item{...}{optional parameters to be passed to the low level function
    \code{RRF.default}.}
}

\value{
  An object of class \code{RRF}, which is a list with the
  following components:

  \item{call}{the original call to \code{RRF}}
  \item{type}{one of \code{regression}, \code{classification}, or
    \code{unsupervised}.}
  \item{predicted}{the predicted values of the input data based on
    out-of-bag samples.}
  \item{importance}{a matrix with \code{nclass} + 2 (for classification)
    or two (for regression) columns.  For classification, the first
    \code{nclass} columns are the class-specific measures computed as
    mean descrease in accuracy.  The \code{nclass} + 1st column is the
    mean descrease in accuracy over all classes.  The last column is the
    mean decrease in Gini index.  For Regression, the first column is
    the mean decrease in accuracy and the second the mean decrease in MSE.
    If \code{importance=FALSE}, the last measure is still returned as a
    vector.}
  \item{importanceSD}{The ``standard errors'' of the permutation-based
    importance measure.  For classification, a \code{p} by \code{nclass
      + 1} matrix corresponding to the first \code{nclass + 1} columns
    of the importance matrix.  For regression, a length \code{p} vector.}
  \item{localImp}{a p by n matrix containing the casewise importance
    measures, the [i,j] element of which is the importance of i-th
    variable on the j-th case. \code{NULL} if \code{localImp=FALSE}.}
  \item{ntree}{number of trees grown.}
  \item{mtry}{number of predictors sampled for spliting at each node.}
  \item{forest}{(a list that contains the entire forest; \code{NULL} if
    \code{RRF} is run in unsupervised mode or if
    \code{keep.forest=FALSE}.}
  \item{err.rate}{(classification only) vector error rates of the
    prediction on the input data, the i-th element being the (OOB) error rate
    for all trees up to the i-th.}
  \item{confusion}{(classification only) the confusion matrix of the
    prediction (based on OOB data).}
  \item{votes}{(classification only) a matrix with one row for each
    input data point and one column for each class, giving the fraction
    or number of (OOB) `votes' from the random forest.}
  \item{oob.times}{number of times cases are `out-of-bag' (and thus used
    in computing OOB error estimate)}
  \item{proximity}{if \code{proximity=TRUE} when
    \code{RRF} is called, a matrix of proximity measures among
    the input (based on the frequency that pairs of data points are in
    the same terminal nodes).}

  \item{mse}{(regression only) vector of mean square errors: sum of squared
    residuals divided by \code{n}.}
  \item{rsq}{(regression only) ``pseudo R-squared'': 1 - \code{mse} /
    Var(y).}
  \item{test}{if test set is given (through the \code{xtest} or additionally
  \code{ytest} arguments), this component is a list which contains the
  corresponding \code{predicted}, \code{err.rate}, \code{confusion},
  \code{votes} (for classification) or \code{predicted}, \code{mse} and
  \code{rsq} (for regression) for the test set.  If
  \code{proximity=TRUE}, there is also a component, \code{proximity},
  which contains the proximity among the test set as well as proximity
  between test and training data.}
}

\note{
For large data sets, especially those with large number of variables, calling RRF via the
formula interface is not advised: There may be too much overhead in handling the formula.
}

\references{
  Houtao Deng and George C. Runger (2012), \emph{Gene Selection with Regularized Random Forest}, Technical Report.
  
  Houtao Deng and George C. Runger (2012), \emph{Feature Selection via Regularized Trees}, arXiv:1201.1587.
}
\author{Houtao Deng \email{softwaredeng@gmail.com}, based on the randomForest R package by Andy Liaw, Matthew Wiener, Leo Breiman and Adele Cutler.}

\examples{
#-----Example 1 -----
library(RRF);set.seed(1)

#only the first and last features are needed
X=matrix(runif(200*500), ncol=500)
class = (X[,1])^2 + (X[,500])^2  
class[class>median(class)]=1;class[class<=median(class)]=0

#ordinary random forest. 
rf <- RRF(X,as.factor(class), flagReg = 0)
impRF=rf$importance
impRF=impRF[,"MeanDecreaseGini"]
x11();plot(impRF,xlab="variable index",ylab="importance")
title("RRF(X,as.factor(class), flagReg = 0)")
#mark the first and last variables
text(30, impRF[1], "V1", cex=1) 
text(460, impRF[500], "V500", cex=1) 

#regularized random forest without using the global importance
rrf <- RRF(X,as.factor(class))
imp=rrf$importance
imp=imp[,"MeanDecreaseGini"]
x11();plot(imp,xlab="variable index",ylab="importance")
title("RRF(X,as.factor(class))")
text(30, imp[1], "V1", cex=1) 
text(460, imp[500], "V500", cex=1) 

#regularized random forest using the importance scores
#from ordinary random forest
imp=impRF/(max(impRF))#normalize the importance score
coefReg=0.9*0.8+0.1*imp #weighted average
rrf <- RRF(X,as.factor(class),coefReg=coefReg)
imp=rrf$importance
imp=imp[,"MeanDecreaseGini"]
x11();plot(imp,xlab="variable index",ylab="importance")
title("RRF(X,as.factor(class),coefReg=coefReg)")
text(30, imp[1], "V1", cex=1) 
text(460, imp[500], "V500", cex=1) 

#smaller regularization coefficients 
#eliminate more features 
imp=impRF/(max(impRF))#normalize the importance score
coefReg=0.9*0.5+0.1*imp #weighted average
rrf <- RRF(X,as.factor(class),coefReg=coefReg)
imp=rrf$importance
imp=imp[,"MeanDecreaseGini"]
x11();plot(imp,xlab="variable index",ylab="importance")
title("RRF(X,as.factor(class),coefReg=coefReg)")
text(30, imp[1], "V1", cex=1) 
text(460, imp[500], "V500", cex=1) 


#setting a large mtry may eliminate more features 
imp=impRF/(max(impRF))#normalize the importance score
coefReg=0.9*0.8+0.1*imp #weighted average
rrf <- RRF(X,as.factor(class),mtry=ncol(X),coefReg=coefReg)
imp=rrf$importance
imp=imp[,"MeanDecreaseGini"]
x11();plot(imp,xlab="variable index",ylab="importance")
title("RRF(X,as.factor(class),mtry=ncol(X),coefReg=coefReg)")
text(30, imp[1], "V1", cex=1) 
text(460, imp[500], "V500", cex=1) 




#-----Example 2 XOR learning-----
set.seed(1)

#only the first 3 features are needed
#and each individual feature is not useful
bSample = sample(0:1,20000,replace=TRUE)
X=matrix(bSample,ncol=40)
class = xor(xor(X[,1],X[,2]),X[,3])

#ordinary random forest. 
rf <- RRF(X,as.factor(class), flagReg = 0,importance=TRUE)
impRF=rf$importance
impRF=impRF[,"MeanDecreaseAccuracy"] # can use gini decrease as well
x11();plot(impRF,xlab="variable index",ylab="importance")
title("RRF(X,as.factor(class),flagReg = 0,importance=TRUE)")


#regularized random forest using the global importance
#also setting a large mtry may eliminate more features
imp=impRF/(max(impRF))#normalize the importance score
coefReg=0.9*0.8+0.1*imp #weighted average
rrf <- RRF(X,as.factor(class),mtry=ncol(X),coefReg=coefReg)
imp=rrf$importance
imp=imp[,"MeanDecreaseGini"]
x11();plot(imp,xlab="variable index",ylab="importance")
title("RRF(X,as.factor(class),mtry=ncol(X),coefReg=coefReg)")



}