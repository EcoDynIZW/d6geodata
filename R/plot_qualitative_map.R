#' plot qualitative maps
#' @return a plot
#' @param tif the raster that should be plotted
#' @export
#' @examples
#' \dontrun{
#' plot_qualitative_map()
#' }

plot_qualitative_map <- function(tif){

  if(length(unique(terra::values(tif))) >= 5){
    tif_df <-  dplyr::tibble(cat = tif %>% terra::values() %>% as.vector()) %>%
      dplyr::count(cat, sort = TRUE) %>%
      dplyr::mutate(cat_fct = ifelse(dplyr::row_number() > 5, 0, cat))

    tif_legend <- tif %>% terra::classify(rcl = matrix(c(tif_df$cat[-c(1:5)],
                                                  rep(0, nrow(tif_df)-5)), ncol = 2, nrow = nrow(tif_df)-5))

    tif_plot <- tif_legend

    terra::values(tif_plot) <- terra::as.factor(terra::values(tif_plot))

    ggplot2::ggplot() +
      stars::geom_stars(data = stars::st_as_stars(tif_plot)) +
      ggplot2::coord_sf(expand = FALSE) +
      rcartocolor::scale_fill_carto_d(
        palette = "Bold",
        name = NULL,
        labels = c("other", terra::sort(unique(terra::values(tif_legend))[-1,]))
      ) +
      ggplot2::guides(fill = ggplot2::guide_legend(label.position = "bottom"))
  } else{
    tif_plot <- tif
    terra::values(tif_plot) <- terra::as.factor(terra::values(tif_plot))
    return(
      ggplot2::ggplot() +
        stars::geom_stars(data = stars::st_as_stars(tif_plot)) +
        ggplot2::coord_sf(expand = FALSE) +
        rcartocolor::scale_fill_carto_d(
          palette = "Bold",
          name = NULL
        ) +
        ggplot2::guides(fill = ggplot2::guide_legend(label.position = "bottom")))
  }
}
