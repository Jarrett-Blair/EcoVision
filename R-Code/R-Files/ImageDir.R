#See Markdown file for additional details

filenames = list.files(directory)

invert$Label = paste0(invert$Label,".tif.",invert$ROI,".jpg")

Label = invert$Label
Label2 = paste0(substr(Label, 1, 21), substr(Label, 25, str_length(Label))) #Remove .01
Label3 = paste0(substr(Label, 1, 23), substr(Label, 27, str_length(Label))) #Remove .01 if long date (e.g. S.)
Label4 = paste0(substr(Label, 1, 30), substr(Label, 35, str_length(Label))) #Remove .tif
Label5 = paste0(substr(Label, 1, 33), substr(Label, 38, str_length(Label))) #Remove .tif if long date
Label6 = paste0(substr(Label, 1, 18), "ib", substr(Label, 21, str_length(Label))) #Lowercase ib
Label7 = paste0(substr(Label, 1, 21), "01.", substr(Label, 22, 27), substr(Label, 32, str_length(Label)))
Label8 = paste0(substr(Label, 1, 23), "01.", substr(Label, 24, 29), substr(Label, 34, str_length(Label)))

allLabs = c(Label, Label2, Label3, Label4, Label5, Label6, Label7, Label8)

my.file.rename <- function(from, to) {
  todir <- dirname(to)
  if (!isTRUE(file.info(todir)$isdir)) dir.create(todir, recursive=TRUE)
  file.copy(from = from,  to = to)
}

split = vector(mode = 'character', length = nrow(invert))
split[which(c(1:nrow(invert)) %in% indicesTraining & invert$AllTaxa %!in% allname)] = 'training'
split[which(c(1:nrow(invert)) %in% indicestest & invert$AllTaxa %!in% allname)] = 'testing'
split[which(invert$AllTaxa %in% allname)] = 'zero'


sites = c()
sitedex = 1
for(filename in filenames){
  if(filename %in% allLabs){
    taxadex = which(allLabs == filename)[1] %% length(Label)
    taxa = invert$AllTaxa[taxadex]
    dataset = split[taxadex]
    my.file.rename(from = paste(getwd(),filename, sep = "/"),
                   to = paste("C:/Carabid_Data/Invert/computer-vision/basedata", dataset, taxa, filename, sep = "/"))
  }
  if(substr(filename, 1, 4) %!in% sites){
    sites[sitedex] = substr(filename, 1, 4)
    sitedex = sitedex + 1
    print(paste("Starting", substr(filename, 1, 4), Sys.time()))
  }
}





