varimp = list()

for(i in 1:10){
  varimp[[i]] = xgb.importance(feature_names = colnames(alltrainData[[1]][2:47]), 
                               model = model[[i]])
}

combimp = varimp[[1]]
for(i in 2:10){
  combimp = rbind(combimp, varimp[[i]])
}

sumimp = tapply(combimp$Gain, combimp$Feature, FUN=sum)
sumimp = data.frame(levels(as.factor(combimp$Feature)), sumimp)

ggplot(sumimp, aes(reorder(Feature, Gain), Gain)) + 
  geom_bar(position = "dodge", stat="identity", color = "black")+
  coord_flip()+
  # geom_hline(yintercept = 0.3637755, size = 1.5) +
  scale_x_discrete(name = "Feature") +
  scale_y_continuous(limits = c(0,.13), expand = c(0,0))+
  guides(fill=FALSE) +
  theme_classic()+
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text = element_text(size = 12, colour = "black"),
    axis.ticks = element_blank(),
    axis.title = element_text(size = 16))


