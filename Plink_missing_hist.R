# This script used for plot missing hist.
# You can get the missing table after run this line 
#
# plink -file yourfile --missing #
# The document need this two file yourfile.ped. yourfile.map.
# i think you can get it.

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

