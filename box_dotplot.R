library(ggplot2)
data<-read.table(file="vgp.se.table",header=F)
data<-na.omit(data)
p<-ggplot(data,aes(x=V1,y=V2))+
  geom_point(size=3,position=position_dodge(0.5),alpha = 0.7)+
  geom_errorbar(aes(ymin=V2-V3, ymax=V2+V3), width=0,position=position_dodge(0.5))+
  theme_bw()+coord_flip()

p<-p+theme(axis.text = element_text(size = 10))+ theme(axis.title = element_text(size = 15))+
  theme(legend.text = element_text(size = 15))
p2<-p+coord_fixed(ratio=0.2)+ scale_color_manual(values=c("dodgerblue4","goldenrod1","#e7176d"))
p2

p<- ggplot(data, aes(x=Group, y=h2, group=Type, color=Type)) + 
  geom_point(size=3,position=position_dodge(0.5),alpha = 0.7)+
  geom_errorbar(aes(ymin=h2-se, ymax=h2+se), width=0,
                position=position_dodge(0.5))+theme_bw()+coord_flip()
p<-p+theme(axis.text = element_text(size = 20))+ theme(axis.title = element_text(size = 15))+
theme(legend.text = element_text(size = 15))


#控制纵横比的两种方式
p1<-p+theme(aspect.ratio = 3)
p2<-p+coord_fixed(ratio=1)
p1
p2

library(ggpubr)
box<-read.csv(file="boxplot.csv",header=T)
p<-ggplot(box,aes(a,i,fill=a),alpha=.7)+geom_boxplot()+theme_bw()+
  theme(axis.text = element_text(size = 15))+ theme(axis.title = element_text(size = 15))+
  theme(legend.text = element_text(size = 15))+
  stat_compare_means(method="anova",label="p.signif")
p
