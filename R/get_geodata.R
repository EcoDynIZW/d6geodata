#' get geoadata from PopDynCloud
#'
#' If you run geo_overview() first you can see wich data is available.
#' From there you can copy the name of the file and paste in 'data_name'.
#' Works for vector data and raster data.
#'
#'
#' @return the file in a folder named after the file
#' @param data_name the name of the data folder (e.g. copied from the website)
#' @param download_data do you want to download the data? Choose "TRUE" or "FALSE"
#' @param path_to_cloud set the path where your cloud is located. Like "E:/PopDynCloud"
#' @export
#' @examples
#' \dontrun{
#' get_geodata_cloud()
#' }

get_geodata_cloud <-
  function(data_name, path_to_cloud, download_data = FALSE) {
    geo_path <- paste(
      path_to_cloud,
      "Geodata",
      paste0(ifelse(dir.exists(
        paste(
          path_to_cloud,
          "Geodata",
          "data-raw",
          stringi::stri_c(unlist(
            stringi::stri_split(data_name, regex = "_")
          )[2]), data_name, sep = "/")) == T, "data-raw", "data-proc")),
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

    if(utils::tail(unlist(stringr::str_split(data_name, "_")), n = 1) %in% c("gpkg", "shp")){

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
      if(!base::dir.exists(paths = here::here("data-raw", data_name))){
        base::dir.create(path = here::here("data-raw", data_name),
                         showWarnings = TRUE,
                         recursive = TRUE)}

      base::file.copy(
        from = c(
          paste0(geo_path, "/", data_name, ".rmd"),
          paste0(geo_path, "/meta-data_", data_name, ".csv"),
          paste0(
            geo_path,
            "/",
            stringi::stri_replace_last_fixed(data_name, "_", ".")
          )
        ),
        to = c(
          paste0(here::here("data-raw", data_name), "/", data_name, ".rmd"),
          paste0(
            here::here("data-raw", data_name),
            "/meta-data_",
            data_name,
            ".csv"
          ),
          paste0(
            here::here("data-raw", data_name),
            "/",
            stringi::stri_replace_last_fixed(data_name, "_", ".")
          )
        )
      )

    }

    return(data)
  }


