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
  file_in <- c("bkg", "fisbroker", "fisbroker - Umweltatlas", "copernicus", "usgs", "osm", "metaver", "other")[utils::menu(c("bkg", "fisbroker", "fisbroker - Umweltatlas", "copernicus", "usgs", "osm", "metaver", "other"), title = "choose source:")]
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
             x == "fisbroker - Umweltatlas",
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
  )
}

#' function for getting copyright of the data
#' @param source source name
#' @param year year of downloaded data
#' @return a character string with the respective license for citation
#' @export
#' @examples
#' \dontrun{
#' get_copyright()
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
  if(source %in% "fisbroker - Umweltatlas"){
    return(paste0("Umweltatlas Berlin / ", base::readline("enter original Name:")))
  }
  if(source %in% "usgs"){
    return(base::readline("go on https://www.usgs.gov/centers/eros/data-citation and cite by specific product:"))
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

