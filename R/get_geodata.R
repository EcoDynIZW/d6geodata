#' get the processed geoadata from droppbox
#' @return the file in a folder named after the file
#' @param data_name the name of the data folder (e.g. copied from the website)
#' @param download_data do you want to download the data? Choose "TRUE" or "FALSE"
#' @export
#' @examples
#' \dontrun{
#' get_geodata()
#' }

get_geodata <- function(data_name, download_data = FALSE){
  meta <- utils::read.csv(here::here("data-proc", "meta_data_overview_proc.csv"))

  tif <- raster::raster((meta %>% dplyr::filter('folder_name' %in% data_name))$dropbox_link)

     if(download_data %in% TRUE){

       base::dir.create(path = here::here("data-raw", data_name))

       raster::writeRaster(tif, here::here(base::gsub("_tif", ".tif", data_name)))



     }

  return(tif)
}


