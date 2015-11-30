if(!("gdata" %in% rownames(installed.packages()))) install.packages("gdata", dependencies = TRUE)
library(gdata) # trim()

## Read file

setwd("~/Documents/Columbia/Dissertation/deposit/Chapter2") # set your directory
tex_file <- readLines("Chapter2.tex", warn = FALSE)
head(tex_file)

grep("\\cite[[:lower:]]*[[:punct:][:digit:]]+", tex_file) # Which lines have citations?
length(grep("\\cite[[:lower:]]*[[:punct:][:digit:]]+", tex_file)) # How many lines?

# function to split out multiple citations in the same line
split_cite <- function(c) {
  tmp <- strsplit(c, "\\cite", fixed = TRUE)
  for(i in 1:length(tmp[[1]])) {
    if(!grepl("[[:lower:]]*[{][[:alpha:]]+", tmp[[1]][i])) {
      tmp[[1]] <- tmp[[1]][!1:length(tmp[[1]]) %in% i]
    }
  }
  return(tmp[[1]])
}

# grab lines with citations (assume \cite names don't start with a #):
cites <- tex_file[grep("\\cite[[:lower:]]*[[:punct:][:digit:]]+", tex_file)]

# run the split_cite() function on each line:
cites <- as.vector(unlist(sapply(cites, split_cite)))

# take out everything before the citation on each line:
cites <- gsub("[[:alnum:][:punct:][:blank:]]+\\\\cite[[:lower:]]*[[:punct:][:digit:]]+", "", cites)

# take out everything after the citation on each line:
cites <- gsub("}[[:alnum:][:punct:][:blank:]]+", "", cites)
cites <- gsub("[[:alnum:][:punct:][:blank:]]+[{]", "", cites) # cleanup

# split up individual \cite{} commands with multiple citations (separated by commas)
cites <- unique(trim(unlist(strsplit(cites, ","))))

# take out lines that are not citations (e.g. \ref{})
#cites <- cites[!1:length(cites) %in% c(38, 40:42)] # edit this line

## Now check master BibTeX file

bib <- readLines("../Master.bib", warn = FALSE)

# index of citation(s) missing from .bib file
which(!sapply(1:length(cites), function(c) sum(grep(cites[c], bib, fixed = TRUE)) > 0))
