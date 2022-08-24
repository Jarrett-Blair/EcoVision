files = basename(shufflefiles)

train$Label = paste0(train$Label,".tif.",train$ROI,".jpg")

Label = train$Label
Label2 = paste0(substr(Label, 1, 21), substr(Label, 25, str_length(Label))) #Remove .01
Label3 = paste0(substr(Label, 1, 23), substr(Label, 27, str_length(Label))) #Remove .01 if long date (e.g. S.)
Label4 = paste0(substr(Label, 1, 30), substr(Label, 35, str_length(Label))) #Remove .tif
Label5 = paste0(substr(Label, 1, 33), substr(Label, 38, str_length(Label))) #Remove .tif if long date
Label6 = paste0(substr(Label, 1, 18), "ib", substr(Label, 21, str_length(Label))) #Lowercase ib
Label7 = paste0(substr(Label, 1, 21), "01.", substr(Label, 22, 27), substr(Label, 32, str_length(Label)))
Label8 = paste0(substr(Label, 1, 23), "01.", substr(Label, 24, 29), substr(Label, 34, str_length(Label)))

trainLabs = c(Label, Label2, Label3, Label4, Label5, Label6, Label7, Label8)

taxadex = c()
for(i in 1:length(files)){
  taxadex[i] = which(trainLabs == files[i]) %% length(Label)
}

shuffletrain = norm.train
for(i in 1:nrow(shuffletrain)){
  shuffletrain[i,] = norm.train[taxadex[i],]
}
