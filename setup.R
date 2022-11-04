library(tidyverse)

tribble(~timestamp,~hvad,~maengde,~udloeb,~hvor,) %>% 
  write_csv("data/transaktioner.csv")


data <- read_csv("data/transaktioner.csv")
ncol(data)
