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
        crs = suppressWarnings(sf::st_crs(as.numeric('epsg'))$proj4string),
        link_of_source = ifelse(
          is.na('link_of_source'),
          fun_source_link(x = source),
          'link_of_source'
        ),
        copyright = as.character(d6geodata::get_copyright(source = source,
                                                      year = lubridate::year('date_of_compile')))
      )

    doit <- c("Yes", "No")[utils::menu(c("Yes", "No"), title = "Do you want to change something?")]
  }

  utils::write.table(data, base::paste0(path, "/meta-data_", data$folder_name, ".csv"),
                   row.names = FALSE, sep = ",")
  return(data)
}

#' function for dates
#' @param x input
#' @return returns a date
#' @examples
#' \dontrun{
#' fun_date("2017-01-01")
#' }

# function for dates
fun_date <- function(x){
  date_in <- paste(base::readline(base::paste0("enter year ", x,": ")),
                   base::readline(base::paste0("enter month ", x,": ")),
                   base::readline(base::paste0("enter day ", x,": ")),
                   sep = "-")
  return(date_in)
}


#' function for numeric
#' @param x input
#' @return returns a number
#' @examples
#' \dontrun{
#' fun_date("1")
#' }

# function for numeric
fun_num <- function(x){
  num_in <- base::readline(paste0(x, ": "))
  while(is.na(suppressWarnings(base::as.numeric(num_in)))){
    print("wrong format. Enter a numeric value")
    num_in <- base::readline(paste0(x, ": "))
  }
  return(num_in)
}

#' function for empty cols
#' @param x input
#' @return if x is "" then it will be converted to NA
#' @examples
#' \dontrun{
#' fun_date("")
#' }

# function for empty cols
empty_as_na <- function(x){
  base::ifelse(base::as.character(x)!="", x, NA)
}

#' function for epsg code
#' @return choose an epsg code or add a costum
#' @examples
#' \dontrun{
#' fun_epsg()
#' }

# function for epsg code
fun_epsg <- function(){
  epsg_in <- c("4326", "3035", "25833", "other")[utils::menu(c("4326", "3035", "25833", "other"), title = "choose epsg?")]
  if(epsg_in %in% "other"){
    epsg_in <- base::readline("enter epsg code: ")
    while(is.na(suppressWarnings(base::as.numeric(epsg_in)))){
      print("wrong format. Enter a numeric value")
      epsg_in <- base::readline("enter epsg code: ")
    }
  }
  return(epsg_in)
}

# function for type of data
fun_type <- function(){
  file_in <-
    c(
      "unordered_categorical",
      "ordered_categorical",
      "binary_categorical",
      "continuous_numeric",
      "discrete_numeric"
    )[utils::menu(
      c(
        "unordered_categorical",
        "ordered_categorical",
        "binary_categorical",
        "continuous_numeric",
        "discrete_numeric"
      ),
      title = "choose file type:"
    )]
  return(file_in)
}

# function for type of file
fun_file <- function(){
  file_in <- c(".asc", ".tif", ".shp", ".gpkg", ".geojson", "other")[utils::menu(c(".asc", ".tif", ".shp", ".gpkg", ".geojson", "other"), title = "choose file ending:")]
  if(file_in %in% "other"){
    file_in <- base::readline("enter file ending:")
  }
  return(file_in)
}


# function for source
fun_source <- function(){
  file_in <- c("bkg", "fisbroker", "copernicus", "usgs", "osm", "metaver", "other")[utils::menu(c("bkg", "fisbroker", "copernicus", "usgs", "osm", "metaver", "other"), title = "choose source:")]
  if(file_in %in% "other"){
    file_in <- base::readline("enter source:")
  }
  return(file_in)
}

# function for source link
fun_source_link <- function(x) {
  ifelse(x == "bkg",
         "https://gdz.bkg.bund.de",
         ifelse(
           x == "fisbroker",
           "https://stadtentwicklung.berlin.de/geoinformation/fis-broker/",
           ifelse(
             x == "copernicus",
             "https://land.copernicus.eu/",
             ifelse(
               x == "usgs",
               "https://www.usgs.gov/",
               ifelse(
                 x == "osm",
                 "https://download.geofabrik.de/",
                 ifelse(
                   x == "metaver",
                   "https://metaver.de/trefferanzeige?docuuid=B57B9F35-AFFF-49F2-BA32-618D1A1CD412#detail_overview",
               base::readline("enter source link:")
               )
               )
             )
           )
         )
         )
}

#' function for getting copyright of the data
#' @param source source name
#' @param year year of downloaded data
#' @return a character string with the respective license for citation
#' @export
#' @examples
#' \dontrun{
#' render_geodata()
#' }

get_copyright <- function(source, year = lubridate::year(Sys.Date())){
  if(source %in% "bkg"){
    return(paste0("\u00A9 GeoBasis-DE / BKG (", year,")"))
  }
  if(source %in% "copernicus"){
    return(paste0("\u00A9 European Union, Copernicus Land Monitoring Service ", year, ", European Environment Agency (EEA)"))
  }
  if(source %in% "fisbroker"){
    return(paste0("Amt für Statistik Berlin-Brandenburg ", year))
  }
  if(source %in% "usgs"){
    return(paste0("go on https://www.usgs.gov/centers/eros/data-citation and cite by specific product"))
  }
  if(source %in% "osm"){
    return(paste0("Data/Maps Copyright 2018 Geofabrik GmbH and OpenStreetMap Contributors"))
  }
  if(source %in% "metaver"){
    return(paste0("\u00A9 Landesbetrieb Geoinformation und Vermessung. Alle Rechte vorbehalten."))
  }
  else{
    return(base::readline("enter license:"))
  }
}

