#jus like the missing_plot.R
#you can use this script after 
#
#plink --file all --freq --out maf#
#

data<-read.table(file="maf.frq",header=T)
#read table
pdf("maf.pdf",height=10,width=10)
hist(data[,5],col='blue',breaks=100)
dev.off()
#plot your data
