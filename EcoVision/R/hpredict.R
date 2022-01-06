#' Hierarchical Predictions
#'
#' This function converts a prediction vector into a hierarchical prediction dataframe.
#'
#' @param preds A vector of labels predicted by a model.
#' @param hierarchy The hierarchy dataframe produced by the "hierarchy" function
#' for your dataset.
#' @return A list of dataframes
#' @export
#'  
hpredict = function(preds, hierarchy){
  #Initializing prediction dataframe
  preddf = data.frame(matrix(NA, nrow = length(preds), ncol = ncol(hierarchy)))
  colnames(preddf) = colnames(hierarchy)
  preddf[,1] = preds
  
  
  for(i in 2:ncol(hierarchy)){
    for(j in 1:nrow(preddf)){
      #For the current pred (in this case preddf[j,i-1]), find the first match
      #in the hierarchy dataframe and assign the label in the next column up
      #as preddf[j,i].
      preddf[j,i] = hierarchy[which(hierarchy[,i-1] == preddf[j,i-1])[1], i]
    }
  }  
}