#' access shiny app for browse geodata on server and may download them
#' @return an app
#' @examples
#' \dontrun{
#' getgeodataApp()
#' }


getgeodataApp <- function()
{
  shiny::runApp(appDir = paste(system.file(package = "d6geodata"), "R", sep = "/"))
}
