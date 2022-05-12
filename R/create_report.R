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
      file <- paste(
        "---
output:
    distill::distill_article:
        highlight: kate      ## styling of code
        code_folding: false  ## if 'true' you can expand and shrink code chunks
        toc: true            ## if 'true' adds a table of content
        toc_depth: 2         ## level to be displayed in the table of content
---

",
        "```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE,
dev = 'ragg_png', fig.width = 9, fig.height = 6, dpi = 600, retina = 1)
Sys.setlocale('LC_TIME', 'C')
```\n\n",
        "```{r packages, echo = FALSE, warning=FALSE, message=FALSE, include = FALSE}
sapply(list('tidyverse', 'here', 'ggplot2', 'raster', 'terra', 'cowplot'),
       library, character.only = TRUE, logical.return = TRUE)
```",
        "

```{r, include = FALSE}
path <- ",paste0('"', paste(out_path, sep = "/"), '"'),"

meta_raw <- utils::read.csv2(list.files(path, pattern = '.csv$', recursive = TRUE, full.names = TRUE))

meta_tab <- meta_raw %>%
  dplyr::mutate(dplyr::across(dplyr::everything(), as.character)) %>%
      tidyr::pivot_longer(cols = dplyr::everything(),
                          names_to = 'column', values_to = 'input') %>%
  flextable::flextable() %>% flextable::autofit()

tif <- raster::raster(list.files(path, pattern = '.tif$', recursive = TRUE, full.names = TRUE))


```\n\n",
        "```{r, layout='l-body-outset', echo = FALSE, warning=FALSE, message=FALSE}

text_plot <- ggplot2::ggplot() +
  ggplot2::theme_void() +
  ggplot2::annotation_custom(
grid::rasterGrob(meta_tab %>% flextable::as_raster()), xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf)

title <- ggdraw() +
  draw_label(
    meta_raw$folder_name,
    fontface = 'bold',
    x = 0,
    hjust = 0
  ) +
  theme(
    plot.margin = margin(0, 0, -180, 7)
  )

tif_plot <- ggplot2::ggplot() +
  stars::geom_stars(data = stars::st_as_stars(tif)) +
    scale_fill_continuous(low=grey(0), # here you can set another color palette
                          high=grey(1),
                          guide='colorbar',
                          na.value='transparent',
                          name = '') +
  ggplot2::theme_void()


plot_grid(
  title, cowplot::plot_grid(tif_plot, text_plot,
                   nrow = 1, ncol = 2,
                   rel_heights = c(0.8, 1) ),
  ncol = 1,
  # rel_heights values control vertical title margins
  rel_heights = c(0.1, 1)
)

```\n\n",
      "***

<details><summary>Session Info</summary>

```{r sessionInfo}
## DO NOT REMOVE!
## We store the settings of your computer and the current versions of the
## packages used to allow for reproducibility
Sys.time()
#git2r::repository() ## uncomment if you are using GitHub
sessionInfo()
```

</details>"
      , sep = "\n")
writeLines(file,
           paste0("C:/Users/wenzler/Documents/GitHub/d6geodatabase/",path_name, ".rmd"))
    }
