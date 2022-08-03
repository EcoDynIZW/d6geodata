#' plot binary maps
#' @return a plot
#' @param tif the raster that should be plotted
#' @param p_base_map base map
#' @export
#' @examples
#' \dontrun{
#' d6plot_binary_map()
#' }

plot_binary_map <- function(tif, p_base_map){
    p_base_map +
    ggplot2::scale_fill_gradient(
      low = "#f1effc",
      high = "#221462",
      breaks = as.vector(terra::minmax(tif)),
      name = NULL
    ) +
    ggplot2::guides(fill = ggplot2::guide_legend(label.position = "bottom"))
}
