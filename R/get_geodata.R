#' get the processed geoadata from droppbox
#' @return the file in a folder named after the file
#' @export
#' @examples
#' \dontrun{
#' get_geodata()
#' }

get_geodata <- function(data_name, download_data){
  meta <- utils::read.csv(here::here("data-proc", "meta_data_overview_proc.csv"))

  tif <- raster::raster((meta %>% dplyr::filter(folder_name %in% data_name))$dropbox_link)

  download_data <- c("Yes", "No")[utils::menu(c("Yes", "No"), title = "Do you want to download this data?")]

     if(download_data %in% "Yes"){

       base::dir.create(path = here::here("data-raw", data_name))

       raster::writeRaster(tif, here::here(base::gsub("_tif", ".tif", data_name)))



     }

  return(tif)
}


