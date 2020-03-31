# brew install poppler
# brew install pkg-config
# install.packages("pdftools")

library(pdftools)
library(stringr)
library(tidyverse)

PDF_FOLDER_NAME <- "pdf"
DATA_FOLDER_NAME <- "data"

PDF_NAME <- "i026084.pdf"
DATA_NAME <- paste(Sys.Date(), "csv", sep = ".")

PDF_PATH <- file.path(PDF_FOLDER_NAME, PDF_NAME)
DATA_PATH <- file.path(DATA_FOLDER_NAME, DATA_NAME)

PAGE_NUMBER <- 3

doc <-
  str_squish(strsplit(pdf_text(PDF_PATH)[[PAGE_NUMBER]], "\n")[[1]])
doc

BEGIN <- 8
FOOTNOTE <- 77

MIN_NUMBER_CASES <- 3

doc <- doc[c(BEGIN:(FOOTNOTE - 1))]
doc

mask_concelho <- !is.na(str_match(doc, "[[:alpha:]()\\.]$"))
mask_casos <-
  !is.na(str_match(doc, "^[:digit:]$|[:digit:]\\s[:digit:]$"))

doc[mask_concelho]

# matched <-
#   unlist(str_extract_all(doc[mask_concelho], "([:alpha:][[:alpha:]\\s\\-().]+)\\s([[:digit:]]+)"))
#
# matched_pattern <- paste(matched, collapse = "|")
# matched_pattern
#
# missing_concelhos <-
#   str_remove_all(doc[mask_concelho], matched_pattern)
# missing_concelhos
#
# missing_concelhos_name <-
#   paste(missing_concelhos[seq(length(missing_concelhos)) %% 2 == 1], missing_concelhos[seq(length(missing_concelhos)) %% 2 == 0])
# missing_concelhos_name <- str_squish(missing_concelhos_name)
# missing_concelhos_name
#
# doc[mask_casos]
#
# missing_concelhos_casos <-
#   unlist(str_extract_all(doc[mask_casos], "[:digit:]$"))
# missing_concelhos_casos
#
# concelhos_casos <-
#   paste(missing_concelhos_name, missing_concelhos_casos)
# concelhos_casos

# ++ -> 1 or more, possessive
doc_pre_table <-
  unlist(
    str_extract_all(
      doc,
      "([:alpha:][[:alpha:]\\s\\-()\\.\\*]+)\\s([[:digit:]]++(?!\\%))"
    )
  )
doc_pre_table
length(doc_pre_table)

# doc_pre_table <- append(doc_pre_table, concelhos_casos)

df <-
  enframe(doc_pre_table, name = NULL) %>%
  separate(value, c("concelho", "n_casos"), "\\s(?=[^\\s]+$)", convert = TRUE) %>%
  separate(concelho, c("concelho", "reportado_por_ARS_RA"), "\\*", convert = FALSE) %>%
  mutate(reportado_por_ARS_RA = if_else(is.na(reportado_por_ARS_RA), as.integer(0), as.integer(1))) %>%
  arrange(desc(n_casos), concelho)
# df <-
#   df %>% mutate(
#     concelho = replace(concelho, concelho == "Macedo de", "Macedo de Cavaleiros"),
#     concelho = replace(concelho, concelho == "Torre de", "Torre de Moncorvo")
#   ) %>% arrange(desc(n_casos), concelho)
df

min(df$n_casos) >= MIN_NUMBER_CASES

DATA_PATH
# write_csv(df, DATA_PATH)
