# Project Context

## Purpose
R Shiny web application for exploring restaurant tipping data with an AI-powered chatbot sidebar. Users can interactively filter, sort, and analyze tip data through natural language queries powered by Claude AI.

## Tech Stack
- **R** (primary language)
- **Shiny** - reactive web framework
- **bslib** - Bootstrap 5 UI components
- **querychat/ellmer** - AI chatbot integration with Anthropic Claude
- **DuckDB** - SQL database for data querying
- **plotly** - interactive scatter plots
- **ggplot2/ggridges** - static visualizations (ridge plots)
- **dplyr** - data manipulation
- **reactable** - interactive data tables
- **reticulate** - Python interoperability (for plotly image export)
- **shinychat** - chat UI components

## Project Conventions

### Code Style
- Use `here()` for file paths
- Emoji comments for section headers (e.g., `# 🎯 Value boxes`)
- Reactive expressions for computed values
- Snake_case for variable and function names
- S3 methods for type dispatch (e.g., `plot_to_img_content`)

### Architecture Patterns
- Single `app.R` file with UI and server logic
- Helper functions in `R/` directory
- System prompts in markdown files (`prompt.md`, `greeting.md`)
- CSS in `styles.css`
- Static assets in `www/`

### Testing Strategy
- Manual testing through Shiny app interaction
- No automated test suite currently

### Git Workflow
- Not currently under git version control

## Domain Context
- **Tips dataset**: Restaurant tipping data with columns: total_bill, tip, sex, smoker, day, time, size, percent
- **querychat**: AI chatbot that translates natural language to DuckDB SQL queries
- **Explain plot**: Vision-based feature that asks Claude to interpret visualizations

## Important Constraints
- SQL queries must return all original columns (SELECT *)
- Chatbot responses should be concise (sidebar display)
- API keys stored in environment variables (ANTHROPIC_API_KEY_4_sidebot, etc.)

## External Dependencies
- **Anthropic Claude API** - AI chat completions and vision
- **Python environment** - Required for plotly image export via kaleido
