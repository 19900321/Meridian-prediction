library(car)
library(tidyverse)
library(mgcv)
library('e1071')
library(caret)
library(nycflights13)
library(ggplot2)
library(pls)
library(reshape2)
library(ggplot2)
library(lattice)
library (VennDiagram)
library(UpSetR)
library(reshape2)


###figure2-a
mydata<- read.csv('C:\\Users\\yinyin\\Desktop\\herbpair\\10.Final result of meridians\\organ-dis.csv', header =T,sep=',')
Kidney = mydata$Herbid [which(mydata$Kidney == 1)]
Liver = mydata$Herbid[which(mydata$Liver == 1)]
Spleen = mydata$Herbid[which(mydata$Spleen == 1)]
Stomach = mydata$Herbid[which(mydata$Stomach == 1)]
Bladder = mydata$Herbid[which(mydata$Bladder == 1)]
Heart = mydata$Herbid[which(mydata$Heart == 1)]
Gallbladder = mydata$Herbid[which(mydata$Gallbladder == 1)]
Lung = mydata$Herbid[which(mydata$Lung == 1)]
LargeIntestine = mydata$Herbid[which(mydata$LargeIntestine == 1)]
SmallIntestine = mydata$Herbid[which(mydata$SmallIntestine == 1)]

upset(mydata, sets = c('Kidney','Liver','Spleen','Stomach','Bladder','Heart','Gallbladder','Lung','LargeIntestine','SmallIntestine' ), sets.bar.color = "#56B4E9",
      order.by = "freq", empty.intersections = "on",show.numbers=TRUE)

###Figure 2 b correlation figure
mydata<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\8.trainging the data\\compound level\\feafru700.csv", header =T,sep=',')
uniquedata2= uniquecombs(mydata)
uniquedata2[is.na(uniquedata2)] <- 0
a=colSums(uniquedata2)
#uniquedata2=apply(uniquedata,2,as.numeric)
combin <- data.frame(rbind(t(data.frame(a)),data.frame(uniquedata2)))
uniquedata2=combin[,which(a!=0)][-1,]
rownames(uniquedata2)=uniquedata2[,1]
uniquedata2=uniquedata2[,-1]

allorgan=scale(select(uniquedata2,Lung:Liver))
library(corrgram)
corrgram(allorgan, order=TRUE, lower.panel=panel.shade,
         upper.panel=panel.pie, text.panel=panel.txt,
         main="Corrgram of meridian intercorrelations")

###figure3-a

allresult<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\10.Final result of meridians\\picture\\moderl result\\all model result.csv", header =T,sep=',')
allresult$data=factor(allresult$Feature_used)

ggplot(data = allresult) +geom_point(mapping = aes(x = F1, y = Balanced.Accuracy,color =Feature_used,shape=Methods),size=3)+ facet_wrap(~ organ, nrow = 3)

##figure3-b
allresultfiter<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\10.Final result of meridians\\picture\\f3b-herb-after-allorgan.csv", header =T,sep=',')
allresult$data=factor(allresult$data)
allresult$organ=factor(allresult$organ)
ggplot(data = allresultfiter) +geom_point(mapping = aes(x = F1, y = Balanced.Accuracy,color = data,shape=method),size=3)+ facet_wrap(~ organ, nrow = 3)
allresultfiter2<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\10.Final result of meridians\\picture\\fig3_all.csv", header =T,sep=',')
allresultfiter2$data=factor(allresultfiter2$data)
allresultfiter2$organ=factor(allresultfiter2$organ)
ggplot(data = allresultfiter2) +geom_point(mapping = aes(x = F1, y = Balanced.Accuracy,color = data,shape=method,group_by()),size=3)+ facet_wrap(~ organ, nrow = 3)

##Figure5-a
mydata5<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\liver model\\new3\\seed-20.csv", header =T,sep=',')
names(mydata5)
ggplot(data=mydata5, aes(x=data,y=F1))+geom_boxplot(aes(fill=method))
##Figure5-b
ggplot(data=mydata5, aes(x=data,y=Balanced.Accuracy))+geom_boxplot(aes(fill=method))

##Figure5-c
##without others

mydata5<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\liver model\\new3\\seed-20.csv", header =T,sep=',')

#with others
mydata6<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\liver model\\new3\\liver+other\\allother.csv", header =T,sep=',')

##all
mydata8<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\liver model\\new3\\all\\all2.csv", header =T,sep=',')
resultfold="C:\\Users\\yinyin\\Desktop\\herbpair\\liver model\\new3\\all\\1"

dat.m <- melt(orignaldata,id.vars=c('data','method'),measure.vars=c('Sensitivity','Specificity','F1','Balanced.Accuracy'))
ggplot(dat.m) + geom_boxplot(aes(x=data, y=value,color=variable,fill=method))
#blance=ggplot(data=orignaldata, aes(x=data,y=Balanced.Accuracy))+geom_boxplot(aes(fill=method))
#png(" blanced.accuracy.png")
#plot(blance)
#dev.off()

#Figure 6a
data6<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\10.Final result of meridians\\picture\\f6a-compound-allorgan.csv", header =T,sep=',')

ggplot(data = data6) +geom_point(mapping = aes(x = data6$Accuracy, y = data6$F1,color =organ,shape=method),size=3)+ facet_wrap(~ data, nrow = 3)

#Figure 6b

data7<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\10.Final result of meridians\\picture\\figure6 b compound all-combination.csv", header =T,sep=',')
data7$ntree=factor(data7$ntree)
data7$mtry=factor(data7$mtry)
ggplot(data7, aes(x=mtry, y=Accuracy, colour=ntree, shape = meridian, group=interaction(ntree, meridian))) + geom_point() + geom_line()+ facet_wrap(~ organ, nrow = 3)

data_liver=filter(data7, organ=='Liver')
ggplot(data_liver, aes(x=mtry, y=Accuracy, colour=ntree, shape = meridian, group=interaction(ntree, meridian))) + geom_point() + geom_line()
data_Lung=filter(data7, organ=='Lung')
ggplot(data_Lung, aes(x=mtry, y=Accuracy, colour=ntree, shape = meridian, group=interaction(ntree, meridian))) + geom_point() + geom_line()
data_Spleen=filter(data7, organ=='Spleen')
ggplot(data_Spleen, aes(x=mtry, y=Accuracy, colour=ntree, shape = meridian, group=interaction(ntree, meridian))) + geom_point() + geom_line()


#them
windowsFonts(
  D=windowsFont("Arial Black"),
  B=windowsFont("Bookman Old Style"),
  E=windowsFont("Comic Sans MS"),
  A=windowsFont("Arial"),
  B=windowsFont("Time New Roman")
)
mytheme <- theme(plot.title=element_text(family = "A",face="plain",
                                         size="10", color="black"),
                 axis.title=element_text(family = "A",face="plain",
                                         size=10, color="black"),
                 axis.text=element_text(family = "A",face="plain", size=10,
                                        color="black"),
                 axis.title.y = element_text(family = "A",face="plain", size=10,
                                             color="black", angle = 45),
                 axis.title.x = element_text(family = "A",face="plain", size=10,
                                             color="black", angle = 45),
                 panel.background=element_rect(fill="white",
                                               color="darkblue"),
                 panel.grid.major.y=element_line(color="grey",
                                                 linetype=1),
                 panel.grid.minor.y=element_line(color="grey",
                                                 linetype=2),
                 panel.grid.minor.x=element_blank(),
                 legend.position="right",legend.justification='center')
bty = 'l'
data8<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\10.Final result of meridians\\mtry1to10\\knn_fit2.csv", header =T,sep=',')
ggplot(data8, aes(x=mtry, y=Accuracy, colour=ntree, shape = meridian, group=interaction(ntree, meridian))) + geom_point() + geom_line()+ggtitle("Profiles for Iris Clusters")
ggplot(data8, aes(x=mtry, y=Accuracy, colour=ntree)) + geom_point() + geom_line()+ggtitle("Profiles for Iris Clusters")+mytheme3
#Figure 6c

#flow wxample1
flow_pic_1_example.csv
mytheme <- theme(plot.title=element_text(family = "A",face="plain",
                                         size=15, color="black"),
                 axis.title=element_text(family = "A",face="plain",
                                         size=15, color="black"),
                 axis.text=element_text(family = "A",face="plain", size=15,
                                        color="black"),
                 axis.title.y = element_text(family = "A",face="plain", size=15
                                             color="black", angle = 45),
                 axis.title.x = element_text(family = "A",face="plain", size=15,
                                             color="black", angle = 0),
                 panel.background=element_rect(fill="transparent",
                                               color="transparent"),
                 panel.border = element_rect(fill="transparent",
                                             color="black"),
                 panel.grid.minor.x=element_blank(),
                 legend.text = element_text(family = "A",face="plain",
                                            size=15, color="black"),
                 legend.title = element_text(family = "A",face="plain",
                                             size=15, color="black"),
                 strip.text = element_text(family = "A",face="plain",
                                           size=15, color="black")
                 
                 )

mytheme2 <- theme(plot.title=element_text(family = "A",face="plain",
                                         size=20, color="black"),
                 axis.title=element_text(family = "A",face="plain",
                                         size=20, color="black",margin=margin(1,1,1,1,"pt")),
                 axis.text=element_text(family = "A",face="plain", size=20,
                                        color="white"),
                 axis.title.y = element_text(family = "A",face="plain", size=20,
                                             color="black", angle = 0,vjust=0.5),
                 axis.title.x = element_text(family = "A",face="plain", size=20,
                                             color="black", angle = 0),
                 panel.background=element_rect(fill="transparent",
                                               color="transparent"),
                 panel.border = element_rect(fill="transparent",
                                             color="black"),
                 panel.grid.minor.x=element_blank(),
                 #legend.position = c(0.8, 0.5),
                 #axis.ticks.margin = unit(0.01,"cm"),
                 legend.text = element_text(family = "A",face="plain",
                                            size=20, color="black"),
                 legend.title = element_text(family = "A",face="plain",
                                             size=20, color="black"),
                 strip.text = element_text(family = "A",face="plain",
                                           size=20, color="black"),
                 plot.margin = margin(1,1,1,1,"pt")
                 )
data10<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\10.Final result of meridians\\picture\\flow_pic_1_example.csv", header =T,sep=',')
data10$ntree=factor(data10$ntree)
data10$mtry=factor(data10$mtry)
ggplot(data10, aes(x=mtry, y=Accuracy, colour=ntree, shape = Feature, group=interaction(ntree,Feature))) + geom_point() + geom_line()+ facet_wrap(~ organ, nrow = 1)+mytheme3


##mytheme3
mytheme3 <- theme(plot.title=element_text(family = "A",face="plain",
                                          size=25, color="black"),
                  axis.title=element_text(family = "A",face="plain",
                                          size=25, color="black",margin=margin(1,1,1,1,"pt")),
                  axis.text=element_blank(),
                  axis.title.y = element_text(family = "A",face="plain", size=25,
                                              color="black", angle = 90,vjust=0.5),
                  axis.title.x = element_text(family = "A",face="plain", size=25,
                                              color="black", angle = 0),
                  axis.ticks = element_blank(),
                  panel.background=element_rect(fill="transparent",
                                                color="transparent"),
                  panel.border = element_rect(fill="transparent",
                                              color="black"),
                  panel.grid.minor.x=element_blank(),
                  legend.position = c(0.7, 0.5),
                  #axis.ticks.margin = unit(0.01,"cm"),
                  legend.text = element_text(family = "A",face="plain",
                                             size=25, color="black"),
                  legend.title = element_text(family = "A",face="plain",
                                              size=25, color="black"),
                  strip.text = element_text(family = "A",face="plain",
                                            size=25, color="black"),
                  plot.margin = margin(1,1,1,1,"pt")
)

axis.title.x = element_blank(),
axis.title.y = element_blank(),
axis.ticks.y  = element_blank(),
mytheme5 <- theme(plot.title=element_text(family = "A",face="plain",
                                          size=25, color="black"),
                  axis.title=element_text(family = "A",face="plain",
                                          size=25, color="black",margin=margin(1,1,1,1,"pt")),
                  axis.text=element_blank(),
                  axis.title.y = element_text(family = "A",face="plain", size=25,
                                              color="black", angle = 90,vjust=0.5),
                  axis.title.x = element_text(family = "A",face="plain", size=25,
                                              color="black", angle = 0),
                  axis.ticks = element_blank(),
                  panel.background=element_rect(fill="transparent",
                                                color="transparent"),
                  panel.border = element_rect(fill="transparent",
                                              color="black"),
                  panel.grid.minor.x=element_blank(),
                  #legend.key.height = unit(5),
                  #legend.position = c(0.7, 0.5),
                  #axis.ticks.margin = unit(0.01,"cm"),
                  legend.text = element_text(family = "A",face="plain",
                                             size=20, color="black",margin=margin(5,5,5,5,"pt")),
                  #legend.position = 'bottom',
                  legend.position = 'left',
                  #legend.box.margin = margin(5,6,5,6, "cm"),
                  #legend.box.spacing = unit(5, "cm"),
                  legend.title = element_text(family = "A",face="plain",
                                              size=25, color="black"),
                  strip.text = element_text(family = "A",face="plain",
                                            size=25, color="black"),
                  plot.margin = margin(1,1,1,1,"pt")
)
#flow wxample2
###figure3-a
mytheme <- theme(plot.title=element_text(family = "A",face="plain",
                                         size="15", color="black"),
                 axis.title=element_text(family = "A",face="plain",
                                         size=15, color="black"),
                 axis.text=element_text(family = "A",face="plain", size=15,
                                        color="black"),
                 axis.title.y = element_text(family = "A",face="plain", size=15,
                                             color="black", angle = 65),
                 axis.title.x = element_text(family = "A",face="plain", size=15,
                                             color="black", angle = 0),
                 panel.background=element_rect(fill="transparent",
                                               color="transparent"),
                 panel.border = element_rect(fill="transparent",
                                             color="black"),
                 panel.grid.minor.x=element_blank(),
                 legend.text = element_text(family = "A",face="plain",
                                            size=15, color="black"),
                 legend.position = 'left',
                 legend.box.margin = margin(0, 0, 0,0, "cm"),
                 legend.title = element_text(family = "A",face="plain",
                                             size=15, color="black"),
                 strip.text = element_text(family = "A",face="plain",
                                           size=15, color="black")
                 
)
allresult<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\10.Final result of meridians\\picture\\example2.csv", header =T,sep=',')
#allresult2=filter(allresult, organ == 'Liver')
#allresult3=filter(allresult2, Methods == c('kNN','RF'))
#allresult2=filter(allresult2, Feature_used == c('Ext','ADME'))
allresult$Feature=factor(allresult$Feature)

ggplot(data = allresult) +geom_point(mapping = aes(x = F1, y = Balanced.Accuracy,color = Feature_used,shape=Methods),size=6)+ facet_wrap(~ organ, nrow = 3)+mytheme5


##change text of function

x <- c(1:10)
y <- x
z <- 10/x

opar <- par(no.readonly = TRUE)

par(mar = c(5, 4, 4, 8) + 0.1)

plot(x, y, type = "b", pch = 21, col = "red", yaxt = "n",  #??????x???y?????????
     lty = 3, ann = FALSE)

lines(x, z, type = "b", pch = 22, col = "blue", lty = 2)  #??????x???1/x?????????

axis(2, at = x, labels = x, col.axis = "red", las = 2)  #????????????????????????
axis(3, at = z, labels = round(z, digits = 2), col.axis = "black", family='A',face= 'plain',
     +      las = 2, cex.axis = 1.5, tck = 0)
axis(4, at = z, labels = round(z, digits = 2), col.axis = "blue", 
     las = 2, cex.axis = 0.7, tck = -0.01)

mtext("y=10/x", side = 4, line = 3, cex.lab = 1, las = 2, col = "blue")

title("An Example of Creative Axes", xlab = "X values", ylab = "Y=X")

par(opar)

##importance
data10<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\10.Final result of meridians\\picture\\The importance for liver.csv", header =T,sep=',')
allfeature = data10
names = allfeature$Feature
allfeature$name=allfeature$Feature
allfeature = allfeature[rev(order(allfeature$Overall)),][1:5,]
allfeature$name = factor(allfeature$name,levels = rev(allfeature$name))
ggplot(data = allfeature, aes(x =  allfeature$name, y = allfeature$Overall, fill=name)) +
  geom_bar(colour="black", fill="#DD8888", width=.01, stat="identity") + geom_point(colour="black",pch=1)+
  guides(fill=FALSE) +
  ggtitle("Top5 important Fearture")+
  theme(plot.title=element_text(family = "A",face="plain",
                                size=25, color="black",hjust = 0.5),
        axis.title=element_text(family = "A",face="plain",
                                size=25, color="black",margin=margin(1,1,1,1,"pt")),
        axis.text=element_text(family = "A",face="plain", size=25,
                               color="black"),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y  = element_blank(),
        axis.ticks.x  = element_blank(),
        panel.background=element_rect(fill="transparent",
                                      color="transparent"),
        panel.border = element_rect(fill="transparent",
                                    color="black"),
        panel.grid.minor.x=element_blank(),
        #legend.position = c(0.8, 0.5),
        #axis.ticks.margin = unit(0.01,"cm"),
        legend.text = element_text(family = "A",face="plain",
                                   size=25, color="black"),
        legend.position = c(0.8, 0.5),
        legend.title = element_text(family = "A",face="plain",
                                    size=25, color="black"),
        strip.text = element_text(family = "A",face="plain",
                                  size=25, color="black"),
        plot.margin = margin(1,1,1,1,"pt")
  )+coord_flip(ylim=c(allfeature$Overall[1],allfeature$Overall[5])) 
#+ scale_x_reverse()

#
data6<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\10.Final result of meridians\\picture\\f6a-compound-allorgan_rfadd.csv", header =T,sep=',')
allresult2 = data6
#organselect = c('Liver')
#allresult2 = allresult2[allresult2$organ %in% organselect, ]
#allresult2=filter(allresult2, allresult2$organ == 'Liver')
#allresult3=filter(allresult2, Methods == c('kNN','RF'))
#allresult4=filter(allresult2, Feature_used == c('Ext','ADME'))
allresult2$method_level  = paste0(allresult2$Methods,'_',allresult2$Level)
allresult2$Feature_used=factor(allresult2$Feature_used)
allresult2$method_level=factor(allresult2$method_level)
ggplot(data = allresult2) +geom_point(mapping = aes(x = F1, y = Balanced.Accuracy,color = Feature_used,shape=Methods),size=6)+ facet_wrap(~ organ, nrow = 3)+mytheme3
ggplot(data = allresult2) +geom_point(mapping = aes(x = F1, y = Balanced.Accuracy,color = method_level,shape=Feature_used),size=6)+ facet_wrap(~ organ, nrow = 3)
ggplot(allresult2, mapping = aes(Feature_used, method_level,fill = Accuracy))+ facet_grid(~ organ, switch = "x", scales = "free_x", space = "free_x")+ geom_tile()+scale_fill_gradient(name = "Accuracy",low = "white",high = "red") + mytheme4
mytheme4 = theme(axis.text.y = element_text(family = "A",face="plain", size=10,color="black"),
                 axis.title.x = element_blank(),
                 axis.title.y = element_blank(),
                 axis.text.x = element_text(family = "A",face="plain",size=10,color="black",angle = 45,margin=margin(20,1,1,1,"pt")),
                 strip.placement = "outside")
a=filter(allresult2, Feature_used == 'MACCS', method_level=='RF_Herb_level_fitered')

##heritage cluster figure

#for real project
organselect = c('Liver')
organselect = c('Lung')
organselect = c('Kidney')
organselect = c('Stomach')
organselect = c('Spleen')
organselect = c('Heart')
organselect = c('LargeIntestine')
allresult3 = allresult2[allresult2$organ %in% organselect, ]
allresult3 = allresult3[,c('method_level','Feature_used','organ','Accuracy')]
allresult4 = dcast(allresult3, method_level+organ~Feature_used)
row.names(allresult4)=allresult4$method_level
allresult4 = allresult4[,-c(1:2)]
allresult5 = as.matrix(allresult4)
colors = c(seq(-3,-2,length=1000),seq(-2,0.5,length=1000),seq(0.5,9,length=1000))
my_palette <- colorRampPalette(c( "white", "red"))(n = 100)
heatmap.2(allresult5, margins=c(10,12),density.info = 'none',col=my_palette, symm=F,symkey=F,symbreaks=F, scale="none", srtRow=0, adjRow=c(0, 1), srtCol=20, adjCol=c(1,1),trace='none',dendrogram="both")

#example
dir.create("data")
dir.create("output")
install.packages("ggdendro")
install.packages("reshape2")
library("ggplot2")
library("ggdendro")
library("reshape2")
library("grid")
otter <- read.csv(file = "data/otter-mandible-data.csv", header = TRUE)
two.species <- c("A. cinerea", "L. canadensis")
otter <- otter[otter$species %in% two.species, ]
rownames(otter) <- NULL
otter.scaled <- otter
otter.scaled[, c(4:9)] <- scale(otter.scaled[, 4:9])
#Clustering
# Run clustering
otter.matrix <- as.matrix(otter.scaled[, -c(1:3)])
rownames(otter.matrix) <- otter.scaled$accession
otter.dendro <- as.dendrogram(hclust(d = dist(x = otter.matrix)))

# Create dendro
dendro.plot <- ggdendrogram(data = otter.dendro, rotate = TRUE)

# Preview the plot
print(dendro.plot)
dendro.plot <- dendro.plot + theme(axis.text.y = element_text(size = 6))
print(dendro.plot)

#heatmap
# Heatmap
# Data wrangling
otter.long <- melt(otter.scaled, id = c("species", "museum", "accession"))


##gernerate rader


install.package('ggradar')
library('ggradar')
devtools::install_github("ricardo-bion/ggradar", 
                         dependencies=TRUE)
library(ggradar)


##pie

percent<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\14drugbank\\Mesh\\bar.csv", header =T,sep=',')
df=percent[which(percent$organ=='Liver'),c(2,3)]
p <- ggplot(data = df, mapping = aes(x = type, y = nums, fill = type)) + geom_bar(stat = 'identity', position = 'stack', width = 1)
p

color = grDevices::colors()[grep('gr(a|e)y', grDevices::colors(), invert = T)]
pie(rep(1,n), col=sample(color, n))
p_1<- ggplot(data =percent, mapping = aes(x = MeSH_disease_categories, y = percentage, fill = MeSH_disease_categories))+geom_bar(stat = 'identity', position = 'stack', width = 1)+facet_wrap(~ organ, ncol=3,scales = "fixed",as.table = TRUE, drop = FALSE)
p_all<- p_1 +theme_classic()+theme(strip.background = element_rect(colour = "black", fill = "white"),strip.text = element_text(family = "A",face="plain",size=15, color="black"),axis.title.y=element_text(family = "A",face="plain",size=20, color="black"),axis.text.x = element_blank(),axis.title.x = element_blank(),axis.text.y =element_text(family = "A",face="plain", size=15,color="black"),axis.ticks.x= element_blank(),legend.text = element_text(family = "A",face="plain",size=9, color="black"),legend.key.size = unit(0.4, "cm"),legend.justification=c(1,0), legend.position=c(1,0))+scale_fill_manual(values=sample(color, 25))
p_all

n <- 25
palette <- distinctColorPalette(25)
pie(rep(1, n), col=palette)
p_all<- p_1 +theme_classic()+theme(axis.text.x = element_blank(),axis.title.x = element_blank(),axis.ticks.x= element_blank(),legend.text = element_text(family = "A",face="plain",size=7, color="black"),legend.key.size = unit(0.35, "cm"),legend.justification=c(1,0), legend.position=c(1,0))+scale_fill_manual(values=distinctColorPalette(25))
p_all

plabel_value <- paste('(', round(df$nums/sum(df$nums) * 100, 1), '%)', sep = '')
label_value
label <- paste(df$type, label_value, sep = '')
label

#??????????????????
p + coord_polar(theta = 'y') + labs(x = '', y = '', title = '') + theme(axis.text = element_blank()) + theme(axis.ticks = element_blank()) + theme(legend.position = "none") 
#????????????????????????x???y????????????,?????????????????????????????????
p + coord_polar(theta = 'y') + labs(x = '', y = '', title = '') + theme(axis.text = element_blank()) + theme(axis.ticks = element_blank()) + theme(legend.position = "none") + geom_text(aes(y = df$nums/2 + c(0, cumsum(df$nums)[-length(df$nums)]), x = sum(df$nums)/150, label = label)) 

#COLOR
#method 1
library(randomcoloR)
n <- 20
palette <- distinctColorPalette(n)
pie(rep(1, n), col=palette)

#method2
library(RColorBrewer)
n <- 60
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
pie(rep(1,n), col=sample(col_vector, n))

#method 3
color = grDevices::colors()[grep('gr(a|e)y', grDevices::colors(), invert = T)]
pie(rep(1,n), col=sample(color, n))

#method6
colorRampPalette(c("red", "green"))(5)
# [1] "#FF0000" "#BF3F00" "#7F7F00" "#3FBF00" "#00FF00"

#method7
par(mfrow = c(1, 2))
pie(rep(1, 12), col = rainbow(12), main = "rainbow12")
pie(rep(1, times = 1000), labels = "", col = rainbow(1000), border = rainbow(1000), 
    main = "rainbow1000")

#method8
par(mfrow = c(2, 2))
pie(rep(1, 12), col = heat.colors(12), main = "heat")
pie(rep(1, 12), col = terrain.colors(12), main = "terrain")
pie(rep(1, 12), col = topo.colors(12), main = "topo")
pie(rep(1, 12), col = cm.colors(12), main = "cm")

#method9,colorRamp()???colorRampPalette()
par(mfrow = c(1, 2))
b2p1 <- colorRampPalette(c("blue", "purple"))
b2p2 <- colorRamp(c("blue", "purple"))
pie(rep(1, 12), labels = "", col = b2p1(12), border = b2p1(12), main = "colorRampPalette")
pie(rep(1, 12), labels = "", col = b2p2(seq(0, 1, len = 12)), border = b2p2(seq(0,1, len = 12)), main = "colorRamp")

#method10 RColorBrewer???

display.brewer.all(type = "seq")#order
display.brewer.all(type = "div")#min,max,middle
display.brewer.all(type = "qual")#class

#how to use
p+scale_fill_brewer(palette = "Set3") 
p+scale_fill_manual(values=c("#999999", "#E69F00"))
p+geom_bar(fill = brewer.pal(length(unique(df$color)), "Set3"))