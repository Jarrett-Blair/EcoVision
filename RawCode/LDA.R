library(caret)
library(e1071)

ldaresults = data.frame(matrix(NA, nrow = 40, ncol = 6))
names(ldaresults) = c("Rank", "Accuracy", "Top 3 Accuracy", "Precision", "Recall", "F1")
is.nan.data.frame <- function(x)
  do.call(cbind, lapply(x, is.nan))

carabidlda = function(rank, traindat, testdat, trainlab, testlab){
  
  rankabund = as.data.frame(table(testlab))
  if(rank == "Family"){
    lda = train(Family ~., 
                method = "lda", 
                #trControl = trControl, 
                metric = "Accuracy",
                data = traindat)  }
  if(rank == "Order"){
    lda = train(Order ~., 
                method = "lda",
                #trControl = trControl, 
                metric = "Accuracy",
                data = traindat)  }
  if(rank == "Class"){
    lda = train(Class ~., 
                method = "lda",
                #trControl = trControl, 
                metric = "Accuracy",
                data = traindat)  }
  if(rank == "All"){
    lda = train(AllTaxa ~., 
                method = "lda",
                #trControl = trControl, 
                metric = "Accuracy",
                data = traindat)  }
  
  pred = predict(lda, testdat)
  # prob = predict(lda, testdat, type = "prob")
  confmat = confusionMatrix(testlab, pred)
  # preddf = data.frame(testlab, pred)
  # 
  # pr = data.frame(matrix(NA, nrow = nrow(rankabund), ncol = 3))
  # 
  # i = 1
  # j = 1
  # Tp = 0
  # Fp = 0
  # Tn = 0
  # Fn = 0
  # correct = 0
  # incorrect = 0
  # truetotal = 0
  # falsetotal = 0
  # for(i in 1:nrow(rankabund)){
  #   for(j in 1:nrow(preddf)){
  #     if(preddf[j,1] == rankabund[i,1]){
  #       if(preddf[j,1] == preddf[j,2]){
  #         Tp = Tp + 1
  #         correct = correct + 1
  #         truetotal = truetotal + prob[j,i]
  #       }
  #       else{
  #         Fn = Fn + 1
  #       }
  #     } 
  #     if(preddf[j,2] == rankabund[i,1] & preddf[j,1] != rankabund[i,1]){
  #       Fp = Fp +1
  #       incorrect = incorrect + 1
  #       falsetotal = falsetotal + prob[j,i]
  #     }
  #     else{
  #       Tn = Tn + 1
  #     }
  #   }
  #   pr[i,1] = Tp/(Tp + Fp)
  #   pr[i,2] = Tp/(Tp + Fn)
  #   pr[i,3] = 2*((pr[i,1]*pr[i,2])/(pr[i,1]+pr[i,2]))
  #   j = 1
  #   Tp = Tn = Fn = Fp = 0
  # }
  # 
  # falseprob = falsetotal/incorrect
  # trueprob = truetotal/correct
  # 
  # pr = data.frame(rankabund, pr)
  # names(pr) = c(rank, "Abundance", "Precision", "Recall", "F1")
  # pr[is.nan(pr)] = 0
  # 
  # top3accuracy = data.frame(matrix(NA, nrow = nrow(prob), ncol = 3))
  # m = 0
  # for(i in 1:nrow(prob)){
  #   top3accuracy[i,1] = names(which.max(prob[i,]))
  #   top3accuracy[i,2] = names(which.max(prob[i, -grep(top3accuracy[i,1], colnames(prob))]))
  #   m = c(top3accuracy[i,1], top3accuracy[i,2])
  #   top3accuracy[i,3] = names(which.max(prob[i, -grep(paste(m, collapse = "|"), colnames(prob))]))
  # }
  # 
  # top3accuracy = data.frame(testlab, top3accuracy)
  # top1 = 0
  # top2 = 0
  # top3 = 0
  # for(j in 1:length(testlab)){
  #   if(top3accuracy[j,1] == top3accuracy[j,2]){
  #     top1 = top1 + 1
  #   }
  #   if(is.na(top3accuracy[j,3]) == FALSE){
  #     if(top3accuracy[j,1] == top3accuracy[j,3]){
  #       top2 = top2 + 1
  #     }
  #   }
  #   if(is.na(top3accuracy[j,4]) == FALSE){
  #     if(top3accuracy[j,1] == top3accuracy[j,4]){
  #       top3 = top3 + 1
  #     }
  #   }
  # }
  # 
  # sitepreds = c()
  # siteaccuracy = c()
  # correct = 0
  # 
  # if(rank == "Species"){
  #   for(i in 1:length(siterows)){
  #     sitepreds[[i]] = max.col(prob[siterows[[i]], sitetaxaind[[i]]])
  #     sitepreds[[i]] = sitetaxa[[i]][sitepreds[[i]]]
  #     siteaccuracy[[i]] = mean(sitepreds[[i]] == spvalidData$SpeciesName[siterows[[i]]])
  #     correct = correct + sum(sitepreds[[i]] == spvalidData$SpeciesName[siterows[[i]]])
  #   }
  # }
  # mylist = list("Accuracy" = confmat$overall[1], 
  #               "top3accuracy" = (top1 + top2 + top3)/length(testlab), 
  #               "trueprob" = trueprob, 
  #               "falseprob" = falseprob, 
  #               "Precision" = mean(pr[,3]), 
  #               "Recall" = mean(pr[,4]), 
  #               "F1" = mean(pr[,5]), 
  #               "pr" = pr, 
  #               "Categories" = nlevels(trainlab),
  #               "sitepreds" = sitepreds,
  #               "siteaccuracy" = siteaccuracy,
  #               "pred" = pred)
  # mylist = rbind(c(rank,
  #                  confmat$overall[1],
  #                  (top1 + top2 + top3)/length(testlab),
  #                  mean(pr[,3]),
  #                  mean(pr[,4]),
  #                  mean(pr[,5])
  # ))
  mylist = pred
  return(mylist)
}

# Sys.time()
# for(x in 1:10){
#   for(m in 1:3){
#     if(m == 1){
#       ldaresults[10*(m-1)+x,] = carabidlda("Family", familytrainData[[x]], familyvalidData[[x]], familytrainLabels[[x]], familyvalidLabels[[x]])
#       print(Sys.time())
#     }
#     if(m == 2){
#       ldaresults[10*(m-1)+x,] = carabidlda("Order", ordertrainData[[x]], ordervalidData[[x]], ordertrainLabels[[x]], ordervalidLabels[[x]])
#       print(Sys.time())
#     }
#     if(m == 3){
#       ldaresults[10*(m-1)+x,] = carabidlda("Class", classtrainData[[x]], classvalidData[[x]], classtrainLabels[[x]], classvalidLabels[[x]])
#       print(Sys.time())
#     }
#   }
# }
# Sys.time()

ldaresults = vector(mode = "list", length = 10)
Sys.time()
for(x in 1:10){
  for(m in 4:4){
    if(m == 1){
      ldaresults[[10*(m-1)+x]] = carabidlda("Family", familytrainData[[x]], familyvalidData[[x]], familytrainLabels[[x]], familyvalidLabels[[x]])
      print(Sys.time())
    }
    if(m == 2){
      ldaresults[[10*(m-1)+x]] = carabidlda("Order", ordertrainData[[x]], ordervalidData[[x]], ordertrainLabels[[x]], ordervalidLabels[[x]])
      print(Sys.time())
    }
    if(m == 3){
      ldaresults[[10*(m-1)+x]] = carabidlda("Class", classtrainData[[x]], classvalidData[[x]], classtrainLabels[[x]], classvalidLabels[[x]])
      print(Sys.time())
    }
    if(m == 4){
      ldaresults[[x]] = carabidlda("All", alltrainData[[x]], allvalidData[[x]], alltrainData[[x]]$AllTaxa, allvalidData[[x]]$AllTaxa)
      print(Sys.time())
    }
  }
}
Sys.time()

predontlda = list()

for(m in 1:10){
  predontlda[[m]] = data.frame(matrix(NA, nrow = length(ldaresults[[m]]), ncol = ncol(simphier)))
  predontlda[[m]][,1] = ldaresults[[m]]
  for(i in 1:ncol(simphier)){
    if(i>1){
      for(j in 1:nrow(predontlda[[m]])){
        predontlda[[m]][j,i] = simphier[which(simphier[,i-1] == predontlda[[m]][j,i-1])[1], i]
      }
    }
  }  
}

acclda = matrix(NA, nrow = 10, ncol = ncol(simphier))
for(j in 1:10){
  for(i in 1:ncol(validhierarchy[[1]])){
    acclda[j,i] = sum(predontlda[[j]][,i] == validhierarchy[[j]][,i])/nrow(validhierarchy[[j]])
  }
}

meanaccslda = colMeans(acclda)

# ldaresults2 = list()
# Sys.time()
# for(x in 1:10){
#   for(m in 1:3){
#     if(m == 1){
#       ldaresults2[[10*(m-1)+x]] = carabidlda("Family", familytrainData[[x]], familyvalidData[[x]], familytrainLabels[[x]], familyvalidLabels[[x]])
#       print(Sys.time())
#     }
#     if(m == 2){
#       ldaresults2[[10*(m-1)+x]] = carabidlda("Order", ordertrainData[[x]], ordervalidData[[x]], ordertrainLabels[[x]], ordervalidLabels[[x]])
#       print(Sys.time())
#     }
#     if(m == 3){
#       ldaresults2[[10*(m-1)+x]] = carabidlda("Class", classtrainData[[x]], classvalidData[[x]], classtrainLabels[[x]], classvalidLabels[[x]])
#       print(Sys.time())
#     }
#     # if(m == 4){
#     #   ldaresults2[[10*(m-1)+x]] = carabidlda("All", classtrainData[[x]], classvalidData[[x]], classtrainLabels[[x]], classvalidLabels[[x]])
#     #   print(Sys.time())
#     # }
#   }
# }
# Sys.time()
# 
# accuracy = c()
# for(i in 31:40){
#   accuracy[i-30] = ldaresults[[i]]$overall[1]
# }