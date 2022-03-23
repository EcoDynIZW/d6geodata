#' function for rendering an markdown to get an html of available geodata
#' @param path The path where the data has to be stored
#' @return a tibble where you have to set the parameters by hand.
#' @export
#' @examples
#' \dontrun{
#' render_geodata()
#' }

render_geodata <-
  function(path) {
    rmarkdown::render(here::here("R", "geodata_overview_github.Rmd"),
                      output_format = "html_document")
  }
