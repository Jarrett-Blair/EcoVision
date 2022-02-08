library(reshape2)
library(sciplot)
library(ggplot2)

metaacc = data.frame(meanaccs, nnacc, meanaccsknn, meanaccslda, meanaccsbayes, meanaccsrare)

colnames(metaacc) = c("XGB", "ANN", "KNN", "LDA", "NB", "Zero")

metaacc[,7] = c("Species",
                "Genus",
                "Family",
                "Order",
                "Class",
                "Phylum")
metaacc = melt(metaacc,id.vars = "V7")

colnames(metaacc) = c("Rank", "Model", "Top1")

Rank = metaacc$Rank
Model = metaacc$Model
Top1 = metaacc$Top1

Rank = ordered(Rank, levels = c("Species",
                                "Genus",
                                "Family",
                                "Order",
                                "Class",
                                "Phylum"))


lineplot.CI(Rank, Top1, Model,
            xlab = "", 
            ylab = expression(bold("Top 1 accuracy")), 
            # legend = F,
            x.leg = 5,
            y.leg = 0.5,
            # xaxt = 'n',
            las = 1,
            lwd = 3,
            cex = 3,
            cex.axis = 2,
            cex.lab = 2.5
            ,ylim = c(-0.05,1.05))

################################################################################

colnames(metadiff) = c("XGB","ANN", "KNN", "LDA", "NB")

metadiff[,6] = c("Species",
                "Genus",
                "Family",
                "Order",
                "Class",
                "Phylum")
metadiff = melt(metadiff,id.vars = "V5")

colnames(metadiff) = c("Rank", "Model", "Top1")

Rank = metadiff$Rank
Model = metadiff$Model
Top1 = as.numeric(metadiff$Top1)

Rank = ordered(Rank, levels = c("Species",
                                "Genus",
                                "Family",
                                "Order",
                                "Class",
                                "Phylum"))


lineplot.CI(Rank, Top1, Model,
            xlab = "", 
            ylab = expression(bold("Diff Accuracy")), 
            # legend = F,
            x.leg = 5,
            y.leg = 0.4,
            # xaxt = 'n',
            las = 1,
            lwd = 3,
            cex = 3,
            cex.axis = 2,
            cex.lab = 2.5
            ,ylim = c(-0.01,0.1))

precisionabund = scatter.smooth(x = speciesacc[,1], 
                                y= speciesacc[,2],
                                span = 5/6,
                                las = 1,
                                cex.axis = 1.3,
                                cex.lab = 1.3,
                                pch = 16,
                                ylim = c(-0.05,1.02),
                                ylab = expression(bold("Precision")),
                                xlab = expression(bold("Prevalence in test data")))

colnames(zerodf) = c("Prevalence", "Accuracy", "Name", "Rank", "RankNum")

ggplot(zerodf, aes(Rank, Accuracy)) +
  geom_violin(trim = T) +
  geom_point() +
  scale_y_continuous(name = "Accuracy", limits = c(0,1.01), expand = c(0,0))+
  guides(fill=FALSE) +
  stat_summary(fun.y = mean, fun.ymax = mean, fun.ymin = mean, geom="crossbar", width = 0.2) +
  theme_classic()+
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 16))


zeroacc = data.frame(zeroacc, c("Genus",
                                "Family",
                                "Order",
                                "Class",
                                "Phylum"))

zeroacc = melt(zeroacc)
colnames(zeroacc) = c("Rank", "Zero", "Acc")

ZeroRank = zeroacc$Rank
ZeroVar = zeroacc$Zero
ZeroVal = zeroacc$Acc

ZeroRank = ordered(ZeroRank, levels = c("Genus",
                                "Family",
                                "Order",
                                "Class",
                                "Phylum"))


lineplot.CI(ZeroRank, ZeroVal, ZeroVar,
            xlab = "", 
            ylab = expression(bold("Top 1 accuracy")), 
            legend = T,
            x.leg = 1,
            y.leg = 0.8,
            # xaxt = 'n',
            las = 1,
            lwd = 3,
            cex = 3,
            cex.axis = 2,
            cex.lab = 2.5
            ,ylim = c(-0.05,1.05))



colnames(splitdf) = c("No Split", "1 Split", "2 Split", "Down Sample")

ggplot(splitdf, aes(Var1, value)) +
  geom_
violin(trim = T) +
  geom_point() +
  scale_y_continuous(name = "Accuracy", limits = c(0.65, 0.8), expand = c(0,0))+
  guides(fill=FALSE) +
  stat_summary(fun.y = mean, fun.ymax = mean, fun.ymin = mean, geom="crossbar", width = 0.2) +
  theme_classic()+
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 16))


AccBarDF = data.frame(c("Bayes", "LDA", "KNN", "ANN", "XGB"), 
                      c(metaacc$Top1[c(25,19,13,7,1)]),
                      c(0.7274074, 0.7694625, 0.8276950, 0.8111305, 0.9044235),
                      c(0.4289619, 0.4721312, 0.5376219, 0.597505, 0.6463321),
                      c(0.653, 0.725, 0.771, 0.750, 0.861))
colnames(AccBarDF) = c("Model", "Top1", "Top3", "NoMeta", "NMT3")
ggplot(AccBarDF, aes(Model, Top1)) + 
  geom_bar(data = AccBarDF, aes(y = NMT3), position = "dodge", stat = "identity", fill = '#B9B9B9', color = "black")+
  geom_bar(position = "dodge", stat="identity", color = "black")+
  geom_bar(data = AccBarDF, aes(y = NoMeta), position = "dodge", stat = "identity", fill = '#3B3B3B', color = "black")+
  geom_bar(data = AccBarDF, aes(y = Top3), position = "dodge", stat = "identity", alpha = 0, fill = 'grey', color = "black")+ 
  # geom_hline(yintercept = 0.3637755, size = 1.5) +
  scale_x_discrete(limits=c("Bayes", "LDA", "KNN", "ANN", "XGB")) +
  scale_y_continuous(name = "Accuracy", limits = c(0,1.05), expand = c(0,0))+
  guides(fill=FALSE) +
  geom_text(aes(label = sprintf("%0.3f", round(Top1, digits = 3))), position = position_dodge(0.1), vjust = -0.5) +
  geom_text(data = AccBarDF, mapping = aes(x = Model, y = Top3, label = sprintf("%0.3f", round(Top3, digits = 3))), position = position_dodge(0.1), vjust = -0.5) +
  geom_text(data = AccBarDF, mapping = aes(x = Model, y = NoMeta, label = sprintf("%0.3f", round(NoMeta, digits = 3))), position = position_dodge(0.1), vjust = -0.5, colour = "white") +
  geom_text(data = AccBarDF, mapping = aes(x = Model, y = NMT3, label = sprintf("%0.3f", round(NMT3, digits = 3))), position = position_dodge(0.1), vjust = -0.5) +
  theme_classic()+
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text = element_text(size = 20, colour = "black"),
    axis.ticks = element_blank(),
    axis.title = element_text(size = 32))

