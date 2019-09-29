#args = commandArgs(trailingOnly = TRUE)
require(rgdal)
setwd("/var/www/ntt.226.cbntt.org/public/download/NTT_Example")
print("antes")
print(getwd())
​shfile = readOGR(NTT_Example.shp, layer='NTT_Example', verbose=TRUE)​
print(shfile)

polys = attr(shfile,'polygons')​
npoly<-length(polys)​

for (i in 1:npoly){​
	ncoords<-length(shfile@polygons[[i]]@Polygons[[1]]@coords)/2
	 cat(paste0(" Field: AOI",i,"|"))
	for(j in 1:ncoords) {
  		cat(paste0(shfile@polygons[[i]]@Polygons[[1]]@coords[j,1],",",shfile@polygons[[i]]@Polygons[[1]]@coords[j,2])​," ")
	}
}
