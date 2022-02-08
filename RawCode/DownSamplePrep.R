
for(i in 1:10){
  set.seed(123)
  alltrainData[[i]] = alltrainData[[i]][ -sample( which(alltrainData[[i]]$AllTaxa=='Ignore'), round(sum(alltrainData[[i]]$AllTaxa=='Ignore') - 1000)), ]
  alltrainData[[i]] = alltrainData[[i]][ -sample( which(alltrainData[[i]]$AllTaxa=='Formicidae'), round(sum(alltrainData[[i]]$AllTaxa=='Formicidae') - 1000)), ]
  alltrainData[[i]] = alltrainData[[i]][ -sample( which(alltrainData[[i]]$AllTaxa=='Diptera'), round(sum(alltrainData[[i]]$AllTaxa=='Diptera') - 1000)), ]
  alltrainData[[i]] = alltrainData[[i]][ -sample( which(alltrainData[[i]]$AllTaxa=='Myrmicinae'), round(sum(alltrainData[[i]]$AllTaxa=='Myrmicinae') - 1000)), ]
  alltrainData[[i]] = alltrainData[[i]][ -sample( which(alltrainData[[i]]$AllTaxa=='Acari'), round(sum(alltrainData[[i]]$AllTaxa=='Acari') - 1000)), ]
  alltrainData[[i]] = alltrainData[[i]][ -sample( which(alltrainData[[i]]$AllTaxa=='Araneae'), round(sum(alltrainData[[i]]$AllTaxa=='Araneae') - 1000)), ]
  alltrainData[[i]] = alltrainData[[i]][ -sample( which(alltrainData[[i]]$AllTaxa=='Arthropoda'), round(sum(alltrainData[[i]]$AllTaxa=='Arthropoda') - 1000)), ]
  rownames(alltrainData[[i]]) = 1:nrow(alltrainData[[i]])
}

