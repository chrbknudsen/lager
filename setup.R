# nulstil transaktionsdatabasen
library(tidyverse)

tribble(~timestamp,~hvad,~antal,~storrelse,~lokation,~kategori, ~tags, ~note) %>% 
  write_rds("data/transaktioner.rds")



# Hvad ellers på todolisten
# 
# Har vi de rigtige felter? det tror vi
# Tilføje nulstil tilføj efter tilføj knap trykket
# Hvordan select box med alternativ tekst box
# populer relevante selectboxes
# mulighed for at vælge mere end en tag
# Får udtag til at fungere.
# - udvælgelse af muligheder
