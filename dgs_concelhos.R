# brew install poppler
# brew install pkg-config
# install.packages("pdftools")

library(pdftools)
library(stringr)
library(tidyverse)
library(tabulizer)

Sys.Date()

PDF_FOLDER_NAME <- "pdf"
DATA_FOLDER_NAME <- "data"

PDF_NAME <-
  paste("49_DGS_boletim_202004201", "pdf", sep = ".")
PDF_NAME
DATA_NAME <- paste(Sys.Date(), "csv", sep = ".")
DATA_NAME

PDF_PATH <- file.path(PDF_FOLDER_NAME, PDF_NAME)
DATA_PATH <- file.path(DATA_FOLDER_NAME, DATA_NAME)

PAGE_NUMBER <- 3

# df_data <- pdf_data(PDF_PATH)[[PAGE_NUMBER]]
# df_data

# pdf_text(PDF_PATH)[[PAGE_NUMBER]]

df_tabulizer <-
  strsplit(extract_text(PDF_PATH, pages = PAGE_NUMBER), "\n")[[1]]
df_tabulizer

concat_broke_down_concelhos <- function(df) {
  concat_concelhos <- character(0)
  to_remove <- integer(0)
  
  stop_words <- c("CONCELHO", "NÚMERO", "NÚMERO DE", "CASOS", "DE CASOS")
  
  for (i in seq_along(df)) {
    if (str_detect(df[i], "^[:digit:]+$")) {
      # concelho <- str_squish(paste(df[i - 2], df[i - 1], df[i]))
      # concat_concelhos <- c(concat_concelhos, concelho)
      
      first_part <-
        ifelse(str_detect(df[i - 2], "[:digit:]") |
                 (df[i - 2] %in% stop_words),
               "",
               df[i - 2])
      concelho <- str_squish(paste(first_part, df[i - 1], df[i]))
      concat_concelhos <- c(concat_concelhos, concelho)
    }
    
    else if (!(str_detect(df[i], "[:digit:]")) &
             (!(df[i] %in% stop_words))) {
      if (str_detect(df[i + 1], "^[[:alpha:]\\s]+[:digit:]+$")) {
        concelho <- str_squish(paste(df[i], df[i + 1]))
        concat_concelhos <- c(concat_concelhos, concelho)
        to_remove <- c(to_remove, i + 1)
      }
    }
  }
  
  return(list("add_concelhos" = concat_concelhos, "remove_concelhos" = to_remove))
}

# concat_broke_down_concelhos(df_tabulizer)

doc <- df_tabulizer
doc

# doc <-
#   str_squish(strsplit(pdf_text(PDF_PATH)[[PAGE_NUMBER]], "\n")[[1]])
# doc

BEGIN <- 13
# FOOTNOTE <- 226

MIN_NUMBER_CASES <- 3

# doc <- doc[c(BEGIN:(FOOTNOTE - 1))]
doc <- doc[c(BEGIN:length(doc))]
doc

concelhos_to_add_and_remove <- concat_broke_down_concelhos(doc)
concelhos_to_add_and_remove

if (length(concelhos_to_add_and_remove$remove_concelhos) > 0) {
  doc <- doc[-concelhos_to_add_and_remove$remove_concelhos]
  doc
}

if (length(concelhos_to_add_and_remove$add_concelhos) > 0) {
  doc <- c(doc, concelhos_to_add_and_remove$add_concelhos)
  doc
}

# mask_concelho <-
#   !is.na(str_match(doc, "[[:alpha:]()\\.]$"))
# mask_casos <-
#   !is.na(str_match(doc, "^[:digit:]+$|[:digit:]\\s[:digit:]$"))
#   !is.na(str_match(doc, "^[:digit:]$|[:digit:]\\s[:digit:]$"))

# doc[mask_concelho]
# doc[mask_casos]

# fix <- doc[append(which(mask_casos), which(mask_casos) - 1)]
# fix
#
# fix_values <- str_extract(fix, "^[:digit:]+$|(?<![:alpha:]\\s)[:digit:]+$")
# fix_values
# fix_values <- fix_values[!is.na(fix_values)]
# fix_values
#
# fix_keys <- str_extract(fix, "[:alpha:]+$|(?<=[:digit:]\\s)[:alpha:]+(?=\\s[:alpha:])")
# fix_keys
# fix_keys <- fix_keys[!is.na(fix_keys)]
# fix_keys
#
# fixed <- paste(fix_keys, fix_values)
# fixed
#
# doc <- str_remove(doc, paste("", fix_keys, collapse = "|"))
# doc <- append(doc, fixed)
# doc

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
  # separate(concelho,
  #          c("concelho", "reportado_por_ARS_RA"),
  #          "\\*",
  #          convert = FALSE) %>%
  # mutate(reportado_por_ARS_RA = if_else(is.na(reportado_por_ARS_RA), as.integer(0), as.integer(1))) %>%
  # arrange(desc(n_casos), concelho)
  arrange(concelho, desc(n_casos))
# df <-
#   df %>% mutate(concelho = replace(concelho, concelho == "António", "Vila Real de Santo António")) %>%
#   arrange(desc(n_casos), concelho)
df

nrow(df)

# Assertion(s)
length(doc_pre_table) == nrow(df)
min(df$n_casos) >= MIN_NUMBER_CASES

duplicated_concelhos <-
  df %>% group_by(concelho) %>% filter(n() > 1)

if (nrow(duplicated_concelhos) > 0) {
  duplicated_concelhos
} else {
  # nrow(duplicated_concelhos) == 0
  cat("No duplicates.")
}

# Save
DATA_PATH
# write_csv(df, DATA_PATH)
