#' Run the rsidebot Shiny application
#'
#' Launches the Restaurant Tipping Dashboard with AI chat interface.
#'
#' @param port The TCP port that the application should listen on.
#'   Defaults to a random available port.
#' @param launch.browser If TRUE, the app will open in a web browser.
#' @param ... Additional arguments passed to \code{\link[shiny]{runApp}}.
#' @return This function does not return; interrupt R to stop the application.
#' @export
#' @examples
#' \dontrun{
#' # Run with default settings
#' run_app()
#'
#' # Run on specific port
#' run_app(port = 3838)
#'
#' # Run without opening browser
#' run_app(launch.browser = FALSE)
#' }
run_app <- function(port = NULL, launch.browser = TRUE, ...) {
  app_dir <- system.file("app", package = "rsidebot")
  if (app_dir == "") {
    stop("Could not find app directory. Try reinstalling `rsidebot`.")
  }
  shiny::runApp(
    app_dir,
    port = port,
    launch.browser = launch.browser,
    ...
  )
}
