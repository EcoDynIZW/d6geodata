#' function for copying the geodata template, adding the paths and rename it to the corresponding data
#' @param path The path where the data lays
#' @export
#' @examples
#' \donotrun{
#' move_to_distill()
#' }

move_to_distill <-
  function(path, data_name) {
    file.copy(from = here::here("R", "geodata_template_html.Rmd"), to = "C:\Users\wenzler\Documents\GitHub\d6geodatabase")
    file.rename(from = file.path("C:\Users\wenzler\Documents\GitHub\d6geodatabase",
                                 "geodata_template_html.Rmd"),
                to = file.path("C:\Users\wenzler\Documents\GitHub\d6geodatabase",
                               unlist(stringi::stri_split(path, regex = "/"))[length(unlist(stringi::stri_split(path, regex = "/")))]))
                     # output_file = unlist(stringi::stri_split(path, regex = "/"))[length(unlist(stringi::stri_split(path, regex = "/")))])
  }
