#' get the path of the user
#' @return the path of the user
#' @export
#' @examples
#' \dontrun{
#' get_user_path()
#' }

get_user_path <- function(){
  if(!dir.exists("PopDynIZW Dropbox")){
    stringi::stri_c((unlist(
      stringi::stri_split(here::here(), regex = '/')
    )[1:3]), collapse = '/')
  } else{
    gsub("C:/", "D:/",stringi::stri_c((unlist(
      stringi::stri_split(here::here(), regex = '/')
    )[1:3]), collapse = '/'))
  }
}

