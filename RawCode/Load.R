setwd("C:/Users/jarre/ownCloud/Invert")


alltrainData = list()
allvalidData = list()
alltrainLabels = list()
allvalidLabels = list()

remove = c(6,7)
removemeta = c(6,7,39:49)

for(i in 1:10){
  alltrainData[[i]] = read.csv(paste("finalnormalltrain", i, ".csv", sep = ""), stringsAsFactors = T)
  allvalidData[[i]] = read.csv(paste("finalnormallvalid", i, ".csv", sep = ""), stringsAsFactors = T)
  
  alltrainData[[i]] = alltrainData[[i]][,-(remove)]
  allvalidData[[i]] = allvalidData[[i]][,-(remove)]
  
  alltrainLabels[[i]] = alltrainData[[i]][,1]
  allvalidLabels[[i]] = allvalidData[[i]][,1]
  
  print(paste0("Round", i, "Done", Sys.time(), sep = " "))
}

for(i in 1:10){
  alltrainData[[i]] = read.csv(paste("finalnormalltrain", i, ".csv", sep = ""), stringsAsFactors = T)
  allvalidData[[i]] = read.csv(paste("finalnormallvalid", i, ".csv", sep = ""), stringsAsFactors = T)
  
  alltrainData[[i]] = alltrainData[[i]][,-(removemeta)]
  allvalidData[[i]] = allvalidData[[i]][,-(removemeta)]
  
  alltrainLabels[[i]] = alltrainData[[i]][,"AllTaxa"]
  allvalidLabels[[i]] = allvalidData[[i]][,"AllTaxa"]
}

