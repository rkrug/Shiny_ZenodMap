#' Shiny UI for the Zenodo network explorer
#'
#' @importFrom shiny fluidPage titlePanel tags HTML sidebarLayout sidebarPanel
#' @importFrom shiny mainPanel tabsetPanel tabPanel textInput numericInput
#' @importFrom shiny passwordInput fluidRow column actionButton selectInput
#' @importFrom shiny checkboxGroupInput selectizeInput checkboxInput sliderInput numericInput helpText verbatimTextOutput
#' @importFrom shiny div fileInput
#' @importFrom shinyFiles shinySaveButton
#' @importFrom visNetwork visNetworkOutput
#' @importFrom DT dataTableOutput
#'
#' @return A Shiny UI object.
ui <- shiny::fluidPage(
  shiny::tags$head(
    shiny::tags$style(shiny::HTML("
      @import url('https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,700&family=Space+Grotesk:wght@400;500;600;700&display=swap');

      :root {
        --bg-soft: #f2f7f4;
        --bg-warm: #f8f1e8;
        --ink: #16363a;
        --ink-muted: #4a6a6d;
        --brand: #0e8272;
        --brand-dark: #09665b;
        --accent: #d86f33;
        --card: rgba(255, 255, 255, 0.9);
        --card-border: rgba(22, 54, 58, 0.12);
        --app-main-height: 720px;
      }

      body {
        font-family: 'Space Grotesk', sans-serif;
        color: var(--ink);
        background:
          radial-gradient(60rem 40rem at -10% -10%, rgba(14, 130, 114, 0.22), transparent 45%),
          radial-gradient(48rem 32rem at 110% -15%, rgba(216, 111, 51, 0.2), transparent 45%),
          linear-gradient(140deg, var(--bg-soft), var(--bg-warm));
        min-height: 100vh;
      }

      .container-fluid {
        max-width: 1600px;
        padding: 24px 16px 30px 16px;
      }

      .hero-card {
        border-radius: 22px;
        padding: 28px 30px 24px 30px;
        margin-bottom: 18px;
        color: #f5fffc;
        background:
          radial-gradient(18rem 12rem at 85% 0%, rgba(255, 255, 255, 0.22), transparent 62%),
          linear-gradient(120deg, #0a5b69, #0f7a6f 45%, #0b6258 100%);
        box-shadow: 0 16px 38px rgba(7, 34, 33, 0.24);
      }

      .hero-kicker {
        display: inline-block;
        margin-bottom: 8px;
        padding: 5px 10px;
        border-radius: 999px;
        letter-spacing: 0.06em;
        text-transform: uppercase;
        font-size: 11px;
        font-weight: 700;
        background: rgba(255, 255, 255, 0.18);
      }

      .hero-title {
        margin: 0 0 6px 0;
        font-family: 'Fraunces', serif;
        font-size: clamp(30px, 5vw, 44px);
        line-height: 1.05;
      }

      .hero-subtitle {
        margin: 0;
        max-width: 920px;
        color: rgba(244, 255, 253, 0.92);
        font-size: 16px;
        line-height: 1.45;
      }

      .panel-card {
        border: 1px solid var(--card-border);
        border-radius: 18px;
        background: var(--card);
        box-shadow: 0 8px 24px rgba(10, 45, 48, 0.08);
        backdrop-filter: blur(5px);
      }

      .controls-card {
        height: 100%;
        display: flex;
        flex-direction: column;
        padding: 18px 16px;
      }

      .status-card,
      .content-card {
        padding: 16px;
        margin-bottom: 0;
      }

      .status-card {
        margin-top: 12px;
      }

      .app-main-row {
        display: flex;
        align-items: stretch;
        height: var(--app-main-height);
        max-height: var(--app-main-height);
        overflow: hidden;
      }

      .app-main-row > [class*='col-'] {
        display: flex;
        flex-direction: column;
        min-height: 0;
      }

      .right-column {
        height: 100%;
        min-height: 0;
      }

      .panel-title {
        margin: 0 0 10px 0;
        font-family: 'Fraunces', serif;
        font-size: 25px;
        line-height: 1.1;
        color: #184448;
      }

      .section-title {
        margin: 14px 0 9px 0;
        font-size: 12px;
        letter-spacing: 0.08em;
        text-transform: uppercase;
        color: var(--ink-muted);
        font-weight: 700;
      }

      .control-tabs {
        flex: 1;
        min-height: 0;
      }

      .control-tabs .tabbable {
        display: flex;
        flex-direction: column;
        height: 100%;
        min-height: 0;
      }

      .control-tabs .tab-content {
        flex: 1;
        min-height: 0;
        max-height: none;
        padding-top: 8px;
      }

      .control-tabs .tab-pane {
        height: 100%;
        overflow-y: auto;
        padding-right: 2px;
      }

      .sidebar-separator {
        border: 0;
        height: 1px;
        margin: 12px 0;
        background: linear-gradient(to right, rgba(14, 130, 114, 0.3), rgba(216, 111, 51, 0.3));
      }

      .help-block {
        color: #4c6668;
      }

      .form-control,
      .selectize-input,
      .selectize-dropdown,
      .well {
        border-radius: 10px;
        border-color: #c7d9d7;
      }

      .selectize-input.focus {
        border-color: #2b8579;
        box-shadow: 0 0 0 3px rgba(14, 130, 114, 0.14);
      }

      .btn {
        border-radius: 12px;
        border-width: 1px;
        font-weight: 600;
        transition: transform 0.18s ease, box-shadow 0.18s ease, background-color 0.18s ease;
      }

      .btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 8px 16px rgba(19, 55, 58, 0.12);
      }

      #fetch {
        color: #fff;
        border-color: transparent;
        background: linear-gradient(120deg, #0f8a79, #0b665f);
      }

      #refresh_graph {
        width: 100%;
        color: #fff;
        border-color: transparent;
        background: linear-gradient(120deg, #dd7d35, #c95d24);
      }

      #relations .shiny-options-group {
        column-count: 2;
        column-gap: 14px;
      }

      .relations-disabled {
        color: #98a8a8;
      }

      .status-card pre {
        margin: 0;
        min-height: 90px;
        max-height: 150px;
        overflow: auto;
        border: 0;
        border-radius: 10px;
        padding: 10px 12px;
        background: #f6fbf9;
        color: #20484c;
      }

      .content-card .tab-content {
        display: flex;
        flex-direction: column;
        flex: 1;
        min-height: 0;
        margin-top: 10px;
        overflow: hidden;
      }

      .content-card {
        display: flex;
        flex-direction: column;
        flex: 1;
        min-height: 0;
      }

      .content-card .tabbable {
        display: flex;
        flex-direction: column;
        flex: 1;
        min-height: 0;
      }

      .content-card .tab-pane {
        height: 100%;
        overflow: hidden;
      }

      .content-card .tab-pane.active {
        display: flex;
        flex-direction: column;
        min-height: 0;
      }

      #metadata_table {
        flex: 1;
        min-height: 0;
        overflow: auto;
      }

      .nav-tabs > li > a,
      .nav-pills > li > a {
        border-radius: 10px;
        color: #2f5f63;
        font-weight: 600;
      }

      .nav-tabs > li.active > a,
      .nav-tabs > li.active > a:focus,
      .nav-tabs > li.active > a:hover,
      .nav-pills > li.active > a,
      .nav-pills > li.active > a:focus,
      .nav-pills > li.active > a:hover {
        color: #fff;
        border-color: transparent;
        background: linear-gradient(120deg, #0e8575, #0c6a61);
      }

      #metadata_table table.dataTable thead th {
        border-bottom: 0;
        color: #1b4d51;
        background: #eef8f5;
      }

      #graph {
        height: 100% !important;
        min-height: 0;
        border-radius: 12px;
        overflow: hidden;
        border: 1px solid rgba(23, 64, 68, 0.12);
      }

      body:not(.loaded) .reveal {
        opacity: 0;
        transform: translateY(10px);
      }

      body.loaded .reveal {
        animation: rise-in 0.65s cubic-bezier(0.2, 0.7, 0.2, 1) both;
      }

      body.loaded .reveal-2 { animation-delay: 0.11s; }
      body.loaded .reveal-3 { animation-delay: 0.22s; }

      @keyframes rise-in {
        from { opacity: 0; transform: translateY(12px); }
        to { opacity: 1; transform: translateY(0); }
      }

      @media (max-width: 991px) {
        .app-main-row {
          display: block;
          height: auto;
          max-height: none;
          overflow: visible;
        }

        .app-main-row > [class*='col-'] {
          display: block;
        }

        .controls-card {
          height: auto;
          margin-bottom: 14px;
        }

        .control-tabs .tab-content {
          min-height: 280px;
        }

        .content-card {
          min-height: 65vh;
        }

        #graph {
          min-height: 56vh;
        }

        #relations .shiny-options-group {
          column-count: 1;
        }
      }
    ")),
    shiny::tags$script(shiny::HTML(
      "document.addEventListener('DOMContentLoaded', function() {\n",
      "  function resizeLayout() {\n",
      "    var viewport = window.innerHeight || document.documentElement.clientHeight;\n",
      "    var container = document.querySelector('.container-fluid');\n",
      "    var hero = document.querySelector('.hero-card');\n",
      "    var statusCard = document.querySelector('.status-card');\n",
      "    if (!container) { return; }\n",
      "    var cs = window.getComputedStyle(container);\n",
      "    var padTop = parseFloat(cs.paddingTop) || 0;\n",
      "    var padBottom = parseFloat(cs.paddingBottom) || 0;\n",
      "    var heroH = 0;\n",
      "    if (hero) {\n",
      "      var hs = window.getComputedStyle(hero);\n",
      "      heroH = hero.offsetHeight + (parseFloat(hs.marginBottom) || 0);\n",
      "    }\n",
      "    var statusH = 0;\n",
      "    if (statusCard) {\n",
      "      var ss = window.getComputedStyle(statusCard);\n",
      "      statusH = statusCard.offsetHeight + (parseFloat(ss.marginTop) || 0) + (parseFloat(ss.marginBottom) || 0);\n",
      "    }\n",
      "    var isMobile = window.matchMedia('(max-width: 991px)').matches;\n",
      "    var minH = 0;\n",
      "    var reserved = isMobile ? 8 : statusH + 8;\n",
      "    var available = Math.max(minH, viewport - padTop - padBottom - heroH - reserved);\n",
      "    document.documentElement.style.setProperty('--app-main-height', available + 'px');\n",
      "  }\n",
      "  document.body.classList.add('loaded');\n",
      "  resizeLayout();\n",
      "  setTimeout(resizeLayout, 60);\n",
      "  window.addEventListener('resize', resizeLayout);\n",
      "  window.addEventListener('load', resizeLayout);\n",
      "  var statusOutput = document.getElementById('status');\n",
      "  if (statusOutput && window.MutationObserver) {\n",
      "    var observer = new MutationObserver(function() { resizeLayout(); });\n",
      "    observer.observe(statusOutput, {childList: true, subtree: true, characterData: true});\n",
      "  }\n",
      "  if (window.jQuery) {\n",
      "    window.jQuery(document).on('shown.bs.tab', 'a[data-toggle=\"tab\"]', function() {\n",
      "      window.dispatchEvent(new Event('resize'));\n",
      "    });\n",
      "  }\n",
      "});\n",
      "Shiny.addCustomMessageHandler('toggleRelationOptions', function(message) {\n",
      "  var container = document.getElementById('relations');\n",
      "  if (!container) { return; }\n",
      "  var available = message.available || [];\n",
      "  var inputs = container.querySelectorAll('input[type=checkbox]');\n",
      "  inputs.forEach(function(input) {\n",
      "    var wrapper = input.closest('label') || input.parentElement;\n",
      "    var enabled = available.indexOf(input.value) !== -1;\n",
      "    input.disabled = !enabled;\n",
      "    if (wrapper) {\n",
      "      wrapper.classList.toggle('relations-disabled', !enabled);\n",
      "    }\n",
      "  });\n",
      "});"
    ))
  ),
  shiny::tags$div(
    class = "hero-card reveal",
    shiny::tags$div(class = "hero-kicker", "Zenodo Mapping Studio"),
    shiny::tags$h1(class = "hero-title", "Zenodo Network Explorer"),
    shiny::tags$p(
      class = "hero-subtitle",
      "Explore citations, versions, and metadata links across community deposits in an interactive graph."
    )
  ),
  shiny::fluidRow(
    class = "app-main-row",
    shiny::column(
      width = 4,
      shiny::tags$div(
        class = "panel-card controls-card reveal reveal-2",
        shiny::tags$h3(class = "panel-title", "Controls"),
        shiny::div(
          class = "control-tabs",
          shiny::tabsetPanel(
            shiny::tabPanel(
              "Data",
              shiny::tags$div(class = "section-title", "Fetch from Zenodo"),
              shiny::textInput("community", "Community id", "ipbes"),
              shiny::textInput("query", "Additional query (optional)", ""),
              shiny::numericInput(
                "max_records",
                "Max records (initial search)",
                100,
                min = 5,
                max = 1000,
                step = 5
              ),
              shiny::passwordInput("token", "Zenodo API token (optional, allows size up to 100)", ""),
              shiny::fluidRow(
                shiny::column(6, shiny::actionButton("fetch", "Fetch metadata")),
                shiny::column(
                  6,
                  shinyFiles::shinySaveButton(
                    "save_rds",
                    "Save data (RDS)",
                    "Save",
                    filename = paste0("zenodo_records_", Sys.Date(), ".rds")
                  )
                )
              ),
              shiny::tags$hr(class = "sidebar-separator"),
              shiny::tags$div(class = "section-title", "Upload Existing Data"),
              shiny::fileInput("upload_rds", "Upload data (RDS)", accept = ".rds")
            ),
            shiny::tabPanel(
              "Explore",
              shiny::tags$div(class = "section-title", "Graph Filters"),
              shiny::selectInput(
                "depth",
                "Expansion depth",
                choices = c("0" = 0, "1" = 1, "2" = 2),
                selected = 1
              ),
              shiny::checkboxInput(
                "community_only",
                "Only community-to-community links",
                FALSE
              ),
              shiny::checkboxInput(
                "map_versioned_to_concept",
                "Map versioned DOIs to concept IDs",
                FALSE
              ),
              shiny::checkboxGroupInput(
                "relations",
                "Relation types",
                choices = c(
                  "All",
                  "IsCitedBy",
                  "Cites",
                  "IsSupplementTo",
                  "IsSupplementedBy",
                  "IsContinuedBy",
                  "Continues",
                  "IsNewVersionOf",
                  "IsPreviousVersionOf",
                  "IsPartOf",
                  "HasPart",
                  "IsReferencedBy",
                  "References",
                  "IsDocumentedBy",
                  "Documents",
                  "IsCompiledBy",
                  "Compiles",
                  "IsVariantFormOf",
                  "IsOriginalFormOf",
                  "IsIdenticalTo",
                  "IsReviewedBy",
                  "Reviews",
                  "IsDerivedFrom",
                  "IsSourceOf",
                  "IsRequiredBy",
                  "Requires",
                  "IsObsoletedBy",
                  "Obsoletes",
                  "IsDescribedBy",
                  "Describes",
                  "HasMetadata",
                  "IsMetadataFor"
                ),
                selected = "All"
              ),
              shiny::selectizeInput(
                "keywords",
                "Keyword filter",
                choices = NULL,
                multiple = TRUE,
                options = list(placeholder = "Choose keywords")
              ),
              shiny::actionButton("refresh_graph", "Refresh graph"),
              shiny::helpText("Expansion uses Zenodo DOIs only and is capped for performance.")
            ),
            shiny::tabPanel(
              "Settings",
              shiny::tags$div(class = "section-title", "Physics"),
              shiny::checkboxInput(
                "physics_enabled",
                "Enable physics",
                TRUE
              ),
              shiny::sliderInput(
                "physics_stabilization",
                "Physics stabilization (iterations)",
                min = 0,
                max = 2000,
                value = 500,
                step = 50
              ),
              shiny::numericInput(
                "physics_max_time",
                "Max stabilization time (seconds)",
                value = 5,
                min = 0,
                max = 60,
                step = 1
              ),
              shiny::helpText("Lower values settle faster; higher values allow more organic layout movement.")
            )
          )
        )
      )
    ),
    shiny::column(
      width = 8,
      class = "right-column",
      shiny::tags$div(
        class = "panel-card content-card reveal reveal-2",
        shiny::tabsetPanel(
          type = "pills",
          shiny::tabPanel("Metadata", DT::dataTableOutput("metadata_table")),
          shiny::tabPanel("Graph", visNetwork::visNetworkOutput("graph", height = "100%"))
        )
      )
    )
  ),
  shiny::tags$div(
    class = "panel-card status-card reveal reveal-3",
    shiny::tags$h3(class = "panel-title", "Status"),
    shiny::verbatimTextOutput("status")
  )
)
