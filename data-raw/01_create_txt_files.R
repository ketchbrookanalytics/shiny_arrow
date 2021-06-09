# In this script we create two large data frames which are then written out to
# separate .txt files

library(dplyr)
library(here)
library(fs)


# Create Data Frames ------------------------------------------------------

# Create 1,000 unique alphanumeric combinations to be used to filter the data by
lookup_codes <- paste0(
  sample(LETTERS, 1000, replace = TRUE), 
  sample(1:9, 1000, replace = TRUE), 
  sample(LETTERS, 1000, replace = TRUE), 
  sample(1:1000)
)

# Create first 3MM row x 10 column data frame 
df_1 <- matrix(
  data = runif(
    n = 1000000 * 10, 
    min = 1, 
    max = 100
  ), 
  nrow = 1000000, 
  ncol = 10
) %>% 
  as.data.frame() %>% 
  dplyr::mutate(
    Item_Code = sample(
      lookup_codes, 
      size = 1000000, 
      replace = TRUE
    )
  )

df_2 <- matrix(
  data = rnorm(
 # Create second 3MM row x 10 column data frame 
   n = 1000000 * 10, 
    mean = 50, 
    sd = 20
  ), 
  nrow = 1000000, 
  ncol = 10
) %>% 
  as.data.frame() %>% 
  dplyr::mutate(
    Item_Code = sample(
      lookup_codes, 
      size = 1000000, 
      replace = TRUE
    )
  )

# Change the column names for each data frame to "Variable_A", "Variable_B", ...
colnames(df_1)[1:10] <- paste0("Variable_", LETTERS[1:10])
colnames(df_2)[1:10] <- paste0("Variable_", LETTERS[1:10])


# Write Out to File -------------------------------------------------------

# Create a directory called "/data/" at the project root (if it does not already 
# exist)
fs::dir_create(here::here("data"))

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
