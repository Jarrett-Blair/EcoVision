#See Markdown file for additional details

library(caret)
library(naivebayes)

bayes = train(AllTaxa ~., 
              method = "naive_bayes", 
              metric = "Accuracy",
              data = train)

validLabels = valid$AllTaxa
bayespred = predict(bayes, as.matrix(allvalidData[,1:49]))
bayesconfmat = confusionMatrix(as.factor(bayespred), as.factor(validLabels))