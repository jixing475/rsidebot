# rsidebot

Restaurant Tipping Data Dashboard with AI Chat - an R package.

This is a Shiny dashboard for exploring restaurant tipping data with an AI-powered chatbot. Users can interactively filter, sort, and analyze tip data through natural language queries powered by Claude AI.

## Installation

```r
# Install from local source
devtools::install()

# Or install dependencies first
pak::pak(c(
  "shiny", "bslib", "plotly", "ggplot2", "ggridges", 
  "dplyr", "reactable", "readr", "reticulate",
  "posit-dev/querychat/pkg-r", "posit-dev/ellmer", "posit-dev/shinychat"
))
```

## Usage

```r
library(rsidebot)

# Run the dashboard
run_app()

# Or specify a port
run_app(port = 3838)
```

## Configuration

Set these environment variables before running:

```r
Sys.setenv(ANTHROPIC_API_KEY_4_sidebot = "your-api-key")
Sys.setenv(ANTHROPIC_BASE_URL_4_sidebot = "https://api.anthropic.com")
Sys.setenv(DATABOT_ANTHROPIC_MODEL_4_sidebot = "claude-3-5-sonnet-latest")
```

Or add them to your `.Renviron` file.

## Features

- Interactive data table with filtering
- Scatter plot (total bill vs tip) with LOESS trend line
- Ridge plot showing tip percentage distributions
- AI chat for natural language data queries
- "Explain plot" feature using Claude's vision capabilities

## Requirements

- R >= 4.1.0
- Python environment with `plotly` and `kaleido` (for plot image export)

## Warnings and Limitations

This app sends your data schema to a remote LLM. It also permits the LLM to run SQL queries against your data. Please keep these facts in mind when dealing with sensitive data.

## License

MIT