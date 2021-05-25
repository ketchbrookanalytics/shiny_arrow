# In this script we create two large data frames which are then written out to
# separate .txt files

library(dplyr)
library(here)


# Create Data Frames ------------------------------------------------------

# Create first 3MM row x 26 column data frame 
df_1 <- matrix(
  data = runif(
    n = 1000000 * 26, 
    min = 1, 
    max = 100
  ), 
  nrow = 1000000, 
  ncol = 26
) %>% 
  as.data.frame()

# Create second 3MM row x 26 column data frame 
df_2 <- matrix(
  data = rnorm(
    n = 1000000 * 26, 
    mean = 50, 
    sd = 20
  ), 
  nrow = 1000000, 
  ncol = 26
) %>% 
  as.data.frame()

# Change the column names for each data frame to "Variable_A", "Variable_B", ...
colnames(df_1) <- paste0("Variable_", LETTERS)
colnames(df_2) <- paste0("Variable_", LETTERS)


# Write Out to File -------------------------------------------------------

# Write first data frame out to tab-delimited .txt file
write.table(
  x = df_1, 
  file = here::here("data/half_of_the_data.txt"), 
  sep = "\t", 
  row.names = FALSE
)

# Write second data frame out to tab-delimited .txt file
write.table(
  x = df_2, 
  file = here::here("data/the_other_half_of_the_data.txt"), 
  sep = "\t", 
  row.names = FALSE
)


