#See Markdown file for additional details

library(caret)

lda = train(AllTaxa ~., 
            method = "LDA", 
            metric = "Accuracy",
            data = train)

validLabels = valid$AllTaxa
ldapred = predict(lda, as.matrix(allvalidData[,1:49]))
ldaconfmat = confusionMatrix(as.factor(ldapred), as.factor(validLabels))