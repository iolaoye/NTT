module AplcatParametersHelper
 include SimulationsHelper
  def parameter_id
    [ [t('aplcat.nativer'), 1], [t('aplcat.introducedp'), 2] ]
  end

  #def fuel_id
    #[
      #[t("Gasoline"), 1], [t("Diesel"), 2]
    #]
  #end

  #def listnum
    #[
      #[t("First Trip"), 1], [t("Second Trip"), 2], [t("Third Trip"), 3], [t("Fourth Trip"), 4]
    #]
  #end

  def num_fmo
    [
      [t("1"), 1], [t("2"), 2], [t("3"), 3], [t("4"), 4], [t("5"), 5], [t("6"), 6], [t("7"), 7], [t("8"), 8],
      [t("9"), 9], [t("10"), 10], [t("11"), 11], [t("12"), 12], [t("13"), 13], [t("14"), 14], [t("15"), 15], [t("16"), 16],
      [t("17"), 17], [t("18"), 18], [t("19"), 19], [t("20"), 20]
    ]
  end

  def create_cow_calf_production_data
    apex_string = @aplcat.noc.to_s + "\t" + "! " + t('aplcat.parameter1') + "\n"
    apex_string += @aplcat.nomb.to_s + "\t" + "! " + t('aplcat.parameter2') + "\n"
    apex_string += @aplcat.norh.to_s + "\t" + "! " + t('aplcat.parameter3') + "\n"
    apex_string += @aplcat.nocrh.to_s + "\t" + "! " + t('aplcat.parameter4') + "\n"
    apex_string += @aplcat.prh.to_s + "\t" + "! " + t('aplcat.parameter5') + "\n"
    apex_string += @aplcat.prb.to_s + "\t" + "! " + t('aplcat.parameter6') + "\n"
    apex_string += @aplcat.abwc.to_s + "\t" + "! " + t('aplcat.parameter7') + "\n"
    apex_string += @aplcat.abwmb.to_s + "\t" + "! " + t('aplcat.parameter8') + "\n"   #average body weight of mature cows
    apex_string += @aplcat.abwh.to_s + "\t" + "! " + t('aplcat.parameter9') + "\n"
    apex_string += @aplcat.abwrh.to_s + "\t" + "! " + t('aplcat.parameter10') + "\n"
    apex_string += @aplcat.adwgbc.to_s + "\t" + "! " + t('aplcat.parameter11') + "\n"
    apex_string += @aplcat.adwgbh.to_s + "\t" + "! " + t('aplcat.parameter12') + "\n"
    apex_string += @aplcat.jdcc.to_s + "\t" + "! " + t('aplcat.parameter13') + "\n"
    apex_string += @aplcat.gpc.to_s + "\t" + "! " + t('aplcat.parameter14') + "\n"
    apex_string += @aplcat.tpwg.to_s + "\t" + "! " + t('aplcat.parameter15') + "\n"
    apex_string += @aplcat.csefa.to_s + "\t" + "! " + t('aplcat.parameter16') + "\n"
    apex_string += @aplcat.srop.to_s + "\t" + "! " + t('aplcat.parameter17') + "\n"
    apex_string += @aplcat.bwoc.to_s + "\t" + "! " + t('aplcat.parameter18') + "\n"
    apex_string += @aplcat.jdbs.to_s + "\t" + "! " + t('aplcat.parameter19') + "\n"
    apex_string += @aplcat.abc.to_s + "\t" + "! " + t('aplcat.parameter20') + "\n"
    apex_string += "\n"
    apex_string += "PARAMETER DETAILS" + "\n"
    apex_string += "\n"
    apex_string += "\n"
    apex_string += "Animal production data: Numbers and proportions" + "\n"
    apex_string += "\n"
    apex_string += "Parameter 1" + "\t" + t('aplcat.noc') + "\n"
    apex_string += "Parameter 2" + "\t" + t('aplcat.nomb') + "\n"
    apex_string += "Parameter 3" + "\t" + t('aplcat.norh') + "\n"
    apex_string += "Parameter 4" + "\t" + t('aplcat.nocrh') + "\n"
    apex_string += "Parameter 5" + "\t" + t('aplcat.prh') + "\n"
    apex_string += "Parameter 6" + "\t" + t('aplcat.prb') + "\n"
    apex_string += "\n"
    apex_string += "Animal production data: Animal weights and rate of weight gain (Unit: lb)" + "\n"
    apex_string += "\n"
    apex_string += "Parameter 7" + "\t" + t('aplcat.abwc') + "\n"
    apex_string += "Parameter 8" + "\t" + t('aplcat.abwmb') + "\n"
    apex_string += "Parameter 9" + "\t" + t('aplcat.abwh') + "\n"
    apex_string += "Parameter 10" + "\t" + t('aplcat.abwrh') + "\n"
    apex_string += "Parameter 11" + "\t" + t('aplcat.adwgbc') + "\n"
    apex_string += "Parameter 12" + "\t" + t('aplcat.adwgbh') + "\n"
    apex_string += "\n"
    apex_string += "Animal production data: Breed, Pregnancy, calving, and weaning" + "\n"
    apex_string += "\n"
    apex_string += "Parameter 13" + "\t" + t('aplcat.jdcc') + "\n"
    apex_string += "Parameter 14" + "\t" + t('aplcat.gpc') + "\n"
    apex_string += "Parameter 15" + "\t" + t('aplcat.tpwg') + "\n"
    apex_string += "Parameter 16" + "\t" + t('aplcat.csefa') + "\n"
    apex_string += "Parameter 17" + "\t" + t('aplcat.srop') + "\n"
    apex_string += "Parameter 18" + "\t" + t('aplcat.bwoc') + "\n"
    apex_string += "Parameter 19" + "\t" + t('aplcat.jdbs') + "\n"
    apex_string += "Parameter 20" + "\t" + t('aplcat.abc') + "\n"
    apex_string += "\n"
    apex_string += "FORMAT AND RANGE" + "\n"
    apex_string += "\n"
    apex_string += "\n"
    apex_string += "Animal production data: Numbers and proportions" + "\n"
    apex_string += "\n"
    apex_string += "Parameter 1" + "\t" + "integer" + "\n"
    apex_string += "Parameter 2" + "\t" + "integer" + "\n"
    apex_string += "Parameter 3" + "\t" + "integer" + "\n"
    apex_string += "Parameter 4" + "\t" + "integer" + "\n"
    apex_string += "Parameter 5" + "\t" + "real" + "(Range 0.1 to 99.9  typical 10 to 20)" + "\n"
    apex_string += "Parameter 6" + "\t" + "real" + "(Range 0.1 to 99.9  typical 10 to 30)" + "\n"
    apex_string += "\n"
    apex_string += "Animal production data: Animal weights and rate of weight gain (Unit: lb)" + "\n"
    apex_string += "\n"
    apex_string += "Parameter 7" + "\t" + "real" + "(Range 800.0 to 1400.00)" + "\n"
    apex_string += "Parameter 8" + "\t" + "real" + "(Range 1000.0 to 1800.0)" + "\n"
    apex_string += "Parameter 9" + "\t" + "real" + "(Range 900.0 to 1200.00)" + "\n"
    apex_string += "Parameter 10" + "\t" + "real" + "(Range 400.0  to 900.0)" + "\n"
    apex_string += "Parameter 11" + "\t" + "real" + "(Range 0.0 to 3.0)" + "\n"
    apex_string += "Parameter 12" + "\t" + "real" + "(Range 0.0 to 3.0)" + "\n"
    apex_string += "\n"
    apex_string += "Animal production data: Breed, Pregnancy, calving, and weaning" + "\n"
    apex_string += "\n"
    apex_string += "Parameter 13" + "\t" + "integer" + "(Range 1 to 366)" + "\n"
    apex_string += "Parameter 14" + "\t" + "integer" + "(Range 1 to 366)" + "\n"
    apex_string += "Parameter 15" + "\t" + "real" + "(Range 80.0 to 120.0)" + "\n"
    apex_string += "Parameter 16" + "\t" + "integer" + "(Range 80 to 120)" + "\n"
    apex_string += "Parameter 17" + "\t" + "real" + "(Range 0.7 to 1.0)" + "\n"
    apex_string += "Parameter 18" + "\t" + "real" + "(Range 50.0 to 80.0)" + "\n"
    apex_string += "Parameter 19" + "\t" + "integer" + "(1 to 366)" + "\n"
    apex_string += "Parameter 20" + "\t" + "integer" + "(1 to 31)" + "\n"
    apex_string += "\n"
    #***** send file to server "
    return send_file_to_APEX(apex_string, "CowCalfProductionData.txt")
  end

  def create_input_animal_transport
    animal_transport = AnimalTransport.where(:scenario_id => @scenario.id)
    # create string for the InputAnimalTransport.txt file
    i = 1
    apex_string = animal_transport.count.to_s +  "\n"
    animal_transport.each do |at|
      apex_string += i.to_s + "    "
      apex_string += at.freq_trip.to_s + "    "
      file_name = "Trip" + i.to_s + "_cc.txt"
      apex_string += file_name + "    "
      apex_string += at.cattlepro == true ? "1    " : "0    "
      apex_string += at.purpose == 0 ? "Buying_animals" : "Selling_animal"
      apex_string += "    " + at.purpose.to_s  + "\t" + "!Parm " + (i+1).to_s + " (a,b,c,d,e,and f)" + "\n"
      anim_string = at.trans.to_s + "\t" + "! " + t("aplcat.trans_feeder") + "\n"
      anim_string += at.categories_trans.to_s + "\t" + "! " + t('aplcat.categories_trans') + "\n"
      anim_string += at.categories_slaug.to_s + "\t" + "! " + t('aplcat.categories_slaug') + "\n"
      anim_string += sprintf("%d",at.avg_marweight) + "\t" + "! " + t('aplcat.avg_marweight') + "\n"
      anim_string += at.num_animal.to_s + "\t" + "! " + t('aplcat.num_animal') + "\n"
      categories = Category.where(:animal_transport_id => at.id)
      categories.each do |cat|
        anim_string += cat.weight.to_s + " " + "\t"
      end
      anim_string += "\n"
      categories.each do |cat|
        anim_string += cat.animals.to_s + " " + "\t"
      end
      anim_string += "\n"
      anim_string += at.mortality_rate.to_s + "\t" + "! " + t('aplcat.mortality_rate') + "\n"
      anim_string += at.distance.to_s + "\t" + "! " + t('aplcat.distance') + "\n"
      anim_string += Trailer.find(at.trailer_id).code + "\t" + "! " + t('aplcat.trailer') + "\n"
      anim_string += Truck.find(at.truck_id).code + "\t" + "! " + t('aplcat.trucks') + "\n"
      anim_string += Fuel.find(at.fuel_id).code + "\t" + "! " + t('aplcat.fuel_type') + "\n"
      anim_string += at.same_vehicle == true ? "1" : "0"
      anim_string += "\t" + "! " + t('aplcat.same_vehicle') + "\n"
      anim_string += at.loading.to_s + "\t" + "! " + t('aplcat.loading') + "\n"
      anim_string += at.carcass.to_s + "\t" + "! " + t('aplcat.carcass') + "\n"
      anim_string += at.boneless_beef.to_s + "\t" + "! " + t('aplcat.boneless_beef') + "\n"
      #***** send each trip file to server
      msg = send_file_to_APEX(anim_string, file_name)
      i += 1
    end
    #***** send file to server "
    return send_file_to_APEX(apex_string, "InputAnimalTransport.txt")
  end

  def create_co2_balance_input
    # create string for the CO2BalanceInput.txt file
    apex_string = "This is the input file showing other sources and sink of greenhouse gas emissions in beef cattle production" + "\n"
    apex_string += "\n"
    apex_string += "Parameters for native range" + "\n"
    apex_string += "\n"
    apex_string += @aplcat.n_tfa.to_s + "\t" + "! " + t('aplcat.n_tfa') + "\n"
    apex_string += @aplcat.n_sr.to_s + "\t" + "! " + t('aplcat.n_sr') + "\n"
    apex_string += @aplcat.n_arnfa.to_s + "\t" + "! " + t('aplcat.n_arnfa') + "\n"
    apex_string += @aplcat.n_arpfa.to_s + "\t" + "! " + t('aplcat.n_arpfa') + "\n"
    apex_string += @aplcat.n_nfar.to_s + "\t" + "! " + t('aplcat.n_nfar') + "\n"
    apex_string += @aplcat.n_npfar.to_s + "\t" + "! " + t('aplcat.n_pfar') + "\n"
    apex_string += @aplcat.n_co2enfp.to_s + "\t" + "! " + t('aplcat.n_co2enfp') + "\n"
    apex_string += @aplcat.n_co2enfa.to_s + "\t" + "! " + t('aplcat.n_co2enfa') + "\n"
    apex_string += @aplcat.n_co2epfp.to_s + "\t" + "! " + t('aplcat.n_co2epfp') + "\n"
    apex_string += @aplcat.n_lamf.to_s + "\t" + "! " + t('aplcat.n_lamf') + "\n"
    apex_string += @aplcat.n_lan2of.to_s + "\t" + "! " + t('aplcat.n_lan2of') + "\n"
    apex_string += @aplcat.n_laco2f.to_s + "\t" + "! " + t('aplcat.n_laco2f') + "\n"
    apex_string += @aplcat.n_socc.to_s + "\t" + "! " + t('aplcat.n_socc') + "\n"
    apex_string += "\n"
    apex_string += "Parameters for introduced pasture" + "\n"
    apex_string += "\n"
    apex_string += @aplcat.i_tfa.to_s + "\t" + "! " + t('aplcat.i_tfa') + "\n"
    apex_string += @aplcat.i_sr.to_s + "\t" + "! " + t('aplcat.i_sr') + "\n"
    apex_string += @aplcat.i_arnfa.to_s + "\t" + "! " + t('aplcat.i_arnfa') + "\n"
    apex_string += @aplcat.i_arpfa.to_s + "\t" + "! " + t('aplcat.i_arpfa') + "\n"
    apex_string += @aplcat.i_nfar.to_s + "\t" + "! " + t('aplcat.i_nfar') + "\n"
    apex_string += @aplcat.i_npfar.to_s + "\t" + "! " + t('aplcat.i_pfar') + "\n"
    apex_string += @aplcat.i_co2enfp.to_s + "\t" + "! " + t('aplcat.i_co2enfp') + "\n"
    apex_string += @aplcat.i_co2enfa.to_s + "\t" + "! " + t('aplcat.i_co2enfa') + "\n"
    apex_string += @aplcat.i_co2epfp.to_s + "\t" + "! " + t('aplcat.i_co2epfp') + "\n"
    apex_string += @aplcat.i_lamf.to_s + "\t" + "! " + t('aplcat.i_lamf') + "\n"
    apex_string += @aplcat.i_lan2of.to_s + "\t" + "! " + t('aplcat.i_lan2of') + "\n"
    apex_string += @aplcat.i_laco2f.to_s + "\t" + "! " + t('aplcat.i_laco2f') + "\n"
    apex_string += @aplcat.i_socc.to_s + "\t" + "! " + t('aplcat.i_socc') + "\n"
    apex_string += "\n"
    #***** send file to server "
    return send_file_to_APEX(apex_string, "CO2BalanceInput.txt")
  end

  def create_forage_quality_input
    # create string for the ForageQualityInput.txt file
    apex_string = "1" + "\t" + "\t" + "\t" + "! " + t('aplcat.parameter1') + "\n"
    apex_string += @aplcat.forage_id.to_s + "\t" + "\t" + "\t" + "! " + t('aplcat.parameter2') + "\n"
    apex_string += @aplcat.jincrease.to_s + "  " + @aplcat.stabilization.to_s + "\t" + " " + @aplcat.decline.to_s + "  " + @aplcat.opt4.to_s + "\t" + t('aplcat.parameter3') + "\n"
    #apex_string += "\n"
    #apex_string += "Crude protein levels (% DM) of forage" + "\n"
    #apex_string += "\n"
    #apex_string += aplcat.cpl_lowest.to_s + "\t" + "! " + t('aplcat.lowest') + "\n"
    #apex_string += aplcat.cpl_highest.to_s + "\t" + "! " + t('aplcat.highest') + "\n"
    apex_string += @aplcat.cpl_lowest.to_s + "\t" + "  " + @aplcat.cpl_highest.to_s + "\t"  + "\t" + t('aplcat.parameter4') + "\n"
    #apex_string += "\n"
    #apex_string += "TDN levels (% DM) of forage" + "\n"
    #apex_string += "\n"
    #apex_string += aplcat.tdn_lowest.to_s + "\t" + "! " + t('aplcat.lowest') + "\n"
    #apex_string += aplcat.tdn_highest.to_s + "\t" + "! " + t('aplcat.highest') + "\n"
    apex_string += @aplcat.tdn_lowest.to_s + "\t" + "  " + @aplcat.tdn_highest.to_s + "\t"  + "\t" + t('aplcat.parameter5') + "\n"
    #apex_string += "\n"
    #apex_string += "NDF levels (% DM) of forage" + "\n"
    #apex_string += "\n"
    #apex_string += aplcat.ndf_lowest.to_s + "\t" + "! " + t('aplcat.lowest') + "\n"
    #apex_string += aplcat.ndf_highest.to_s + "\t" + "! " + t('aplcat.highest') + "\n"
    apex_string += @aplcat.ndf_lowest.to_s + "\t" + + "  " + @aplcat.ndf_highest.to_s + "\t"  + "\t" + t('aplcat.parameter6') + "\n"
    #apex_string += "\n"
    #apex_string += "ADF levels (% DM) of forage" + "\n"
    #apex_string += "\n"
    #apex_string += aplcat.adf_lowest.to_s + "\t" + "! " + t('aplcat.lowest') + "\n"
    #apex_string += aplcat.adf_highest.to_s + "\t" + "! " + t('aplcat.highest') + "\n"
    apex_string += @aplcat.adf_highest.to_s + "\t" + + "  " + @aplcat.adf_lowest.to_s + "\t"  + "\t" + t('aplcat.parameter7') + "\n"
    #apex_string += "\n"
    #apex_string += "Feed intake rates (% of body weight)" + "\n"
    #apex_string += "\n"
    #apex_string += aplcat.fir_lowest.to_s + "\t" + "! " + t('aplcat.lowest') + "\n"
    #apex_string += aplcat.fir_highest.to_s + "\t" + "! " + t('aplcat.highest') + "\n"
    apex_string += @aplcat.fir_lowest.to_s + "\t" + + "  " + @aplcat.fir_highest.to_s + "\t"  + "\t" + t('aplcat.parameter8') + "\n"
    apex_string += "\n"
    #***** send file to server "
    return send_file_to_APEX(apex_string, "ForageQualityInput.txt")
  end

  def create_sim_file_aplcat
    # create string for the SimFileAPLCAT.txt file
    apex_string = @aplcat.mdogfc.to_s + "\t" + "! " + t('aplcat.mdogfc') + "\n"
    apex_string += @aplcat.mxdogfc.to_s + "\t" + "! " + t('aplcat.mxdogfc') + "\n"
    apex_string += @aplcat.cwsoj.to_s + "\t" + "! " + t('aplcat.cwsoj') + "\n"
    apex_string += @aplcat.cweoj.to_s + "\t" + "! " + t('aplcat.cweoj') + "\n"
    apex_string += @aplcat.ewc.to_s + "\t" + "! " + t('aplcat.ewc') + "\n"
    apex_string += @aplcat.nodew.to_s + "\t" + "! " + t('aplcat.nodew') + "\n"
    apex_string += @aplcat.byos.to_s + "\t" + "! " + t('aplcat.byos') + "\n"
    apex_string += @aplcat.eyos.to_s + "\t" + "! " + t('aplcat.eyos') + "\n"
    apex_string += "\n"
    #***** send file to server "
    return send_file_to_APEX(apex_string, "SimFileAPLCAT.txt")
  end

  def create_input_secondary_emissions
    # create string for the InputSecondaryEmissions.txt file
    apex_string = "Input file used for estimating secondary emissions from field operations and transportation" + "\n"
    apex_string += "\n"
    apex_string += "!! Engine related parameters for estimation of fuel consumption" + "\n"
    apex_string += "\n"
    apex_string += @aplcat.theta.to_s + "\t" + "! " + t('aplcat.theta') + "\n"
    apex_string += @aplcat.fge.to_s + "\t" + "! " + t('aplcat.fge') + "\n"
    apex_string += @aplcat.fde.to_s + "\t" + "! " + t('aplcat.fde') + "\n"
    apex_string += "\n"
    apex_string += "!! List of each field management operation performed in the year: " + "\n"
    apex_string += "\n"
    apex_string += t('aplcat.area') + " " + "\t" + t('aplcat.equipment') + " " + "\t" + t('aplcat.fuel') + "\n"
    apex_string += "\n"
    #apex_string += "First" + "\n"
    if @aplcat.first_area != nil then
      if @aplcat.first_area > 0 then
        apex_string += @aplcat.first_area.to_s + " " + "\t"
        apex_string += @aplcat.first_equip.to_s + " " +"\t"
        apex_string += Fuel.find(@aplcat.first_fuel_id).code + " " +"\t" + "\n"
      end
    end
    #apex_string += "Second" + "\n"
    if @aplcat.second_area != nil then
      apex_string += @aplcat.second_area.to_s + " " +"\t"
      apex_string += @aplcat.second_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.second_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Third" + "\n"
    if @aplcat.third_area != nil then
      apex_string += @aplcat.third_area.to_s + " " + "\t"
      apex_string += @aplcat.third_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.third_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Fourth" + "\n"
    if @aplcat.fourth_area != nil then
      apex_string += @aplcat.fourth_area.to_s + " " +"\t"
      apex_string += @aplcat.fourth_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.fourth_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Fifth" + "\n"
    if @aplcat.fifth_area != nil then
      apex_string += @aplcat.fifth_area.to_s + " " +"\t"
      apex_string += @aplcat.fifth_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.fifth_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Sixth" + "\n"
    if @aplcat.sixth_area != nil then
      apex_string += @aplcat.sixth_area.to_s + " " +"\t"
      apex_string += @aplcat.sixth_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.sixth_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Seventh" + "\n"
    if @aplcat.seventh_area != nil then
      apex_string += @aplcat.seventh_area.to_s + " " +"\t"
      apex_string += @aplcat.seventh_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.seventh_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Eighth" + "\n"
    if @aplcat.eighth_area != nil then
      apex_string += @aplcat.eighth_area.to_s + " " +"\t"
      apex_string += @aplcat.eighth_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.eighth_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Ninth" + "\n"
    if @aplcat.ninth_area != nil then
      apex_string += @aplcat.ninth_area.to_s + " " +"\t"
      apex_string += @aplcat.ninth_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.ninth_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Tenth" + "\n"
    if @aplcat.tenth_area != nil then
      apex_string += @aplcat.tenth_area.to_s + " " +"\t"
      apex_string += @aplcat.tenth_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.tenth_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Tenth" + "\n"
    if @aplcat.eleventh_area != nil then
      apex_string += @aplcat.eleventh_area.to_s + " " +"\t"
      apex_string += @aplcat.eleventh_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.eleventh_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Tenth" + "\n"
    if @aplcat.twelveth_area != nil then
      apex_string += @aplcat.twelveth_area.to_s + " " +"\t"
      apex_string += @aplcat.twelveth_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.twelveth_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Tenth" + "\n"
    if @aplcat.thirteen_area != nil then
      apex_string += @aplcat.thirteen_area.to_s + " " +"\t"
      apex_string += @aplcat.thirteen_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.thirteen_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Tenth" + "\n"
    if @aplcat.fourteen_area != nil then
      apex_string += @aplcat.fourteen_area.to_s + " " +"\t"
      apex_string += @aplcat.fourteen_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.fourteen_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Tenth" + "\n"
    if @aplcat.fifteen_area != nil then
      apex_string += @aplcat.fifteen_area.to_s + " " +"\t"
      apex_string += @aplcat.fifteen_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.fifteen_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Tenth" + "\n"
    if @aplcat.sixteen_area != nil then
      apex_string += @aplcat.sixteen_area.to_s + " " +"\t"
      apex_string += @aplcat.sixteen_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.sixteen_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Tenth" + "\n"
    if @aplcat.seventeen_area != nil then
      apex_string += @aplcat.seventeen_area.to_s + " " +"\t"
      apex_string += @aplcat.seventeen_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.seventeen_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Tenth" + "\n"
    if @aplcat.eighteen_area != nil then
      apex_string += @aplcat.eighteen_area.to_s + " " +"\t"
      apex_string += @aplcat.eighteen_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.eighteen_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Tenth" + "\n"
    if @aplcat.ninteen_area != nil then
      apex_string += @aplcat.ninteen_area.to_s + " " +"\t"
      apex_string += @aplcat.ninteen_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.ninteen_fuel_id).code + " " +"\t" + "\n"
    end
    #apex_string += "Tenth" + "\n"
    if @aplcat.twenty_area != nil then
      apex_string += @aplcat.twenty_area.to_s + " " +"\t"
      apex_string += @aplcat.twenty_equip.to_s + " " +"\t"
      apex_string += Fuel.find(@aplcat.twenty_fuel_id).code + " " +"\t" + "\n"
    end
    apex_string += "\n"
    #***** send file to server "
    return send_file_to_APEX(apex_string, "InputSecondaryEmissions.txt")
  end

  def create_simul_methods
    # create string for the SimulMethods.txt file
    apex_string = @aplcat.mm_type.to_s + "\t" + "! " + t('aplcat.mm_type') + "\n"
    apex_string += @aplcat.nit.to_s + "\t" + "! " + t('aplcat.nit') + "\n"
    apex_string += @aplcat.fqd.to_s + "\t" + "! " + t('aplcat.fqd') + "\n"
    apex_string += @aplcat.uovfi.to_s + "\t" + "! " + t('aplcat.uovfi') + "\n"
    apex_string += @aplcat.srwc.to_s + "\t" + "! " + t('aplcat.srwc') + "\n"
    apex_string += @aplcat.byos.to_s + "\t" + "! " + t('aplcat.byos') + "\n"
    apex_string += @aplcat.eyos.to_s + "\t" + "! " + t('aplcat.eyos') + "\n"
    #***** send file to server "
    return send_file_to_APEX(apex_string, "SimulMethods.txt")
  end

  def create_simul_parms
    # create string for the SimulParms.txt file
    apex_string = @aplcat.mrgauh.to_s + "\t" + "! " + t('aplcat.parameter1') + "\n"
    apex_string += @aplcat.plac.to_s + "\t" + "! " + t('aplcat.parameter2') + "\n"
    apex_string += @aplcat.pcbb.to_s + "\t" + "! " + t('aplcat.parameter3') + "\n"
    apex_string += @aplcat.fmbmm.to_s + "\t" + "! " + t('aplcat.parameter4') + "\n"
    apex_string += @aplcat.domd.to_s + "\t" + "! " + t('aplcat.parameter5') + "\n"
    apex_string += @aplcat.vsim.to_s + "\t" + "! " + t('aplcat.parameter6') + "\n"
    apex_string += @aplcat.faueea.to_s + "\t" + "! " + t('aplcat.parameter7') + "\n"
    apex_string += @aplcat.acim.to_s + "\t" + "! " + t('aplcat.parameter8') + "\n"
    apex_string += @aplcat.mmppm.to_s + "\t" + "! " + t('aplcat.parameter9') + "\n"
    apex_string += @aplcat.cffm.to_s + "\t" + "! " + t('aplcat.parameter10') + "\n"
    apex_string += @aplcat.fnemm.to_s + "\t" + "! " + t('aplcat.parameter11') + "\n"
    apex_string += @aplcat.effd.to_s + "\t" + "! " + t('aplcat.parameter12') + "\n"
    apex_string += @aplcat.ptbd.to_s + "\t" + "! " + t('aplcat.parameter13') + "\n"
    apex_string += @aplcat.pocib.to_s + "\t" + "! " + t('aplcat.parameter14') + "\n"
    apex_string += @aplcat.bneap.to_s + "\t" + "! " + t('aplcat.parameter15') + "\n"
    apex_string += @aplcat.cneap.to_s + "\t" + "! " + t('aplcat.parameter16') + "\n"
    apex_string += @aplcat.hneap.to_s + "\t" + "! " + t('aplcat.parameter17') + "\n"
    apex_string += @aplcat.pobw.to_s + "\t" + "! " + t('aplcat.parameter18') + "\n"
    apex_string += @aplcat.posw.to_s + "\t" + "! " + t('aplcat.parameter19') + "\n"
    apex_string += @aplcat.posb.to_s + "\t" + "! " + t('aplcat.parameter20') + "\n"
    apex_string += @aplcat.poad.to_s + "\t" + "! " + t('aplcat.parameter21') + "\n"
    apex_string += @aplcat.poada.to_s + "\t" + "! " + t('aplcat.parameter22') + "\n"
    apex_string += @aplcat.cibo.to_s + "\t" + "! " + t('aplcat.parameter23') + "\n"
    apex_string += "\n"
    apex_string += "Simulation Parameters" + "\n"
    apex_string += "\n"
    apex_string += "Parameter 1" + "\t" + t('aplcat.mrgauh') + "\n"
    apex_string += "Parameter 2" + "\t" + t('aplcat.plac') + "\n"
    apex_string += "Parameter 3" + "\t" + t('aplcat.pcbb') + "\n"
    apex_string += "Parameter 4" + "\t" + t('aplcat.fmbmm') + "\n"
    apex_string += "Parameter 5" + "\t" + t('aplcat.domd') + "\n"
    apex_string += "Parameter 6" + "\t" + t('aplcat.vsim') + "\n"
    apex_string += "Parameter 7" + "\t" + t('aplcat.faueea') + "\n"
    apex_string += "Parameter 8" + "\t" + t('aplcat.acim') + "\n"
    apex_string += "Parameter 9" + "\t" + t('aplcat.mmppm') + "\n"
    apex_string += "Parameter 10" + "\t" + t('aplcat.cffm') + "\n"
    apex_string += "Parameter 11" + "\t" + t('aplcat.fnemm') + "\n"
    apex_string += "Parameter 12" + "\t" + t('aplcat.effd') + "\n"
    apex_string += "Parameter 13" + "\t" + t('aplcat.ptbd') + "\n"
    apex_string += "Parameter 14" + "\t" + t('aplcat.pocib') + "\n"
    apex_string += "Parameter 15" + "\t" + t('aplcat.bneap') + "\n"
    apex_string += "Parameter 16" + "\t" + t('aplcat.cneap') + "\n"
    apex_string += "Parameter 17" + "\t" + t('aplcat.hneap') + "\n"
    apex_string += "Parameter 18" + "\t" + t('aplcat.pobw') + "\n"
    apex_string += "Parameter 19" + "\t" + t('aplcat.posw') + "\n"
    apex_string += "Parameter 20" + "\t" + t('aplcat.posb') + "\n"
    apex_string += "Parameter 21" + "\t" + t('aplcat.poad') + "\n"
    apex_string += "Parameter 22" + "\t" + t('aplcat.poada') + "\n"
    apex_string += "Parameter 23" + "\t" + t('aplcat.cibo') + "\n"
    apex_string += "\n"
    apex_string += "PARAMETER FORMAT AND RANGE" + "\n"
    apex_string += "\n"
    apex_string += "Parameter 1" + "\t" + "real" + "0.0 to 7.0" + "\n"
    apex_string += "Parameter 2" + "\t" + "real" + "45 to 65" + "\n"
    apex_string += "Parameter 3" + "\t" + "real" + "45 to 65" + "\n"
    apex_string += "Parameter 4" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 5" + "\t" + "real" + "0 to 100" + "\n"
    apex_string += "Parameter 6" + "\t" + "real" + "> 0" + "\n"
    apex_string += "Parameter 7" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 8" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 9" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 10" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 11" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 12" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 13" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 14" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 15" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 16" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 17" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 18" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 19" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 20" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 20" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "Parameter 20" + "\t" + "real" + "0 to 1" + "\n"
    apex_string += "\n"
    #***** send file to server "
    return send_file_to_APEX(apex_string, "SimulParms.txt")
  end

  def create_water_est_cow_calf
    # create string for the WaterEstCowCalf.txt file
    apex_string = @aplcat.drinkg.to_s + "\t" + "! " + t('aplcat.drinkg') + "\n"
    apex_string += @aplcat.drinkl.to_s + "\t" + "! " + t('aplcat.drinkl') + "\n"
    apex_string += @aplcat.drinkm.to_s + "\t" + "! " + t('aplcat.drinkm') + "\n"
    #apex_string += aplcat.avghm.to_s + "\t" + "! " + t('aplcat.avghm') + "\n"
    #apex_string += "\n"
    #apex_string += "Daily Average Temperature for each months" + "\n"
    #apex_string += "\n"
    apex_string += @aplcat.tjan.to_s + "  "
    apex_string += @aplcat.tfeb.to_s + "  "
    apex_string += @aplcat.tmar.to_s + "  "
    apex_string += @aplcat.tapr.to_s + "  "
    apex_string += @aplcat.tmay.to_s + "  "
    apex_string += @aplcat.tjun.to_s + "  "
    apex_string += @aplcat.tjul.to_s + "  "
    apex_string += @aplcat.taug.to_s + "  "
    apex_string += @aplcat.tsep.to_s + "  "
    apex_string += @aplcat.toct.to_s + "  "
    apex_string += @aplcat.tnov.to_s + "  "
    apex_string += @aplcat.tdec.to_s + "  " + "! " + t("aplcat.parameter4") + "\n"
    #apex_string += "\n"
    #apex_string += "Daily Average Humidity for each months" + "\n"
    #apex_string += "\n"
    apex_string += @aplcat.hjan.to_s + "  "
    apex_string += @aplcat.hfeb.to_s + "  "
    apex_string += @aplcat.hmar.to_s + "  "
    apex_string += @aplcat.hapr.to_s + "  "
    apex_string += @aplcat.hmay.to_s + "  "
    apex_string += @aplcat.hjun.to_s + "  "
    apex_string += @aplcat.hjul.to_s + "  "
    apex_string += @aplcat.haug.to_s + "  "
    apex_string += @aplcat.hsep.to_s + "  "
    apex_string += @aplcat.hoct.to_s + "  "
    apex_string += @aplcat.hnov.to_s + "  "
    apex_string += @aplcat.hdec.to_s + "  " + "! " + t("aplcat.parameter5") + "\n"
    #apex_string += aplcat.avgtm.to_s + "\t" + "! " + t('aplcat.avgtm') + "\n"
    apex_string += @aplcat.rhae.to_s + "\t" + "! " + t('aplcat.rhae') + "\n"
    apex_string += @aplcat.tabo.to_s + "\t" + "! " + t('aplcat.tabo') + "\n"
    apex_string += @aplcat.mpism.to_s + "\t" + "! " + t('aplcat.mpism') + "\n"
    apex_string += @aplcat.spilm.to_s + "\t" + "! " + t('aplcat.spilm') + "\n"
    apex_string += @aplcat.pom.to_s + "\t" + "! " + t('aplcat.pom') + "\n"
    apex_string += @aplcat.srinr.to_s + "\t" + "! " + t('aplcat.srinr') + "\n"
    apex_string += @aplcat.sriip.to_s + "\t" + "! " + t('aplcat.sriip') + "\n"
    apex_string += @aplcat.pogu.to_s + "\t" + "! " + t('aplcat.pogu') + "\n"
    apex_string += @aplcat.adoa.to_s + "\t" + "! " + t('aplcat.adoa') + "\n"
    apex_string += @aplcat.ape.to_s + "\t" + "! " + t('aplcat.ape') + "\n"
    apex_string += "\n"
    #***** send file to server "
    return send_file_to_APEX(apex_string, "WaterEstCowCalf.txt")
  end

  def create_run_parm_aplcat
    apex_string = "!!  This is the run parameter input file for running the model Animal Production Life Cycle Analysis Tool (APLCAT)" + "\n"
    apex_string += "!!  Enter 0 for not running any particular module" + "\n" + "\n"
    apex_string += @aplcat.running_drinking_water.to_s + "\t" + "! " + t('aplcat.running_drinking_water') + "\n"
    apex_string += @aplcat.running_complete_stocker.to_s + "\t" + "! " + t('aplcat.running_complete_stocker') + "\n"
    apex_string += @aplcat.running_ghg.to_s + "\t" + "! " + t('aplcat.running_ghg') + "\n"
    apex_string += @aplcat.running_transportation.to_s + "\t" + "! " + t('aplcat.running_transportation') + "\n"
    #***** send file to server "
    return send_file_to_APEX(apex_string, "RunParmAPLCAT.txt")
  end

  def create_beef_cattle_nutrition
    grazing = GrazingParameter.where(:scenario_id => @scenario.id)
    apex_string = (@aplcat.forage == true ? "1" : "0") + "\t" + "| " + t('graze.forage') + "\n"
    apex_string += grazing.count.to_s + "\t" + "| " + t('graze.total') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%d", grazing[i].code) + "\t"
    end
    apex_string += "| " + t('graze.code_for_html') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%d", grazing[i].starting_julian_day) + "\t"
    end
    apex_string += "| " + t('graze.sjd') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%d", grazing[i].ending_julian_day) + "\t"
    end
    apex_string += "| " + t('graze.ejd') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%d", grazing[i].for_button).to_s + "\t" #No for_button anymore at the moment.
    end
    apex_string += "| " + t('graze.dmi_code') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].for_dmi_cows) + "\t"
    end
    apex_string += "| " + t('graze.dmi_cows') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].for_dmi_bulls) + "\t"
    end
    apex_string += "| " + t('graze.dmi_bulls') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].for_dmi_heifers) + "\t"
    end
    apex_string += "| " + t('graze.dmi_heifers') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].for_dmi_calves) + "\t"
    end
    apex_string += "| " + t('graze.dmi_calves') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].for_dmi_rheifers) + "\t"
    end
    apex_string += "| " + t('graze.dmi_rheifers') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%d", grazing[i].green_water_footprint) + "\t"
    end
    apex_string += "| " + t('graze.gwff') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].dmi_code) + "\t"
    end
    apex_string += "| " + t('graze.code_supp_html') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%d", grazing[i].supplement_button).to_s + "\t" #No supplement_button at the moment.
    end
    apex_string += "| " + t('graze.dmi_code') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].dmi_cows) + "\t"
    end
    apex_string += "| " + t('graze.dmi_cows') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].dmi_bulls) + "\t"
    end
    apex_string += "| " + t('graze.dmi_bulls') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].dmi_heifers) + "\t"
    end
    apex_string += "| " + t('graze.dmi_heifers') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].dmi_calves) + "\t"
    end
    apex_string += "| " + t('graze.dmi_calves') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%.2f", grazing[i].dmi_rheifers) + "\t"
    end
    apex_string += "| " + t('graze.dmi_rheifers') + "\n"
    for i in 0..grazing.count-1
      apex_string += sprintf("%d", grazing[i].green_water_footprint_supplement) + "\t"
    end
    apex_string += "| " + t('graze.gwfs') + "\n"
    apex_string += "\n"
    apex_string += "Data on animalfeed (Supplement/Concentrate)" + "\n"
    apex_string += "\n"

    <<-DOC
        for= j in 0..supplement.count-1
          apex_string += sprintf("%d", supplement[j].code) + "\t"
        end
        apex_string += "| " + t('supplement.code') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%d", supplement[j].starting_julian_day) + "\t"
        end
        apex_string += "| " + t('graze.sjd') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%d", supplement[j].ending_julian_day) + "\t"
        end
        apex_string += "| " + t('graze.ejd') + "\n"
        #for j in 0..supplement.count-1
          #apex_string += sprintf("%d", supplement[j].for_button) + "\t"
        #end
        # apex_string += "| " + t('graze.dmi_code') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%.2f", supplement[j].for_dmi_cows) + "\t"
        end
        apex_string += "| " + t('graze.dmi_cows') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%.2f", supplement[j].for_dmi_bulls) + "\t"
        end
        apex_string += "| " + t('graze.dmi_bulls') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%.2f", supplement[j].for_dmi_heifers) + "\t"
        end
        apex_string += "| " + t('graze.dmi_heifers') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%.2f", supplement[j].for_dmi_calves) + "\t"
        end
        apex_string += "| " + t('graze.dmi_calves') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%.2f", supplement[j].for_dmi_rheifers) + "\t"
        end
        apex_string += "| " + t('graze.dmi_rheifers') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%d", supplement[j].green_water_footprint) + "\t"
        end
        apex_string += "| " + t('graze.gwff') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%d", supplement[j].dmi_code) + "\t"
        end
        apex_string += "| " + t('graze.code_supp') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%.2f", supplement[j].dmi_cows) + "\t"
        end
        apex_string += "| " + t('graze.dmi_cows') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%.2f", supplement[j].dmi_bulls) + "\t"
        end
        apex_string += "| " + t('graze.dmi_bulls') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%.2f", supplement[j].dmi_heifers) + "\t"
        end
        apex_string += "| " + t('graze.dmi_heifers') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%.2f", supplement[j].dmi_calves) + "\t"
        end
        apex_string += "| " + t('graze.dmi_calves') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%.2f", supplement[j].dmi_rheifers) + "\t"
        end
        apex_string += "| " + t('graze.dmi_rheifers') + "\n"
        for j in 0..supplement.count-1
          apex_string += sprintf("%d", supplement[j].green_water_footprint_supplement) + "\t"
        end
        apex_string += "| " + t('graze.gwfs') + "\n"
    DOC

    apex_string += "\n"
    apex_string += "IMPORTANT NOTE: Details of parameters defined in the above 11 lines:" + "\n"
    apex_string += "\n"
    apex_string += "Line 1: " + t('graze.total') + "\n"
    apex_string += "Line 2: " + t('graze.code_for') + "\n"
    apex_string += "Line 3: " + t('graze.sjd') + "\n"
    apex_string += "Line 4: " + t('graze.ejd') + "\n"
    apex_string += "Line 5: " + t('graze.ln5') + "\n"
    apex_string += "Line 6: " + t('graze.dmi_cows') + "\n"
    apex_string += "Line 7: " + t('graze.dmi_bulls') + "\n"
    apex_string += "Line 8: " + t('graze.dmi_heifers') + "\n"
    apex_string += "Line 9: " + t('graze.dmi_calves') + "\n"
    apex_string += "Line 10: " + t('graze.dmi_rheifers') + "\n"
    apex_string += "Line 11: " + t('graze.ln10') + "\n"
    apex_string += "\n"
    #***** send file to server "
    return send_file_to_APEX(apex_string, "BeefCattleNutrition.txt")
  end

  def read_aplcat_results
      #if simulation successful. Do. 1) delete the previous results 2) donwload the new results and save in database
      AplcatResult.where(:scenario_id => @scenario.id).delete_all
      aplcatresult = AplcatResult.new
      #download the results files
      data = get_file_from_APLCAT("AnimalWeights.txt")
      data1 = data.split("\n")
      if data.include? "Error =>" then
        return data
      else
        data_weights = data.each_line.take(375).last
        data_weights.each_line do |line|
          #read line by line of the file
          line_columns = line.split(" ")
          weights = Hash.new
            weights["calf_aws"] = line_columns[1, 1]
            weights["rh_aws"] = line_columns[2, 1]
            weights["fch_aws"] = line_columns[3, 1]
            weights["cow_aws"] = line_columns[4, 1]
            weights["bull_aws"] = line_columns[5, 1]
        end
      end
      data = get_file_from_APLCAT("ManureOutputFile.txt")
      #save the information needed in aplcatresult
      data1 = data.split("\n")
      if data.include? "Error =>" then
        return data
      else
        data_calf = data.each_line.take(1795).last
        data_rh = data.each_line.take(1796).last
        data_fch = data.each_line.take(1797).last
        data_cow = data.each_line.take(1798).last
        data_bull = data.each_line.take(1799).last
        manure_excretion = Hash.new
          data_calf.each_line do |line|
          #read line by line of the file
          line_columns = line.split(" ")
            manure_excretion["calf_sme"] = line_columns[2, 1]
          end
          data_rh.each_line do |line|
            line_columns = line.split(" ")
            manure_excretion["rh_sme"] = line_columns[3, 1]
          end
          data_fch.each_line do |line|
            line_columns = line.split(" ")
            manure_excretion["fch_sme"] = line_columns[4, 1]
          end
          data_cow.each_line do |line|
            line_columns = line.split(" ")
            manure_excretion["cow_sme"] = line_columns[2, 1]
          end
          data_bull.each_line do |line|
            line_columns = line.split(" ")
            manure_excretion["bull_sme"] = line_columns[2, 1]
          end
      end
      data = get_file_from_APLCAT("EmissionOutputCalves.txt")
      #save the information needed in aplcatresult
      data1 = data.split("\n")
      if data.include? "Error =>" then
        return data
      else
        data_calf_gei = data.each_line.take(388).last
        data_calf_ni = data.each_line.take(410).last
        data_calf_une = data.each_line.take(411).last
        data_calf_fne = data.each_line.take(412).last
        data_calf_tne = data.each_line.take(413).last
        data_calf_tnr = data.each_line.take(414).last
        emmission_calves = Hash.new
          data_calf_gei.each_line do |line|
          #read line by line of the file
          line_columns = line.split(" ")
            emmission_calves["calf_gei"] = line_columns[3, 1]
          end
          data_calf_ni.each_line do |line|
            line_columns = line.split(" ")
            emmission_calves["calf_ni"] = line_columns[3, 1]
          end
            data_calf_une.each_line do |line|
              line_columns = line.split(" ")
            emmission_calves["calf_une"] = line_columns[4, 1]
          end
            data_calf_fne.each_line do |line|
              line_columns = line.split(" ")
            emmission_calves["calf_fne"] = line_columns[4, 1]
          end
            data_calf_tne.each_line do |line|
              line_columns = line.split(" ")
            emmission_calves["calf_tne"] = line_columns[4, 1]
          end
            data_calf_tnr.each_line do |line|
              line_columns = line.split(" ")
            emmission_calves["calf_tnr"] = line_columns[4, 1]
          end
      end
      data = get_file_from_APLCAT("EmsnOutBulls.txt")
      #save the information needed in aplcatresult
      data1 = data.split("\n")
      if data.include? "Error =>" then
        return data
      else
        data_bull_gei = data.each_line.take(390).last
        data_bull_ni = data.each_line.take(412).last
        data_bull_une = data.each_line.take(413).last
        data_bull_fne = data.each_line.take(414).last
        data_bull_tne = data.each_line.take(415).last
        data_bull_tnr = data.each_line.take(416).last
        emmission_bull = Hash.new
          data_bull_gei.each_line do |line|
          #read line by line of the file
          line_columns = line.split(" ")
            emmission_bull["bull_gei"] = line_columns[3, 1]
          end
          data_bull_ni.each_line do |line|
            line_columns = line.split(" ")
            emmission_bull["bull_ni"] = line_columns[3, 1]
          end
            data_bull_une.each_line do |line|
              line_columns = line.split(" ")
            emmission_bull["bull_une"] = line_columns[4, 1]
          end
            data_bull_fne.each_line do |line|
              line_columns = line.split(" ")
            emmission_bull["bull_fne"] = line_columns[4, 1]
          end
            data_bull_tne.each_line do |line|
              line_columns = line.split(" ")
            emmission_bull["bull_tne"] = line_columns[4, 1]
          end
            data_bull_tnr.each_line do |line|
              line_columns = line.split(" ")
            emmission_bull["bull_tnr"] = line_columns[4, 1]
          end
      end
      data = get_file_from_APLCAT("EmsnOutCows.txt")
      #save the information needed in aplcatresult
      data1 = data.split("\n")
      if data.include? "Error =>" then
        return data
      else
        data_cow_gei = data.each_line.take(390).last
        data_cow_ni = data.each_line.take(412).last
        data_cow_une = data.each_line.take(413).last
        data_cow_fne = data.each_line.take(414).last
        data_cow_tne = data.each_line.take(415).last
        data_cow_tnr = data.each_line.take(416).last
        emmission_cow = Hash.new
          data_cow_gei.each_line do |line|
          #read line by line of the file
          line_columns = line.split(" ")
            emmission_cow["cow_gei"] = line_columns[3, 1]
          end
          data_cow_ni.each_line do |line|
            line_columns = line.split(" ")
            emmission_cow["cow_ni"] = line_columns[4, 1]
          end
            data_cow_une.each_line do |line|
              line_columns = line.split(" ")
            emmission_cow["cow_une"] = line_columns[4, 1]
          end
            data_cow_fne.each_line do |line|
              line_columns = line.split(" ")
            emmission_cow["cow_fne"] = line_columns[4, 1]
          end
            data_cow_tne.each_line do |line|
              line_columns = line.split(" ")
            emmission_cow["cow_tne"] = line_columns[4, 1]
          end
            data_cow_tnr.each_line do |line|
              line_columns = line.split(" ")
            emmission_cow["cow_tnr"] = line_columns[4, 1]
          end
      end
      data = get_file_from_APLCAT("EmsnOutFirstCalfHeifers.txt")
      #save the information needed in aplcatresult
      data1 = data.split("\n")
      if data.include? "Error =>" then
        return data
      else
        data_fch_gei = data.each_line.take(390).last
        data_fch_ni = data.each_line.take(412).last
        data_fch_une = data.each_line.take(413).last
        data_fch_fne = data.each_line.take(414).last
        data_fch_tne = data.each_line.take(415).last
        data_fch_tnr = data.each_line.take(416).last
        emmission_fch = Hash.new
          data_fch_gei.each_line do |line|
          #read line by line of the file
          line_columns = line.split(" ")
            emmission_fch["fch_gei"] = line_columns[3, 1]
          end
          data_fch_ni.each_line do |line|
            line_columns = line.split(" ")
            emmission_fch["fch_ni"] = line_columns[4, 1]
          end
            data_fch_une.each_line do |line|
              line_columns = line.split(" ")
            emmission_fch["fch_une"] = line_columns[4, 1]
          end
            data_fch_fne.each_line do |line|
              line_columns = line.split(" ")
            emmission_fch["fch_fne"] = line_columns[4, 1]
          end
            data_fch_tne.each_line do |line|
              line_columns = line.split(" ")
            emmission_fch["fch_tne"] = line_columns[4, 1]
          end
            data_fch_tnr.each_line do |line|
              line_columns = line.split(" ")
            emmission_fch["fch_tnr"] = line_columns[4, 1]
          end
      end
      data = get_file_from_APLCAT("EmsnOutReplHeifers.txt")
      #save the information needed in aplcatresult
      data1 = data.split("\n")
      if data.include? "Error =>" then
        return data
      else
        data_rh_gei = data.each_line.take(390).last
        data_rh_ni = data.each_line.take(412).last
        data_rh_une = data.each_line.take(413).last
        data_rh_fne = data.each_line.take(414).last
        data_rh_tne = data.each_line.take(415).last
        data_rh_tnr = data.each_line.take(416).last
        emmission_rh = Hash.new
          data_rh_gei.each_line do |line|
          #read line by line of the file
          line_columns = line.split(" ")
            emmission_rh["rh_gei"] = line_columns[3, 1]
          end
          data_rh_ni.each_line do |line|
            line_columns = line.split(" ")
            emmission_rh["rh_ni"] = line_columns[4, 1]
          end
            data_rh_une.each_line do |line|
              line_columns = line.split(" ")
            emmission_rh["rh_une"] = line_columns[4, 1]
          end
            data_rh_fne.each_line do |line|
              line_columns = line.split(" ")
            emmission_rh["rh_fne"] = line_columns[4, 1]
          end
            data_rh_tne.each_line do |line|
              line_columns = line.split(" ")
            emmission_rh["rh_tne"] = line_columns[4, 1]
          end
            data_rh_tnr.each_line do |line|
              line_columns = line.split(" ")
            emmission_rh["rh_tnr"] = line_columns[4, 1]
          end
      end
  end

  ################################  aplcat - run the selected scenario for aplcat #################################
  def run_aplcat
    msg = "OK"
    msg = send_file_to_APEX("APLCAT", "APLCAT") #this operation will create APLCAT+session folder from APLCAT folder
    #find the aplcat parameters for the sceanrio selected
    @aplcat = AplcatParameter.find_by_scenario_id(@scenario.id)
    if @aplcat == nil then
      return "You need to create the APLCAT information before trying to simulate. Click on the scnario you want to work with and then select APLCAT option from the side menu"
    end
    if create_cow_calf_production_data != "OK"
      return t('aplcat.error') + " " + t('aplcat.cow_calf')
    end
    if create_input_animal_transport != "OK"
      return t('aplcat.error') + " " + t('aplcat.animal_trans')
    end
    if create_co2_balance_input != "OK"
      return t('aplcat.error') + " " + t('aplcat.co2_balance')
    end
    if create_forage_quality_input != "OK"
      return t('aplcat.error') + " " + t('aplcat.forage_quality')
    end
    if create_sim_file_aplcat != "OK"
      return t('aplcat.error') + " " + t('aplcat.simul_file')
    end
    if create_input_secondary_emissions != "OK"
      return t('aplcat.error') + " " + t('aplcat.secondary_emm')
    end
    if create_simul_methods != "OK"
      return t('aplcat.error') + " " + t('aplcat.simul_method')
    end
    if create_simul_parms != "OK"
      return t('aplcat.error') + " " + t('aplcat.simul_parms')
    end
    if create_water_est_cow_calf != "OK"
      return t('aplcat.error') + " " + t('aplcat.water_est')
    end
    if create_run_parm_aplcat != "OK"
      return t('aplcat.error') + " " + t('aplcat.run_parm')
    end
    if create_beef_cattle_nutrition != "OK"
      return "There is an error creating APLCAT txt file. Check Beef Cattle Nutrition."
    end
    client = Savon.client(wsdl: URL_SoilsInfo)
    ###### create control, param, site, and weather files ########
    response = client.call(:run_aplcat, message: {"session_id" => session[:session_id]})
    if response.body[:run_aplcat_response][:run_aplcat_result].include? "Time taken to run APLCAT" then
      return read_aplcat_results()
    else
      return "Error running APLCAT"
    end
    #***Saved for future references
    #apex_string += aplcat.mm_type.to_s + "\t" + "! " + t('aplcat.parameter1') + "\n"
    #apex_string += aplcat.nit.to_s + "\t" + "! " + t('aplcat.parameter2') + "\n"
    #apex_string += aplcat.fqd.to_s + "\t" + "! " + t('aplcat.parameter3') + "\n"
    #apex_string += aplcat.uovfi.to_s + "\t" + "! " + t('aplcat.parameter4') + "\n"
    #apex_string += aplcat.srwc.to_s + "\t" + "! " + t('aplcat.parameter5') + "\n"
    #apex_string += aplcat.byos.to_s + "\t" + "! " + t('aplcat.parameter6') + "\n"
    #apex_string += aplcat.eyos.to_s + "\t" + "! " + t('aplcat.parameter7') + "\n"
    #apex_string += "\n"
    #apex_string += "Details of model parameters on simulation methods" + "\n"
    #apex_string += "\n"
    #apex_string += "Parameter 1" + "\t" + t('aplcat.mm_type') + "\n"
    #apex_string += "Parameter 2" + "\t" + t('aplcat.nit') + "\n"
    #apex_string += "Parameter 3" + "\t" + t('aplcat.fqd') + "\n"
    #apex_string += "Parameter 4" + "\t" + t('aplcat.uovfi') + "\n"
    #apex_string += "Parameter 5" + "\t" + t('aplcat.srwc') + "\n"
    #apex_string += "Parameter 6" + "\t" + t('aplcat.byos') + "\n"
    #apex_string += "Parameter 7" + "\t" + t('aplcat.eyos') + "\n"
    #apex_string += "\n"
    #apex_string += "PARAMETER FORMAT AND RANGE" + "\n"
    #apex_string += "\n"
    #apex_string += "Parameter 1" + "\t" + "integer" + "1 or 2" + "\n"
    #apex_string += "Parameter 2" + "\t" + "integer" + "1,2, or 3" + "\n"
    #apex_string += "Parameter 3" + "\t" + "integer" + "1 or 0" + "\n"
    #apex_string += "Parameter 4" + "\t" + "integer" + "1 or 0" + "\n"
    #apex_string += "Parameter 5" + "\t" + "integer" + "1 or 0" + "\n"
    #apex_string += "Parameter 6" + "\t" + "integer" + "Four digit year" + "\n"
    #apex_string += "Parameter 7" + "\t" + "integer" + "Four digit year" + "\n"
    #apex_string += "\n"
    #***** send file to server "
    #msg = send_file_to_APEX(apex_string, "SimulMethods.txt")

    #apex_string += aplcat.mrga.to_s + "\t" + "! " + t('aplcat.mrga') + "\n"
    #apex_string += aplcat.platc.to_s + "\t" + "! " + t('aplcat.platc') + "\n"
    #apex_string += aplcat.pctbb.to_s + "\t" + "! " + t('aplcat.pctbb') + "\n"
    #apex_string += aplcat.mm_type.to_s + "\t" + "! " + t('aplcat.mm_type') + "\n"
    #apex_string += aplcat.dmd.to_s + "\t" + "! " + t('aplcat.dmd') + "\n"
    #apex_string += aplcat.vsim_gp.to_s + "\t" + "! " + t('aplcat.vsim') + "\n"
    #apex_string += aplcat.foue.to_s + "\t" + "! " + t('aplcat.foue') + "\n"
    #apex_string += aplcat.ash.to_s + "\t" + "! " + t('aplcat.ash') + "\n"
    #apex_string += aplcat.mmppfm.to_s + "\t" + "! " + t('aplcat.mmppfm') + "\n"
    #apex_string += aplcat.cfmms.to_s + "\t" + "! " + t('aplcat.cfmms') + "\n"
    #apex_string += aplcat.fnemimms.to_s + "\t" + "! " + t('aplcat.fnemimms') + "\n"
    #apex_string += aplcat.effn2ofmms.to_s + "\t" + "! " + t('aplcat.effn2ofmms') + "\n"
    #apex_string += aplcat.ptdife.to_s + "\t" + "! " + t('aplcat.ptdife') + "\n"
    #apex_string += aplcat.byosm.to_s + "\t" + "! " + t('aplcat.byosm') + "\n"

    #***Saved for future references
    #apex_string = "Input file for estimating drinking water requirement of cattle" + "\n"
    #apex_string += "\n"
    #apex_string += aplcat.noc.to_s + "\t" + "! " + t('aplcat.noc') + "\n"
    #apex_string += aplcat.abwc.to_s + "\t" + "! " + t('aplcat.abwc') + "\n"
    #apex_string += aplcat.norh.to_s + "\t" + "! " + t('aplcat.norh') + "\n"
    #apex_string += aplcat.abwh.to_s + "\t" + "! " + t('aplcat.abwh') + "\n"
    #apex_string += aplcat.nomb.to_s + "\t" + "! " + t('aplcat.nomb') + "\n"
    #apex_string += aplcat.abwmb.to_s + "\t" + "! " + t('aplcat.abwmb') + "\n"
    #apex_string += aplcat.dwawfga.to_s + "\t" + "! " + t('aplcat.dwawfga') + "\n"
    #apex_string += aplcat.dwawflc.to_s + "\t" + "! " + t('aplcat.dwawflc') + "\n"
    #apex_string += aplcat.dwawfmb.to_s + "\t" + "! " + t('aplcat.dwawfmb') + "\n"
    #***Saved for future references

    # take monthly avg max and min temp and get an average of those two
    # take monthly rh to add to dringking water.
    #county = County.find(Location.find(session[:location_id]).county_id)
    <<-DOC
      county = County.find(@project.location.county_id)
      if county != nil then
        client = Savon.client(wsdl: URL_SoilsInfo)
        response = client.call(:create_wp1_from_weather, message: {"loc" => APEX_FOLDER + "/APEX" + session[:session_id], "wp1name" => county.wind_wp1_name, "pgm" => ApexControl.find_by_control_description_id(6).value.to_i.to_s})

        #response = client.call(:create_wp1_from_weather2, message: {"loc" => APEX_FOLDER + "/APEX" + session[:session_id], "wp1name" => county.wind_wp1_name, "code" => county.county_state_code})
        #weather_data = response.body[:create_wp1_from_weather2_response][:create_wp1_from_weather2_result]


        weather_data = response.body[:create_wp1_from_weather_response][:create_wp1_from_weather_result][:string]
        max_temp = weather_data[2].split
        min_temp = weather_data[3].split
        rh = weather_data[14].split
        for i in 0..max_temp.count-1
        min_temp[i] = sprintf("%5.1f",((max_temp[i].to_f + min_temp[i].to_f) / 2) * 9/5 + 32)
        rh[i] = 100 * (Math.exp((17.625 * rh[i].to_f) / (243.04 + rh[i].to_f)) / Math.exp((17.625 * min_temp[i].to_f) / (243.04 + min_temp[i].to_f)))
        apex_string += sprintf("%.1f", min_temp[i]) + "  "
        end
        apex_string += "\t" + "! " + t('aplcat.avg_temp') + "\n"
        for i in 0..rh.count-1
        apex_string += sprintf("%.1f", rh[i]) + "  "
        end
        apex_string += "\t" + "! " + t('aplcat.avg_rh') + "\n"
      end
    DOC
    #***Saved for future references
    #apex_string += aplcat.adwgbc.to_s + "\t" + "! " + t('aplcat.adwgbc') + "\n"
    #apex_string += aplcat.adwgbh.to_s + "\t" + "! " + t('aplcat.adwgbh') + "\n"
    #apex_string += aplcat.mrga.to_s + "\t" + "! " + t('aplcat.mrga') + "\n"
    #apex_string += aplcat.prh.to_s + "\t" + "! " + t('aplcat.prh') + "\n"
    #apex_string += aplcat.prb.to_s + "\t" + "! " + t('aplcat.prb') + "\n"
    #apex_string += aplcat.jdcc.to_s + "\t" + "! " + t('aplcat.jdcc') + "\n"
    #apex_string += aplcat.gpc.to_s + "\t" + "! " + t('aplcat.gpc') + "\n"
    #apex_string += aplcat.tpwg.to_s + "\t" + "! " + t('aplcat.tpwg') + "\n"
    #apex_string += aplcat.csefa.to_s + "\t" + "! " + t('aplcat.csefa') + "\n"
    #apex_string += aplcat.srop.to_s + "\t" + "! " + t('aplcat.srop') + "\n"
    #apex_string += aplcat.bwoc.to_s + "\t" + "! " + t('aplcat.bwoc') + "\n"
    #apex_string += aplcat.jdbs.to_s + "\t" + "! " + t('aplcat.jdbs') + "\n"
    #apex_string += aplcat.platc.to_s + "\t" + "! " + t('aplcat.platc') + "\n"
    #apex_string += aplcat.pctbb.to_s + "\t" + "! " + t('aplcat.pctbb') + "\n"
    #apex_string += aplcat.rhaeba.to_s + "\t" + "! " + t('aplcat.rhaeba') + "\n"
    #apex_string += aplcat.toaboba.to_s + "\t" + "! " + t('aplcat.toaboba') + "\n"
    #apex_string += aplcat.dmi.to_s + "\t" + "! " + t('aplcat.dmi') + "\n"
    #apex_string += aplcat.dmd.to_s + "\t" + "! " + t('aplcat.dmd') + "\n"
    #apex_string += aplcat.mpsm.to_s + "\t" + "! " + t('aplcat.mpsm') + "\n"
    #apex_string += aplcat.splm.to_s + "\t" + "! " + t('aplcat.splm') + "\n"
    #apex_string += aplcat.pmme.to_s + "\t" + "! " + t('aplcat.pmme') + "\n"
    #apex_string += aplcat.napanr.to_s + "\t" + "! " + t('aplcat.napanr') + "\n"
    #apex_string += aplcat.napaip.to_s + "\t" + "! " + t('aplcat.napaip') + "\n"
    #apex_string += aplcat.pgu.to_s + "\t" + "! " + t('aplcat.pgu') + "\n"
    #apex_string += aplcat.ada.to_s + "\t" + "! " + t('aplcat.ada') + "\n"
    #apex_string += aplcat.ape.to_s + "\t" + "! " + t('aplcat.ape') + "\n"

    #apex_string += "\n"
    #apex_string = "Input file for estimating Secondary Emmission Input" + "\n"
    #apex_string += "\n"
    #apex_string = "Input file for estimating Simulation Methods" + "\n"
    #apex_string += "\n"
    #apex_string += aplcat.mm_type.to_s + "\t" + "! " + t('aplcat.mm_type') + "\n"
    #apex_string += aplcat.fmbmm.to_s + "\t" + "! " + t('aplcat.fmbmm') + "\n"
    #apex_string += aplcat.nit.to_s + "\t" + "! " + t('aplcat.nit') + "\n"
    #apex_string += aplcat.fqd.to_s + "\t" + "! " + t('aplcat.fqd') + "\n"
    #apex_string += aplcat.uovfi.to_s + "\t" + "! " + t('aplcat.uovfi') + "\n"
    #apex_string += aplcat.srwc.to_s + "\t" + "! " + t('aplcat.srwc') + "\n"
    #apex_string += "\n"
    #msg = send_file_to_APEX(apex_string, "EmmisionTransportAndSimulationCowCalf.txt")
    #***Saved for future references

    #input file for APLCAT Results
      #apex_string += "Calf" + "\t" + "Repl_hef" + "\t" + "FC_hef" + "\t" + "Cow" + "\t" + "Bull" + "|" + "Calf" + "\t" + "Repl_hef" + "\t" + "FC_hef" + "\t" + "Cow" + "\t" + "Bull" + "\t" + "Results per animal" + "\n"
      #apex_string = "\n"
      #apex_string = "Animal growth Resuls" + "\n"
      #apex_string += aplcatresult.calf_aws.to_s + "\t" + aplcatresult.rh_aws.to_s + "\t" + aplcatresult.fch_aws.to_s + "\t" + aplcatresult.cow_aws.to_s + "\t" + aplcatresult.bull_aws.to_s + "|" + aplcatresult.calf_aws.to_s + "\t" + aplcatresult.rh_aws.to_s + "\t" + aplcatresult.fch_aws.to_s + "\t" + aplcatresult.cow_aws.to_s + "\t" + aplcatresult.bull_aws.to_s + "\t" + "Animal weights (lb | kg)" + "\n"
      #apex_string = "\n"
      #apex_string = "Feed Intake Rates" + "\n"
      #apex_string += aplcatresult.calf_dmi.to_s + "\t" + aplcatresult.rh_dmi.to_s + "\t" + aplcatresult.fch_dmi.to_s + "\t" + aplcatresult.cow_dmi.to_s + "\t" + aplcatresult.bull_dmi.to_s + "|" + aplcatresult.calf_dmi.to_s + "\t" + aplcatresult.rh_dmi.to_s + "\t" + aplcatresult.fch_dmi.to_s + "\t" + aplcatresult.cow_dmi.to_s + "\t" + aplcatresult.bull_dmi.to_s + "\t" + "Dry Matter Intake ('kg',daily | annual)" + "\n"
      #apex_string += aplcatresult.calf_gei.to_s + "\t" + aplcatresult.rh_gei.to_s + "\t" + aplcatresult.fch_gei.to_s + "\t" + aplcatresult.cow_gei.to_s + "\t" + aplcatresult.bull_gei.to_s + "|" + aplcatresult.calf_gei.to_s + "\t" + aplcatresult.rh_gei.to_s + "\t" + aplcatresult.fch_gei.to_s + "\t" + aplcatresult.cow_gei.to_s + "\t" + aplcatresult.bull_gei.to_s + "\t" + "Gross Energy Intake ('daily',Mcal | MJ)" + "\n"
      #apex_string = "\n"
      #apex_string = "Water Intake Results" + "\n"
      #apex_string += aplcatresult.calf_wi.to_s + "\t" + aplcatresult.rh_wi.to_s + "\t" + aplcatresult.fch_wi.to_s + "\t" + aplcatresult.cow_wi.to_s + "\t" + aplcatresult.bull_wi.to_s + "|" + aplcatresult.calf_wi.to_s + "\t" + aplcatresult.rh_wi.to_s + "\t" + aplcatresult.fch_wi.to_s + "\t" + aplcatresult.cow_wi.to_s + "\t" + aplcatresult.bull_wi.to_s + "\t" + "Water Intake ('L/year',Emb_feed | drinking)" + "\n"
      #apex_string = "\n"
      #apex_string = "Manure Excretion Results" + "\n"
      #apex_string += aplcatresult.calf_sme.to_s + "\t" + aplcatresult.rh_sme.to_s + "\t" + aplcatresult.fch_sme.to_s + "\t" + aplcatresult.cow_sme.to_s + "\t" + aplcatresult.bull_sme.to_s + "|" + aplcatresult.calf_sme.to_s + "\t" + aplcatresult.rh_sme.to_s + "\t" + aplcatresult.fch_sme.to_s + "\t" + aplcatresult.cow_sme.to_s + "\t" + aplcatresult.bull_sme.to_s + "\t" + "Solid manure excr. ('kg/year',manu | manu_N)" + "\n"
      #apex_string = "\n"
      #apex_string = "Nitrogen Balance Results" + "\n"
      #apex_string += aplcatresult.calf_ni.to_s + "\t" + aplcatresult.rh_ni.to_s + "\t" + aplcatresult.fch_ni.to_s + "\t" + aplcatresult.cow_ni.to_s + "\t" + aplcatresult.bull_ni.to_s + "|" + aplcatresult.calf_ni.to_s + "\t" + aplcatresult.rh_ni.to_s + "\t" + aplcatresult.fch_ni.to_s + "\t" + aplcatresult.cow_ni.to_s + "\t" + aplcatresult.bull_ni.to_s + "\t" + "Nitrogen Intake (g/day | kg/year)" + "\n"
      #apex_string += aplcatresult.calf_tne.to_s + "\t" + aplcatresult.rh_tne.to_s + "\t" + aplcatresult.fch_tne.to_s + "\t" + aplcatresult.cow_tne.to_s + "\t" + aplcatresult.bull_tne.to_s + "|" + aplcatresult.calf_tne.to_s + "\t" + aplcatresult.rh_tne.to_s + "\t" + aplcatresult.fch_tne.to_s + "\t" + aplcatresult.cow_tne.to_s + "\t" + aplcatresult.bull_tne.to_s + "\t" + "Total Nitrogen excretion (g/day | kg/year)" + "\n"
      #apex_string += aplcatresult.calf_tnr.to_s + "\t" + aplcatresult.rh_tnr.to_s + "\t" + aplcatresult.fch_tnr.to_s + "\t" + aplcatresult.cow_tnr.to_s + "\t" + aplcatresult.bull_tnr.to_s + "|" + aplcatresult.calf_tnr.to_s + "\t" + aplcatresult.rh_tnr.to_s + "\t" + aplcatresult.fch_tnr.to_s + "\t" + aplcatresult.cow_tnr.to_s + "\t" + aplcatresult.bull_tnr.to_s + "\t" + "Total Nitrogen retained (g/day | kg/year)" + "\n"
      #apex_string += aplcatresult.calf_fne.to_s + "\t" + aplcatresult.rh_fne.to_s + "\t" + aplcatresult.fch_fne.to_s + "\t" + aplcatresult.cow_fne.to_s + "\t" + aplcatresult.bull_fne.to_s + "|" + aplcatresult.calf_fne.to_s + "\t" + aplcatresult.rh_fne.to_s + "\t" + aplcatresult.fch_fne.to_s + "\t" + aplcatresult.cow_fne.to_s + "\t" + aplcatresult.bull_fne.to_s + "\t" + "Fecal Nitrogen excretion (g/day | kg/year)" + "\n"
      #apex_string += aplcatresult.calf_une.to_s + "\t" + aplcatresult.rh_une.to_s + "\t" + aplcatresult.fch_une.to_s + "\t" + aplcatresult.cow_une.to_s + "\t" + aplcatresult.bull_une.to_s + "|" + aplcatresult.calf_une.to_s + "\t" + aplcatresult.rh_une.to_s + "\t" + aplcatresult.fch_une.to_s + "\t" + aplcatresult.cow_une.to_s + "\t" + aplcatresult.bull_une.to_s + "\t" + "Urine Nitrogen excretion (g/day | kg/year)" + "\n"
      #apex_string = "\n"
      #apex_string = "Greenhouse Gas Emission" + "\n"
      #apex_string += aplcatresult.calf_eme.to_s + "\t" + aplcatresult.rh_eme.to_s + "\t" + aplcatresult.fch_eme.to_s + "\t" + aplcatresult.cow_eme.to_s + "\t" + aplcatresult.bull_eme.to_s + "|" + aplcatresult.calf_eme.to_s + "\t" + aplcatresult.rh_eme.to_s + "\t" + aplcatresult.fch_eme.to_s + "\t" + aplcatresult.cow_eme.to_s + "\t" + aplcatresult.bull_eme.to_s + "\t" + "AEnteric methane emission ('daily', g | Mcal)" + "\n"
      #apex_string += aplcatresult.calf_mme.to_s + "\t" + aplcatresult.rh_mme.to_s + "\t" + aplcatresult.fch_mme.to_s + "\t" + aplcatresult.cow_mme.to_s + "\t" + aplcatresult.bull_mme.to_s + "|" + aplcatresult.calf_mme.to_s + "\t" + aplcatresult.rh_mme.to_s + "\t" + aplcatresult.fch_mme.to_s + "\t" + aplcatresult.cow_mme.to_s + "\t" + aplcatresult.bull_mme.to_s + "\t" + "Manure methane emission (g/day | kg/year)" + "\n"
      #apex_string += "\n"

      #***** send file to server "
      #msg = send_file_to_APEX(apex_string, "AplcatResults.txt")
  end

  def get_file_from_APLCAT(file)
    client = Savon.client(wsdl: URL_SoilsInfo)
    ###### retrieve MSW, MWS, ACY files from apex simulation ########
    response = client.call(:get_aplcat_file, message: {"file" => file, "session_id" => session[:session_id]})
    if !response.body[:get_aplcat_file_response][:get_aplcat_file_result] == "Error" then
      return response.body[:get_aplcat_file_response][:get_aplcat_file_result]
    else
      return response.body[:get_aplcat_file_response][:get_aplcat_file_result]
    end
  end
end
