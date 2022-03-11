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
                        short_description = NA,
                        units_of_data = NA,
                        link = NA,
                        date_of_download = NA,
                        modified = NA)

  doit <- "Yes"

  while(doit == "Yes"){

    data <- data %>%
      dplyr::mutate(
        folder_name = ifelse(is.na(data$folder_name), base::readline("folder name:"), data$folder_name),
        name = ifelse(is.na(data$name), base::readline("name of data:"), data$name),
        crs = ifelse(is.na(data$projection), base::readline("projection name:"), data$projection),
        epsg = ifelse(is.na(data$EPSG_code), fun_epsg(), data$EPSG_code),
        year_of_data = NA,
        short_description = NA,
        units_of_data = NA,
        link = NA,
        date_of_download = NA,
        modified = NA,
        proj_editor = ifelse(is.na(data$proj_editor), base::readline("project editor:"), data$proj_editor),
        Dep = ifelse(is.na(data$Dep), fun_num("Department"), data$Dep),
        sup_vis = ifelse(is.na(data$sup_vis), base::readline("super visor:"), data$sup_vis),
        data_name = ifelse(is.na(data$data_name), base::readline("names of data files:"),data$data_name),
        data_name_archive = ifelse(is.na(data$data_name_archive), base::readline("original names of data files in archive:"), data$data_name_archive),
        edited_unique_identifier = ifelse(is.na(data$edited_unique_identifier), base::readline("edited unique identifier:"), data$edited_unique_identifier),
        original_unique_identifier = ifelse(is.na(data$original_unique_identifier), base::readline("original unique identifier:"), data$original_unique_identifier),
        storage_folder = "data-raw",
        study_country = ifelse(is.na(data$study_country), base::readline("study country:"), data$study_country),
        study_area = ifelse(is.na(data$study_area), base::tolower(base::readline("study area:")), data$study_area),
        species = ifelse(is.na(data$species), base::tolower(base::readline("species:")), data$species),
        type_of_sample = ifelse(is.na(data$type_of_sample), base::readline("type of sample:"), data$type_of_sample),
        type_of_data = ifelse(is.na(data$type_of_data), base::readline("type of data:"), data$type_of_data),
        type_of_measure = ifelse(is.na(data$type_of_measure), base::readline("type of measure:"), data$type_of_measure),
        repeated_measure = c("yes", "no")[utils::menu(c("yes", "no"), title = "repeated measure?")],
        no_spec = ifelse(is.na(data$no_spec), fun_num("number of species"), data$no_spec),
        no_ind = ifelse(is.na(data$no_ind), fun_num("number of individuals"), data$no_ind),
        data_from = ifelse(is.na(data$data_from), fun_date("from"), data$data_from),
        data_to = ifelse(is.na(data$data_to), fun_date("to"), data$data_to),
        additional_info = ifelse(is.na(data$additional_info), base::readline("additional information:"), data$additional_info),
        publication = ifelse(is.na(data$publication), base::readline("publication name:"), data$publication),
        publication_doi = ifelse(is.na(data$publication_doi), base::readline("publication doi:"), data$publication_doi),
        metadata_description = ifelse(is.na(data$metadata_description), base::readline("metadata description:"), data$metadata_description),
        temporal_resolution_sec = ifelse(is.na(data$temporal_resolution_sec), fun_num("temporal resolution sec"), data$temporal_resolution_sec),
        temporal_resolution_min = ifelse(is.na(data$temporal_resolution_min), fun_num("temporal resolution min"), data$temporal_resolution_min),
        IZW_archive_path = ifelse(is.na(data$IZW_archive_path), base::readline("IZW archive path:"), data$IZW_archive_path),
        IZW_data_path = ifelse(is.na(data$IZW_data_path), base::readline("IZW data path:"), data$IZW_data_path),
        external_archives = ifelse(is.na(data$external_archives), base::readline("external archives:"), data$external_archives),
        sample_data = ifelse(is.na(data$sample_data), base::readline("sample data:"), data$sample_data),
        proc_data = ifelse(is.na(data$proc_data), base::readline("processed data:"), data$proc_data),
        cooperation = ifelse(is.na(data$cooperation), base::readline("cooperation:"), data$cooperation),
        data_owner = ifelse(is.na(data$data_owner), base::readline("data owner:"), data$data_owner),
        projection = ifelse(is.na(data$projection), base::readline("projection name:"), data$projection),
        EPSG_code = ifelse(is.na(data$EPSG_code), fun_epsg(), data$EPSG_code),
        data_type = ifelse(is.na(data$data_type), base::readline("data type ending:"), data$data_type)
      ) %>%
      dplyr::mutate_each(dplyr::funs(empty_as_na))

    data <- dplyr::mutate(data,
                          proj_name = base::paste(lubridate::year(data_from),
                                                  species,
                                                  study_country,
                                                  study_area,
                                                  type_of_data,
                                                  proj_editor,
                                                  sep = "_"))

    doit <- c("Yes", "No")[utils::menu(c("Yes", "No"), title = "Do you want to change something?")]
  }

  if(!base::file.exists(base::paste(path, data$proj_name, sep = "/"))){ # creates new folder per layer
    base::dir.create(base::paste(path, data$proj_name, sep = "/"))
  }

  xlsx::write.xlsx(data, base::paste0(path, "/meta_data_", data$proj_name, "/", data$proj_name, ".xlsx"),
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
  date_in <- base::readline(base::paste0("enter date ", x,": "))
  while(base::class(try(assertthat::is.date(base::as.Date(date_in)), silent = TRUE)) == "try-error"){
    print("wrong format. Enter date as following: 2017-01-01")
    date_in <- base::readline(base::paste0("enter date ", x,": "))
  }
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
