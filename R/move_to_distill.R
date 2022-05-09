#' function for copying the geodata template, adding the paths and rename it to the corresponding data
#' @param path The path where the data lays
#' @export
#' @examples
#' \dontrun{
#' move_to_distill()
#' }

move_to_distill <-
  function(path, to_path = "C:/Users/wenzler/Documents/GitHub/d6geodatabase") {
    base::file.copy(from = here::here("R", "geodata_template_html.Rmd"), to = to_path)
    base::file.rename(from = base::file.path(to_path,
                                 "geodata_template_html.Rmd"),
                to = base::file.path(to_path,
                                     paste0(base::unlist(stringi::stri_split(here::here(path), regex = "/"))[length(base::unlist(stringi::stri_split(here::here(path), regex = "/")))],
                                            ".rmd")))
                     # output_file = unlist(stringi::stri_split(path, regex = "/"))[length(unlist(stringi::stri_split(path, regex = "/")))])
  }
