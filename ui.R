library(shiny)

shinyUI(fluidPage(
  leafletOutput('myMap', height = 800)
))

