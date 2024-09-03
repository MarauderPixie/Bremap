library(tidyverse)
library(patchwork)
library(ragg)
library(sf)

# cosmetics ----
source("colors.R")

# helper function ----
label_pos <- function(dim, relpos) {
  map_range <- max(st_coordinates(geografie)[, dim]) - min(st_coordinates(geografie)[, dim])
  pos_sub <- relpos * map_range

  max(st_coordinates(geografie)[, dim]) - pos_sub
}

# read in data ----
# kataster <- read_sf("shapefiles/Liegenschaften/KatasterBezirk.shp")
geografie <- read_sf("shapefiles/Geologische_Karte/gk_gdfb_052024_inspire_HB.shp") %>%
  st_transform(crs = "EPSG:5677") %>%
  mutate(y = st_coordinates(st_centroid(.))[, 2]) %>%
  filter(y < 5890000) %>%
  select(-y)
ax_gewaesser <- read_sf("shapefiles/Basis_DLM/gew01_f.shp") %>%
  st_transform(crs = "EPSG:5677")
ortsteile <- read_sf("shapefiles/Verwaltungsgrenzen/hb_ortsteile_BRE.shp") %>%
  st_transform(crs = "EPSG:5677")
zentrum <- ortsteile %>%
  filter(bez_st %in% c("Mitte", "Neustadt", "Östliche Vorstadt",
                       "Schwachhausen", "Findorff"),
         !(bez_ot %in% c("In den Hufen", "Riensberg", "Huckelriede",
                         "Radio Bremen", "Neuenland", "Neu-Schwachhausen")))
ostvor <- ortsteile %>%
  filter(bez_st == "Östliche Vorstadt")
strassen <- read_sf("shapefiles/Strassennetz/Strassennetz.shp") %>%
  st_transform(crs = "EPSG:5677") %>%
  mutate(y = st_coordinates(st_centroid(.))[, 2]) %>%
  filter(y < 5920000) %>%
  select(-y)
ax_bahnstrecke <- read_sf("shapefiles/Basis_DLM/ver03_l.shp") %>%
  st_transform(crs = "EPSG:5677")

zentrum_bauwerke <- readRDS("shapefiles/zentrum_bauwerke.rds")
ostvor_bauwerke <- readRDS("shapefiles/ostvor_bauwerke.rds")
bbox_bauwerke <- readRDS("shapefiles/bbox_bauwerke.rds")
