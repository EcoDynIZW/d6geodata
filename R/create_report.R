#' function for creating a rmd file and copying it to the webpage folder
#' @param path_name name of the folder
#' @param out_path The path where the data lays
#' @export
#' @examples
#' \dontrun{
#' create_report()
#' }


create_report <-
  function(path_name, out_path){
    file <- paste0(
      "---
output:
    distill::distill_article:
        highlight: kate      ## styling of code
        code_folding: false  ## if 'true' you can expand and shrink code chunks
        toc: true            ## if 'true' adds a table of content
        toc_depth: 2         ## level to be displayed in the table of content
---

\n\n",
"```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE, message = FALSE, warning = FALSE,
dev = 'ragg_png', fig.width = 9, fig.height = 6, dpi = 250, retina = 1)

Sys.setlocale('LC_TIME', 'C')

#sapply(list('tidyverse', 'ggplot2', 'raster', 'terra'),
#       library, character.only = TRUE, logical.return = TRUE)
library(patchwork)

`%>%` <- magrittr::`%>%`

ggplot2::theme_set(ggplot2::theme_void())
ggplot2::theme_update(
  legend.position = 'top',
  legend.key.width = ggplot2::unit(3.5, 'lines'),
  legend.key.height = ggplot2::unit(.5, 'lines'),
  plot.margin = ggplot2::margin(rep(10, 4)),
  plot.title = ggplot2::element_text(hjust = .5, face = 'bold')
)
```\n\n",
    "

```{r data-impor}
path <-
    paste(d6geodata::get_dropbox_path(),'", paste0(stringi::stri_c((
      unlist(stringi::stri_split(out_path, regex = "/"))[-(1:2)]
    ), collapse = "/")), "', sep = '/')

meta <-
      utils::read.csv(list.files(path, pattern = '.csv$', recursive = TRUE, full.names = TRUE)) %>%
  dplyr::mutate(dplyr::across(dplyr::everything(), as.character))

tif <-
  terra::rast(list.files(path, pattern = '.tif$', recursive = TRUE, full.names = TRUE))


```\n\n",
    "```{r data-table}

meta_tbl <-
  meta %>%
  tidyr::pivot_longer(
    cols = dplyr::everything(),
    names_to = 'column',
    values_to = 'input'
  ) %>%
  flextable::flextable() %>%
  flextable::autofit()

```\n\n",
    "```{r map}

p_base_map <-
  ggplot2::ggplot() +
  stars::geom_stars(data = stars::st_as_stars(tif)) +
  ggplot2::coord_sf(expand = FALSE)

if(meta$type_of_data == 'binary_categorical') {
  p_map <- d6geodata::plot_binary_map(tif = tif, p_base_map = p_base_map)
  }

if(meta$type_of_data %in% c('continual_numeric', 'discrete_numeric')) {
  p_map <- d6geodata::plot_quantitative_map(tif = tif, p_base_map = p_base_map)
}

if(meta$type_of_data %in% c('unordered_categorical', 'ordered_categorical')) {
  p_map <- d6geodata::plot_qualitative_map(tif = tif, p_base_map = p_base_map)
}

```\n\n",
"```{r table}
p_table <-
  ggplot2::ggplot() +
  ggplot2::annotation_custom(
    grob = grid::rasterGrob(meta_tbl %>% flextable::as_raster()),
    xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf
  )
```\n\n",
"```{r plot, layout='l-screen'}
p_map + p_table + plot_annotation(title = meta$folder_name)
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
writeLines(file,
           paste0(d6geodata::get_user_path(),
                  "/Documents/GitHub/d6geodatabase/",path_name, ".rmd"))
  }
