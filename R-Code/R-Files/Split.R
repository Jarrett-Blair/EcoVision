#See Markdown file for additional details

invert = read.csv("Invert_Meta_Final.csv")

'%!in%' = function(x,y)!('%in%'(x,y))

alltable = table(invert$AllTaxa)
allname = names(which(alltable <= 99))

#Train:Test ratio is 7:3, so I am initializing those values here
fractionTraining = 0.70
fractiontest = 0.30

seeds = 2833

set.seed(seeds)

# Compute sample sizes.
sampleSizeTraining = floor(fractionTraining * nrow(invert))
sampleSizetest = floor(fractiontest * nrow(invert))
# Create the randomly-sampled indices for the dataframe. Use setdiff() to
# avoid overlapping subsets of indices.
indicesTraining = sort(sample(seq_len(nrow(invert)), size=sampleSizeTraining))
indicestest = setdiff(seq_len(nrow(invert)), indicesTraining)

# Finally, output the three dataframes for training, testing, and zero shot.
dfTraining = invert[indicesTraining, ]
dftest = invert[indicestest, ]

set = subset(dfTraining, AllTaxa %!in% allname)
alltrain = set

set = subset(dftest, AllTaxa %!in% allname)
alltest = set

allzero = subset(invert, AllTaxa %in% allname)
# write.csv(alltest, "test.csv", row.names = F)
# write.csv(alltrain, "train.csv", row.names = F)
# write.csv(allzero, "zero.csv", row.names = F)



#Order Level


ordertable = table(invert$Order)
ordername = names(which(ordertable <= 99))

fractionTraining   <- 0.70
fractiontest       <- 0.30

seeds = c(2833)

set.seed(seeds)

# Compute sample sizes.
sampleSizeTraining   <- floor(fractionTraining   * nrow(invert))
sampleSizetest       <- floor(fractiontest       * nrow(invert))
# Create the randomly-sampled indices for the dataframe. Use setdiff() to
# avoid overlapping subsets of indices.
indicesTraining    <- sort(sample(seq_len(nrow(invert)), size=sampleSizeTraining))
indicesNotTraining <- setdiff(seq_len(nrow(invert)), indicesTraining)
indicestest  <- sort(sample(indicesNotTraining, size=sampleSizetest))

# Finally, output the three dataframes for training, testing and zero shot.
dfTraining   <- invert[indicesTraining, ]
dftest       <- invert[indicestest, ]

'%!in%' <- function(x,y)!('%in%'(x,y))


dfTraining = subset(dfTraining, Order %!in% c('indet.', ordername))
dftest = subset(dftest, Order %!in% c('indet.', ordername))
dfzero = subset(invert, Order %in% c('indet.', ordername))


# write.csv(dftest, "ordertest.csv", row.names = F)
# write.csv(dftrain, "ordertrain.csv", row.names = F)
# write.csv(dfzero, "orderzero.csv", row.names = F)