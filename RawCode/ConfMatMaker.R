mat = as.data.frame(xgbconfmat[[1]]$table)
for(i in 2:10){
  for(j in 1:nrow(mat)){
    mat[j,3] = mat[j,3] + as.data.frame(xgbconfmat[[i]]$table)[j,3]
  }
}
mat = dcast(data = mat, formula = Prediction~Reference)
write.csv(mat, "OrderConfMat.csv")

allmat = as.data.frame(t(allmat))
