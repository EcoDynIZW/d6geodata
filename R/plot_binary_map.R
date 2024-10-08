#' plot binary maps
#' @return a plot
#' @param tif the raster that should be plotted
#' @export
#' @examples
#' \dontrun{
#' plot_binary_map()
#' }

plot_binary_map <- function(tif){
  ggplot2::ggplot() +
    stars::geom_stars(data = stars::st_as_stars(tif)) +
    ggplot2::coord_sf(expand = FALSE) +
    ggplot2::scale_fill_gradient(
      low = "#f1effc",
      high = "#221462",
      breaks = as.vector(terra::minmax(tif)),
      name = meta$units_of_data,
      na.value = "grey90"
    ) +
    ggplot2::guides(fill = ggplot2::guide_legend(label.position = "bottom",
                                                 title.position = "top")) +
    theme(legend.title = element_text(hjust = 0.5))
}
