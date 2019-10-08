args = commandArgs(trailingOnly = TRUE)
require(rgdal)
s_f_org = readOGR(dsn=args[1])
s_f = spTransform(s_f_org, CRS("+proj=longlat +datum=WGS84"))
polys = attr(s_f_org,'polygons')
npoly<-length(polys)
for (i in 1:npoly){
    ncoords<-length(s_f@polygons[[i]]@Polygons[[1]]@coords)/2
    cat(paste0(" Field: AOI",i,"|"))
    for(j in 1:ncoords) {
        cat(paste0(s_f@polygons[[i]]@Polygons[[1]]@coords[j,1],",",s_f@polygons[[i]]@Polygons[[1]]@coords[j,2]),"")
    }
}

