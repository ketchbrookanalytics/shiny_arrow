
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {shiny} + {arrow} in R: A Use Case by Ketchbrook Analytics

<!-- badges: start -->
<!-- badges: end -->

Shiny apps are an incredible tool for bringing data science to life,
communicating your work with non-technical stakeholders, or allowing
self-service data exploration for an audience. One of the tricky parts
about managing shiny apps is keeping them from taking up a lot of space
on the server they are deployed on, especially when it is necessary to
include the data as part of the app (as opposed to querying an external
database).

As your data becomes *“big”*, moving from traditional record-oriented
file types (e.g., *.csv*, *.txt*, etc.) to more modern column-oriented
file types (*.parquet*) can drastically reduce the size of the file
containing your data. This is where the [{arrow}]() package can help.

The **{arrow}** package provides two major benefits:

1.  It has the ability to read & write *.parquet* files (among other
    file types)
2.  You can query the data in that file *before* bringing it into an R
    data frame, using **{dplyr}** verbs, which provides for dramatic
    speed improvements

This repository contains an [example shiny app](app.R) demonstrating how
to accomplish this. This app is also [live on
shinyapps.io](https://ketchbrookanalytics.shinyapps.io/shiny_arrow/).

## Installation

Perform the following steps to get the shiny app up & running on your
desktop:

1.  Install the [{renv}
    package](https://rstudio.github.io/renv/articles/renv.html) by
    running `install.packages("renv")` in the R console
2.  Clone this repository to your desktop
3.  Open the **shiny\_arrow.Rproj** file from the directory on your
    local machine where you cloned this repository
4.  Run `renv::restore()` to install the package dependencies needed to
    run this app successfully
5.  Run the scripts in the [data-raw](data-raw) directory to generate
    the mock data
6.  Open the [app.R](app.R) file and execute the code in that script to
    launch the app

------------------------------------------------------------------------

## Session Info

``` r
sessionInfo()
#> R version 4.0.3 (2020-10-10)
#> Platform: x86_64-w64-mingw32/x64 (64-bit)
#> Running under: Windows 10 x64 (build 19042)
#> 
#> Matrix products: default
#> 
#> locale:
#> [1] LC_COLLATE=English_United States.1252 
#> [2] LC_CTYPE=English_United States.1252   
#> [3] LC_MONETARY=English_United States.1252
#> [4] LC_NUMERIC=C                          
#> [5] LC_TIME=English_United States.1252    
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices datasets  utils     methods   base     
#> 
#> loaded via a namespace (and not attached):
#>  [1] compiler_4.0.3    magrittr_2.0.1    htmltools_0.5.1.1 tools_4.0.3      
#>  [5] yaml_2.2.1        stringi_1.5.3     rmarkdown_2.8     knitr_1.33       
#>  [9] stringr_1.4.0     xfun_0.23         digest_0.6.27     rlang_0.4.11     
#> [13] renv_0.12.5       evaluate_0.14
```
