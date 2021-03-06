# library(tools)
# dirMan <- "C:/Users/student/Dropbox/semTools/semTools/man/runMI.Rd"
# showNonASCIIfile(dirMan)

sourceDir <- function(path, trace = TRUE, ...) {
     for (nm in list.files(path, pattern = "\\.[RrSsQq]$")) {
		if(nm != "AllClass.R" & nm != "AllGenerics.R") {
        if(trace) cat(nm,":") 
        source(file.path(path, nm), ...)
        if(trace) cat("\n")
		}
     }
}

sourceDirData <- function(path, trace = TRUE) {
     for (nm in list.files(path, pattern = "\\.[Rr]da$")) {
        if(trace) cat(nm,":") 
        load(paste0(path, nm), envir = .GlobalEnv)
        if(trace) cat("\n")
	}
}

#get
#assign
#dir <- "C:/Users/Sunthud/Desktop/My Dropbox/simsem/simsem/R/"
#dir <- "C:/Users/Sunthud/simsem_backup/simsem/R/"
library(lavaan)

dir <- "C:/Users/student/Dropbox/semTools/semTools/R/"
sourceDir(dir)

dirData <- "C:/Users/student/Dropbox/semTools/semTools/data/"
sourceDirData(dirData)
######### Distribution

skew(1:5)
kurtosis(1:5)
mardiaSkew(HolzingerSwineford1939[,paste("x", 1:9, sep="")])
mardiaKurtosis(HolzingerSwineford1939[,paste("x", 1:9, sep="")])

######### measurementInvariance

library(lavaan)
HW.model <- ' visual =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed =~ x7 + x8 + x9 '

measurementInvariance(HW.model, data=HolzingerSwineford1939, group="school")

######### moreFitIndices

HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- cfa(HS.model, data=HolzingerSwineford1939)
moreFitIndices(fit)

fit2 <- cfa(HS.model, data=HolzingerSwineford1939, estimator="MLR")
moreFitIndices(fit2)

library(psych)
dat <- iqitems
for(i in 1:ncol(iqitems)) {
	dat[,i] <- ordered(iqitems[,i])
}
iq.model <- '
reason =~ reason.4 + reason.16 + reason.17 + reason.19
letter =~ letter.7 + letter.33 + letter.34 + letter.58
matrix =~ matrix.45 + matrix.46 + matrix.47 + matrix.55
rotate =~ rotate.3 + rotate.4 + rotate.6 + rotate.8
'
fit3 <- cfa(iq.model, data=dat)
moreFitIndices(fit3)


######### orthogonalize

library(MASS)

n <- 500
means <- c(0,0)
covmat <- matrix(c(1, 0.3, 0.3, 1),nrow=2)

data <- mvrnorm(n,means,covmat)

x<-as.vector(data[,1])
z<-as.vector(data[,2])

y<-rnorm(n,0,1)+.4*x+.4*z+.2*x*z

x1<-rnorm(n,0.2,.2)+.7*x
x2<-rnorm(n,0.2,.2)+.7*x
x3<-rnorm(n,0.2,.2)+.7*x
z1<-rnorm(n,0.2,.2)+.7*z
z2<-rnorm(n,0.2,.2)+.7*z
z3<-rnorm(n,0.2,.2)+.7*z
y1<-rnorm(n,0.2,.2)+.7*y
y2<-rnorm(n,0.2,.2)+.7*y
y3<-rnorm(n,0.2,.2)+.7*y

dat<-data.frame(cbind(x1,x2,x3,z1,z2,z3,y1,y2,y3))

datOrth <-orthogonalize(dat,(1:3), (4:6))

########### Saris, Satorra, and van der Veld (2009)

library(lavaan)

HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- cfa(HS.model, data=HolzingerSwineford1939, group="sex", meanstructure=TRUE)
miPowerFit(fit)

model <- ' 
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + a*y2 + b*y3 + c*y4
     dem65 =~ y5 + a*y6 + b*y7 + c*y8

  # regressions
    dem60 ~ ind60
    dem65 ~ ind60 + dem60

  # residual correlations
    y1 ~~ y5
    y2 ~~ y4 + y6
    y3 ~~ y7
    y4 ~~ y8
    y6 ~~ y8
'
fit2 <- sem(model, data=PoliticalDemocracy, meanstructure=TRUE)
miPowerFit(fit2, stdLoad=0.3, cor=0.2, stdBeta=0.2, intcept=0.5)

############### Measurement Invariance ############################################

model <- ' f1t1 =~ y1t1 + y2t1 + y3t1
              f1t2 =~ y1t2 + y2t2 + y3t2
			  f1t3 =~ y1t3 + y2t3 + y3t3'

var1 <- c("y1t1", "y2t1", "y3t1")
var2 <- c("y1t2", "y2t2", "y3t2")
var3 <- c("y1t3", "y2t3", "y3t3")
constrainedVar <- list(var1, var2, var3)
longInvariance(model, auto=1, constrainAuto=TRUE, varList=constrainedVar, data=exLong)
longInvariance(model, auto=1, constrainAuto=TRUE, varList=constrainedVar, data=exLong, group="sex", group.equal=c("loadings", "intercepts"))

################ Power Analysis ################################################

plotRMSEApower(rmsea0=.05, rmseaA=.075, df=23, nlow=100, nhigh=500, steps=10)

plotRMSEAdist(rmsea=c(.05, .08), n=200, df=20, ptile=0.95, rmseaScale = TRUE)
plotRMSEAdist(rmsea=c(.05, .01), n=200, df=20, ptile=0.05, rmseaScale = FALSE)

findRMSEApower(rmsea0=.05, rmseaA=.08, df=20, n=200)

findRMSEAsamplesize(rmsea0=.05, rmseaA=.08, df=20, power=0.80)

################ Probing interaction ###########################################

dat2wayRC <- orthogonalize(dat2way, 1:3, 4:6)
dat2wayMC <- indProd(dat2way, 1:3, 4:6)
dat2wayDMC <- indProd(dat2way, 1:3, 4:6, doubleMC=TRUE)

dat3wayRC <- orthogonalize(dat3way, 1:3, 4:6, 7:9)
dat3wayMC <- indProd(dat3way, 1:3, 4:6, 7:9)
dat3wayDMC <- indProd(dat3way, 1:3, 4:6, 7:9, doubleMC=TRUE)

library(lavaan) 
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

fitMC2way <- sem(model1, data=dat2wayMC, meanstructure=TRUE, std.lv=FALSE)
summary(fitMC2way)
result2wayMC <- probe2WayMC(fitMC2way, c("f1", "f2", "f12"), "f3", "f2", c(-1, 0, 1))
result2wayMC

plotProbe(result2wayRC, xlim=c(-2, 2))
plotProbe(result2wayMC, xlim=c(-2, 2))

library(lavaan)
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

fitRC3way <- sem(model3, data=dat3wayRC, meanstructure=TRUE, std.lv=FALSE)
summary(fitRC3way)
result3wayRC <- probe3WayRC(fitRC3way, c("f1", "f2", "f3", "f12", "f13", "f23", "f123"), "f4", c("f1", "f2"), c(-1, 0, 1), c(-1, 0, 1))
result3wayRC

fitMC3way <- sem(model3, data=dat3wayMC, meanstructure=TRUE, std.lv=FALSE)
summary(fitMC3way)
result3wayMC <- probe3WayMC(fitMC3way, c("f1", "f2", "f3", "f12", "f13", "f23", "f123"), "f4", c("f1", "f2"), c(-1, 0, 1), c(-1, 0, 1))
result3wayMC

plotProbe(result3wayRC, xlim=c(-2, 2))
plotProbe(result3wayMC, xlim=c(-2, 2))

################################# outClipboard #############################

library(lavaan)
HW.model <- ' visual  =~ c("c1", "c1")*x1 + NA*x1 + c("c2", "c2")*x2 + c("c3", "c3")*x3
              textual =~ c("c4", "c4")*x4 + NA*x4 + c("c5", "c5")*x5 + c("c6", "c6")*x6
               speed   =~ c("c7", "c7")*x7 + NA*x7 + c("c8", "c8")*x8 + c("c9", "c9")*x9 
			   visual ~~ c(1, NA)*visual
			   textual ~~ c(1, NA)*textual
			   speed ~~ c(1, NA)*speed
			   
			   '

fit <- cfa(HW.model, data=HolzingerSwineford1939, group="school", meanstructure=TRUE)

clipboard(fit)
clipboard(fit, "mifit")
clipboard(fit, "coef")
clipboard(fit, "se")
clipboard(fit, "samp")
clipboard(fit, "fit")

################################ rmseaNested ##############################

# plotPower
# plotDist
# findPower
# findDist
# equiPower


################################# group allocation power #################



################################### Transcribe code ###################

library(lavaan)
HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- cfa(HS.model, data=HolzingerSwineford1939)
parTable(fit)



########### Auxiliary

library(lavaan)

HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '
			  
dat <- data.frame(HolzingerSwineford1939, z=rnorm(nrow(HolzingerSwineford1939), 0, 1))
			  
fit <- cfa(HS.model, data=dat, meanstructure=TRUE) #, group="sex", meanstructure=TRUE)
fitaux <- auxiliary(fit, data=dat, aux="z", fun="cfa", missing="ml")
	
fitgroup <- cfa(HS.model, data=dat, group="school")
fitgroupaux <- auxiliary(HS.model, data=dat, aux="z", group="school", fun="cfa")

mod <- ' x5 ~ x4
x4 ~ x3
x3 ~ x1 + x2
'

fitpath <- sem(mod, data=dat)
fitpathaux <- auxiliary(mod, aux="z", data=dat, fun="sem")

dat2 <- data.frame(PoliticalDemocracy, z=rnorm(nrow(PoliticalDemocracy), 0, 1))
model <- ' 
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + a*y2 + b*y3 + c*y4
     dem65 =~ y5 + a*y6 + b*y7 + c*y8

  # regressions
    dem60 ~ ind60
    dem65 ~ ind60 + dem60

  # residual correlations
    y1 ~~ y5
    y2 ~~ y4 + y6
    y3 ~~ y7
    y4 ~~ y8
    y6 ~~ y8
'
fitsem <- sem(model, data=dat2, meanstructure=TRUE)
fitsemaux <- auxiliary(fitsem, aux="z", data=dat2, meanstructure=TRUE, fun="sem")


HS.model.cov <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 
			  visual ~ sex
			  textual ~ sex
			  speed ~ sex'
	  
fitcov <- sem(HS.model.cov, data=dat, fixed.x=FALSE, meanstructure=TRUE) 
as.data.frame(fitcov@ParTable)
fitcovaux <- auxiliary(fitcov, aux="z", data=dat, fun="sem")

HS.model.cov2 <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              x7 ~ visual + textual'
	  
fitcov2 <- sem(HS.model.cov2, data=dat, fixed.x=FALSE, meanstructure=TRUE) 
as.data.frame(fitcov2@ParTable)
fitcov2aux <- auxiliary(fitcov2, aux="z", data=dat, fun="sem")

HS.model2 <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9'
			  
fit <- cfa(HS.model2, data=dat, meanstructure=TRUE)
fitaux <- auxiliary(fit, data=dat, aux="z", fun="cfa")
cfa.auxiliary(HS.model2, data=dat, aux="z")

HS.model2 <- ' visual  =~ x1 + x2 + x3
              speed   =~ x7 + x8 + x9'
fit <- cfa(HS.model2, data=HolzingerSwineford1939, meanstructure=TRUE)
fitaux <- auxiliary(HS.model2, data=HolzingerSwineford1939, aux=c("x4", "x5"), fun="cfa")

library(lavaan)
library(semTools)

# model for generating data
pop.model <- '
f =~ 1*x1 + 1*x2 + 1*x3 + 1*x4
f ~~ 1*f
x1 ~~ 0.2*x1
x2 ~~ 0.2*x2
x3 ~~ 0.2*x3
x4 ~~ 0.2*x4

# auxiliary variable is correlated with uniqueness
x1 + x2 + x3 + x4 ~~ 0.5*a
a ~~ 1*a
'

# analysis model for using auxiliary function in semTools
model1 <- '
f =~ x1 + x2 + x3 + x4
'

# analysis model for incorporating auxiliary variables using saturated correlates
model2 <- '
f =~ x1 + x2 + x3 + x4
x1 + x2 + x3 + x4 ~~ a
'

# generate data
set.seed(13243546)

my.df <- simulateData(pop.model, sample.nobs=500)

# 4 missing data patterns with no missing data for auxiliary variables
miss.pat <- list( c(1,1,1,1,1),
                  c(NA,1,1,1,1),
                  c(1,NA,1,1,1),
                  c(1,1,NA,1,1),
                  c(1,1,1,NA,1) )

# create a selection matrix for missing data
selection <- do.call( rbind,
                      sample( miss.pat, size=500, replace=TRUE, prob=c(0.6,
                                                                       0.1,
                                                                       0.1,
                                                                       0.1,
                                                                       0.1) ) )                     

# generate missing data by multiplying data with selection matrix
my.df <- my.df*selection

# using auxiliary( ) from semTools
fit1 <- cfa(model1, data=my.df, std.lv=TRUE, missing='fiml', meanstructure=TRUE)
fit.aux <- cfa.auxiliary(fit1, aux='a', data=my.df, missing='fiml')
fit.aux2 <- cfa.auxiliary(model1, aux='a', data=my.df, missing='fiml')

# running saturated correlates model directly
fit2 <- cfa(model2, data=my.df, std.lv=TRUE, missing='fiml')

#################################### runMI function ###########################################


HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

HSMiss <- HolzingerSwineford1939[,paste("x", 1:9, sep="")]
randomMiss <- rbinom(prod(dim(HSMiss)), 1, 0.1)
randomMiss <- matrix(as.logical(randomMiss), nrow=nrow(HSMiss))
HSMiss[randomMiss] <- NA

out <- cfa.mi(HS.model, data=HSMiss, m = 3, chi="all")
summary(out)
inspect(out, "fit")
inspect(out, "impute")
standardizedSolution(out)

outscaled <- cfa.mi(HS.model, data=HSMiss, m = 3, chi="all", estimator="mlm")
summary(outscaled)
inspect(outscaled, "fit")
inspect(outscaled, "impute")

##Multiple group example
HSMiss2 <- cbind(HSMiss, school = HolzingerSwineford1939[,"school"])
out2 <- cfa.mi(HS.model, data=HSMiss2, m = 3, miArgs=list(noms="school"), chi="MR", group="school")
summary(out2)
inspect(out2, "fit")
inspect(out2, "impute")

##Example using previously imputed data with runMI
library(Amelia)

modsim <- '
f1 =~ 0.7*y1+0.7*y2+0.7*y3
f2 =~ 0.7*y4+0.7*y5+0.7*y6
f3 =~ 0.7*y7+0.7*y8+0.7*y9'

mod <- '
f1 =~ y1+y2+y3
f2 =~ y4+y5+y6
f3 =~ y7+y8+y9'

datsim <- simulateData(modsim,model.type="cfa", meanstructure=TRUE, 
	std.lv=TRUE, sample.nobs=c(200,200))
randomMiss2 <- rbinom(prod(dim(datsim)), 1, 0.1)
randomMiss2 <- matrix(as.logical(randomMiss2), nrow=nrow(datsim))
datsim[randomMiss2] <- NA
datsimMI <- amelia(datsim,m=3, noms="group")

out3 <- runMI(mod, data=datsimMI$imputations, chi="LMRR", group="group", fun="cfa")
summary(out3)
inspect(out3, "fit")
inspect(out3, "impute")

library(mice)
model.syntax <- '
  # intercept and slope with fixed coefficients
    i =~ 1*t1 + 1*t2 + 1*t3 + 1*t4
    s =~ 0*t1 + 1*t2 + 2*t3 + 3*t4

  # regressions
    i ~ x1 + x2
    s ~ x1 + x2
'

library(simsem)
temp <- Demo.growth
temp[,paste0("t", 1:4)] <- imposeMissing(temp[,paste0("t", 1:4)], pmMCAR=0.2)


imp <- mice(temp,m=5,print=F)

imputedData <- NULL
for(i in 1:5) {
imputedData[[i]] <- complete(x=imp, action=i, include=FALSE) 
}
  
out4 <- runMI(model.syntax, data=imputedData, fun="growth")
summary(out4)
inspect(out4, "fit")
inspect(out4, "impute")

popModel <- "
f1 =~ 0.7*y1 + 0.7*y2 + 0.7*y3 + 0.7*y4
f1 ~~ 1*f1
y1 | 0.5*t1
y2 | 0.25*t1
y3 | 0*t1
y4 | -0.5*t1
"

analyzeModel <- "
f1 =~ y1 + y2 + y3 + y4
"

dat <- simulateData(popModel, sample.nobs  = 200L)
miss.pat <- matrix(as.logical(rbinom(prod(dim(dat)), 1, 0.2)), nrow(dat), ncol(dat))
dat[miss.pat] <- NA
out5 <- cfa.mi(analyzeModel, data=dat, ordered=paste0("y", 1:4), m = 3, miArgs=list(ords = c("y1", "y2", "y3", "y4")))
summary(out5)
inspect(out5, "fit")
inspect(out5, "impute")

############### FMI function

library(Amelia)
library(lavaan)

modsim <- '
f1 =~ 0.7*y1+0.7*y2+0.7*y3
f2 =~ 0.7*y4+0.7*y5+0.7*y6
f3 =~ 0.7*y7+0.7*y8+0.7*y9'

datsim <- simulateData(modsim,model.type="cfa", meanstructure=TRUE, 
                       std.lv=TRUE, sample.nobs=c(200,200))
randomMiss2 <- rbinom(prod(dim(datsim)), 1, 0.1)
randomMiss2 <- matrix(as.logical(randomMiss2), nrow=nrow(datsim))
randomMiss2[,10] <- FALSE
datsim[randomMiss2] <- NA
datsimMI <- amelia(datsim,m=3,idvars="group")

out1 <- fmi(datsimMI$imputations, exclude="group")
out1
                       
out2 <- fmi(datsimMI$imputations, exclude="group", method="null")
out2
                       
out3 <- fmi(datsimMI$imputations, varnames=c("y1","y2","y3","y4"))
out3

out4 <- fmi(datsimMI$imputations, group="group")
out4

########### Raykov's reliability

HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- cfa(HS.model, data=HolzingerSwineford1939)
reliability(fit)

fit2 <- cfa(HS.model, data=HolzingerSwineford1939, estimator="MLR")
reliability(fit2)

fit3 <- cfa(HS.model, data=HolzingerSwineford1939, estimator="MLR", group="school", group.equal="loadings")
reliability(fit3)

library(psych)
dat <- iqitems
for(i in 1:ncol(iqitems)) {
	dat[,i] <- ordered(iqitems[,i])
}
iq.model <- '
reason =~ reason.4 + reason.16 + reason.17 + reason.19
letter =~ letter.7 + letter.33 + letter.34 + letter.58
matrix =~ matrix.45 + matrix.46 + matrix.47 + matrix.55
rotate =~ rotate.3 + rotate.4 + rotate.6 + rotate.8
'
fit4 <- cfa(iq.model, data=dat)
reliability(fit4) # Should provide a warning for coefficient alpha

HS.model2 <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 
			  visual ~ textual + speed'

fit5 <- cfa(HS.model2, data=HolzingerSwineford1939)
reliability(fit5) # Should provide a warning for the endogenous variable


HS.model3 <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 
			  higher =~ visual + textual + speed'

fit6 <- cfa(HS.model3, data=HolzingerSwineford1939)
reliability(fit6) # Should provide a warning for the endogenous variable
reliabilityL2(fit6, "higher")

HS.model4 <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
			  higher =~ visual + textual + x7 + x8 + x9'

fit7 <- cfa(HS.model4, data=HolzingerSwineford1939)
reliability(fit7) # Should provide a warning for the endogenous variable
reliabilityL2(fit7, "higher")

HS.model5 <- ' visual  =~ x1 + x2 + x3 + x4
              textual =~ x4 + x5 + x6 + x7
			  speed   =~ x7 + x8 + x9 '

fit8 <- cfa(HS.model5, data=HolzingerSwineford1939)
reliability(fit8) 

########### Implied factor means and covariances

HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 
			  visual ~ agemo
			  textual ~ agemo
			  speed ~ agemo'

fit <- cfa(HS.model, data=HolzingerSwineford1939, fixed.x = FALSE, meanstructure=TRUE)
impliedFactorStat(fit)
impliedFactorMean(fit)
impliedFactorCov(fit)

fit2 <- cfa(HS.model, data=HolzingerSwineford1939, group="school")
impliedFactorStat(fit2)
impliedFactorMean(fit2)
impliedFactorCov(fit2)
