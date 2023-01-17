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
    tif <-
      terra::rast(
        paste(
          path_to_cloud,
          "Geodata",
          "data-proc",
          stringi::stri_c(unlist(
            stringi::stri_split(data_name, regex = "_")
          )[2]),
          data_name,
          stringi::stri_replace_last_fixed(data_name, "_", "."),
          sep = "/"
        )
      )

    if (download_data %in% TRUE) {
      dir.create(here::here("data-raw", data_name))

base::file.copy(from = paste(
  path_to_cloud,
  "Geodata",
  "data-proc",
  stringi::stri_c(unlist(stringi::stri_split(data_name, regex = "_"))[2]),
  data_name,
  sep = "/"
),
to = here::here("data-raw"),
recursive = TRUE)

  }

    return(tif)
    }


