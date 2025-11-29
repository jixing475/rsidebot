#' @keywords internal
plot_to_img_content <- function(p) {

  UseMethod("plot_to_img_content", p)
}

#' @keywords internal
plot_to_img_content.plotly <- function(p) {
  # Ensure Python/kaleido is available
  if (!reticulate::py_available(initialize = FALSE)) {
    stop("Python is not available. Please configure reticulate::use_python() before using explain_plot with plotly.")
  }

  tmp <- tempfile(fileext = ".png")
  on.exit(unlink(tmp))
  plotly::save_image(p, tmp, width = 800, height = 600)
  ellmer::content_image_file(tmp, resize = "high")
}

#' @keywords internal
plot_to_img_content.ggplot <- function(p) {
  tmp <- tempfile(fileext = ".png")
  on.exit(unlink(tmp))
  ggplot2::ggsave(tmp, p, width = 800, height = 600, units = "px", dpi = 100)
  ellmer::content_image_file(tmp, resize = "high")
}

#' @export
explain_plot <- function(
  chat,
  p,
  ...,
  .ctx = NULL,
  session = shiny::getDefaultReactiveDomain()
) {
  chat_id <- paste0("explain_plot_", sample.int(1e9, 1))
  chat <- chat$clone()

  img_content <- plot_to_img_content(p)
  img_url <- paste0("data:", img_content@type, ";base64,", img_content@data)

  shiny::showModal(
    shiny::modalDialog(
      shiny::tags$button(
        type = "button",
        class = "btn-close d-block ms-auto mb-3",
        `data-bs-dismiss` = "modal",
        aria_label = "Close"
      ),
      shiny::tags$img(
        src = img_url,
        style = "max-width: min(100%, 400px);",
        class = "d-block border mx-auto mb-3"
      ),
      shinychat::chat_ui(chat_id),
      size = "l",
      easyClose = TRUE,
      title = NULL,
      footer = NULL
    ) |>
      shiny::tagAppendAttributes(style = "--bs-modal-margin: 1.75rem;")
  )

  session$onFlushed(function() {
    stream <- chat$stream_async(
      "Interpret this plot, which is based on the current state of the data (i.e. with filtering applied, if any). Try to make specific observations if you can, but be conservative in drawing firm conclusions and express uncertainty if you can't be confident.",
      img_content
    )
    shinychat::chat_append(chat_id, stream)
  })

  shiny::observeEvent(session$input[[paste0(chat_id, "_user_input")]], {
    stream <- chat$stream_async(session$input[[paste0(chat_id, "_user_input")]])
    shinychat::chat_append(chat_id, stream)
  })
}
