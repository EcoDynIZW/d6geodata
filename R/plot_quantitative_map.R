#' plot quantitative maps
#' @return a plot
#' @param tif the raster that should be plotted
#' @param p_base_map base map
#' @export
#' @examples
#' \dontrun{
#' plot_quantitative_map()
#' }

plot_quantitative_map <- function(tif, p_base_map){
  p_base_map +
    rcartocolor::scale_fill_carto_c(
      palette = "Emrld",
      name = NULL
    ) +
    ggplot2::guides(fill = ggplot2::guide_colorbar(label.position = "bottom"))
}
