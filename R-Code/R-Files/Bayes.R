#See Markdown file for additional details

library(caret)
library(naivebayes)

bayes = train(AllTaxa ~., 
              method = "naive_bayes", 
              metric = "Accuracy",
              data = train)

testLabels = test$AllTaxa
bayespred = predict(bayes, as.matrix(alltestData[,1:49]))
bayesconfmat = confusionMatrix(as.factor(bayespred), as.factor(testLabels))