# "remove" overlaps mit wasser
inter_geografie <- st_intersection(ax_gewaesser, geografie)
inter_zentrum   <- st_intersection(ax_gewaesser, zentrum)
inter_ostvor <- st_intersection(bbox_wasser, ostvor)

# reduce to relevant areas
ostvor_buff <- st_buffer(st_centroid(ostvor), 1000)
bbox_wasser <- st_intersection(st_as_sfc(st_bbox(ostvor_buff)), ax_gewaesser)

ostvor_centroids <- ostvor %>%
  st_centroid() %>%
  st_coordinates() %>%
  as_tibble()

ostvor_annotations <- tibble(
  ortsteil = ostvor$bez_ot,
  # x = c(3487747, 3489901, 3488907, 3488078), # pre-agg
  x = c(3487947, 3489651, 3488957, 3488278),
  xend = ostvor_centroids$X,
  # y = c(5883632, 5883584, 5881291, 5881466), # pre-agg
  y = c(5882982, 5883134, 5880991, 5881416),
  yend = ostvor_centroids$Y,
  curvature = c(0.2, 0.1, -0.1, -0.2),
  nudge_x = c(0, 50, -50, -50),
  nudge_y = c(50, 0, 0, 0),
  hjust = c(.5, 0, 1, 1),
  vjust = c(0, .5, .5, .5)
)

# final map WIP ----
ganz_brem <- base_plot +
  geom_sf(data = geografie) +
  geom_sf(data = inter_geografie, fill = col_plot_bg) +
  geom_sf(data = zentrum, aes(fill = bez_st)) +
  geom_sf(data = inter_zentrum, fill = col_plot_bg) +
  geom_sf(data = ax_gewaesser[ortsteile, ],
          fill = "darkblue", alpha = .4) +
  geom_sf(data = ax_bahnstrecke[st_buffer(ortsteile, 1500), ],
          color = "#624c36", linewidth = .3, linetype = 6) +
  geom_sf(data = filter(strassen, StrassenAr != "G")[st_buffer(ortsteile, 1200), ],
          color = "gray57", linewidth = .5) +
  geom_text(aes(x = 3502457, y = 5899260), hjust = 1, vjust = 1,
            family = "Playfair Display ExtraBold", label = "Hansestadt Bremen",
            size.unit = "pt", size = 44) +
  geom_sf(data = st_as_sfc(st_bbox(ostvor_buff)),
          fill = "transparent", color = pergamono[3],
          linetype = "5151", linewidth = .75)

viertel_zoom <- base_plot +
  geom_sf(data = ostvor, aes(fill = bez_ot), alpha = .7) +
  geom_sf(data = inter_ostvor, fill = col_plot_bg) +
  geom_sf(data = bbox_wasser,
          fill = "darkblue", alpha = .4) +
  geom_sf(data = bbox_bauwerke, color = pergamono[8]) +
  geom_sf(data = ostvor_bauwerke, color = pergamono[5]) +
  geom_curve(data = ostvor_annotations, curvature = .2,
             aes(x = x, xend = xend, y = y, yend = yend),
             color = pergamono[3]) +
  geom_label(data = ostvor_annotations, family = "Playfair Display Medium",
             aes(x = x, y = y, label = ortsteil, hjust = hjust, vjust = vjust),
             nudge_x = ostvor_annotations$nudge_x, nudge_y = ostvor_annotations$nudge_y,
             alpha = .6, fill = col_plot_bg, label.padding = unit(0.2, "lines"),
             label.r = unit(0.1, "lines"), label.size = 0, color = pergamono[2]) +
  geom_label(aes(x = 3487664, y = 5883384, label = "Östliche Vorstadt"),
             family = "Playfair Display SemiBold", size.unit = "pt", size = 20,
             alpha = .6, fill = col_plot_bg, label.padding = unit(0.2, "lines"),
             label.r = unit(0.1, "lines"), label.size = 0,
             hjust = 0, vjust = 0, nudge_x = -30) +
  theme(
    plot.margin = margin(0, 0, 0, 0)
  )


## create final map & save to png ----
agg_png("70x50.png", width = 70, height = 50,
        units = "cm", res = 300, scaling = 2.5)

ganz_brem + inset_element(
  viertel_zoom,
  right = .4,
  top = 0.6,
  left = unit(0, 'npc') + unit(.5, 'cm'),
  bottom = unit(0, 'npc') + unit(.5, 'cm')
)

dev.off()
