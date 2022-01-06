#' Top n Accuracy
#'
#' This function calculates accuracy of a model when comparing against the top 'n'
#' predictions.
#'
#' @param n Number of predictions to compare against.
#' @param testlab The true labels for your test data.
#' @param prob Dataframe, matrix, or numeric vector of prediction probabilities.
#' Dataframes and matrices must be organized such that columns represent separate
#' classes and rows represent each specimen. Numeric vectors must be organized 
#' such the probabilities of every class is given for a specimen before continuing
#' to the next specimen, and the order of classes is maintained between specimens
#' (e.g. In a dataset with 20 classes, the probabilities given to class 1 would 
#' be indexed in the vector as 1, 21, 41, etc.).
#' @param numclass Number of classes being predicted. Only required if 'prob' is
#' given as a numerical vector. Default is Inf.
#' @return A list of dataframes
#' @export


topnacc = function(x, testlab, prob, numclass = Inf){
  if(x > numclass){
    stop('x > numclass')
  }
  #Making test labels numeric
  testlab = as.numeric(testlab)
  
  #Creating probability matrix, with each column representing a different class
  if(is.numeric(prob) & !is.matrix(prob)){
    prob = matrix(prob, nrow = numclass)
    prob = t(prob)
    colnames(prob) = c(1:numclass)
  }
  colnames(prob) = c(1:numclass)
  
  #Creating a dataframe of top 'x' predictions
  topxpreds = data.frame(matrix(NA, nrow = nrow(prob), ncol = x))
  for(i in 1:nrow(prob)){
    #Each row is reordered by descending probability. The name of the top 'x' columns
    #from each row are recorded in topxpreds
    topxpreds[i,] =  as.numeric(names(prob[i,order(as.numeric(prob[i,]), decreasing = T)])[1:x])
  }
  
  topxaccuracy = sum(testlab == topxpreds)/length(testlab)
  
  return(topxaccuracy)
}
