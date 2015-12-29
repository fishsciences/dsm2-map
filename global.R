library(rgdal)
library(leaflet)

flowlines = readOGR(dsn = "./shapefiles", layer="FlowlinesLatLong")
ibdpm = readOGR(dsn = "./shapefiles", layer = "IBDPMChannelsLatLong")
nodes = readOGR(dsn = "./shapefiles", layer = "NodesLatLong")

map = leaflet() %>% 
  addTiles(group = "Map") %>%
  addProviderTiles("MapQuestOpen.Aerial", group = "Aerial") %>%
  setView(lng = -121.77, lat = 38.14, zoom = 9) %>%
  addPolylines(data = flowlines, color = "blue", weight = 4, group = "All DSM2 Channels", popup = ~paste("Channel", channel_nu, "<br>",
                                                                                                         "Length (km):", round(km, 1))) %>%
  addPolylines(data = ibdpm, color = "darkred", weight = 4, group = "IB-DPM Channels", popup = ~paste("Channel", channel_nu, "<br>",
                                                                                                      "Length (km):", round(km, 1))) %>%
  addCircles(data = nodes, color = "black", radius = 20, group = "DSM2 Nodes", popup = ~paste("Node", NNUM)) %>%
  addLayersControl(
    overlayGroups = c("All DSM2 Channels", "IB-DPM Channels", "DSM2 Nodes"),
    baseGroups = c("Map", "Aerial"),
    options = layersControlOptions(collapsed = FALSE)
  )



