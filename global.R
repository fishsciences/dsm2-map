library(rgdal)
library(leaflet)
library(dplyr)


ibdpm = readOGR(dsn = "./shapefiles", layer = "IBDPMChannelsLatLong")
nodes = readOGR(dsn = "./shapefiles", layer = "NodesLatLong")
flowlines = readOGR(dsn = "./shapefiles", layer="FlowlinesLatLong")
cll = read.csv("ChannelLatLong.csv")
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



