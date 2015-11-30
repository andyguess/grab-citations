# grab-citations

Searches .tex file for BibTeX citation names (in \cite?[]{} commands), then spits out list.

## Setup

### Read files

```{r}
setwd("~/Documents/Columbia/Dissertation/deposit/Chapter2") # set your directory
tex_file <- readLines("Chapter2.tex", warn = FALSE)
bib <- readLines("../Master.bib", warn = FALSE) # master BibTeX file
head(tex_file)
```

### Explore data

```{r}
grep("\\cite[[:lower:]]*[[:punct:][:digit:]]+", tex_file) # Which lines have citations?
length(grep("\\cite[[:lower:]]*[[:punct:][:digit:]]+", tex_file)) # How many lines?
```

### Run function

```{r}
source("grab_citations.R")
grab_citations(tex_file, bib)
```
