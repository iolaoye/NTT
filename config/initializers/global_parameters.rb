﻿#######################################################
# Global variables used in the application
#######################################################


# URL to the mapping application
	URL_MAP = 'http://nn.tarleton.edu/GoogleMapPost/Default.aspx'
	#URL_MAP = 'http://nn.tarleton.edu/NTTRails/Default.aspx'

#NTT verision
	VERSION = "NTTG3"

# URL to send information to NTT, which return the results
	URL_NTT = 'http://nn.tarleton.edu/NttApex/NNRestService.ashx'

# URL to get heat units
	URL_HU = 'http://nn.tarleton.edu/NTTCalcHU/NTTService.asmx?WSDL'

#APEX folders.
	APEX = "C:/Borrar/NTTFiles"

#folder for own weather files
	OWN = 'public/weather'

#folder for Prism weather, wind, and wp1 files
	PRISM = 'X:/Weather/weatherFiles/US'
	WP1 = 'X:/Weather/wp1File'
	WIND = 'X:/Weather/wndFile'

#folder for download project files
	DOWNLOAD = 'public/download'

#public folder
	APEX_ORIGINAL = 'public/APEX1'

#convertion values
	AC_TO_HA = 0.404685645
	FT_TO_M = 0.3048
	FT_TO_HA = 0.0000093
	IN_TO_MM = 25.4
	THA_TO_TAC = 0.446
	LBS_TO_KG = 0.453592
	AC_TO_M2 = 4046.85645
	IN_TO_CM = 2.54
	MM_TO_IN = 0.03937007874
	KG_TO_LBS = 2.204622621849
	HA_TO_AC = 2.47105384
	T_STATISTIC_EVALUATED = 1.645
	FT2_TO_M2 = 0.092903
#field constants
	SMZ = '_SMZ'
	ROAD = '_Road'
	Crop_Road = 191  #191 is the crop id but the number is 300

