library(shiny)
library(shinyWidgets)
library(leaflet)
library(rgdal)
library(dplyr)

channel_df = read.csv("ChannelInfo.csv")
nodes = readOGR(dsn = "./shapefiles", layer = "NodesLatLong")
nll = nodes@data %>% rename(lon = X, lat = Y)
flowlines = readOGR(dsn = "./shapefiles", layer="FlowlinesLatLong")
cll = read.csv("ChannelLatLong.csv")

# # Code below only needs to be run if shapefiles change
# flowlines@data$id = rownames(flowlines@data)
# all.points = ggplot2::fortify(flowlines, channel_nu = "id")
# all.df = plyr::join(all.points, flowlines@data, by = "id") %>%
#   mutate(chan.ord = paste(channel_nu, order, sep = "."))
# # find approximate midpoint of channel
# mid = all.df %>%
#   group_by(channel_nu) %>%
#   summarise(mid = round(median(order, na.rm = TRUE), 0)) %>%
#   mutate(chan.ord = paste(channel_nu, mid, sep = "."))
# # nad = new all.df
# nad = all.df %>%
#   filter(chan.ord %in% mid$chan.ord) %>%
#   select(long, lat, channel_nu)
# write.csv(nad, "ChannelLatLong.csv", row.names = FALSE)

# function to highlight selected channel or node
mark_selected <- function(map, group_name, layer_id, upnode = NULL){
  if (group_name == "channels"){
    addPolylines(map,
                 data = subset(flowlines, channel_nu == layer_id),
                 color = "#FDE725FF",
                 weight = 8,
                 opacity = 0.95,
                 group = group_name,
                 layerId = "SelectedChannel") %>% 
      addCircles(data = subset(nodes, NNUM == upnode),
                 color = "red",
                 radius = 80,
                 opacity = 0.95,
                 fillOpacity = 0.95,
                 group = group_name,
                 layerId = "UpNode")
  }else{
    addCircles(map,
               data = subset(nodes, NNUM == layer_id),
               color = "#FDE725FF",
               radius = 80,
               opacity = 0.95,
               fillOpacity = 0.95,
               group = group_name,
               layerId = "SelectedNode")
  }
}


