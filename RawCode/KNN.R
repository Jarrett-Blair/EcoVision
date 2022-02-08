alltrainData = vector(mode = "list", length = 1)
allvalidData = vector(mode = "list", length = 1)
# alltrainLabels = list()
# allvalidLabels = list()

remove = c(6,7)

for(i in 1:10){
  #############            #############
  #############   Family   #############
  #############            #############
  # 
  # familytrainData[[i]] = read.csv(paste("normfamilytrain", i, ".csv", sep = ""), stringsAsFactors = T)
  # familyvalidData[[i]] = read.csv(paste("normfamilyvalid", i, ".csv", sep = ""), stringsAsFactors = T)
  # 
  # familytrainData[[i]] = familytrainData[[i]][,-remove]
  # familyvalidData[[i]] = familyvalidData[[i]][,-remove]
  # 
  # familytrainLabels[[i]] = familytrainData[[i]][,1]
  # familyvalidLabels[[i]] = familyvalidData[[i]][,1]
  # 
  # #############         #############
  # #############  Order  #############
  # #############         #############
  # 
  # ordertrainData[[i]] = read.csv(paste("normordertrain", i, ".csv", sep = ""), stringsAsFactors = T)
  # ordervalidData[[i]] = read.csv(paste("normordervalid", i, ".csv", sep = ""), stringsAsFactors = T)
  # 
  # ordertrainData[[i]] = ordertrainData[[i]][,-remove]
  # ordervalidData[[i]] = ordervalidData[[i]][,-remove]
  # 
  # ordertrainLabels[[i]] = ordertrainData[[i]][,1]
  # ordervalidLabels[[i]] = ordervalidData[[i]][,1]
  # 
  # ############         #############
  # ############  Class  #############
  # ############         #############
  # 
  # classtrainData[[i]] = read.csv(paste("normclasstrain", i, ".csv", sep = ""), stringsAsFactors = T)
  # classvalidData[[i]] = read.csv(paste("normclassvalid", i, ".csv", sep = ""), stringsAsFactors = T)
  # 
  # classtrainData[[i]] = classtrainData[[i]][,-remove]
  # classvalidData[[i]] = classvalidData[[i]][,-remove]
  # 
  # classtrainLabels[[i]] = classtrainData[[i]][,1]
  # classvalidLabels[[i]] = classvalidData[[i]][,1]
  
  #############            #############
  #############    All     #############
  #############            #############
  
  alltrainData[[i]] = read.csv(paste("normalltrain", i, ".csv", sep = ""), stringsAsFactors = T)
  allvalidData[[i]] = read.csv(paste("normallvalid", i, ".csv", sep = ""), stringsAsFactors = T)
  
  alltrainData[[i]] = alltrainData[[i]][,-(remove)]
  allvalidData[[i]] = allvalidData[[i]][,-(remove)]
  
  # alltrainLabels[[i]] = alltrainData[[i]][,"AllTaxa"]
  # allvalidLabels[[i]] = allvalidData[[i]][,"AllTaxa"]
}

library(doParallel)
library(foreach)
library(doSNOW)
library(caret)
library(e1071)

carabidknn = function(rank, traindat, testdat, x){
  
  # rankabund = as.data.frame(table(testlab))
  # if(rank == "Family"){
  #   knn = train(Family ~., 
  #               method = "knn",
  #               tuneGrid = expand.grid(k = 1:25),
  #               #trControl = trControl, 
  #               metric = "Accuracy",
  #               data = traindat)  }
  # if(rank == "Order"){
  #   knn = train(Order ~., 
  #               method = "knn",
  #               tuneGrid = expand.grid(k = 1:25),
  #               #trControl = trControl, 
  #               metric = "Accuracy",
  #               data = traindat)  }
  # if(rank == "Class"){
  #   knn = train(Class ~., 
  #               method = "knn",
  #               tuneGrid = expand.grid(k = 1:25),
  #               #trControl = trControl, 
  #               metric = "Accuracy",
  #               data = traindat)  }
  if(rank == "AllTaxa"){
    knn = caret::train(AllTaxa ~., 
                method = "knn",
                tuneGrid = expand.grid(k = seq(1,25,2)),
                #trControl = trControl, 
                metric = "Accuracy",
                data = traindat)
    }
  write.table(x, file=paste("Done", x, ".txt", sep=""),
              sep="\t")
  # pred = predict(knn, testdat)
  # prob = predict(knn, testdat, type = "prob")
  # confmat = confusionMatrix(testlab, pred)
  mylist = knn
  return(mylist)
}

# knnresults = vector(mode = "list", length = 1)

registerDoParallel(cores = 5)
Sys.time()
knnresults = foreach(x=1:10) %dopar% {
  carabidknn("AllTaxa", alltrainData[[x]], allvalidData[[x]], x)
}
Sys.time()

testfun = function(i){write.table(i, file=paste("Done", i, ".txt", sep=""),
              sep="\t")}
test = foreach(i=1:5) %dopar% {testfun(i)}

# Sys.time()
# for(x in 1:10){
#   for(m in 4:4){
#     # if(m == 1){
#     #   knnresults[[10*(m-1)+x]] = carabidknn("Family", familytrainData[[x]], familyvalidData[[x]], familytrainLabels[[x]], familyvalidLabels[[x]])
#     #   print(Sys.time())
#     # }
#     # if(m == 2){
#     #   knnresults[[10*(m-1)+x]] = carabidknn("Order", ordertrainData[[x]], ordervalidData[[x]], ordertrainLabels[[x]], ordervalidLabels[[x]])
#     #   print(Sys.time())
#     # }
#     # if(m == 3){
#     #   knnresults[[10*(m-1)+x]] = carabidknn("Class", classtrainData[[x]], classvalidData[[x]], classtrainLabels[[x]], classvalidLabels[[x]])
#     #   print(Sys.time())
#     # }
#     if(m == 4){
#       print(paste0("AllTaxa starting", x, sep = " "))
#       print(Sys.time()) 
#       knnresults[[x]] = carabidknn("AllTaxa", alltrainData[[x]], allvalidData[[x]])
#       # save(knnresults, file = "knnresults.RData")
#     }
#   }
# }
# Sys.time()

save(knnresults, file = "knnresultsNOMeta.RData")
