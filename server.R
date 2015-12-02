library(shiny)

shinyServer(function(input, output) {
  output$myMap = renderLeaflet(map)
})





