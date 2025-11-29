library(shiny)
library(bslib)
library(fontawesome)
library(reactable)
library(ggplot2)
library(ggridges)
library(dplyr)
library(querychat)

Sys.setenv(http_proxy="http://127.0.0.1:1087")
Sys.setenv(https_proxy="http://127.0.0.1:1087")

# Configure Python BEFORE loading plotly
library(reticulate)
Sys.setenv(RETICULATE_PYTHON = "/Users/zero/miniconda3/envs/sidebot/bin/python3")
reticulate::py_config()  # Force Python initialization

# Load plotly AFTER Python is configured
library(plotly)

api_key <- Sys.getenv("ANTHROPIC_API_KEY_4_sidebot", "")
base_url <- Sys.getenv("ANTHROPIC_BASE_URL_4_sidebot", "")
model <- Sys.getenv("DATABOT_ANTHROPIC_MODEL_4_sidebot", "claude-3-5-sonnet-latest")

tips <- readr::read_csv(
  system.file("extdata/tips.csv", package = "rsidebot")
) |>
  mutate(percent = round((tip / total_bill) * 100, 2))

querychat_handle <- querychat_init(
  tips,
  create_chat_func = purrr::partial(
    ellmer::chat_anthropic,
    base_url = paste0(base_url, "/v1"),
    model = model,
    api_key = api_key
  ),
  greeting = readLines(
    system.file("prompts/greeting.md", package = "rsidebot"),
    warn = FALSE
  )
)

icon_explain <- tags$img(src = "stars.svg")

ui <- page_fillable(
  style = "background-color: rgb(248, 248, 248);",
  title = "Restaurant tipping",
  includeCSS(system.file("styles/styles.css", package = "rsidebot")),
  useBusyIndicators(),

  # 📊 Dashboard content (70%)
  div(
    style = "height: 70vh; overflow-y: auto; padding: 1rem;",

    # 🏷️ Header
    textOutput("show_title", container = h3),
    verbatimTextOutput("show_query") |>
      tagAppendAttributes(style = "max-height: 100px; overflow: auto;"),

    # 🎯 Value boxes
    layout_columns(
      fill = FALSE,
      value_box(
        showcase = fa_i("user"),
        "Total tippers",
        textOutput("total_tippers", inline = TRUE)
      ),
      value_box(
        showcase = fa_i("wallet"),
        "Average tips",
        textOutput("average_tip", inline = TRUE)
      ),
      value_box(
        showcase = fa_i("dollar-sign"),
        "Average bill",
        textOutput("average_bill", inline = TRUE)
      ),
    ),
    layout_columns(
      style = "min-height: 450px;",
      col_widths = c(6, 6, 12),

      # 🔍 Data table
      card(
        style = "height: 500px;",
        card_header("Tips data"),
        reactableOutput("table", height = "100%")
      ),

      # 📊 Scatter plot
      card(
        card_header(
          class = "d-flex justify-content-between align-items-center",
          "Total bill vs tip",
          span(
            actionLink(
              "interpret_scatter",
              icon_explain,
              class = "me-3 text-decoration-none",
              aria_label = "Explain scatter plot"
            ),
            popover(
              title = "Add a color variable",
              placement = "top",
              fa_i("ellipsis"),
              radioButtons(
                "scatter_color",
                NULL,
                c("none", "sex", "smoker", "day", "time"),
                inline = TRUE
              )
            )
          )
        ),
        plotlyOutput("scatterplot")
      ),

      # 📊 Ridge plot
      card(
        card_header(
          class = "d-flex justify-content-between align-items-center",
          "Tip percentages",
          span(
            actionLink(
              "interpret_ridge",
              icon_explain,
              class = "me-3 text-decoration-none",
              aria_label = "Explain ridgeplot"
            ),
            popover(
              title = "Split ridgeplot",
              placement = "top",
              fa_i("ellipsis"),
              radioButtons(
                "tip_perc_y",
                "Split by",
                c("sex", "smoker", "day", "time"),
                "day",
                inline = TRUE
              )
            )
          )
        ),
        plotOutput("tip_perc")
      ),
    )
  ),

  # 💬 Chat area (30%)
  card(
    style = "height: 30vh; overflow-y: auto; border-top: 2px solid #dee2e6;",
    card_header("Chat"),
    querychat_ui("chat")
  )
)

server <- function(input, output, session) {
  # ✨ querychat ✨ -----------------------------------------------------------

  querychat <- querychat_server("chat", querychat_handle)

  # We don't normally need the chat object, but in this case, we want it so we
  # can pass it to explain_plot
  chat <- querychat$chat

  # The reactive data frame. Either returns the entire dataset, or filtered by
  # whatever querychat decided.
  #
  # querychat$df is already a reactive data frame, we're just creating an alias
  # to it called `tips_data` so the code below can be more readable.
  tips_data <- querychat$df

  # 🏷️ Header outputs --------------------------------------------------------

  output$show_title <- renderText({
    querychat$title()
  })

  output$show_query <- renderText({
    querychat$sql()
  })

  # 🎯 Value box outputs -----------------------------------------------------

  output$total_tippers <- renderText({
    nrow(tips_data())
  })

  output$average_tip <- renderText({
    x <- mean(tips_data()$tip / tips_data()$total_bill) * 100
    paste0(formatC(x, format = "f", digits = 1, big.mark = ","), "%")
  })

  output$average_bill <- renderText({
    x <- mean(tips_data()$total_bill)
    paste0("$", formatC(x, format = "f", digits = 2, big.mark = ","))
  })

  # 🔍 Data table ------------------------------------------------------------

  output$table <- renderReactable({
    reactable(tips_data(), pagination = FALSE, compact = TRUE)
  })

  # 📊 Scatter plot ----------------------------------------------------------

  scatterplot <- reactive({
    req(nrow(tips_data()) > 0)

    color <- input$scatter_color

    data <- tips_data()

    p <- plot_ly(
      data,
      x = ~total_bill,
      y = ~tip,
      type = "scatter",
      mode = "markers"
    )

    if (color != "none") {
      p <- plot_ly(
        data,
        x = ~total_bill,
        y = ~tip,
        color = as.formula(paste0("~", color)),
        type = "scatter",
        mode = "markers"
      )
    }

    p <- p |>
      add_lines(
        x = ~total_bill,
        y = fitted(loess(tip ~ total_bill, data = data)),
        line = list(color = "rgba(255, 0, 0, 0.5)"),
        name = "LOESS",
        inherit = FALSE
      )

    p <- p |> layout(showlegend = FALSE)

    return(p)
  })

  output$scatterplot <- renderPlotly({
    scatterplot()
  })

  observeEvent(input$interpret_scatter, {
    explain_plot(chat, scatterplot(), .ctx = ctx)
  })

  # 📊 Ridge plot ------------------------------------------------------------

  tip_perc <- reactive({
    req(nrow(tips_data()) > 0)

    df <- tips_data() |> mutate(percent = tip / total_bill)

    ggplot(
      df,
      aes_string(x = "percent", y = input$tip_perc_y, fill = input$tip_perc_y)
    ) +
      geom_density_ridges(scale = 3, rel_min_height = 0.01, alpha = 0.6) +
      scale_fill_viridis_d() +
      theme_ridges() +
      labs(x = "Percent", y = NULL, title = "Tip Percentages by Day") +
      theme(legend.position = "none")
  })

  output$tip_perc <- renderPlot({
    tip_perc()
  })

  observeEvent(input$interpret_ridge, {
    explain_plot(chat, tip_perc(), .ctx = ctx)
  })
}

shinyApp(ui, server)
