#' get the path of the user
#' @return the path of the user
#' @export
#' @examples
#' \dontrun{
#' get_user_path()
#' }

get_user_path <- function(){
  if(!"PopDynIZW Dropbox" %in% unlist(
    stringi::stri_split(here::here(), regex = '/'))){
    stringi::stri_c((unlist(
      stringi::stri_split(here::here(), regex = '/')
    )[1:3]), collapse = '/')
  } else{
    gsub("D:/", "C:/",stringi::stri_c((unlist(
      stringi::stri_split(here::here(), regex = '/')
    )[1:3]), collapse = '/'))
  }
}

