####Generate clipping mask Orinoquia data ######################################


setwd("C:/Users/silvi/Documents/WCS/SNAPP/Data/IGAC/DivisiónPolíticaCol")

require(rgdal)
require(maptools)
require(rgeos)

#upload IGAC political map of Colombia
municipios<-readShapeSpatial("C:/Users/silvi/Documents/WCS/SNAPP/Data/IGAC/DivisiónPolíticaCol/Municipios", proj4string = CRS("+proj=tmerc 
                            +lat_0=4.596200416666666 +lon_0=-74.07750791666666 
                           +k=1 +x_0=1000000 +y_0=1000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 
                                                             +units=m +no_defs"))
                             
plot(municipios)

#plot only Orinoquia
plot(municipios[municipios@data$NOM_DEPART %in% c("ARAUCA", "CASANARE", "META", 
                                                  "VICHADA"),])

#save Orinoquia as shape
ori_municipios<-municipios[municipios@data$NOM_DEPART %in% c("ARAUCA", "CASANARE", "META", 
                                             "VICHADA"),]
writeSpatialShape(ori_municipios, "MunicipiosOrinoquia")

#merge municipios by department
ori_municipios<-readOGR("MunicipiosOrinoquia.shp", layer="MunicipiosOrinoquia")

orinoco<-gUnaryUnion(ori_municipios, id=ori_municipios@data$NOM_DEPART)
plot(orinoco)

row.names(orinoco)<-as.character(1:length(orinoco))
head(ori_municipios@data)
d1<-unique(ori_municipios@data$NOM_DEPART)
d1<-as.data.frame(d1)
orinoco_depts<-SpatialPolygonsDataFrame(orinoco, d1)

##merge all departments into a single region
orinoco_depts@data$region<-rep("Orinoco", 4)
orinoco<-gUnaryUnion(orinoco_depts, id=orinoco_depts@data$region)
plot(orinoco)

row.names(orinoco)<-as.character(1:length(orinoco))
d2<-"Orinoco"
d2<-as.data.frame(d2)
orinoco<-SpatialPolygonsDataFrame(orinoco, d2)
plot(orinoco)

##adjust projection for departments and region

proj4string(orinoco_depts)<- CRS("+proj=tmerc +lat_0=4.596200416666666 
                                 +lon_0=-74.07750791666666 +k=1 +x_0=1000000 +y_0=1000000 
                                 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

proj4string(orinoco)<- CRS("+proj=tmerc +lat_0=4.596200416666666 
                                 +lon_0=-74.07750791666666 +k=1 +x_0=1000000 +y_0=1000000 
                           +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

save(orinoco, orinoco_depts, file="Orinoco_masks.robj")

png("Orinoco.png")
plot(orinocoWGS)
dev.off()
