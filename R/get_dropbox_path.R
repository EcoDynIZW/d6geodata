#' get the path to our dropbox
#' @return the path to the dropbox
#' @export
#' @examples
#' \dontrun{
#' get_dropbox_path()
#' }

get_dropbox_path <- function(){
  if(dir.exists("PopDynIZW Dropbox")){
    paste(stringi::stri_c((unlist(
      stringi::stri_split(here::here(), regex = '/')
    )[1:3]), collapse = '/'), 'PopDynIZW Dropbox', sep = "/")
  } else{if(dir.exists(paste(gsub("C:/", "D:/",stringi::stri_c((unlist(
    stringi::stri_split(here::here(), regex = '/')
  )[1:3]), collapse = '/')), 'PopDynIZW Dropbox', sep = "/"))){
    paste(gsub("C:/", "D:/",stringi::stri_c((unlist(
      stringi::stri_split(here::here(), regex = '/')
    )[1:3]), collapse = '/')), 'PopDynIZW Dropbox', sep = "/")

  } else{
    if ("PopDynIZW Dropbox" %in% unlist(stringi::stri_split(here::here(), regex = '/'))) {
      paste(stringi::stri_c((unlist(
        stringi::stri_split(here::here(), regex = '/')
      )[1:which(unlist(stringi::stri_split(here::here(), regex = '/')) == "PopDynIZW Dropbox")]),
      collapse = '/'), sep = "/") }
    else{"E:/PopDynIZW Dropbox/PopDynIZW Dropbox"}
      }
  }
}

