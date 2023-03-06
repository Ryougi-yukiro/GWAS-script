library(qqman)
library(GenABEL)
dat<-read.table(file="final_SNP_N.fastGWA",header=T)

# 6.xxxx = -log10(有效SNP大小)
manhattan(dat, bp="POS",main = "Manhattan Plot", ylim = c(0, 10), cex = 1, cex.axis = 0.9, 
          col = c("blue4", "orange3"), suggestiveline = F, genomewideline = 6.701146923590293)
qq(dat$P, main = "Q-Q plot of GWAS p-values", xlim = c(0, 7), 
   ylim = c(0,12), pch = 18, col = "blue4", cex = 1.5, las = 1)

(lam<-estlambda(dat$P,plot=T))

# p-value矫正 修正lanmba=1
chis = qchisq(dat$P,df=1,lower.tail = F)
ps1=pchisq(chis/lam,df=1,lower.tail = F)
dat$Q=ps1

qq(dat$Q, main = "Q-Q plot of GWAS p-values", xlim = c(0, 7), 
   ylim = c(0,12), pch = 18, col = "blue4", cex = 1.5, las = 1)

manhattan(dat, bp="POS",p="Q",main = "Manhattan Plot", ylim = c(0, 10), cex = 0.8, cex.axis = 0.9, 
          col = c("blue4", "orange3"), suggestiveline = F, genomewideline = 6.701146923590293)
write.table(dat,file="snp_re_PCA10_N_after.fastGWA")
