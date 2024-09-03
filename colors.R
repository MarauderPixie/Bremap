## colors ----
# basics
# lines etc: #443525
# geom fill: #f0f0f0
# plot bg: #efe8e1
col_plot_bg <- "#faf3e1"
col_strokes <- "#443525"
col_areas   <- "#efe8e1" # "#f0f0f0"

# pergament colors
pergamono <- c("#201912", "#413324", "#624c36",
               "#836648", "#a4805a", "#b6997b",
               "#c8b29c", "#daccbd", "#ece5de")

pergadiv <- c("#bfa58a", "#89bfa5", "#89a3bf", "#bf89a3")

perganeutral <- c("#bfa58a","#bfb289","#bebf89",
                  "#b1bf89","#a3bf89","#96bf89")

## ggplot theme & defaults ----
theme_set(
  theme_void(base_family = "Yrsa Medium") +
    theme(
      # text = element_text(family = "TlwgTypewriter"),
      legend.position = "none",
      panel.background = element_rect(fill = col_plot_bg),
      plot.background =  element_rect(fill = col_plot_bg),
      strip.background = element_rect(fill = col_plot_bg),
    )
)

update_geom_defaults("point", list(colour = col_strokes))
update_geom_defaults("line", list(colour = col_strokes))
update_geom_defaults("area", list(colour = "transparent",
                                  fill   = pergamono[8]))
update_geom_defaults("rect", list(colour = "transparent",
                                  fill   = pergamono[8]))
update_geom_defaults("sf", list(colour = "transparent",
                                fill   = pergamono[8]))
update_geom_defaults("density", list(colour = col_strokes,
                                     fill   = pergamono[8]))
update_geom_defaults("bar", list(colour = col_plot_bg,
                                 fill   = pergamono[8]))
update_geom_defaults("col", list(colour = col_plot_bg,
                                 fill   = pergamono[8]))
update_geom_defaults("text", list(colour = pergamono[2]))
update_geom_defaults("label", list(colour = pergamono[2]))


base_plot <- ggplot() +
  scale_fill_manual(values = perganeutral) +
  scale_color_manual(values = perganeutral)
