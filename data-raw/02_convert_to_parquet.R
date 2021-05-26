# In this script, we convert the .txt files in the "/data/" directory to 
# .parquet files to save space on disk and to leverage the speed of 
# {arrow} + {dplyr}

library(here)
library(vroom)
library(dplyr)
library(arrow)
library(fs)

# Read in the data from the .txt files appended into a single data frame, then
# write the data frame out to a single .parquet file
vroom::vroom(
  list.files(
    path = here::here("data"), 
    full.names = TRUE
  ), 
  delim = "\t"
) %>% 
  arrow::write_parquet(
    here::here("data/all_of_the_data.parquet")
  )

# Show that the .parquet file containing ALL of the data is smaller (takes up
# less space on disk) than EACH of the .txt files (which only contain half of
# the data)
fs::file_info(
  path = list.files(
    here::here("data"), 
    full.names = TRUE
  )
) %>% 
  dplyr::select(path, size) %>% 
  dplyr::mutate(
    file_type = stringr::str_extract(
      string = path, 
      pattern = "[^.]+$"   # extract text after period
    )
  ) %>% 
  dplyr::group_by(file_type) %>% 
  dplyr::summarise(
    total_size = sum(size)
  )

# Remove the .txt files once we've created the .parquet files
file.remove(
  list.files(
    path = here::here("data"), 
    full.names = TRUE, 
    pattern = ".txt$"   # file name ends with ".txt"
  )
)
