library(GenABEL)

dat<-read.table(file="GBLUP_g2.fastGWA",header=T)

(lam<-estlambda(dat$P,plot=T))
    