\name{probe2WayRC}
\alias{probe2WayRC}
\title{
Probing two-way interaction on the residual-centered latent interaction
}
\description{
Probing interaction for simple intercept and simple slope for the residual-centered latent two-way interaction (Pornprasertmanit, Schoemann, Geldhof, & Little, submitted)
}
\usage{
probe2WayRC(fit, nameX, nameY, modVar, valProbe)
}
\arguments{
  \item{fit}{The lavaan model object used to evaluate model fit}
  \item{nameX}{The vector of the factor names used as the predictors. The first-order factor will be listed first. The last name must be the name representing the interaction term.}
  \item{nameY}{The name of factor that is used as the dependent variable.}
  \item{modVar}{The name of factor that is used as a moderator. The effect of the other independent factor on each moderator variable value will be probed.}
  \item{valProbe}{The values of the moderator that will be used to probe the effect of the other independent factor.}
}
\details{
Before using this function, researchers need to make the products of the indicators between the first-order factors and residualize the products by the original indicators (Lance, 1988; Little, Bovaird, & Widaman, 2006). The process can be automated by the \code{\link{indProd}} function. Note that the indicator products can be made for all possible combination or matched-pair approach (Marsh et al., 2004). Next, the hypothesized model with the regression with latent interaction will be used to fit all original indicators and the product terms. See the example for how to fit the product term below. Once the lavaan result is obtained, this function will be used to probe the interaction.

The probing process on residual-centered latent interaction is based on transforming the residual-centered result into the no-centered result. See Pornprasertmanit, Schoemann, Geldhof, and Little (submitted) for further details. Note that this approach based on a strong assumption that the first-order latent variables are normally distributed. The probing process is applied after the no-centered result (parameter estimates and their covariance matrix among parameter estimates) has been computed. See the \code{\link{probe2WayMC}} for further details.
}
\value{
A list with two elements:
\enumerate{
  \item{SimpleIntercept} The intercepts given each value of the moderator. This element will be shown only if the factor intercept is estimated (e.g., not fixed as 0).
  \item{SimpleSlope} The slopes given each value of the moderator. 
}
In each element, the first column represents the values of the moderators specified in the \code{valProbe} argument. The second column is the simple intercept or simple slope. The third column is the standard error of the simple intercept or simple slope. The fourth column is the Wald (\emph{z}) statistic. The fifth column is the \emph{p}-value testing whether the simple intercepts or slopes are different from 0.
}
\references{

Lance, C. E. (1988). Residual centering, exploratory and confirmatory moderator analysis, and decomposition of effects in path models containing interactions. \emph{Applied Psychological Measurement, 12}, 163-175.

Little, T. D., Bovaird, J. A., & Widaman, K. F. (2006). On the merits of orthogonalizing powered and product terms: Implications for modeling interactions. \emph{Structural Equation Modeling, 13}, 497-519.

Marsh, H. W., Wen, Z., & Hau, K. T. (2004). Structural equation models of latent interactions: Evaluation of alternative estimation strategies and indicator construction. \emph{Psychological Methods, 9}, 275-300.

Pornprasertmanit, S., Schoemann, A. M., Geldhof, G. J., & Little, T. D. (submitted). \emph{Probing latent interaction estimated with a residual centering approach.} 

}
\author{
    Sunthud Pornprasertmanit (University of Kansas; \email{psunthud@ku.edu})
}
\seealso{
	\itemize{
		\item \code{\link{indProd}} For creating the indicator products with no centering, mean centering, double-mean centering, or residual centering.
		\item \code{\link{probe2WayMC}} For probing the two-way latent interaction when the results are obtained from mean-centering, or double-mean centering.
		\item \code{\link{probe3WayMC}} For probing the three-way latent interaction when the results are obtained from mean-centering, or double-mean centering.
		\item \code{\link{probe3WayRC}} For probing the two-way latent interaction when the results are obtained from residual-centering approach.
		\item \code{\link{plotProbe}} Plot the simple intercepts and slopes of the latent interaction.
	}
}
\examples{
library(lavaan) 

dat2wayRC <- orthogonalize(dat2way, 1:3, 4:6)

model1 <- "
f1 =~ x1 + x2 + x3
f2 =~ x4 + x5 + x6
f12 =~ x1.x4 + x2.x5 + x3.x6
f3 =~ x7 + x8 + x9
f3 ~ f1 + f2 + f12
f12 ~~0*f1
f12 ~~ 0*f2
x1 ~ 0*1
x4 ~ 0*1
x1.x4 ~ 0*1
x7 ~ 0*1
f1 ~ NA*1
f2 ~ NA*1
f12 ~ NA*1
f3 ~ NA*1
"

fitRC2way <- sem(model1, data=dat2wayRC, meanstructure=TRUE, std.lv=FALSE)
summary(fitRC2way)

result2wayRC <- probe2WayRC(fitRC2way, c("f1", "f2", "f12"), "f3", "f2", c(-1, 0, 1))
result2wayRC
}
