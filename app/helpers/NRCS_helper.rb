module NrcsHelper
  def get_soils_nrcs
	url_soils = "https://sdmdataaccess.sc.egov.usda.gov/Tabular/SDMTabularService.asmx?WSDL"

	req = "SELECT hydgrp as horizdesc2,compname as seriesname,albedodry_r as albedo,comppct_r as compct,sandtotal_r as sand,silttotal_r as silt, 100-sandtotal_r-silttotal_r as clay, dbthirdbar_r as bd,om_r as om,texdesc as texture,ph1to1h2o_r as ph,hzdepb_r as ldep,drainagecl as horizgen,ecec_r as cec,muname, slope_r FROM sacatalog sac INNER JOIN legend l ON l.areasymbol = sac.areasymbol AND l.areatypename = 'Non-MLRA Soil Survey Area' INNER JOIN mapunit mu ON mu.lkey = l.lkey LEFT OUTER JOIN component c ON c.mukey = mu.mukey LEFT OUTER JOIN chorizon ch ON ch.cokey = c.cokey LEFT OUTER JOIN chtexturegrp chtgrp ON chtgrp.chkey = ch.chkey LEFT OUTER JOIN chtexture cht ON cht.chtgkey = chtgrp.chtgkey LEFT OUTER JOIN chtexturemod chtmod ON chtmod.chtkey = cht.chtkey WHERE l.areasymbol='TX143' AND mu.mukey='365419' AND musym='WoC' AND hydgrp<>'' AND hzdepb_r <> '' ORDER BY mu.mukey, compname, hzdepb_r"
	client = Savon.client(wsdl: url_soils)

	response = client.call(:run_query, message: {"Query" => req})

	msg = response.body[:run_query_response][:run_query_result][:diffgram][:new_data_set][:table]

  end
end
