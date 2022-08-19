#See Markdown file for additional details

library(caret)

remove = c(1:8,13,14,23:40,65,69:71,78,79)
coldex = c(1:49)

#Load in data sets created in Split.r
train = as.data.frame(read.csv("train.csv"))
valid = as.data.frame(read.csv("valid.csv"))

valid = valid[,-remove]
train = train[,-remove]
zero = zero[-remove]

train[,coldex] = lapply(train[,coldex], as.numeric)
valid[,coldex] = lapply(valid[,coldex], as.numeric)
zero[,coldex] = lapply(zero[,coldex], as.numeric)

normParam = preProcess(train)
norm.valid = predict(normParam, valid)
norm.train = predict(normParam, train)
norm.zero = predict(normParam, zero)

# write.csv(norm.valid, "normvalid.csv", row.names = F)
# write.csv(norm.train, "normtrain.csv", row.names = F)
# write.csv(norm.zero, "normzero.csv", row.names = F)



#Order Level


library(dplyr)
remove = c(1:8,13,14,23:31,33:40,65,69:71,78,79,84)
coldex = c(1:49)

#Load in data sets created in Split.r
train = as.data.frame(read.csv("ordertrain.csv"))
valid = as.data.frame(read.csv("ordervalid.csv"))
zero = as.data.frame(read.csv("orderzero.csv"))

train = train %>% relocate(Order, .before = AllTaxa)
valid = valid %>% relocate(Order, .before = AllTaxa)
zero = zero %>% relocate(Order, .before = AllTaxa)

valid = valid[,-remove]
train = train[,-remove]
zero = zero[, -remove]

train[,coldex] = lapply(train[,coldex], as.numeric)
valid[,coldex] = lapply(valid[,coldex], as.numeric)
zero[,coldex] = lapply(zero[,coldex], as.numeric)

normParam = preProcess(train)
norm.valid = predict(normParam, valid)
norm.train = predict(normParam, train)
norm.zero = predict(normParam, zero)

# write.csv(norm.valid, "normordervalid.csv", row.names = F)
# write.csv(norm.train, "normordertrain.csv", row.names = F)
# write.csv(norm.zero, "normorderzero.csv", row.names = F)