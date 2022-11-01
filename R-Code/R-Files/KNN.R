#See Markdown file for additional details

library(caret)

knn.morph = train(AllTaxa ~., 
                  method = "knn",
                  tuneGrid = expand.grid(k = seq(1,25,2)),
                  metric = "Accuracy",
                  data = train)

testLabels = test$AllTaxa
knnpred = predict(knn, as.matrix(alltestData[,1:49]))
knnconfmat = confusionMatrix(as.factor(knnpred), as.factor(testLabels))
