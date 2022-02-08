setwd("C:/Users/jarre/ownCloud/Invert")
df = read.csv("InvertsV2.csv", stringsAsFactors = F)
alldata = read.csv("alltrain1.csv")
allname = levels(as.factor(alldata$AllTaxa))
hierarchy = data.frame(matrix(NA, nrow = length(allname), ncol = 13))
hierarchylevels = c("Species", 
                    "Genus", 
                    "Subfamily", 
                    "Family", 
                    "Superfamily", 
                    "Infraorder", 
                    "Suborder", 
                    "Order", 
                    "Superorder", 
                    "Subclass", 
                    "Class", 
                    "Subphylum", 
                    "Phylum")
names(hierarchy) = hierarchylevels
hierarchy[,1] = allname
for(i in 2:ncol(hierarchy)){
  for(j in 1:length(allname)){
    if(which(hierarchylevels == df[which(df$AllTaxa == allname[j])[1], "Det_Level"]) < i){
      hierarchy[j,i] = as.character(df[which(df$AllTaxa == allname[j])[1],names(hierarchy)[i]])
    }
    else{
      hierarchy[j,i] = hierarchy[j,1]
    }
  }
}

for(i in ncol(hierarchy):1){
  for(j in nrow(hierarchy):1){
    if(hierarchy[j,i] == "NULL"){
      hierarchy[j,i] = hierarchy[j,i+1]
    }
  }
}