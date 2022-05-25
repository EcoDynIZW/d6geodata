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
  } else{
    paste(gsub("C:/", "D:/",stringi::stri_c((unlist(
      stringi::stri_split(here::here(), regex = '/')
    )[1:3]), collapse = '/')), 'PopDynIZW Dropbox', sep = "/")
  }
}

