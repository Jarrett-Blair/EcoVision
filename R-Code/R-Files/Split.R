#See Markdown file for additional details

invert = read.csv("Invert_Meta_Final.csv")

'%!in%' = function(x,y)!('%in%'(x,y))

alltable = table(invert$AllTaxa)
allname = names(which(alltable <= 99))

#Train:Test ratio is 7:3, so I am initializing those values here
fractionTraining = 0.70
fractionvalid = 0.30

seeds = 2833

set.seed(seeds)

# Compute sample sizes.
sampleSizeTraining = floor(fractionTraining * nrow(invert))
sampleSizevalid = floor(fractionvalid * nrow(invert))
# Create the randomly-sampled indices for the dataframe. Use setdiff() to
# avoid overlapping subsets of indices.
indicesTraining = sort(sample(seq_len(nrow(invert)), size=sampleSizeTraining))
indicesvalid = setdiff(seq_len(nrow(invert)), indicesTraining)

# Finally, output the three dataframes for training, validation and valid.
dfTraining = invert[indicesTraining, ]
dfvalid = invert[indicesvalid, ]

set = subset(dfTraining, AllTaxa %!in% allname)
alltrain = set

set = subset(dfvalid, AllTaxa %!in% allname)
allvalid = set

allzero = subset(invert, AllTaxa %in% allname)
# write.csv(allvalid, "valid.csv", row.names = F)
# write.csv(alltrain, "train.csv", row.names = F)
# write.csv(allzero, "zero.csv", row.names = F)



#Order Level


ordertable = table(invert$Order)
ordername = names(which(ordertable <= 99))

fractionTraining   <- 0.70
fractionvalid       <- 0.30

seeds = c(2833)

set.seed(seeds)

# Compute sample sizes.
sampleSizeTraining   <- floor(fractionTraining   * nrow(invert))
sampleSizevalid       <- floor(fractionvalid       * nrow(invert))
# Create the randomly-sampled indices for the dataframe. Use setdiff() to
# avoid overlapping subsets of indices.
indicesTraining    <- sort(sample(seq_len(nrow(invert)), size=sampleSizeTraining))
indicesNotTraining <- setdiff(seq_len(nrow(invert)), indicesTraining)
indicesvalid  <- sort(sample(indicesNotTraining, size=sampleSizevalid))

# Finally, output the three dataframes for training, validation and valid.
dfTraining   <- invert[indicesTraining, ]
dfvalid       <- invert[indicesvalid, ]

'%!in%' <- function(x,y)!('%in%'(x,y))


dfTraining = subset(dfTraining, Order %!in% c('indet.', ordername))
dfvalid = subset(dfvalid, Order %!in% c('indet.', ordername))
dfzero = subset(invert, Order %in% c('indet.', ordername))


# write.csv(dfvalid, "ordervalid.csv", row.names = F)
# write.csv(dftrain, "ordertrain.csv", row.names = F)
# write.csv(dfzero, "orderzero.csv", row.names = F)