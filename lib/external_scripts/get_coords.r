#tryCatch({require(rgdal)},
#        error = function(w) {msg0 <<- w})
#
args = commandArgs(trailingOnly = TRUE)
require(rgdal)
s_f_org = readOGR(dsn=args[1])
s_f = spTransform(s_f_org, CRS("+proj=longlat +datum=WGS84"))
polys = attr(s_f_org,'polygons')
npoly<-length(polys)
for (i in 1:npoly){
	sub_polys = length(s_f@polygons[[i]]@Polygons)
	for(l in 1:sub_polys) {
    	ncoords<-length(s_f@polygons[[i]]@Polygons[[l]]@coords)/2
    	field_name = as.character(s_f$FIELD[i])
    	if(identical(character(0), field_name)) { cat(paste0(" Field: AOI",i,"_",l,"|")) }
    	else cat(paste0(" Field: ",field_name,"_",l,"|"))
    	for(j in 1:ncoords) {
        	cat(paste0(s_f@polygons[[i]]@Polygons[[l]]@coords[j,1],",",s_f@polygons[[i]]@Polygons[[l]]@coords[j,2]),"")
    	}
    }
}




