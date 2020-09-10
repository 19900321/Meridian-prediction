library(car)
library(tidyverse)
library(mgcv)
library('e1071')
library(caret)
library(nycflights13)
library(class)
library(e1071)
library(lattice)
library (VennDiagram)
library(UpSetR)
library(reshape2)
library("ggplot2")
library("ggdendro")
library("reshape2")
library("grid")
library(gplots) 

mydata2<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\8.trainging the data\\compound level\\feafru700.csv", header =T,sep=',')
#dim(mydata2)
#uniquedata = uniquecombs(mydata2)
#dim(uniquedata)

#Taking the numeric part of the IRIS data
#top50 = c(iLOGP, AliLogS, AliSolubility.mg.ml., AliSolubility.mol.l., WLOGP, ConsensusLogP, logKp.cm.s., Silicos.ITLogP, ESOLSolubility.mol.l., ESOLLogS, XLOGP3, MR, MLOGP, ESOLSolubility.mg.ml., SyntheticAccessibility, Silicos.ITLogSw, MW, Heavyatoms, TPSA, FractionCsp3, Silicos.ITSolubility.mol.l., Rotatablebonds, Silicos.ITSolubility.mg.ml., H.bondacceptors, H.bonddonors, Muegge.violations, Ghose.violations, Leadlikeness.violations, Brenk.alerts, Lipinski.violations, BioavailabilityScore, Aromaticheavyatoms, MACCSFP74, MACCSFP155, MACCSFP141, ExtFP621, ExtFP277, ExtFP207, MACCSFP136, MACCSFP93, MACCSFP104, MACCSFP149, MACCSFP147, CYP2C9inhibitor, ExtFP194, ExtFP983, PubchemFP115, ExtFP797, PubchemFP51)
dataall<- select(mydata2,c(Lung, Spleen, Stomach, Bladder, Cardiovascular, Gallbladder, Heart, Kidney, LargeIntestine, Liver, iLOGP, AliLogS, AliSolubility.mg.ml., AliSolubility.mol.l., WLOGP, ConsensusLogP, logKp.cm.s., Silicos.ITLogP, ESOLSolubility.mol.l., ESOLLogS, XLOGP3, MR, MLOGP, ESOLSolubility.mg.ml., SyntheticAccessibility, Silicos.ITLogSw, MW, Heavyatoms, TPSA, FractionCsp3, Silicos.ITSolubility.mol.l., Rotatablebonds, Silicos.ITSolubility.mg.ml., H.bondacceptors, H.bonddonors, Muegge.violations, Ghose.violations, Leadlikeness.violations, Brenk.alerts, Lipinski.violations, BioavailabilityScore, Aromaticheavyatoms, MACCSFP74, MACCSFP155, MACCSFP141, ExtFP621, ExtFP277, ExtFP207, MACCSFP136, MACCSFP93, MACCSFP104, MACCSFP149, MACCSFP147, CYP2C9inhibitor, ExtFP194, ExtFP983, PubchemFP115, ExtFP797, PubchemFP51))
#a=colSums(filter1)
#combin <- data.frame(rbind(t(data.frame(a)),data.frame(filter1)))
#n2=combin[,which(a!=0)][-1,]
organ=select(mydata2,c(Lung:Liver))
data50= select(mydata2,c(iLOGP,MACCSFP74, AliLogS, AliSolubility.mg.ml., AliSolubility.mol.l., WLOGP, ConsensusLogP, logKp.cm.s., Silicos.ITLogP, ESOLSolubility.mol.l., ESOLLogS, XLOGP3, MR, MLOGP, ESOLSolubility.mg.ml., SyntheticAccessibility, Silicos.ITLogSw, MACCSFP155, MW, MACCSFP141, ExtFP621, ExtFP277, ExtFP207, MACCSFP136, MACCSFP93, MACCSFP104, MACCSFP149, MACCSFP147, ExtFP194, ExtFP983, Heavyatoms, PubchemFP115, ExtFP797, PubchemFP516, ExtFP585, ExtFP705, MACCSFP114, ExtFP459, MACCSFP90, PubchemFP143, ExtFP880, ExtFP15, ExtFP355, MACCSFP153, PubchemFP672, ExtFP690, ExtFP643, MACCSFP118, PubchemFP712))
datatop100 = select(mydata2,c(iLOGP,MACCSFP74, AliLogS, AliSolubility.mg.ml., AliSolubility.mol.l., WLOGP, ConsensusLogP, logKp.cm.s., Silicos.ITLogP, ESOLSolubility.mol.l., ESOLLogS, XLOGP3, MR, MLOGP, ESOLSolubility.mg.ml., SyntheticAccessibility, Silicos.ITLogSw, MACCSFP155, MW, MACCSFP141, ExtFP621, ExtFP277, ExtFP207, MACCSFP136, MACCSFP93, MACCSFP104, MACCSFP149, MACCSFP147, ExtFP194, ExtFP983, Heavyatoms, PubchemFP115, ExtFP797, PubchemFP516, ExtFP585, ExtFP705, MACCSFP114, ExtFP459, MACCSFP90, PubchemFP143, ExtFP880, ExtFP15, ExtFP355, MACCSFP153, PubchemFP672, ExtFP690, ExtFP643, MACCSFP118, PubchemFP712, ExtFP137, ExtFP239, PubchemFP839, ExtFP739,PubchemFP797, PubchemFP579, TPSA, ExtFP940, MACCSFP150, ExtFP785, PubchemFP697, PubchemFP818, PubchemFP535, ExtFP156, MACCSFP116, PubchemFP432, MACCSFP96, ExtFP765, MACCSFP131, FractionCsp3, ExtFP504,PubchemFP776, ExtFP127, MACCSFP128, ExtFP719,ExtFP447,ExtFP804, ExtFP551, PubchemFP684, MACCSFP160, ExtFP989, SubFP88,ExtFP640, MACCSFP82, MACCSFP132, PubchemFP337, ExtFP116,ExtFP971, ExtFP112, ExtFP128,SubFP49,MACCSFP109,PubchemFP335,PubchemFP860, ExtFP801, MACCSFP129, ExtFP272,ExtFP582,Silicos.ITSolubility.mol.l.,Rotatablebonds))

X = scale(data,scale=TRUE, center=TRUE)
scale = scale(select(mydata2,c(ExtFP1:MACCSFP166)))
##PCA_data
#PCA <- prcomp(data, scale. = T, center = T)
PCA_data <- princomp(data)
biplot(PCA_data )
screeplot(PCA_data, type="lines")
trydata = select(mydata2,c(MW:MACCSFP166))

datatop100_2 = apply(datatop100, MARGIN = 2, FUN = function(x) (x-min(x))/(max(x)-min(x)))
PCA_data <- princomp(datatop100_2)   
plot(x = PCA_data$scores[, 1],
     y = PCA_data$scores[, 2],
     col = rainbow(2)[mydata2$Liver],
     xlab = "PC1",
     ylab = "PC2",
     main = "PCA of top 100 Feature of Liver")

datatop50_2 = apply(data50, MARGIN = 2, FUN = function(x) (x-min(x))/(max(x)-min(x)))

pca <- prcomp(datatop50_2)
y = pca$sdev^2/sum(pca$sdev^2)*100
barplot(y,names.arg=c("PC1", "PC2", "PC3", "PC4"), ylab = "Percent Variance Captured",xlab = "",main = "")
pca$rotation
library(FactoMineR)
pca3 <- PCA(datatop100_2, graph = T)
PCA_data <- princomp(datatop50_2)   
plot(x = PCA_data$scores[, 1],
     y = PCA_data$scores[, 2],
     col = rainbow(2)[mydata2$Liver],
     xlab = "PC1",
     ylab = "PC2",
     main = "PCA of top 50 Feature of Liver")

#Select the first principal component for the second model
model2 = PCA_data$loadings[,1]

#For the second model, we need to calculate scores by multiplying our loadings with the data
model2_scores <- as.matrix(data) %*% model2

#Loading libraries for naiveBayes model
##PCA

PCA_Organ=function(score,model2_scores,data,col2)
{
  plot( score[,1:2], pch=20, col=col2, xlim =c (-3,3),ylim=c(-3,3))
  dataEllipse( score[,1], score[,2], col2, lwd=1,
               group.labels = NULL, plot.points=FALSE, 
               add=TRUE,fill=TRUE, fill.alpha=0.02)  
  
  mod1<-naiveBayes(data,col2)
  
  mod2<-naiveBayes(model2_scores, col2)
  
  table(predict(mod1, data), col2)
  
  table(predict(mod2, model2_scores), col2)
}
collung=factor(organ$Lung)
colliver=factor(organ$Liver)
score=PCA_data$scores
PCA_Organ(score,model2_scores,data,collung)
PCA_Organ(score,model2_scores,n2,colliver)
colLargeIntestine=factor(n2$LargeIntestine)
PCA_Organ(score,model2_scores,n2,colLargeIntestine)
pca <- prcomp(data)
plot(x = pca$x[, 1],
     y = pca$x[, 2],
     col = rainbow(2)[dataall$Lung],
     xlab = "PC1",
     ylab = "PC2",
     main = "PCA of iris data")
plot(x = PCA_data$scores[, 1],
     y = PCA_data$scores[, 2],
     col = rainbow(2)[dataall$Lung],
     xlab = "PC1",
     ylab = "PC2",
     main = "PCA of iris data")


#matrix
data16<- read.csv("C:\\Users\\yinyin\\Desktop\\herbpair\\13.IG\\IG-scaled.csv", header =T,sep=',')
allresult4 = data16
#allresult4$Heart = scale(allresult4,center = TRUE, scale = TRUE)
#for real project
#Liver = c('Liver')
#Liver2 = allresult2[allresult4$organ %in% Liver, ]
#allresult3 = allresult2[,c('method_level','Feature_used','organ','Accuracy')]
#allresult4 = dcast(allresult3, method_level+organ~Feature_used)
row.names(allresult4)=allresult4$Feature
allresult4 = allresult4[,-c(1)]
selected_feature_top155 = c('ConsensusLogP','MACCSFP149','iLOGP','WLOGP','AliSolubility.mol.l.','ESOLSolubility.mol.l.','MLOGP','logKp.cm.s.','ESOLLogS','AliLogS','XLOGP3','MACCSFP34','Silicos.ITLogP','Silicos.ITLogSw','PubchemFP672','AliSolubility.mg.ml.','ESOLSolubility.mg.ml.','SyntheticAccessibility','MR','ExtFP998','ExtFP804','MW','ExtFP589','ExtFP787','MACCSFP82','TPSA','ExtFP585','ExtFP127','ExtFP940','ExtFP880','ExtFP625','MACCSFP141','Heavyatoms','PubchemFP452','FractionCsp3','ExtFP375','MACCSFP155','Silicos.ITSolubility.mol.l.','ExtFP15','PubchemFP374','MACCSFP74','ExtFP777','PubchemFP818','PubchemFP686','ExtFP621','MACCSFP138','ExtFP976','ExtFP803','MACCSFP160','ExtFP765','MACCSFP136','SubFP84','SubFP1','PubchemFP567','MACCSFP96','ExtFP409','PubchemFP663','PubchemFP824','ExtFP649','MACCSFP90','ExtFP785','SubFP88','ExtFP467','ExtFP1013','ExtFP983','MACCSFP104','ExtFP156','ExtFP137','ExtFP705','PubchemFP144','Rotatablebonds','ExtFP302','PubchemFP189','PubchemFP860','PubchemFP839','PubchemFP840','PubchemFP861','Silicos.ITSolubility.mg.ml.','MACCSFP116','PubchemFP819','H.bondacceptors','PubchemFP516','PubchemFP193','MACCSFP93','MACCSFP114','H.bonddonors','PubchemFP186','ExtFP486','ExtFP194','PubchemFP228','ExtFP845','ExtFP197','MACCSFP147','ExtFP277','ExtFP207','PubchemFP115','ExtFP797','ExtFP459','PubchemFP143','ExtFP355','MACCSFP153','ExtFP690','ExtFP643','MACCSFP118','PubchemFP712','ExtFP762','ExtFP276','ExtFP663','ExtFP971','ExtFP949','PubchemFP776','MACCSFP132','ExtFP169','ExtFP606','SubFP13','ExtFP582','ExtFP664','ExtFP493','ExtFP615','MACCSFP146','MACCSFP53','PubchemFP681','ExtFP684','ExtFP228','ExtFP799','ExtFP712','PubchemFP20','ExtFP587','MACCSFP131','MACCSFP120','ExtFP442','MACCSFP109','ExtFP989','ExtFP1012','ExtFP575','ExtFP1017','ExtFP1016','PubchemFP199','PubchemFP698','ExtFP186','ExtFP483','ExtFP800','ExtFP914','PubchemFP12','ExtFP213','ExtFP923','ExtFP646','PubchemFP687','ExtFP280','MACCSFP150','ExtFP221','ExtFP571')
selected_feature_top75_30 =c('MR','MACCSFP136','ESOLSolubility.mol.l.','iLOGP','AliLogS','AliSolubility.mol.l.','ConsensusLogP','ESOLSolubility.mg.ml.','ESOLLogS','WLOGP','AliSolubility.mg.ml.','Silicos.ITLogP','MW','MLOGP','XLOGP3','logKp.cm.s.','SyntheticAccessibility','Silicos.ITLogSw','Heavyatoms','MACCSFP155','TPSA','ExtFP127','SubFP84','Silicos.ITSolubility.mol.l.','MACCSFP141','FractionCsp3','SubFP1','PubchemFP567','MACCSFP96','PubchemFP189','PubchemFP860','PubchemFP839','PubchemFP144','Rotatablebonds','PubchemFP840','MACCSFP74','PubchemFP861','MACCSFP149','MACCSFP34','PubchemFP672','ExtFP998','ExtFP804','ExtFP589','ExtFP787','MACCSFP82','ExtFP585','ExtFP940','ExtFP621','ExtFP277','ExtFP207','MACCSFP93','MACCSFP104','MACCSFP147','ExtFP194','ExtFP762','ExtFP276','PubchemFP818','ExtFP663','ExtFP615','MACCSFP146','MACCSFP53','PubchemFP681','ExtFP684','ExtFP1013','ExtFP228','ExtFP799','ExtFP712','ExtFP1017','ExtFP1016','PubchemFP199','PubchemFP698','ExtFP186','ExtFP483','ExtFP800','ExtFP914') 
allresult5_30 = allresult4[selected_feature_top75_30,]


allresult5 = as.matrix(allresult5_30)
kcolors = c(seq(-3,-2,length=100),seq(-2,0.5,length=100),seq(0.5,6,length=100))
my_palette <- colorRampPalette(c( "white", "red"))(n = 100)
heatmap.2(allresult5, margins=c(10,10),density.info = 'none',col=my_palette, symm=F,symkey=F,symbreaks=F, scale="none", srtRow=45, adjRow=c(0, 1), srtCol=45, adjCol=c(1,1),trace='none',dendrogram="row",cexRow=0.5,cexCol=0.5)
heatmap.2(allresult5, margins=c(5,7),density.info = 'none',col=my_palette, symm=F,symkey=F,symbreaks=F, scale="none", srtRow=0, adjRow=c(0, 1), srtCol=0, adjCol=c(1,1),trace='none',dendrogram="row",cexRow=1,cexCol=0.6,keysize=0.5,densadj=0.5)
heatmap.2(allresult5, margins=c(5,7),density.info = 'none',col=my_palette, symm=F,symkey=F,symbreaks=F, scale="none", srtRow=0, adjRow=c(0, 1), srtCol=0, adjCol=c(1,1),trace='none',dendrogram="row",cexRow=0.6,cexCol=1,keysize=0.5,densadj=0.5)

##cor PCA
mydata2_2 = select(mydata2,MW:MACCSFP166)
mydata2$Liver = ifelse(mydata2$Liver>0,1,0)
cor = cor(mydata2_2, mydata2$Liver)
cor = as.data.frame(cor)
index1 = order(cor$V1,decreasing = TRUE)
index2 = order(cor$V1)
# top50 = mydata2_2[,index[1:50]]
top50 = mydata2_2[,c(index1[1:5],index2[1:5])]

PCA_data <- prcomp(top50)
plot(x = PCA_data$x[, 1],
     y = PCA_data$x[, 2],
     col = ifelse(mydata2$Liver>0,"red","blue"),
     xlab = "PC1",
     ylab = "PC2",
     main = "PCA of top 50 Feature of Liver")

# MDS
# Classical MDS
# N rows (objects) x p columns (variables)
# each row identified by a unique row name

d <- dist(top50) # euclidean distances between the rows
fit <- cmdscale(d,eig=TRUE, k=2) # k is the number of dim
# fit # view results

# plot solution 
x <- fit$points[,1]
y <- fit$points[,2]
plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2", 
     main="Metric	MDS",	col = ifelse(mydata2$Liver>0,"red","blue"))
# text(x, y, labels = row.names(mydata), cex=.7)
