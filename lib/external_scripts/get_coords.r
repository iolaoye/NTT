args = commandArgs(trailingOnly = TRUE)
require(rgdal)
#setwd("public/download/NTT_Example")
#print("antes")
#print(getwd())
​shape_file = readOGR(dsn=args[1], layer='NTT_Example', verbose=TRUE)​
#print(shfile)

polys = attr(​shape_file,'polygons')​
npoly<-length(polys)​

for (i in 1:npoly){​
	ncoords<-length(​shape_file@polygons[[i]]@Polygons[[1]]@coords)/2
	 cat(paste0(" Field: AOI",i,"|"))
	for(j in 1:ncoords) {
  		cat(paste0(​shape_file@polygons[[i]]@Polygons[[1]]@coords[j,1],",",​shape_file@polygons[[i]]@Polygons[[1]]@coords[j,2])​," ")
	}
}
