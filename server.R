shinyServer(function(input, output, session) {
  
  output$Map = renderLeaflet({
    leaflet() %>%
      setView(lng = -121.56, lat = 38.15, zoom = 10) %>%
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
  
  proxyMap = leafletProxy("Map")
  
  observeEvent(input$map_back,{
    proxyMap %>% addProviderTiles(input$map_back) 
  })
  
  observeEvent(input$Map_shape_click, {
    # SelectedChannel and SelectedNode are used to indicate that the user has clicked on a feature that is currently selected
    # app responds by setting dropdown menu to empty which triggers removal of the selected line or circle
    # if the user clicks on an unselected channel or node, then the channel or node number are returned as the layer id (i.e., p$id)
    p <- input$Map_shape_click
    req(p$id)
    select_input = case_when( # select input that will be updated
      p$group == "channels" ~ "selected_channel",
      TRUE                  ~ "selected_node"
    )
    if (p$id %in% c("SelectedChannel", "SelectedNode", "UpNode")){
      new_value = ""      # used in updateSelectInput below
      proxyMap %>% removeShape(layerId = p$id)
    }else{
      new_value = p$id
      proxyMap %>% setView(lng=p$lng, lat=p$lat, input$Map_zoom) %>% mark_selected(p$group, p$id)
    } 
    updateSelectInput(session, select_input, selected = new_value)  # update the location selectInput on map clicks
  })
  
  # update the map markers and view when selected channel changes
  observeEvent(input$selected_channel, {
    cll_sub <- filter(cll, channel_nu == input$selected_channel)
    upnode <- filter(channel_df, chan_no == input$selected_channel)[["upnode"]]
    if(nrow(cll_sub) == 0){  
      proxyMap %>% removeShape(layerId = "SelectedChannel") %>% removeShape(layerId = "UpNode")
    }else{
      proxyMap %>% setView(lng = cll_sub$lon, lat = cll_sub$lat, input$Map_zoom) %>% mark_selected("channels", input$selected_channel, upnode)
    }
  })
  
  # update the map markers and view on location when selected node changes
  observeEvent(input$selected_node, {
    p <- input$Map_shape_click
    nll_sub <- filter(nll, NNUM == input$selected_node)
    if(nrow(nll_sub) == 0){  
      proxyMap %>% removeShape(layerId = "SelectedNode")
    }else{
      proxyMap %>% setView(lng = nll_sub$lon, lat = nll_sub$lat, input$Map_zoom) %>% mark_selected("nodes", input$selected_node)
    }
  })
  
})





