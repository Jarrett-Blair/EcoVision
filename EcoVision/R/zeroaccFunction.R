#' Zero Shot Accuracy
#'
#' This function calculates zero shot accuracy at the first possible level for 
#' each specimen.
#'
#' @param seen Hierarchy of training data labels.
#' @param actual Hierarchy data frame of test labels.
#' @param preds Hierarchy data frame of predicted labels.
#' @return A list of dataframes
#' @export

zeroacc = function(seen, actual, preds){
  #Getting vector of all labels seen by the model
  seen = as.vector(as.matrix(seen))
  seen = unique(seen)
  
  actual[,1] = as.character(actual[,1])
  
  for(j in 1:nrow(actual)){
    colnum = min(which(simphier[as.character(actual[j,1]),] %in% seen))
    confpred[j] = preds[j,colnum]
    confact[j] = actual[j,colnum]
  }
  confrare = sum(confpred == confact)/length(confpred)
  return(confrare)
}