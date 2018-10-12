#####DRIVERS OF CHANGE ###########################################

### prioritizing drivers of change based on impact and uncertainty

setwd("D:/sAlvarez/Documents/SocioEconomicoSNAPP")
library(plyr)
library(magrittr)
library(dplyr)

motores<-read.csv("MotoresPriorizadosGF.csv", header=T, sep=";")
mot.impacto<-subset(motores, select = Desarrollo.de.infraestructura:Cambio.climático) 
mot.impacto<-mot.impacto[,sort(colnames(mot.impacto))]

mot.certi<-subset(motores, select = Desarrollo.de.infraestructura.1:Cambio.climático.1)
mot.certi<-mot.certi[,sort(colnames(mot.certi))]

##mean and median for all drivers accross all participants in terms of impact
mean.mot.impacto<-apply(mot.impacto, 2, mean, na.rm=T)
median.mot.impacto<-apply(mot.impacto, 2, median, na.rm=T)

##mean and median for all drivers accross all participants in terms of uncertainty
mean.mot.certi<-apply(mot.certi, 2, mean, na.rm=T)
median.mot.certi<-apply(mot.certi, 2, median, na.rm=T)

###mean by drivers by sector
mean.mot.impacto.sectors<- data.frame(mot.impacto, sector= motores$Sector) %>% subset(
  ., sector %in% c("Palmero", "Ganadero", "Agroforestales")) %>% group_by(sector) %>% 
  summarise_all(mean, na.rm=T) %>% as.data.frame

mean.mot.certi.sectors<- data.frame(mot.certi, sector= motores$Sector) %>% subset(
  ., sector %in% c("Palmero", "Ganadero", "Agroforestales")) %>% group_by(sector) %>% 
  summarise_all(mean, na.rm=T) %>% as.data.frame

par(pty="s")

plot(mean.mot.impacto, mean.mot.certi, xlim=c(1, 5), ylim=c(5,1), pch=c(1, 4, 6, 8, 17, 19), col=c(rep('#e41a1c',6), rep('#377eb8',6), rep('#4daf4a', 6), rep('#984ea3', 6)), xlab="Impacto", ylab="Incertidumbre")

text.leg<-
  legend(x="right", legend=colnames(mot.impacto), cex=0.7, pt.cex=0.5)
