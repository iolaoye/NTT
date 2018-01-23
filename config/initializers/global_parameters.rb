#######################################################
# Global variables used in the application
#######################################################


# URL to the mapping application
	URL_MAP = 'http://nn.tarleton.edu/GoogleMapNRCS_Test/Default.aspx'
	#URL_MAP = 'http://nn.tarleton.edu/NTTRails/Default.aspx'

#NTT verision
	VERSION = "NTTG3"

# URL to send information to NTT, which return the results
	URL_NTT = 'http://nn.tarleton.edu/NTTRails/NNRestService.ashx' 
	#URL_NTT1 = 'http://45.40.132.224/NNMultipleStates/NNRestService.ashx' 

# URL to get heat units
	URL_HU = 'http://nn.tarleton.edu/weather/service.asmx?WSDL'

# URL to get weather information
	URL_Weather = 'http://nn.tarleton.edu/weather/service.asmx?WSDL'

# URL to get soils information
	URL_SoilsInfo = 'http://nn.tarleton.edu/GetSoils/NTTservice.asmx?WSDL'

#APEX folders.
	APEX = "public/NTTFiles"
	APEX_FOLDER = "E:/NTTHTML5Files"
	APEX_ORIGINAL = 'public/APEX1'

#folder for examples
	EXAMPLES = "public/Examples"

#folder for own weather files
	OWN = 'public/weather'

#folder for Prism weather, wind, and wp1 files
	PRISM = 'E:/Weather/weatherFiles/US'
	PRISM1 = 'E:/Weather/weatherFiles/1981-2015'
	PRISM2 = 'E:/Weather/weatherFiles/borrar'
	WP1 = 'E:/Weather/wp1File'
	WIND = 'E:/Weather/wndFile'

#folder for download project files
	DOWNLOAD = 'public/download'

#folder for wick program - this is to print results in pdf file
	r_root = Rails.root.to_s
	WICK_FOLDER = r_root + '/public/Wicked/bin/'

	host_os = RbConfig::CONFIG['host_os']
	case host_os
	when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
		#windows dev
		WICK_ENV = WICK_FOLDER + 'wkhtmltopdf.exe'
	when /darwin|mac os/
		#osx dev
		WICK_ENV = "#{ENV['GEM_HOME']}/gems/wkhtmltopdf-binary-#{Gem.loaded_specs['wkhtmltopdf-binary'].version}/bin/wkhtmltopdf_darwin_x86"
	when /linux/
		#linux prod
		WICK_ENV = "#{ENV['GEM_HOME']}/gems/wkhtmltopdf-binary-#{Gem.loaded_specs['wkhtmltopdf-binary'].version}/bin/wkhtmltopdf_linux_amd64"
	when /solaris|bsd/
	else
		WICK_ENV = "#{ENV['GEM_HOME']}/gems/wkhtmltopdf-binary-#{Gem.loaded_specs['wkhtmltopdf-binary'].version}/bin/wkhtmltopdf_linux_amd64"
	end


#convertion values
	AC_TO_HA = 0.404685645
	AC_TO_FT2 = 43560
	FT_TO_M = 0.3048
	FT_TO_KM = 0.0003048
	FT_TO_HA = 0.0000093
	IN_TO_MM = 25.4
	THA_TO_TAC = 0.446   # METRIC TONS / HA TO US TONS / AC
	LBS_TO_KG = 0.453592
	AC_TO_M2 = 4046.85645
	IN_TO_CM = 2.54
	MM_TO_IN = 0.03937007874
	KG_TO_LBS = 2.204622621849
	HA_TO_AC = 2.4710538147
	T_STATISTIC_EVALUATED = 1.96   # 1.96 (5% significance two-tails, 1.645 10% siginificance two-tails according to Edward 1.96 is better)
	FT2_TO_M2 = 0.092903
	FT_TO_MM = 304.8
	AC_TO_KM2 = 0.00404685643
	KM2_TO_HA = 247.10538147
	HA_TO_M2 = 10000
	KM_TO_M = 1000
	FSEFF = 1.0
	MAX_STRIPS = 6
	PO4_TO_P2O5 = 0.4364
#field constants
	SMZ = '_SMZ'
	ROAD = '_Road'
	Crop_Road = 191  #191 is the crop id but the number is 300

