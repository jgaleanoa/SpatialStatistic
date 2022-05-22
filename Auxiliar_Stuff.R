# # Se transforma a formato sf
# datos_geo2 <- st_as_sf(as.data.frame(datos_geo), 
#                        coords = c("x", "y"),
#                        remove = FALSE, agr = "constant",
#                        crs = "+proj=utm +zone=16 ellps=WGS84")
# 
# # Se construye el variograma muestral con tendencia (libreria gstat)
# vario <- variogram(Temperatura ~ x + y, datos_geo2,
#                    cutoff = 200000)
# 
# # Se ajusta un modelo de variograma gaussiano
# fit <- fit.variogram(vario, vgm(model = "Gau", nugget = NA), fit.method = 2)
# 
# # Se define la malla de predicciones
# buffer <- Indianashputm %>%
#   st_geometry() %>%
#   st_buffer(40)
# 
# 
# grid <- buffer %>% 
#   st_as_stars(nx = 100, ny = 100)
# 
# grid <- grid %>% 
#   st_crop(buffer)
# 
# pred <- krige(formula = Temperatura ~ x + y,
#               locations = datos_geo2, model = fit,
#               newdata = grid)
# 
# prueba <- krige.cv(Temperatura ~ x + y, datos_geo2, model = fit)
# saveRDS(prueba, "cv_uk.Rds")
# 
# grid$var1.pred <- pred$var1.pred
# grid$var1.var <- pred$var1.var
# 
# plot(grid["var1.pred"], breaks = "equal", 
#      col = viridis::inferno(20), 
#      key.pos = 4,
#      main = "Kriging universal (predicciones)")
# 
# plot(grid["var1.var"] %>% sqrt(), breaks = "equal",
#      col = viridis::inferno(20), 
#      key.pos = 4,
#      main = "Kriging universal (desviación estándar)")
# 
# 
# poly <- st_cast(Indianashputm$geometry, to = "POLYGON")
# polys <- SpatialPolygonsDataFrame(as_Spatial(poly), )
# datos_geo3 <- SpatialPolygonsDataFrame() 
# ggplot() +
#   geom_stars(data = grid, aes(fill = var1.pred, x = x, y = y)) +
#   scale_fill_viridis_c() + 
#   geom_sf(data = datos_geo2) +
#   geom_sf(data = Indianashputm) +
#   coord_sf(lims_method = "geometry_bbox")
# 
# 
# pa1 <- ggplot() + 
#   geom_stars(data = grid, aes(fill = var1.pred, x = x, y = y)) +
#   geom_sf(data = Indianashputm, fill = NA) +
#   geom_sf(data = datos_geo2) +
#   scale_fill_viridis_c(na.value = "white") +
#   labs(title = "Mejor modelo (predicción)",
#        fill = "Temperatura \npromedio") +
#   theme_classic() +
#   theme(axis.ticks = element_blank(),
#         axis.text = element_blank(),
#         axis.title = element_blank(),
#         plot.title = element_text(hjust = 0.5))
# 
# pa2 <- ggplot() + 
#   geom_stars(data = grid, aes(fill = sqrt(var1.var), x = x, y = y)) +
#   geom_sf(data = Indianashputm, fill = NA) +
#   geom_sf(data = datos_geo2) +
#   scale_fill_viridis_c(na.value = "white") +
#   labs(title = "Mejor modelo (desviación estándar)", 
#        fill = "Temperatura \npromedio") +
#   theme_classic() +
#   theme(axis.ticks = element_blank(),
#         axis.text = element_blank(),
#         axis.title = element_blank(),
#         plot.title = element_text(hjust = 0.5))
# 
# saveRDS(pa1, "pa1.Rds")
# saveRDS(pa2, "pa2.Rds")
# pa1 <- readRDS("pa1.Rds")
# pa2 <- readRDS("pa2.Rds")
# 
# 
# 

# grid_points <- st_sfc(st_multipoint(as.matrix(prediction_grid)))
# st_crs(grid_points) <- CRS("+proj=utm +zone=16 ellps=WGS84")
# Indianapoly <- st_transform(Indianashputm$geometry, CRS("+proj=utm +zone=16 ellps=WGS84"),"POLYGON")
# grid_map <- st_intersection(Indianapoly, grid_points)
# plot(grid_map, cex = 0.2, main = "Puntos de predicción", 
#      axes = T, xaxt = "n", yaxt = "n")
