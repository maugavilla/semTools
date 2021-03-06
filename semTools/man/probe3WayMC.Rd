\name{probe3WayMC}
\alias{probe3WayMC}
\title{
Probing two-way interaction on the residual-centered latent interaction
}
\description{
Probing interaction for simple intercept and simple slope for the no-centered or mean-centered latent two-way interaction
}
\usage{
probe3WayMC(fit, nameX, nameY, modVar, valProbe1, valProbe2)
}
\arguments{
  \item{fit}{The lavaan model object used to evaluate model fit}
  \item{nameX}{The vector of the factor names used as the predictors. The three first-order factors will be listed first. Then the second-order factors will be listeed. The last element of the name will represent the three-way interaction. Note that the fourth element must be the interaction between the first and the second variables. The fifth element must be the interaction between the first and the third variables. The sixth element must be the interaction between the second and the third variables.}
  \item{nameY}{The name of factor that is used as the dependent variable.}
  \item{modVar}{The name of two factors that are used as the moderators. The effect of the independent factor on each combination of the moderator variable values will be probed.}
  \item{valProbe1}{The values of the first moderator that will be used to probe the effect of the independent factor.}
  \item{valProbe2}{The values of the second moderator that will be used to probe the effect of the independent factor.}
}
\details{
Before using this function, researchers need to make the products of the indicators between the first-order factors using mean centering (Marsh, Wen, & Hau, 2004). Note that the double-mean centering may not be appropriate for probing interaction if researchers are interested in simple intercepts. The mean or double-mean centering can be done by the \code{\link{indProd}} function. The indicator products can be made for all possible combination or matched-pair approach (Marsh et al., 2004). Next, the hypothesized model with the regression with latent interaction will be used to fit all original indicators and the product terms. See the example for how to fit the product term below. Once the lavaan result is obtained, this function will be used to probe the interaction.

Let that the latent interaction model regressing the dependent variable (\eqn{Y}) on the independent varaible (\eqn{X}) and two moderators (\eqn{Z} and \eqn{W}) be
\deqn{
	Y = b_0 + b_1X + b_2Z + b_3W + b_4XZ + b_5XW + b_6ZW + b_7XZW + r,
}
where \eqn{b_0} is the estimated intercept or the expected value of \eqn{Y} when \eqn{X}, \eqn{Z}, and \eqn{W} are 0, \eqn{b_1} is the effect of \eqn{X} when \eqn{Z} and \eqn{W} are 0, \eqn{b_2} is the effect of \eqn{Z} when \eqn{X} and \eqn{W} is 0, \eqn{b_3} is the effect of \eqn{W} when \eqn{X} and \eqn{Z} are 0, \eqn{b_4} is the interaction effect between \eqn{X} and \eqn{Z} when \eqn{W} is 0, \eqn{b_5} is the interaction effect between \eqn{X} and \eqn{W} when \eqn{Z} is 0, \eqn{b_6} is the interaction effect between \eqn{Z} and \eqn{W} when \eqn{X} is 0, \eqn{b_7} is the three-way interaction effect between \eqn{X}, \eqn{Z}, and \eqn{W}, and \eqn{r} is the residual term.

For probing three-way interaction, the simple intercept of the independent variable at the specific values of the moderators (Aiken & West, 1991) can be obtained by
\deqn{
	b_{0|X = 0, Z, W} = b_0 + b_2Z + b_3W + b_6ZW.
}

The simple slope of the independent varaible at the specific values of the moderators can be obtained by
\deqn{
	b_{X|Z, W} = b_1 + b_3Z + b_4W + b_7ZW.
}

The variance of the simple intercept formula is
\deqn{
	Var\left(b_{0|X = 0, Z, W}\right) = Var\left(b_0\right) + Z^2Var\left(b_2\right) + W^2Var\left(b_3\right) + Z^2W^2Var\left(b_6\right) + 2ZCov\left(b_0, b_2\right) + 2WCov\left(b_0, b_3\right) + 2ZWCov\left(b_0, b_6\right) + 2ZWCov\left(b_2, b_3\right) + 2Z^2WCov\left(b_2, b_6\right) + 2ZW^2Cov\left(b_3, b_6\right) 
}
where \eqn{Var} denotes the variance of a parameter estimate and \eqn{Cov} denotes the covariance of two parameter estimates.

The variance of the simple slope formula is 
\deqn{
	Var\left(b_{X|Z, W}\right) = Var\left(b_1\right) + Z^2Var\left(b_4\right) + W^2Var\left(b_5\right) + Z^2W^2Var\left(b_7\right) + 2ZCov\left(b_1, b_4\right) + 2WCov\left(b_1, b_5\right) + 2ZWCov\left(b_1, b_7\right) + 2ZWCov\left(b_4, b_5\right) + 2Z^2WCov\left(b_4, b_7\right) + 2ZW^2Cov\left(b_5, b_7\right) 
}

Wald statistic is used for test statistic.
}
\value{
A list with two elements:
\enumerate{
  \item{SimpleIntercept} The intercepts given each value of the moderator. This element will be shown only if the factor intercept is estimated (e.g., not fixed as 0).
  \item{SimpleSlope} The slopes given each value of the moderator. 
}
In each element, the first column represents the values of the first moderator specified in the \code{valProbe1} argument. The second column represents the values of the second moderator specified in the \code{valProbe2} argument. The third column is the simple intercept or simple slope. The fourth column is the standard error of the simple intercept or simple slope. The fifth column is the Wald (\emph{z}) statistic. The sixth column is the \emph{p}-value testing whether the simple intercepts or slopes are different from 0.
}
\references{
Aiken, L. S., & West, S. G. (1991). Multiple regression: Testing and interpreting interactions. Newbury Park, CA: Sage.

Marsh, H. W., Wen, Z., & Hau, K. T. (2004). Structural equation models of latent interactions: Evaluation of alternative estimation strategies and indicator construction. \emph{Psychological Methods, 9}, 275-300.
}
\author{
    Sunthud Pornprasertmanit (University of Kansas; \email{psunthud@ku.edu})
}
\seealso{
	\itemize{
		\item \code{\link{indProd}} For creating the indicator products with no centering, mean centering, double-mean centering, or residual centering.
		\item \code{\link{probe2WayMC}} For probing the two-way latent interaction when the results are obtained from mean-centering, or double-mean centering.
		\item \code{\link{probe2WayRC}} For probing the two-way latent interaction when the results are obtained from residual-centering approach.
		\item \code{\link{probe3WayRC}} For probing the two-way latent interaction when the results are obtained from residual-centering approach.
		\item \code{\link{plotProbe}} Plot the simple intercepts and slopes of the latent interaction.
	}
}
\examples{
library(lavaan)

dat3wayMC <- indProd(dat3way, 1:3, 4:6, 7:9)

model3 <- "
f1 =~ x1 + x2 + x3
f2 =~ x4 + x5 + x6
f3 =~ x7 + x8 + x9
f12 =~ x1.x4 + x2.x5 + x3.x6
f13 =~ x1.x7 + x2.x8 + x3.x9
f23 =~ x4.x7 + x5.x8 + x6.x9
f123 =~ x1.x4.x7 + x2.x5.x8 + x3.x6.x9
f4 =~ x10 + x11 + x12
f4 ~ f1 + f2 + f3 + f12 + f13 + f23 + f123
f1 ~~ 0*f12
f1 ~~ 0*f13
f1 ~~ 0*f123
f2 ~~ 0*f12
f2 ~~ 0*f23
f2 ~~ 0*f123
f3 ~~ 0*f13
f3 ~~ 0*f23
f3 ~~ 0*f123
f12 ~~ 0*f123
f13 ~~ 0*f123
f23 ~~ 0*f123
x1 ~ 0*1
x4 ~ 0*1
x7 ~ 0*1
x10 ~ 0*1
x1.x4 ~ 0*1
x1.x7 ~ 0*1
x4.x7 ~ 0*1
x1.x4.x7 ~ 0*1
f1 ~ NA*1
f2 ~ NA*1
f3 ~ NA*1
f12 ~ NA*1
f13 ~ NA*1
f23 ~ NA*1
f123 ~ NA*1
f4 ~ NA*1
" 

fitMC3way <- sem(model3, data=dat3wayMC, meanstructure=TRUE, std.lv=FALSE)
summary(fitMC3way)

result3wayMC <- probe3WayMC(fitMC3way, c("f1", "f2", "f3", "f12", "f13", "f23", "f123"), "f4", c("f1", "f2"), c(-1, 0, 1), c(-1, 0, 1))
result3wayMC
}
