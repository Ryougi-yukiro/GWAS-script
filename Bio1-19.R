
library(raster)
## Loading required package: sp
library(openxlsx)
locations <- read.csv("https://simplemaps.com/static/data/world-cities/basic/simplemaps-worldcities-basic.csv", header = TRUE)
write.csv(locations, "locations.csv")
locations <- read.csv("locations.csv")
locations30 <- locations[sample(1:nrow(locations), 30),]
colnames(locations30)

coordinates(locations30) = c("lng","lat") # specify column names
coordinates(locations30)
### 年均温
bio1 <- raster("CHELSA_bio10_1.tif")
plot(bio1, main="Annual Mean Temperature", 
     xlab="Longitude", ylab="Latitude", col=rev(heat.colors(100)))

res_bio1 <- extract(x = bio1, y = locations30)
