#' Split a Dataframe
#'
#' This function splits a dataframe into several, smaller dataframes. The 
#' dataframes can also be modified by removing unwanted groups, and/or setting a
#' minimum number of individuals per group.
#'
#' @param data The dataframe to be split
#' @param label The column name which contains the groups
#' @param fracs Vector of fractions to split the dataframe into, must == 1
#' @param remove Vector of group names to remove from dataframe
#' @param min Minimum number of individuals per group. Groups with < min will be removed
#' @return A list of dataframes
#' @export
splitr = function(data, label, fracs, remove, min){
  if(sum(fracs) != 1){
    stop('Sum of fracs does not equal 1')
  }
  '%!in%' = function(x,y)!('%in%'(x,y))
  iter = length(fracs) #Setting number of iterations to run through
  #Initializing indices and dataframe vectors
  indices = vector(mode = "list", length = iter)
  dfs = vector(mode = "list", length = iter)
  
  #Removing unwanted labels from dataset
  data = data[which(data[,label] %!in% remove),]
  
  #Removing labels below threshold
  abundances = table(data[,label])
  names = names(which(abundances <= min))
  data = data[which(data[,label] %!in% names),]
  
  #Generating dataframes
  for(x in 1:iter){
    samplesize = floor(fracs[x] * nrow(data)) #Setting number of samples to pull for current iter
    
    taken = unlist(indices) #Recording which indices have already been used to avoid repetition 
    openindices = setdiff(seq_len(nrow(data)), taken) #Recording which indices are still available
    indices[[x]] = sort(sample(openindices, size=samplesize)) #Setting indices for current iter
    
    dfs[[x]] = data[indices[[x]], ] #Generating df for current iter
  }
  return(dfs)
}
  
