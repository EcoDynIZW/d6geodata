#' show overview of geodata
#' @return a list with folder names
#' @param folder do you want the main or sub folders
#' @export
#' @examples
#' \dontrun{
#' geo_overview()
#' }

geo_overview <- function(folder = c("main", "sub")[utils::menu(c("main", "sub"), title = "choose folder:")]){
  # show main folders
  main_fold <- list.dirs(here::here(base::getwd(), "GeoData", "data-raw"), recursive = FALSE, full.names = FALSE)
  if(folder %in% "main"){
  print(main_fold)
  }
  # show sub folders
  if(folder %in% "sub"){
  sub_fold <- lapply(main_fold,
                     function(x){list.dirs(here::here(base::getwd(), "GeoData", "data-raw", x),
                                           recursive = FALSE,
                                           full.names = FALSE)})
  names(sub_fold) <- main_fold

  print(sub_fold)
  }

  path <- c("yes", "no")[utils::menu(c("yes", "no"), title = "Do you need the path?")]
  if(path %in% "yes"){
    main_folder <- list.dirs(here::here(base::getwd(), "GeoData", "data-raw"), recursive = FALSE, full.names = FALSE)[
      utils::menu(list.dirs(here::here(base::getwd(), "GeoData", "data-raw"), recursive = FALSE, full.names = FALSE),
                  title = "which main folder?")
    ]
    sub_folder <- list.dirs(here::here(base::getwd(), "GeoData", "data-raw", main_folder), recursive = FALSE, full.names = FALSE)[
      utils::menu(list.dirs(here::here(base::getwd(), "GeoData", "data-raw", main_folder), recursive = FALSE, full.names = FALSE),
                  title = "which data file?")
    ]

  final_path <- here::here(base::getwd(), "GeoData", "data-raw", main_folder, sub_folder)
  }
  return(final_path)
}


#devtools::install_local(force = TRUE)
# d6geodata::geo_overview(path = "C:/Users/wenzler/PopDynIZW Dropbox/GeoData/",folder = "main")

# c("sub","main")[utils::menu(c("sub","main"), title = "choose folder:")]
# base::readline("choose folder:", c("sub","main"))

