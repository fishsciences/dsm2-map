
shinyUI(
  bootstrapPage(
    title = "DSM2 Map",
    tags$style(type = "text/css", 
               "html, body {width:100%;height:100%}",
               ".leaflet-map-pane { z-index: auto; }"),
    leafletOutput('Map', width = "100%", height = "100%"),
    absolutePanel(top = 10, right = 20, 
                  wellPanel(
                    selectInput(inputId = "map_back", label = "Background map",
                                choices = c("BlackAndWhite" = "OpenStreetMap.BlackAndWhite",
                                            "WorldTopoMap" = "Esri.WorldTopoMap",
                                            "WorldImagery" = "Esri.WorldImagery"),
                                selected = "Esri.WorldTopoMap"),
                    pickerInput(inputId = "selected_channel", label = "Selected channel", 
                                choices = c("", sort(cll$channel_nu)), selected = "", options = list(`live-search` = TRUE, size = 10)),
                    pickerInput(inputId = "selected_node", label = "Selected node", 
                                choices = c("", sort(nll$NNUM)), selected = "", options = list(`live-search` = TRUE, size = 10))
                  )
    )
  )
)


