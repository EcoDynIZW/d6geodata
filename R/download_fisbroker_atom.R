#' Download data from fisbroker
#' @param zip_link the atom url of the data from fisbroker.
#' @param name name of the folder where the data should be stored. If dolder does not exist the folder will be created
#' @param path path where it has to be stored
#' @return A folder with the data as a geopackage.
#' @export
#' @examples
#' \dontrun{
#' download_fisbroker_atom()
#' }

#### Function
download_fisbroker_atom <- function(zip_link, path ,name){
  temp <- tempfile()
  download.file(zip_link, temp, method = "auto", quiet = FALSE)
  unzip(temp, exdir = paste(path, name, sep = "/"))

  # you have to set the crs because it is missing sometimes. The default epsg on fisbroker is 25833
  ras <- raster(list.files(paste(path, name, sep = "/"),
                                    pattern = ".tif$", full.names = TRUE)[1], crs = "+proj=utm +zone=33 +ellps=GRS80 +units=m +no_defs")
  return(ras)
}

