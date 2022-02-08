setwd("C:/Users/jarre/ownCloud/Invert")
df = read.csv("InvertMeta.csv", stringsAsFactors = F)
alldata = df
allname = levels(as.factor(alldata$AllTaxa))
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
hierarchyignore = data.frame(matrix(NA, nrow = length(allname), ncol = length(hierarchylevels)))
names(hierarchyignore) = hierarchylevels
hierarchyignore[,1] = allname
for(i in 2:ncol(hierarchyignore)){
  for(j in 1:length(allname)){
    if(df[which(df$AllTaxa == allname[j])[1], "Det_Level"] != "no taxonomic resolution"){
      if(which(hierarchylevels == df[which(df$AllTaxa == allname[j])[1], "Det_Level"]) < i){
        hierarchyignore[j,i] = as.character(df[which(df$AllTaxa == allname[j])[1],names(hierarchyignore)[i]])
      }
      else{
        hierarchyignore[j,i] = hierarchyignore[j,1]
      }
    }
    else{
      hierarchyignore[j,i] = hierarchyignore[j,1]
    }
  }
}

for(i in ncol(hierarchyignore):1){
  for(j in nrow(hierarchyignore):1){
    if(hierarchyignore[j,i] == "NULL"){
      hierarchyignore[j,i] = hierarchyignore[j,i+1]
    }
  }
}

hierarchyignore[which(hierarchyignore[,1] == "Larva"),] = "Larva"
hierarchyignore[which(hierarchyignore[,1] == "Nymph"),] = "Nymph"
hierarchyignore[which(hierarchyignore[,1] == "indet."),] = "indet."
hierarchyignore[which(hierarchyignore[,1] == "Juvenile"),] = "Juvenile"

hierarchyall = hierarchyignore
