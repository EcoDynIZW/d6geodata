#' show overview of geodata
#' @param path the path to the dropbox folder
#' @return a list with folder names
#' @export
#' @examples
#' \dontrun{
#' geo_overview()
#' }

geo_overview <- function(path = getwd(), folder){
  # show main folders

  main_fold <- list.dirs(here::here(path, "data-raw"), recursive = FALSE, full.names = FALSE)
  if(folder %in% "main"){
  print(main_fold)
  }
  # show sub folders
  if(folder %in% "sub"){
  sub_fold <- lapply(main_fold,
                     function(x){list.dirs(here::here(path, "data-raw", x),
                                           recursive = FALSE,
                                           full.names = FALSE)})
  names(sub_fold) <- main_fold

  print(sub_fold)
  }


}
#devtools::install_local(force = TRUE)
# d6geodata::geo_overview(folder = "sub")

