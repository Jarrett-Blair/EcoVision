#See Markdown file for additional details

zeroclass = c()
for(i in 1:nrow(zeropreds)){
  zeroclass[i] = names(which.max(zeropreds[i,]))
}

simpzero = hierarchy[,c('Species',
                        'Genus',
                        'Family',
                        'Order',
                        'Class'
                        'Phylum')]

predont = data.frame(matrix(NA, nrow = length(zeroclass), ncol = 6))
predont[,1] = zeroclass
for(i in 2:6){
  for(j in 1:nrow(predont)){
    predont[j,i] = simpzero[which(simpzero[,i-1] == predont[j,i-1])[1], i]
  }
}

zerolabs = zero$AllTaxa

testhierarchy = data.frame(matrix(NA, nrow =length(zerolabs), ncol = 6))
testhierarchy[,1] = zerolabs
for(i in 2:6){
  for(j in 1:nrow(testhierarchy)){
    testhierarchy[j,i] = simpzero[which(simpzero[,i-1] == testhierarchy[j,i-1])[1], i]
  }
}  

simpzero$known = NA
for(i in 1:nrow(simpzero)){
  simpzero$known[i] = which(simpzero[i,] %in% levels(testlab))[1]
} 

count = c()
for(i in 1:length(zerolabs)){
  level = simpzero$known[which(simpzero[,1] == testhierarchy[i,1])]
  count[i] = predont[i,level] == testhierarchy[i,level]
}

accuracy = count/nrow(zero)