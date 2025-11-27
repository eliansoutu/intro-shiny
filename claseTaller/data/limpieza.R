library(tidyverse)

#Cargo datos
data_sq <- read_csv("claseTaller/data/API_AG.LND.FRST.K2_DS2_en_csv_v2_5867.csv",skip = 3)
data_porc <- read_csv("claseTaller/data/API_AG.LND.FRST.ZS_DS2_en_csv_v2_269003.csv", skip = 3)

#Cargo metadata para agregar region
meta <- read_csv("claseTaller/data/Metadata_Country_API_AG.LND.FRST.K2_DS2_en_csv_v2_5867.csv") %>% 
  select(1, 2) %>% 
  janitor::clean_names()

#Limpiamos datos
data_porc <- data_porc %>% 
  janitor::clean_names() %>% 
  pivot_longer(x1960:x2023, names_to = "anio", values_to = "valor") %>% 
  drop_na(valor) %>% 
  select(-c(indicator_code, x2024,x70)) %>% 
  mutate(anio = parse_number(anio),
         indicator_name = "Cobertura")

data_sq <- data_sq %>% 
  janitor::clean_names() %>% 
  pivot_longer(x1960:x2023, names_to = "anio", values_to = "valor") %>% 
  drop_na(valor) %>% 
  select(-c(indicator_code, x2024,x70)) %>% 
  mutate(anio = parse_number(anio),
         indicator_name = "Superficie")

#Unimos bases y nos quedamos solo con registros de países
data_join <- bind_rows(data_sq, data_porc) %>% 
  left_join(meta) %>% 
  drop_na(region)


write_csv(data_join, "data_shiny.csv")
