library(gdata)

setwd("/Users/aguess/Documents/Columbia/Dissertation/deposit/Chapter2")
ch2 <- readLines("Chapter2.tex", warn = FALSE)
head(ch2)

grep("\\cite[[:lower:]]*[[:punct:][:digit:]]+", ch2)
length(grep("\\cite[[:lower:]]*[[:punct:][:digit:]]+", ch2))

split_cite <- function(c) {
  tmp <- strsplit(c, "\\cite", fixed = TRUE)
  for(i in 1:length(tmp[[1]])) {
    if(!grepl("[[:lower:]]*[{][[:alpha:]]+", tmp[[1]][i])) {
      tmp[[1]] <- tmp[[1]][!1:length(tmp[[1]]) %in% i]
    }
  }
  return(tmp[[1]])
}

cites <- ch2[grep("\\cite[[:lower:]]*[[:punct:][:digit:]]+", ch2)] # [[:alnum:]:]+
cites <- as.vector(unlist(sapply(cites, split_cite)))
cites <- gsub("[[:alnum:][:punct:][:blank:]]+\\\\cite[[:lower:]]*[[:punct:][:digit:]]+", "", cites)
cites <- gsub("}[[:alnum:][:punct:][:blank:]]+", "", cites)
cites <- gsub("[[:alnum:][:punct:][:blank:]]+[{]", "", cites)
cites <- unique(trim(unlist(strsplit(cites, ","))))

cites <- cites[!1:length(cites) %in% c(38, 40:42)] # not citations

# now check master file
bib <- readLines("../Master.bib", warn = FALSE)
which(!sapply(1:length(cites), function(c) sum(grep(cites[c], bib, fixed = TRUE)) > 0))
