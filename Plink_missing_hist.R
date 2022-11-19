indmiss<-read.table(file="plink.imiss", header=TRUE)
snpmiss<-read.table(file="plink.lmiss", header=TRUE)
# read data into R
​
pdf("histimiss.pdf") #indicates pdf format and gives title to file
hist(indmiss[,6],breaks=100,main="Histogram individual missingness") #selects column 6, names header of file
​
pdf("histlmiss.pdf")
hist(snpmiss[,5],breaks=100,main="Histogram SNP missingness")
dev.off() # shuts down the current device

