if(!("gdata" %in% rownames(installed.packages()))) install.packages("gdata", dependencies = TRUE)
library(gdata) # trim()

## Function to split out multiple citations in the same line

split_cite <- function(c) {
  tmp <- strsplit(c, "\\cite", fixed = TRUE)
  for(i in 1:length(tmp[[1]])) {
    if(!grepl("[[:lower:]]*[{][[:alpha:]]+", tmp[[1]][i])) {
      tmp[[1]] <- tmp[[1]][!1:length(tmp[[1]]) %in% i]
    }
  }
  return(tmp[[1]])
}

## Function to grab \cite refs in given .tex file and spit out in the ones missing from a .bib file

grab_citations <- function(tex, master_bib) {
  
  # grab lines with citations (assume \cite names don't start with a #):
  cites <- tex[grep("\\cite[[:lower:]]*[[:punct:][:digit:]]+", tex)]
  
  # run the split_cite() function on each line:
  cites <- as.vector(unlist(sapply(cites, split_cite)))
  
  # take out everything before the citation on each line:
  cites <- gsub("[[:alnum:][:punct:][:blank:]]+\\\\cite[[:lower:]]*[[:punct:][:digit:]]+", "", cites)
  
  # take out everything after the citation on each line:
  cites <- gsub("}[[:alnum:][:punct:][:blank:]]+", "", cites)
  cites <- gsub("[[:alnum:][:punct:][:blank:]]+[{]", "", cites) # cleanup
  
  # split up individual \cite{} commands with multiple citations (separated by commas):
  cites <- unique(trim(unlist(strsplit(cites, ","))))
  
  # take out lines that are not citations (e.g. \ref{}):
  #cites <- cites[!1:length(cites) %in% c(38, 40:42)] # edit this line
  
  # citation(s) missing from .bib file
  return(cites[which(!sapply(1:length(cites), function(c) sum(grep(cites[c], master_bib, fixed = TRUE)) > 0))])
  
}
