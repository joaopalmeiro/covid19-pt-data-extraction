# brew install poppler
# brew install pkg-config
# install.packages("pdftools")

library(pdftools)
library(stringr)
library(tidyverse)

PDF_FOLDER_NAME <- "pdf"
DATA_FOLDER_NAME <- "data"

PDF_NAME <- "i026070.pdf"
DATA_NAME <- paste(Sys.Date(), "csv", sep=".")

PDF_PATH <- file.path(PDF_FOLDER_NAME, PDF_NAME)
DATA_PATH <- file.path(DATA_FOLDER_NAME, DATA_NAME)

doc <- str_squish(strsplit(pdf_text(PDF_PATH)[[3]], "\n")[[1]])
doc

BEGIN <- 6
FOOTNOTE <- 39
DATE <-  42

doc <- doc[c(BEGIN:(FOOTNOTE-1), (FOOTNOTE+1):(DATE-1))]
doc

doc_pre_table <- unlist(str_extract_all(doc, "([:alpha:][[:alpha:]\\s\\-()]+)\\s([[:digit:]]+)"))
doc_pre_table

df <- enframe(doc_pre_table, name = NULL) %>% separate(value, c("concelho", "n_casos"), "\\s(?=[^\\s]+$)")
df

# write_csv(df, DATA_PATH)
