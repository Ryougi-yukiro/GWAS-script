remotes::install_github("coolbutuseless/ggpattern")
library(magrittr)
library(tidyverse)
dffig2a<-read.csv(file="Pan-African_genome.csv",encoding="UTF-8",check.names=FALSE)
dffig2a<-dffig2a[,complete.cases(t(dffig2a))]
dffig2a %>% pivot_longer(-'Super-population') -> new.dffig2a
library(ggplot2)
cols<-c("#ffa657","#fd8011","#6cbe6c","#349734",
        "#eba0d5","#da7dbd","#63a0cb","#1f7ab4",
        "#d0d166","#bbbe21")
library(ggpattern)
p1<-ggplot(data = new.dffig2a,aes(x=`Super-population`,y=value))+
  geom_bar_pattern(stat="identity",
                   position = "dodge",
                   aes(pattern=name,
                       fill=name),
                   pattern_density=0.01,
                   fill=cols,
                   color="black",
                   show.legend = FALSE,cex.axis=100)+
  scale_pattern_manual(values = c('Divergence'='stripe',
                                  'Diversity'="none"))+
  scale_y_continuous(expand = expansion(mult = c(0,0.1)),
                     labels = scales::percent,
                     limits = c(0,0.25/100),
                     breaks = seq(0,0.25/100,by=0.05/100))+
  labs(x=NULL,y=NULL)+
  theme_classic()+
  theme(axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid = element_line(linetype = "dashed"),
        panel.grid.major = element_line(),
        panel.grid.minor = element_blank())

ggplot()+
  geom_rect_pattern(data=data.frame(x=1,xend=2,y=1,yend=2),
                    aes(xmin=x,ymin=y,xmax=xend,ymax=yend),
                    pattern_density=1,
                    fill="white",
                    color="black")+
  geom_rect_pattern(data=data.frame(x=1,xend=2,y=2.5,yend=3.5),
                    aes(xmin=x,ymin=y,xmax=xend,ymax=yend),
                    pattern="none",
                    pattern_density=1,
                    fill="grey",
                    color="black")+
  theme_void()+
  geom_text(data=data.frame(x=2,y=1.5),
            aes(x=x,y=y),label="Divergence",
            hjust=-0.1)+
  geom_text(data=data.frame(x=2,y=3),
            aes(x=x,y=y),label="Diversity",
            hjust=-0.1)+
  xlim(1,4) -> p2

p1+annotation_custom(grob = ggplotGrob(p2),
                    xmin = 4,xmax = Inf,
                    ymin = 0.2/100,ymax=0.25/100) -> p3
p3