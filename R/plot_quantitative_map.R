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
      name = NULL
    ) +
    ggplot2::guides(fill = ggplot2::guide_legend(label.position = "bottom"))
}
