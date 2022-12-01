#' function for getting license of the data
#' @param source source name
#' @param year year of downloaded data
#' @return a character string with the respective license for citation
#' @export
#' @examples
#' \dontrun{
#' render_geodata()
#' }

get_license <- function(source, year = lubridate::year(Sys.Date())){
  if(source %in% "bkg"){
    return(paste0("© GeoBasis-DE / BKG (", year,")"))
    }
  if(source %in% "copernicus"){
    return(paste0("© European Union, Copernicus Land Monitoring Service ", year, ", European Environment Agency (EEA)"))
  }
  if(source %in% "fisbroker"){
    return(paste0("Amt für Statistik Berlin-Brandenburg ", year))
  }
  if(source %in% "usgs"){
    return(pasteo("go on https://www.usgs.gov/centers/eros/data-citation and cite by specific product"))
  }
  if(source %in% "other"){
    return(base::readline("enter license:"))
  }
}
