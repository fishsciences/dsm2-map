shinyUI(bootstrapPage(
  title = "DSM2 Map",
  tags$style(
    type = "text/css",
    "html, body {width:100%;height:100%}",
    ".leaflet-map-pane { z-index: auto; }"
  ),
  leafletOutput('Map', width = "100%", height = "100%"),
  absolutePanel(
    top = 10,
    right = 20,
    wellPanel(
      pickerInput(
        inputId = "selected_station",
        label = "Selected station",
        choices = c("", sort(sll$RKI)),
        selected = "",
        options = list(`live-search` = TRUE, size = 10)
      ),
      pickerInput(
        inputId = "selected_node",
        label = "Selected node",
        choices = c("", sort(nll$NNUM)),
        selected = "",
        options = list(`live-search` = TRUE, size = 10)
      ),
      pickerInput(
        inputId = "selected_channel",
        label = "Selected channel",
        choices = c("", sort(cll$channel_nu)),
        selected = "",
        options = list(`live-search` = TRUE, size = 10)
      ),
      conditionalPanel(condition = 'input.selected_channel != ""',
                       HTML(
                         paste("Upstream node of selected", "channel is shown in red.", sep = "<br/>")
                       )),
      br(),
      tags$a(href = "https://github.com/fishsciences/dsm2-map", "Code on GitHub")
    )
  )
))
