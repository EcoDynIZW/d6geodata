#' get the path of the user
#' @return the path of the user
#' @export
#' @examples
#' \dontrun{
#' get_user_path()
#' }

get_user_path <- function(){
  stringi::stri_c((unlist(
    stringi::stri_split(.libPaths()[1], regex = '/')
  )[1:3]), collapse = '/')
}

