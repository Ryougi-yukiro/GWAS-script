library(ggplot2)
data<-read.csv(file="h2_ucorrect.csv",header=F)
data<-na.omit(data)
p<- ggplot(data, aes(x=Group, y=h2, group=Type, color=Type)) + 
  geom_point(size=3,position=position_dodge(0.5),alpha = 0.7)+
  geom_errorbar(aes(ymin=h2-se, ymax=h2+se), width=0,
                position=position_dodge(0.5))+theme_bw()+coord_flip()
p<-p+theme(axis.text = element_text(size = 20))+ theme(axis.title = element_text(size = 15))+
theme(legend.text = element_text(size = 15))
p<-p + scale_color_manual(values=c("dodgerblue4","goldenrod1","#e7176d"))
#控制纵横比的两种方式
p1<-p+theme(aspect.ratio = 3)
p2<-p+coord_fixed(ratio=1)
p1
p2