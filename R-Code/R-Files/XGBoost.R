#See Markdown file for additional details

library(caret)
library(xgboost)
library(Matrix)

trainLabels = train$AllTaxa
validLabels = valid$AllTaxa

trainlab = as.numeric(trainLabels) - 1
validlab = as.numeric(validLabels) - 1

dtrain <- xgb.DMatrix(label = trainlab, data = as.matrix(trainData[,1:49]))
watchlist = list(train=dtrain)

numclass = 46
model = xgb.train(data = dtrain, 
                  max.depth = 100, 
                  eta = 0.1, 
                  nrounds = 400, 
                  watchlist = watchlist,
                  eval.metric = "merror",
                  eval.metric = "mlogloss",
                  verbose = 0,
                  num_class = numclass,
                  objective = "multi:softprob")

litls = levels(as.factor(trainLabels))

preds = predict(model, as.matrix(valid[,c(1:49)]))
preds = matrix(preds, nrow = numclass)
preds = t(preds)
preds = as.data.frame(preds)
colnames(preds) = litls

predname = c()
for(i in 1:nrow(preds)){
  predname[i] = names(which.max(preds[i,]))
}

xgbconfmat = confusionMatrix(as.factor(predname), validlab)