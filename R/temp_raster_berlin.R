#' Get template raster for Berlin. This can be used to rasterize vecotr data within Berlin borders.
#' This is made by using the copernicus database rasters as template.
#'
#' @return a template spatRaster
#'
#' @param resolution resolution in meters, default 10 meters
#'
#' @export
#' @examples
#' \dontrun{
#' temp_rast(resolution = 10)
#' }

temp_ras <- function(resolution = 10){
  terra::rast(
    crs = sf::st_crs(3035)$proj4string,
    extent = c(4531040, 4576740, 3253790, 3290790),
    resolution = resolution,
    vals = NA,
    names = "temp"
  )
}
