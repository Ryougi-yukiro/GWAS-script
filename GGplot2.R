library(dplyr)
library(ggplot2)
library(qqman)
data("gwasResults")
head(gwasResults)
don <- gwasResults %>% 
  
  # Compute chromosome size
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(chr_len)-chr_len) %>%
  select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(gwasResults, ., by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

axisdf <- don %>% group_by(CHR) %>% 
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )
don <- don %>%
  # 添加高亮和注释信息：snpsOfInterest中的rs编号和P值大于6的点
  mutate( is_highlight=ifelse(SNP %in% snpsOfInterest, "yes", "no")) %>%
  mutate( is_annotate=ifelse(-log10(P)>6, "yes", "no"))

p1<-ggplot(don, aes(x=BPcum, y=-log10(P))) +
  scale_color_manual(values = rep(c("grey", "grey"), 22 ))+
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3,color="red") +
  scale_x_continuous( label = axisdf$CHR, breaks= axisdf$center ) +
  geom_point(data=subset(don, is_highlight=="yes"), color="blue", size=2,shape=17)+
  scale_y_continuous(expand = c(0, 0) ) +     # remove space between plot area and x axis
  theme_bw() +
  theme( 
    legend.position = "None",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
)
#自定义一个矩形图例,这个函数包只是方便构建和合并
p2<-ggplot()+geom_pointrange(data=data.frame(x=5,y=1,ymin=2,ymax=2),
                  aes(x=x,y=y,ymin=ymin,ymax=ymax),
                  fill="red",color="red")+
  geom_pointrange(data=data.frame(x=5,y=1.5,ymin=1.5,ymax=1.5),
                    aes(x=x,y=y,ymin=ymin,ymax=ymax),
                    fill="blue",
                    color="blue",shape=17)+
  theme_void()+
  geom_text(data=data.frame(x=10,y=1),
            aes(x=x,y=y),label="SNP",
            hjust=-0.1)+
  geom_text(data=data.frame(x=10,y=1.5),
            aes(x=x,y=y),label="SV",
            hjust=-0.1)+
  xlim(1,100)
p2
#将图例合并入p1
p1+annotation_custom(grob = ggplotGrob(p2),
                     xmin = 1000,xmax = 2500,
                     ymin = 6.5,ymax=8) -> p3
p3