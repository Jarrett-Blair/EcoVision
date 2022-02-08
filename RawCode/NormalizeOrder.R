library(lattice)
library(caret)

for(i in 1:10){
  
  alltrain = as.data.frame(read.csv(paste("finalordertrain", i, ".csv", sep = "")))
  allvalid = as.data.frame(read.csv(paste("finalordervalid", i, ".csv", sep = "")))
  alltrain[,25:79] = lapply(alltrain[,25:79], as.numeric)
  allvalid[,25:79] = lapply(allvalid[,25:79], as.numeric)
  
  allremove = c(1:14,16:24,26,27,29,30,38:40)
  allvalid = allvalid[,-allremove]
  alltrain = alltrain[,-allremove]
  
  allnormParam <- preProcess(alltrain)
  allnorm.valid <- predict(allnormParam, allvalid)
  allnorm.train <- predict(allnormParam, alltrain)
  
  write.csv(allnorm.valid, paste("finalnormordervalid", i, ".csv", sep = ""), row.names = F)
  write.csv(allnorm.train, paste("finalnormordertrain", i, ".csv", sep = ""), row.names = F)
  
  print(paste0("Round", i, "Done", Sys.time(), sep = " "))
}
