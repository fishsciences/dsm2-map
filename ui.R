library(shiny)

shinyUI(bootstrapPage(
  title = "DSM2 Map",
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput('Map', width = "100%", height = "100%"),
  absolutePanel(top = 10, left = 50, 
                selectInput("selected_channel", "Selected channel", c("", cll$channel_nu), selected = ""))
))

