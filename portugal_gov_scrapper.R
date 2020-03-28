# Source
#
# Author: Governo da República Portuguesa: Administração Interna
# Title: Balanço das atividades do SEF e da GNR nas fronteiras terrestres
# URL: https://www.portugal.gov.pt/pt/gc22/comunicacao/comunicado?i=balanco-das-atividades-do-sef-e-da-gnr-nas-fronteiras-terrestres
# Accessed: 2020-03-28

library(tidyverse)
library(rvest)
library(stringr)

URL <-
  "https://www.portugal.gov.pt/pt/gc22/comunicacao/comunicado?i=balanco-das-atividades-do-sef-e-da-gnr-nas-fronteiras-terrestres"

page <- read_html(URL)
page

publication_date <- page %>%
  html_node(".time") %>%
  html_text()
publication_date <- unlist(strsplit(trimws(publication_date), " "))[1]
publication_date

DATA_FOLDER_NAME <- "data-sef-gnr"
DATA_NAME <- paste(publication_date, "csv", sep = ".")
DATA_PATH <- file.path(DATA_FOLDER_NAME, DATA_NAME)

text <- page %>%
  html_node(".gov-texts") %>%
  html_text()
text <- trimws(text)

text
nchar(text)

regex_ppa <-
  "[:alpha:][[:alpha:][:space:]]+\\,[:space:][[:alpha:][:space:]]+[:space:]\\–[:space:][[:digit:]\\.]+"
regex_total <- "(?<=total de )[[:digit:]\\.]+"
regex_total_impedidos <- "[[:digit:]\\.]+(?= foram impedidos)"
regex_ppa_impedidos <-
  "[:upper:][[:alpha:][:space:]]+[:space:]\\([[:digit:]\\.]+\\)"

str_to_int <- function(string, big.mark = ".") {
  reg_big_mark <- paste("\\", big.mark, sep = "")
  reg <- paste(reg_big_mark, "\\(", "\\)", sep = "|")
  
  int <- gsub(reg, "", string)
  
  return(as.integer(int))
}

total <- str_to_int(str_extract(text, regex_total))
total

total_impedidos <-
  str_to_int(str_extract(text, regex_total_impedidos))
total_impedidos

# PPA -> Ponto de Passagem Autorizado
ppa_data <- unlist(str_extract_all(text, regex_ppa))
ppa_data

impedidos_data <- unlist(str_extract_all(text, regex_ppa_impedidos))
impedidos_data

df_impedidos <-
  enframe(impedidos_data, name = NULL) %>%
  separate(value,
           c("ppa", "n_cidadaos_impedidos_entrar"),
           "[:space:]\\(") %>%
  mutate(n_cidadaos_impedidos_entrar = str_to_int(n_cidadaos_impedidos_entrar))
df_impedidos

df <-
  enframe(ppa_data, name = NULL) %>%
  separate(value,
           c("ppa", "n_cidadaos_controlados"),
           "[:space:]\\–[:space:]") %>%
  mutate(n_cidadaos_controlados = str_to_int(n_cidadaos_controlados)) %>%
  separate(ppa, c("ppa_1", "ppa_2"), "\\,[:space:]") %>%
  arrange(desc(n_cidadaos_controlados), ppa_1, ppa_2)
df

df <- df %>% full_join(df_impedidos, by = c("ppa_1" = "ppa"))
df

sum(df$n_cidadaos_controlados) == total
sum(df$n_cidadaos_impedidos_entrar) == total_impedidos

round((total_impedidos / total) * 100, 2)

DATA_PATH
# write_csv(df, DATA_PATH)
