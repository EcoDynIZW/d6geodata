#' function for creating a rmd file and copying it to the webpage folder
#' @param path_name name of the folder
#' @param out_path The path where the data lays
#' @param cats add categories that will show up after render
#' @export
#' @examples
#' \dontrun{
#' create_report()
#' }


create_report <-
  function(path_name, out_path, cats){
    file <- paste0(
"---
title: '",paste0(stringi::stri_c(unlist(stringi::stri_split(path_name, regex = "_"))[1:3], collapse =  " ")),"'
categories:
",stringi::stri_c("  - ", cats, collapse = "\n"),"
author:
  - name: Moritz Wenzler-Meya

    affiliation: IZW Berlin
    affiliation_url: https://ecodynizw.github.io/EcoDynIZW
date: '",Sys.Date(),"'
output:
  distill::distill_article:
    self_contained: false
    toc: true
---

\n\n",
"```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE, message = FALSE, warning = FALSE,
dev = 'ragg_png', fig.width = 9, fig.height = 6, dpi = 250, retina = 1)

Sys.setlocale('LC_TIME', 'C')

library(patchwork)

`%>%` <- magrittr::`%>%`

ggplot2::theme_set(ggplot2::theme_void())
ggplot2::theme_update(
  legend.position = 'bottom',
  legend.key.width = ggplot2::unit(3.5, 'lines'),
  legend.key.height = ggplot2::unit(.5, 'lines'),
  plot.margin = ggplot2::margin(rep(10, 4)),
  plot.title = ggplot2::element_text(hjust = .5, face = 'bold')
)
```\n\n",
    "

```{r data-impor}

# get path
path <-
    paste0(ifelse(dir.exists('T:/wenzler') == T, 'T:/wenzler',
    ifelse(dir.exists('C:/PopDynCloud') == T, 'C:/PopDynCloud', 'E:/PopDynCloud')),  '/',  '",out_path,"')

meta <-
      utils::read.csv(list.files(path, pattern = '.csv$', recursive = TRUE, full.names = TRUE)) %>%
  dplyr::mutate(dplyr::across(dplyr::everything(), as.character))

```\n\n",
    "```{r data-table}
meta_gt <- gt::gt(meta %>%
  tidyr::pivot_longer(
    cols = dplyr::everything(),
    names_to = 'column',
    values_to = 'input'
  ))
```\n\n",
    "```{r map}
p_map <-
 readRDS(paste0(ifelse(dir.exists('T:/wenzler') == T, 'T:/wenzler',
    ifelse(dir.exists('C:/PopDynCloud') == T, 'C:/PopDynCloud', 'E:/PopDynCloud')),  '/',  '",out_path, '/', path_name ,"' ,'.rds'))

```\n\n",

"```{r plot, layout='l-screen'}
p_map
meta_gt
```


<details><summary>Session Info</summary>

```{r sessionInfo}
## DO NOT REMOVE!
## We store the settings of your computer and the current versions of the
## packages used to allow for reproducibility
Sys.time()
#git2r::repository() ## uncomment if you are using GitHub
sessionInfo()
```

</details>")
if(!dir.exists(paste0(d6geodata::get_user_path(),
                     "/Documents/GitHub/EcoDynIZW.github.io/_posts_geodata/", path_name)) == TRUE){
  dir.create(paste0(d6geodata::get_user_path(),
                    "/Documents/GitHub/EcoDynIZW.github.io/_posts_geodata/", path_name))
}
writeLines(file,
           paste0(d6geodata::get_user_path(),
                  "/Documents/GitHub/EcoDynIZW.github.io/_posts_geodata/", path_name, "/", path_name, ".rmd"))
  }
