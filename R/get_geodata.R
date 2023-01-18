#' get the processed geoadata from droppbox
#' @return the file in a folder named after the file
#' @param data_name the name of the data folder (e.g. copied from the website)
#' @param download_data do you want to download the data? Choose "TRUE" or "FALSE"
#' @param path_to_cloud set the path where your cloud is located. Like "E:/PopDynCloud"
#' @export
#' @examples
#' \dontrun{
#' get_geodata()
#' }

get_geodata <-
  function(data_name, path_to_cloud, download_data = FALSE) {
    geo_path <- paste(
      path_to_cloud,
      "Geodata",
      c("data-raw", "data-proc")[utils::menu(c("raw", "processed"), title = "Raw or processed data?")],
      stringi::stri_c(unlist(
        stringi::stri_split(data_name, regex = "_")
      )[2]),
      data_name,
      sep = "/")

    if(utils::tail(unlist(stringr::str_split(data_name, "_")), n = 1) %in% c("tif", "asc")){

      data <-
        terra::rast(
          paste(
            geo_path,
            stringi::stri_replace_last_fixed(data_name, "_", "."),
            sep = "/"
          )
        )
    }

    if(utils::tail(unlist(stringr::str_split(data_name, "_")), n = 1) %in% "gpkg"){

      data <-
        sf::st_read(
          paste(
            geo_path,
            stringi::stri_replace_last_fixed(data_name, "_", "."),
            sep = "/"
          )
        )
    }



    if (download_data %in% TRUE) {
      dir.create(here::here("data-raw", data_name))

base::file.copy(from = geo_path,
to = here::here("data-raw"),
recursive = TRUE)

  }

    return(data)
    }


