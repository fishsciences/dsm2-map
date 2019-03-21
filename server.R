shinyServer(function(input, output, session) {
  
  selChannelNodes <- reactive({
    req(input$selected_channel)
    d = filter(channel_df, chan_no == input$selected_channel)
    c("up" = d[["upnode"]], "down" = d[["downnode"]])
  })
  
  # toyed around with the idea of adding labels to map to indicate up and down nodes (rather than displaying text in the panel)
  # but didn't want to deal with complication of another level of groups and layers
  output$upNode <- renderText({
    paste("Upstream node:", selChannelNodes()[["up"]])
  })
  
  output$downNode <- renderText({
    paste("Downstream node:", selChannelNodes()[["down"]])
  })
  
  output$Map = renderLeaflet({
    leaflet() %>%
      setView(lng = -121.56, lat = 38.15, zoom = 10)
  })
  
  observeEvent(input$map_back,{
    delta.map = leafletProxy("Map", session) %>%
      addProviderTiles(input$map_back) %>%
      clearShapes() %>%
      addPolylines(data = flowlines, 
                   color = "darkgreen", 
                   weight = 6, 
                   group = "channels",
                   layerId = ~channel_nu) %>%
      addCircles(data = nodes, 
                 color = "black", 
                 radius = 60, 
                 opacity = 0.95,
                 fillOpacity = 0.95,
                 group = "nodes",
                 layerId = ~NNUM)
  })
  
  # highlight selected channel and node
  chan_sel <- function(map, channel){
    addPolylines(map,
                 data = subset(flowlines, channel_nu == channel),
                 color = "#FDE725FF",
                 weight = 8,
                 opacity = 0.95,
                 group = "channels",
                 layerId = "SelectedChannel")
  }
  
  node_sel <- function(map, node){
    addCircles(map,
               data = subset(nodes, NNUM == node),
               color = "#FDE725FF",
               radius = 80,
               opacity = 0.95,
               fillOpacity = 0.95,
               group = "nodes",
               layerId = "SelectedNode")
  }
  
  # update the location selectInput on map clicks
  observeEvent(input$Map_shape_click, {
    p <- input$Map_shape_click
    if(!is.null(p$id)){
      if (p$group == "channels"){
        if (p$id != "SelectedChannel"){  # 'SelectedChannel' layer placed on top of channel layer; don't want to update when 'Channel' layer clicked
          if(is.null(input$selected_channel) || input$selected_channel != p$id){
            updateSelectInput(session, "selected_channel", selected = p$id)
          }
        }else{
          updateSelectInput(session, "selected_channel", selected = "")
        }
      }else{
        if (p$id != "SelectedNode"){ 
          if(is.null(input$selected_node) || input$selected_node != p$id){
            updateSelectInput(session, "selected_node", selected = p$id)
          }
        }else{
          updateSelectInput(session, "selected_node", selected = "")
        }
      }
    }
  })
  
  # update the map markers and view on map clicks
  observeEvent(input$Map_shape_click, {
    p <- input$Map_shape_click
    proxy <- leafletProxy("Map")
    if (p$group == "channels"){
      if(p$id == "SelectedChannel"){
        proxy %>% removeShape(layerId="SelectedChannel")
      } else {
        proxy %>% setView(lng=p$lng, lat=p$lat, input$Map_zoom) %>% chan_sel(p$id)
      }
    }else{
      if(p$id == "SelectedNode"){
        proxy %>% removeShape(layerId="SelectedNode")
      } else {
        proxy %>% setView(lng=p$lng, lat=p$lat, input$Map_zoom) %>% node_sel(p$id)
      }
    }
  })
  
  # update the map markers and view on location when selected channel changes
  observeEvent(input$selected_channel, {
    p <- input$Map_shape_click
    p2 <- filter(cll, channel_nu == input$selected_channel)
    proxy <- leafletProxy("Map")
    if(nrow(p2)==0){  
      proxy %>% removeShape(layerId = "SelectedChannel")
    } else if(length(p$id) && input$selected_channel != p$id){    # length(p$id) evaluated as 0 or 1, which is interpreted as TRUE/FALSE
      proxy %>% setView(lng = p2$lon, lat = p2$lat, input$Map_zoom) %>% chan_sel(input$selected_channel)
    } else if(!length(p$id)){
      proxy %>% setView(lng = p2$lon, lat = p2$lat, input$Map_zoom) %>% chan_sel(input$selected_channel)
    }
  })
  
  # update the map markers and view on location when selected node changes
  observeEvent(input$selected_node, {
    p <- input$Map_shape_click
    p2 <- filter(nll, NNUM == input$selected_node)
    proxy <- leafletProxy("Map")
    if(nrow(p2)==0){  
      proxy %>% removeShape(layerId = "SelectedNode")
    } else if(length(p$id) && input$selected_node != p$id){    # length(p$id) evaluated as 0 or 1, which is interpreted as TRUE/FALSE
      proxy %>% setView(lng = p2$lon, lat = p2$lat, input$Map_zoom) %>% node_sel(input$selected_node)
    } else if(!length(p$id)){
      proxy %>% setView(lng = p2$lon, lat = p2$lat, input$Map_zoom) %>% node_sel(input$selected_node)
    }
  })
  
})





