#' create name of data files
#' @return a data name in a given format
#' @export
#' @examples
#' \dontrun{
#' data_name()
#' }

data_name <- function(){
  base::paste(base::gsub(" ", "-", base::readline("name of data:")),
        base::readline("country/region:"),
        base::readline("year:"),
        base::readline("resolution:"),
        fun_l_epsg(),
        base::readline("file_type:"),
        sep = "_")
}



# function for length of epsg
fun_l_epsg <- function(){
  epsg_in <- base::readline("epsg:")
  if(suppressWarnings(base::nchar(epsg_in) < 5)){
    epsg_in <- paste0("0", epsg_in)
  }
  return(epsg_in)
}
