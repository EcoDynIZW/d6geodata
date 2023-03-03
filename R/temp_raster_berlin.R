#' get template raster for Berlin
#' @return a template spatRaster
#' @param resolution resolution in meters
#' @export
#' @examples
#' \dontrun{
#' temp_rast(resolution)
#' }

temp_ras <- function(resolution){
  terra::rast(
    crs = sf::st_crs(3035)$proj4string,
    extent = c(4531040, 4576740, 3253790, 3290790),
    resolution = resolution,
    vals = NA,
    names = "temp"
  )
}
