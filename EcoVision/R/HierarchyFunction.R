#' Hierarchy Dataframe Maker
#'
#' This function creates a dataframe containing a hierarchical ordering of labels.
#' Each row contains a nested group of related labels. Each column represents a 
#' class of labels. Label specificity decreases with column number (i.e. column 1
#' has the most specific labels, whereas the last column will have the broadest
#' labels). Dataframes produced from this function are intended to be used for 
#' reference when generating hierarchical predictions in the hpredict function.
#'
#' @param data The dataframe containing raw labels.
#' @param ranks A vector of column name strings. The columns names in this 
#' vector must exist in 'data', and should represent all the class levels to 
#' be included in the hierarchical dataframe.
#' @param LITLs A vector of column names or numbers indicating the Lowest
#' Identified Taxonomic Level for each specimen (i.e row) in 'data'.This 
#' parameter is to be used if not all specimens are classified to the same
#' level in 'data'. Default is the first listed name in 'ranks'.
#' @return A list of dataframes
#' @export
hierarchy = function(data, ranks, LITLs = ranks[1]){
  #Get LITL labels for each specimen
  if(length(LITLs) != 1 & length(LITLs) != nrow(data)){
    stop("The length of LITLs must either eqaul 1 or equal the number of 
         rows in 'data'.")
  }
  if(length(LITLs) == 1){
    LITLs = rep(LITLs, nrow(data))
  }
  LITLlabels = c()
  for(i in 1:nrow(data)){
    LITLlabels[i] = data[i,LITLs[i]]
  }
  #Get all unique LITL labels
  uniquelabels = levels(as.factor(LITLlabels))
  
  #Create hierarchy DF
  hierarchy = data.frame(matrix(NA, nrow = length(LITLlabels), ncol = length(ranks)))
  colnames(hierarchy) = ranks
  #Set first column of DF as the unique LITLlabels
  hierarchy[,1] = uniquelabels
  #For loop starting with second taxonomic level/column
  for(i in 2:ncol(hierarchy)){
    #Iterate through each unique LITL label
    for(j in 1:length(uniquelabels)){
      row = which(LITLlabels == uniquelabels[j])[1]
      if(which(ranks == LITLs[row]) < i){
        hierarchy[j,i] = as.character(data[row,ranks[i]])
      }
      else{
        hierarchy[j,i] = hierarchyignore[j,1]
      }
    }
  }
  return(hierarchy)
}
