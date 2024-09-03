# Die Bauwerke Shapefile ist riesig und wird hier verkleinert
ortsteile <- read_sf("shapefiles/Verwaltungsgrenzen/hb_ortsteile_BRE.shp") %>%
  st_transform(crs = "EPSG:5677")
bauwerke <- read_sf("shapefiles/Liegenschaften/GebaeudeBauwerk.shp") %>%
  st_transform(crs = "EPSG:5677")

zentrum <- ortsteile %>%
  filter(bez_st %in% c("Mitte", "Neustadt", "Östliche Vorstadt",
                       "Schwachhausen", "Findorff"),
         !(bez_ot %in% c("In den Hufen", "Riensberg", "Huckelriede",
                         "Radio Bremen", "Neuenland", "Neu-Schwachhausen")))

ostvor <- ortsteile %>%
  filter(bez_st == "Östliche Vorstadt")

ostvor_buff <- st_buffer(st_centroid(ostvor), 1000)
ostvor_bbox <- ostvor_buff %>%
  st_bbox() %>%
  st_as_sfc()
bbox_bauwerke <- st_intersection(ostvor_bbox, bauwerke)

zentrum_bauwerke <- bauwerke[zentrum, ]
ostvor_bauwerke  <- zentrum_bauwerke[ostvor, ]

saveRDS(zentrum_bauwerke, "shapefiles/zentrum_bauwerke.rds")
saveRDS(ostvor_bauwerke, "shapefiles/ostvor_bauwerke.rds")
saveRDS(bbox_bauwerke, "shapefiles/bbox_bauwerke.rds")
