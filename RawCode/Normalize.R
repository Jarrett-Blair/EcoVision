library(lattice)
library(caret)


train = as.data.frame(read.csv("train.csv"))
test = as.data.frame(read.csv("test.csv"))
train[,2:13] = lapply(train[,2:13], as.numeric)
test[,2:13] = lapply(test[,2:13], as.numeric)

allnormParam <- preProcess(train)
allnorm.test <- predict(allnormParam, test)
allnorm.train <- predict(allnormParam, train)

write.csv(allnorm.test, "normtest.csv", row.names = F)
write.csv(allnorm.train, "normtrain.csv", row.names = F)
