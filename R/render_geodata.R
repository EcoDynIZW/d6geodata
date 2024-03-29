#' function for rendering an markdown to get an html of available geodata
#' @param path The path where the data has to be stored
#' @param data_name the name of the data
#' @return a tibble where you have to set the parameters by hand.
#' @export
#' @examples
#' \dontrun{
#' render_geodata()
#' }

render_geodata <-
  function(path, data_name) {
    rmarkdown::render(here::here("R", "geodata_template_html.Rmd"),
                      output_format = "html_document",
                      output_dir = path,
                      output_file = unlist(stringi::stri_split(path, regex = "/"))[length(unlist(stringi::stri_split(path, regex = "/")))])
  }
