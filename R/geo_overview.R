#' show overview of geodata
#' @return a list with folder names
#' @param path_to_cloud set the path to the cloud
#' @export
#' @examples
#' \dontrun{
#' geo_overview()
#' }

geo_overview <- function(path_to_cloud){
  data_fold <- c("data-raw", "data-proc")[utils::menu(c("raw", "processed"), title = "Raw or processed data:")]

  folder <- c("main", "sub")[utils::menu(c("main", "sub"), title = "choose folder type:")]


  # show main folders
  main_fold <- list.dirs(paste(path_to_cloud, "GeoData", data_fold, sep = "/"), recursive = FALSE, full.names = FALSE)
  if(folder %in% "main"){
  print(main_fold)
  }
  # show sub folders
  if(folder %in% "sub"){
  sub_fold <- lapply(main_fold,
                     function(x){list.dirs(paste(path_to_cloud, "GeoData", data_fold, x, sep = "/"),
                                           recursive = FALSE,
                                           full.names = FALSE)})
  names(sub_fold) <- main_fold

  print(sub_fold)
  }
}


#devtools::install_local(force = TRUE)
# d6geodata::geo_overview(path = "C:/Users/wenzler/PopDynIZW Dropbox/GeoData/",folder = "main")

# c("sub","main")[utils::menu(c("sub","main"), title = "choose folder:")]
# base::readline("choose folder:", c("sub","main"))

