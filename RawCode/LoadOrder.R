setwd("C:/Users/jarre/ownCloud/Invert")


ordertrainData = list()
ordervalidData = list()
ordertrainLabels = list()
ordervalidLabels = list()

remove = c(6,7)

for(i in 1:10){
  ordertrainData[[i]] = read.csv(paste("finalnormordertrain", i, ".csv", sep = ""), stringsAsFactors = T)
  ordervalidData[[i]] = read.csv(paste("finalnormordervalid", i, ".csv", sep = ""), stringsAsFactors = T)
  
  ordertrainData[[i]] = ordertrainData[[i]][,-(remove)]
  ordervalidData[[i]] = ordervalidData[[i]][,-(remove)]
  
  ordertrainLabels[[i]] = ordertrainData[[i]][,1]
  ordervalidLabels[[i]] = ordervalidData[[i]][,1]
  
  print(paste0("Round", i, "Done", Sys.time(), sep = " "))
}