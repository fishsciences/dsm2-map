library(shiny)
library(shinyWidgets)
library(leaflet)
library(rgdal)
library(dplyr)

stations = readOGR(dsn = "./shapefiles", layer = "Stations_EPSG_4326") %>% 
  subset(!is.na(RKI) & !(!is.na(Alias) & RKI %in% c("RSAC075", "RSAC092", "RSAN007"))) # a few stations have duplicate entries; Alias column separates those 3 stations to remove duplicate RKIs
sll = stations@data %>% rename(lon = xcoord, lat = ycoord) %>% mutate(RKI = as.character(RKI))
nodes = readOGR(dsn = "./shapefiles", layer = "Nodes_EPSG_4326")
nll = nodes@data %>% rename(lon = X, lat = Y)
flowlines = readOGR(dsn = "./shapefiles", layer = "Flowlines_EPSG_4326")
cll = read.csv("ChannelLatLon.csv")

radius = 200 # radius of circles representing stations and nodes
fill_opacity = 0.7

# # Code below only needs to be run if flowlines shapefile changes
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
# write.csv(nad, "ChannelLatLon.csv", row.names = FALSE)

# function to highlight selected channel or node
mark_selected <- function(map, group_name, layer_id, up_node = NULL){
  if (group_name == "channels"){
    addPolylines(map,
                 data = subset(flowlines, channel_nu == layer_id),
                 color = "#FDE725FF",
                 weight = 8,
                 opacity = 0.95,
                 group = group_name,
                 layerId = "SelectedChannel") %>% 
      addCircles(data = subset(nodes, NNUM == up_node),
                 color = "red",
                 radius = radius,
                 opacity = 0.95,
                 fillOpacity = fill_opacity,
                 group = group_name,
                 layerId = "UpNode")
  }
  if (group_name == "nodes"){
    addCircles(map,
               data = subset(nodes, NNUM == layer_id),
               color = "#FDE725FF",
               radius = radius,
               opacity = 0.95,
               fillColor = "black",
               fillOpacity = fill_opacity,
               group = group_name,
               layerId = "SelectedNode")
  }
  if (group_name == "stations"){
    addCircles(map,
               data = subset(stations, RKI == layer_id),
               color = "#FDE725FF",
               radius = radius,
               opacity = 0.95,
               fillColor = "saddlebrown",
               fillOpacity = fill_opacity,
               group = group_name,
               layerId = "SelectedStation")
  }
}


