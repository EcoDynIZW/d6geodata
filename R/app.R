
library(shiny)

getgeodataApp <- function() {

geopath <- base::readline("path to dep6:")

main_folders <- lapply(
  X = list.dirs(
    path = paste(geopath, "GeoData", "data", sep = "/"),
    recursive = F,
    full.names = F
    ),
  FUN = function(x){
    gsub("\\./", "", x)
            }
  )

sub_folders <- lapply(main_folders, function(x) {
  subs <- gsub("\\./",
               "",
               list.dirs(
                 path = file.path(paste(geopath, "GeoData", "data", sep = "/"), x),
                 recursive = FALSE,
                 full.names = FALSE
               ))

  # Filter out unwanted subfolders (e.g., _archive)
  subfolders <- subs[!subs %in% c("_archive")]
  return(subfolders)
}
  )

names(sub_folders) <- main_folders

ui <- shiny::fluidPage(
  shiny::titlePanel("Show And Download Geodata"),

  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::selectInput("mainfolder", "Select Mainfolder:",
                  choices = c(None='.', main_folders), width = "100%"),
      shiny::uiOutput("subfolderUI"),

      shinyFiles::shinyDirButton("directory", "Choose Directory and Download", "Please select a directory")
    ),

    shiny::mainPanel(
      shiny::uiOutput("iframeOutput")      # Dynamic iframe
    )
  )
)

server <- function(input, output, session) {

  # Update subfolder choices based on selected mainfolder
  observeEvent(input$mainfolder, {
    shiny::subfolders <- sub_folders[[input$mainfolder]] # Access subfolder list by mainfolder name

    shiny::updateSelectInput(session, "subfolder",
                      choices = c(None='.', subfolders))

  })

  # Render the subfolder selectInput dynamically based on the selected mainfolder
  output$subfolderUI <- renderUI({
    shiny::selectInput("subfolder", "Select Subfolder:",
                choices = NULL) # Initially empty; will be updated based on mainfolder
  })

  shinyFiles::shinyDirChoose(input, "directory", roots = c(home = getwd()), session = session)

  selected_dir <- shiny::reactive({
    req(input$directory)
    shinyFiles::parseDirPath(c(home = getwd()), input$directory)


  })

  full_path <- shiny::reactive({
    req(input$mainfolder,input$subfolder)
    file.path(paste(geopath, "GeoData", "data", sep = "/"), paste(input$mainfolder,input$subfolder, # selected_dir()
                                      sep = "/"))
  })

  shiny::observeEvent(input$directory, {
    req(full_path(), selected_dir())

    # Create the target directory if it doesn't exist
    base::dir.create(path = selected_dir(), showWarnings = TRUE, recursive = TRUE)

    # Get the size of the file for progress tracking (if it's a single file)
    file_size <- sum(sapply(list.files(full_path(), full.names = TRUE, recursive = FALSE), file.size))

    files_to_copy <- list.files(full_path(), full.names = TRUE, recursive = FALSE, include.dirs = FALSE)

    # Show a progress bar that updates based on real copy time
    shiny::withProgress(message = 'Copying files...', value = 0, {

      num_files <- length(files_to_copy)
      if (num_files == 0) {
        shiny::showNotification("No files to copy!", type = "warning")
        return(NULL)
      }

      # Copy each file and update the progress
      for (i in seq_along(files_to_copy)) {
        file.copy(from = files_to_copy[i], to = selected_dir(), overwrite = TRUE)

        # Update the progress bar
        shiny::incProgress(1 / num_files, detail = paste("Copying file", i, "of", num_files))
      }

      # Notify user that the folder has been copied
      shiny::showNotification(paste("Folder copied to:", selected_dir()), type = "message")
    })
  })

  # Render the iframe dynamically based on the selected mainfolder and subfolder
  output$iframeOutput <- shiny::renderUI({
    if (!is.null(input$subfolder)) {
      url <- paste0("https://ecodynizw.github.io/posts_geodata/", input$subfolder)

      tags$iframe(
        src = url,
        style = "width:100%;height:600px;border:none;"
      )
    } else {
      tags$p("No subfolder selected.")
    }
  })
}

shinyApp(ui, server)

}

