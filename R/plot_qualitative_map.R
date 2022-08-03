#' plot qualitative maps
#' @return a plot
#' @param tif the raster that should be plotted
#' @param p_base_map base map
#' @export
#' @examples
#' \dontrun{
#' plot_qualitative_map()
#' }

plot_qualitative_map <- function(tif, p_base_map){
  p_base_map +
    rcartocolor::scale_fill_carto_c(
      palette = "Bold",
      breaks = as.vector(terra::minmax(tif))[1]:as.vector(terra::minmax(tif))[2],
      name = NULL
    ) +
    ggplot2::guides(fill = ggplot2::guide_legend(label.position = "bottom"))
}
