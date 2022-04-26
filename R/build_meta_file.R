#' create meta data for new files
#' @param path The path where the data has to be stored
#' @return a tibble where you have to set the parameters by hand.
#' @export
#' @examples
#' \dontrun{
#' build_meta_file()
#' }


build_meta_file <- function(path = "."){

  data <- dplyr::tibble(folder_name = NA,
                        name = NA,
                        crs = NA,
                        epsg = NA,
                        year_of_data = NA,
                        units_of_data = NA,
                        type_of_data = NA,
                        source = NA,
                        link_of_source = NA,
                        date_of_download = NA,
                        short_description = NA,
                        modified = NA)

  doit <- "Yes"

  while(doit == "Yes"){

    data <- data %>%
      dplyr::mutate(
        folder_name = ifelse(is.na(data$folder_name), base::readline("folder name:"), data$folder_name),
        name = ifelse(is.na(data$name), base::readline("name of data:"), data$name),
        crs = ifelse(is.na(data$crs), base::readline("projection name:"), data$crs),
        epsg = ifelse(is.na(data$epsg), fun_epsg(), data$epsg),
        year_of_data = ifelse(is.na(data$year_of_data), fun_num("year of data"), data$year_of_data),
        type_of_data = ifelse(is.na(data$type_of_data), base::readline("type of data:"), data$type_of_data),
        units_of_data = ifelse(is.na(data$units_of_data), base::readline("units of data:"), data$units_of_data),
        source = ifelse(is.na(data$source), base::readline("source of data:"), data$source),
        link_of_source = ifelse(is.na(data$link_of_source), base::readline("link to source:"), data$link_of_source),
        date_of_download = ifelse(is.na(data$date_of_download), fun_date(""), data$date_of_download),
        short_description = ifelse(is.na(data$short_description), base::readline("short description:"), data$short_description),
        modified = ifelse(is.na(data$modified), base::readline("modified?:"), data$modified)
      ) %>%
      dplyr::mutate_each(dplyr::funs(empty_as_na))

    doit <- c("Yes", "No")[utils::menu(c("Yes", "No"), title = "Do you want to change something?")]
  }

  utils::write.csv(data, base::paste0(path, "/meta_data_", data$name, ".csv"),
                   row.names = FALSE)
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

