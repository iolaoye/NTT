args = commandArgs(trailingOnly = TRUE)
require(rgdal)
​print(args)
shfile <- readOGR(args[1], layer="NTT_Example")​
polys = attr(shfile,'polygons')​
npoly<-length(polys)​

for (i in 1:npoly){​
	ncoords<-length(shfile@polygons[[i]]@Polygons[[1]]@coords)/2
	 cat(paste0(" Field: AOI",i,"|"))
	for(j in 1:ncoords) {
  		cat(paste0(shfile@polygons[[i]]@Polygons[[1]]@coords[j,1],",",shfile@polygons[[i]]@Polygons[[1]]@coords[j,2])​," ")
	}
}
