#' plot quantitative maps
#' @return a plot
#' @param tif the raster that should be plotted
#' @export
#' @examples
#' \dontrun{
#' plot_quantitative_map()
#' }

plot_quantitative_map <- function(tif){
  ggplot2::ggplot() +
    stars::geom_stars(data = stars::st_as_stars(tif)) +
    ggplot2::coord_sf(expand = FALSE) +
    rcartocolor::scale_fill_carto_c(
      palette = "Emrld",
      name = meta$units_of_data
    ) +
    ggplot2::guides(fill = ggplot2::guide_legend(label.position = "bottom",
                                                 title.position = "top")) +
    theme(legend.title = element_text(hjust = 0.5))
}
