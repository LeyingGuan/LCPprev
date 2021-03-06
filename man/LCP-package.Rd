\name{LCP-package}
\alias{LCP-package}
\alias{LCP}
\docType{package}
\title{
\packageTitle{LCP}
}
\description{
\packageDescription{LCP}
}
\details{

The DESCRIPTION file:
\packageDESCRIPTION{LCP}
\packageIndices{LCP}
~~ An overview of how to use the package, including the most important functions ~~
}
\author{
\packageAuthor{LCP}

Maintainer: \packageMaintainer{LCP}
}
\references{
~~ Literature or other references for background information ~~
}
~~ Optionally other standard keywords, one per line, from file KEYWORDS in the R ~~
~~ documentation directory ~~
\keyword{ package }
\seealso{
~~ Optional links to other man pages, e.g. ~~
~~ \code{\link[<pkg>:<pkg>-package]{<pkg>}} ~~
}
\examples{
set.seed(2021)
n <- 1000; n0 <- 1000; m <- 1000
data = sim_data_generator_1D_example2(sim_name = "1D_setA", n = n, n0 = n0, m = m)
xtrain = data$xtrain
ytrain = data$ytrain
xcalibration = data$xcalibration
ycalibration = data$ycalibration
xtest = data$xtest
ytest = data$ytest
PItruth = data$truePI

D = matrix(0, n0, n0)
Dnew = matrix(0, m, n0)
DnewT = matrix(0, n0, m)
for(i in 1:n0){
  D[i,] = abs(xcalibration[i] - xcalibration)
}
for(i in 1:m){
  Dnew[i,] = abs(xtest[i] - xcalibration)
  DnewT[,i] = abs(xtest[i] - xcalibration)
}
eps = abs(ycalibration)
order1 = order(eps)
alpha = .05
# H is the ordered pair-wise distance matrix
myLCR = LCPmodule$new(H =D[order1, order1], V = eps[order1], h = .2, alpha = alpha, type = "distance")
# get the lower index l(i) for i = 1,..., n in the ordered data
myLCR$lower_idx()
# precalculate unnormlized cumulative probablities for training data
myLCR$cumsum_unnormalized()
# fit in the unnormalized weight for the new sample/samples and construct conformal PI
# Dnew is m by n (training) ordered distance matrix for m test samples and n training samples
myLCR$LCP_construction(Hnew =Dnew[,order1], HnewT = DnewT[order1,])

deltaLCP = myLCR$band_V
qLL = -deltaLCP
qLU = +deltaLCP

deltaCP = quantile(eps, 1-alpha)
qL =  -rep(deltaCP, m)
qU = rep(deltaCP,m)

ll = order(xtest)
plot(xtest[ll], ytest[ll], type = "p", pch = ".", ylim = c(-3, 4), xlab = 'X', ylab = 'Y')
points(xtest[ll], PItruth[ll,1], type = 'l')
points(xtest[ll], PItruth[ll,2], type = 'l')

points(xtest[ll], qL[ll], type = 'l', col = "blue")
points(xtest[ll], qU[ll], type = 'l', col = "blue")

points(xtest[ll], qLL[ll], type = 'l', col = "red")
points(xtest[ll], qLU[ll], type = 'l', col = "red")

legend("topleft", legend = c("Truth", "CP", "LCP"), lty = 1, col = c("black","blue","red"), bty = "n")

}
