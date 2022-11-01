#See Markdown file for additional details

library(caret)

lda = train(AllTaxa ~., 
            method = "LDA", 
            metric = "Accuracy",
            data = train)

testLabels = test$AllTaxa
ldapred = predict(lda, as.matrix(alltestData[,1:49]))
ldaconfmat = confusionMatrix(as.factor(ldapred), as.factor(testLabels))