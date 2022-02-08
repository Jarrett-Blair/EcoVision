setwd("/SciBorg/array0/blair")

# familytrainData = list()
# familyvalidData = list()
# familytrainLabels = list()
# familyvalidLabels = list()
# 
# ordertrainData = list()
# ordervalidData = list()
# ordertrainLabels = list()
# ordervalidLabels = list()
# 
# classtrainData = list()
# classvalidData = list()
# classtrainLabels = list()
# classvalidLabels = list()

alltrainData = vector(mode = "list", length = 10)
allvalidData = vector(mode = "list", length = 10)
alltrainLabels = vector(mode = "list", length = 10)
allvalidLabels = vector(mode = "list", length = 10)

remove = c(6,7)

for(i in 1:1){
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
  
  alltrainLabels[[i]] = alltrainData[[i]][,"AllTaxa"]
  allvalidLabels[[i]] = allvalidData[[i]][,"AllTaxa"]
}

library(doParallel)
library(foreach)
library(doSNOW)
library(neuralnet)
library(caret)
library(nnet)
registerDoParallel(cores = 5)
carabidnet = function(rank, traindat, testdat, hidden){
  print(Sys.time())
  n = names(traindat)
  rankabund = as.data.frame(table(testdat[,1]))  
  
  if(rank == "Family"){
    f = as.formula(paste("Family ~", paste(n[!n %in% c("Family")], collapse = " + ")))
  }
  if(rank == "Order"){
    f = as.formula(paste("Order ~", paste(n[!n %in% "Order"], collapse = " + ")))
  }
  if(rank == "Class"){
    f = as.formula(paste("Class ~", paste(n[!n %in% "Class"], collapse = " + ")))
  }
  if(rank == "AllTaxa"){
    f = as.formula(paste("AllTaxa ~", paste(n[!n %in% "AllTaxa"], collapse = " + ")))
  }

  #time = data.frame(matrix(NA, nrow = length(layers), ncol = 1))
  #soft.plus <- function(x) log(1 + exp(x))
  vaccuracy = c()
  vpr.nn_2 = list()
  nn = list()
  for(i in 25:25){
    set.seed(123)
    nn = neuralnet::neuralnet(f, 
                   data = traindat, 
                   hidden = i, 
                   linear.output = F, 
                   threshold = 0.5, 
                   #act.fct = soft.plus,
                   #learningrate = 0.001,
                   rep = 1)
    #end = Sys.time()
    #time = end - start
    
    valid = cbind(testdat[, 2:ncol(testdat)], nnet::class.ind(as.factor(testdat[,1])))
    vpr.nn = neuralnet::compute(nn, valid[,1:(ncol(testdat) - 1)])
    vpr.nn_ = vpr.nn$net.result
    voriginal_values = max.col(valid[,ncol(testdat):ncol(valid)])
    vpr.nn_2[[i]] = max.col(vpr.nn_)
    vaccuracy[i] = mean(vpr.nn_2[[i]] == voriginal_values)
    write.table(vaccuracy[i], file=paste("Done", i, ".txt", sep=""),
                sep="\t")
  }
  vorignal_values = as.factor(voriginal_values)
  mylist = list(confusionMatrix(vorignal_values, factor(vpr.nn_2[[which.max(vaccuracy)]], levels = levels(vorignal_values))),
                which.max(vaccuracy),
                vaccuracy
                )
  return(mylist)
}


netresults = vector(mode = "list", length = 10)

foreach(x = 1:10) %dopar% {
  for(m in 4:4){
    if(m == 1){
      print("Family starting")
      print(Sys.time())      
      netresults[[10*(m-1)+x]] = carabidnet(rank = "Family", 
                                   traindat = familytrainData[[x]], 
                                   testdat = familyvalidData[[x]],
                                   hidden = 15)
    }
    if(m == 2){
      print("Order starting")
      print(Sys.time())      
      netresults[[10*(m-1)+x]] = carabidnet(rank = "Order", 
                                   traindat = ordertrainData[[x]], 
                                   testdat = ordervalidData[[x]],
                                   hidden = 15)
    }
    if(m == 3){
      print("Class starting")
      print(Sys.time())      
      netresults[[10*(m-1)+x]] = carabidnet(rank = "Class", 
                                   traindat = classtrainData[[x]], 
                                   testdat = classvalidData[[x]],
                                   hidden = 15)
    }
    if(m == 4){
      print("AllTaxa starting")
      print(Sys.time())      
      netresults[[x]] = carabidnet(rank = "AllTaxa", 
                                   traindat = alltrainData[[x]], 
                                   testdat = allvalidData[[x]],
                                   hidden = 15)
      # save(netresults, file = "netresults.RData")
    }
  }
}

print(Sys.time())

save(netresults, file = "netresults.RData")