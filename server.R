library(shiny)
library(leaflet)

shinyServer(function(input, output, session) {
  
  # add marker to indicate selected channel
  am_sel <- function(map, x, y) addMarkers(map, x, y, layerId = "Selected")
  
  # update the location selectInput on map clicks
  observeEvent(input$Map_shape_click, {
    p <- input$Map_shape_click
    if(!is.null(p$id)){
      if(is.null(input$selected_channel) || input$selected_channel != p$id){
        updateSelectInput(session, "selected_channel", selected = p$id)
      }
    }
  })
  
  # update the map markers and view on map clicks
  observeEvent(input$Map_shape_click, {
    p <- input$Map_shape_click
    proxy <- leafletProxy("Map")
    if(!is.null(p$id)){
      if(p$id == "Selected"){
        proxy %>% removeMarker(layerId="Selected")
      } else {
        proxy %>% setView(lng=p$lng, lat=p$lat, input$Map_zoom) %>% am_sel(p$lng, p$lat)
      }
    }
  })
  
  # update the map markers and view on location selectInput changes
  observeEvent(input$selected_channel, {
    p <- input$Map_shape_click
    p2 <- filter(cll, channel_nu == input$selected_channel)
    proxy <- leafletProxy("Map")
    if(nrow(p2)==0){
      proxy %>% removeMarker(layerId = "Selected")
    } else if(length(p$id) && input$selected_channel != p$id){
      proxy %>% setView(lng = p2$lon, lat = p2$lat, input$Map_zoom) %>% am_sel(p2$lon, p2$lat)
    } else if(!length(p$id)){
      proxy %>% setView(lng = p2$lon, lat = p2$lat, input$Map_zoom) %>% am_sel(p2$lon, p2$lat)
    }
  })
  
  output$Map = renderLeaflet(
    leaflet() %>% 
      addProviderTiles("Stamen.Terrain", group = "Terrain") %>%
      addProviderTiles("OpenStreetMap.BlackAndWhite", group = "Black & White") %>%
      setView(lng = -121.77, lat = 38.14, zoom = 10) %>%
      addPolylines(data = flowlines, 
                   color = "blue", 
                   weight = 4, 
                   group = "All DSM2 Channels",
                   layerId = ~channel_nu,
                   popup = ~paste("Channel", channel_nu, "<br>", "Length (km):", round(km, 1))) %>%
      addPolylines(data = ibdpm, 
                   color = "darkred", 
                   weight = 4, 
                   group = "IB-DPM Channels",
                   layerId = ~channel_nu,
                   popup = ~paste("Channel", channel_nu, "<br>", "Length (km):", round(km, 1))) %>%
      addCircles(data = nodes, color = "black", radius = 20, group = "DSM2 Nodes", popup = ~paste("Node", NNUM)) %>%
      addLayersControl(
        overlayGroups = c("All DSM2 Channels", "IB-DPM Channels", "DSM2 Nodes"),
        baseGroups = c("Terrain", "Black & White"),
        options = layersControlOptions(collapsed = FALSE)
      )
  )
})





