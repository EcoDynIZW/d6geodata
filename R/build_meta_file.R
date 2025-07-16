#' create meta data for new files
#' @param path The path where the data has to be stored
#' @param data_name name of the data
#' @return a tibble where you have to set the parameters by hand.
#' @export
#' @examples
#' \dontrun{
#' build_meta_file()
#' }


build_meta_file <- function(path = ".", data_name = ""){

  data <- dplyr::tibble(folder_name = NA,
                        name = NA,
                        crs = NA,
                        epsg = NA,
                        year_of_data = NA,
                        units_of_data = NA,
                        resolution = NA,
                        type_of_data = NA,
                        type_of_file = NA,
                        source = NA,
                        link_of_source = NA,
                        date_of_compile = NA,
                        copyright = NA,
                        short_description = NA,
                        modified = NA)

  doit <- "Yes"

  while(doit == "Yes"){

    data <- data %>%
      dplyr::mutate(
        folder_name = data_name,
        name = stringi::stri_replace_last_fixed(data_name, "_", "."),
        epsg = ifelse(is.na(data$epsg), fun_epsg(), data$epsg),
        year_of_data = ifelse(
          is.na(data$year_of_data),
          fun_num("year of data"),
          data$year_of_data
        ),
        units_of_data = ifelse(
          is.na(data$units_of_data),
          base::readline("units of data:"),
          data$units_of_data
        ),
        resolution = ifelse(
          is.na(data$resolution),
          base::readline("resolution:"),
          data$resolution
        ),
        type_of_data = ifelse(is.na(data$type_of_data), fun_type(), data$type_of_data),
        type_of_file = ifelse(is.na(data$type_of_file), fun_file(), data$type_of_file),
        source = ifelse(is.na(data$source), fun_source(), data$source),
        date_of_compile = as.character(Sys.Date()),
        short_description = ifelse(
          is.na(data$short_description),
          base::readline("short description:"),
          data$short_description
        ),
        modified = ifelse(
          is.na(data$modified),
          base::readline("modified?:"),
          data$modified
        )
      ) %>%
      dplyr::mutate_each(dplyr::funs(empty_as_na)) %>%
      dplyr::mutate(
        crs = suppressWarnings(sf::st_crs(as.numeric(epsg))$proj4string),
        link_of_source = ifelse(
          is.na(link_of_source),
          fun_source_link(x = source),
          'link_of_source'
        ),
        copyright = as.character(d6geodata::get_copyright(source = source,
                                                      year = lubridate::year(date_of_compile)))
      )

    doit <- c("Yes", "No")[utils::menu(c("Yes", "No"), title = "Do you want to change something?")]
  }

  utils::write.table(data, base::paste0(path, "/meta-data_", data$folder_name, ".csv"),
                   row.names = FALSE, sep = ",")
  return(data)
}

