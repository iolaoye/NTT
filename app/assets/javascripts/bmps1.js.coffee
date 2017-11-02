# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be irrigation in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

take_efficiency = ->
   switch $("#bmp_ai_irrigation_id").val()
       when "1" #Sprinkle
           $("#bmp_ai_irrigation_efficiency").val(70)
           $("#bmp_ai_irrigation_efficiency_lable").val("70 - 80%")
       when "2" #Furrow/Flood
           $("#bmp_ai_irrigation_efficiency").val(65)
           $("#bmp_ai_irrigation_efficiency_lable").val("50 - 70%")
       when "3" #Drip
           $("#bmp_ai_irrigation_efficiency").val(85)
           $("#bmp_ai_irrigation_efficiency_lable").val("80 - 95%")
       when "7" #Furow Diken
           $("#bmp_ai_irrigation_efficiency").val(90)
           $("#bmp_ai_irrigation_efficiency_lable").val("80 - 95%")
       when "8" #Tailwater
           $("#bmp_ai_irrigation_efficiency").val(65)
           $("#bmp_ai_irrigation_efficiency_lable").val("50 - 70%")

update_max_row = ->
    top = $("#climate_max_1").val()
    $(".max").val(top)

update_min_row = ->
    top = $("#climate_min_1").val()
    $(".min").val(top)

update_pcp_row = ->
    top = $("#climate_pcp_1").val()
    $(".pcp").val(top)

update_animal_options = ->
  url = "/fertilizers/" + $("#bmp_sf_animal_id").val() + ".json"
  $.getJSON url, (fertilizer) ->
     $("#bmp_sf_dry_manure").val(fertilizer.dry_matter)
     $("#bmp_sf_no3_n").val(fertilizer.qn)
     $("#bmp_sf_po4_p").val(fertilizer.qp)
     $("#bmp_sf_org_n").val(fertilizer.yn)
     $("#bmp_sf_org_p").val(fertilizer.yp)

#update nutrients for manure control
update_manure_control_options = ->
  url = "/manure_controls/" + $("#bmp_mc_animal_id").val() + ".json"
  $.getJSON url, (control) ->
     $("#bmp_mc_no3_n").val(control.no3n)
     $("#bmp_mc_po4_p").val(control.po4p)
     $("#bmp_mc_org_n").val(control.orgn)
     $("#bmp_mc_org_p").val(control.orgp)

#update bmp sublist depending on the bmp selected.
update_bmpsublist = ->
  url = "/bmplists/" + $("#bmp_bmp_id").val() + "/bmpsublists.json"
  if $("#bmp_bmp_id").val() > 0
    $.getJSON url, (bmpsublists) ->
      url = window.location.href
      n = url.indexOf('locale=')
      language = url.substring(n, n + 9)
      if language == "locale=en"
        items = []
        items.push "<option value>Select One</option>"
        $.each bmpsublists, (key, bmpsublist) ->
           items.push "<option value=\"" + bmpsublist.id + "\">" + bmpsublist.name + "</option>"
        $("#bmp_bmpsublist_id").html items.join("")
        $("#bmp_bmpsublist_id").removeAttr("disabled")
      else if language == "locale=es"
        items = []
        items.push "<option value>Select One</option>"
        $.each bmpsublists, (key, bmpsublist) ->
          items.push "<option value=\"" + bmpsublist.id + "\">" + bmpsublist.spanish_name + "</option>"
        $("#bmp_bmpsublist_id").html items.join("")
        $("#bmp_bmpsublist_id").removeAttr("disabled")
      else
        window.alert 'WTF Language error. Default English will be set for list Click [OK] to continue.'
        items = []
        items.push "<option value>Select One</option>"
        $.each bmpsublists, (key, bmpsublist) ->
          items.push "<option value=\"" + bmpsublist.id + "\">" + bmpsublist.name + "</option>"
        $("#bmp_bmpsublist_id").html items.join("")
        $("#bmp_bmpsublist_id").removeAttr("disabled")
  else
    items = []
    items.push "<option value>Select One</option>"
    $("#bmp_bmpsublist_id").html items.join("")
    $("#bmp_bmpsublist_id").removeAttr("disabled")

#switch all of the bmps off to avoid having something on that does not belong to the new selected bmp
switch_all_to_off = ->
    $("#irrigation").toggle(false)
    $("#irrigation1").toggle(false)
    $("#water_stress_factor").toggle(false)
    $("#irrigation_efficiency").toggle(false)
    $("#maximum_single_application").toggle(false)
    $("#safety_factor").toggle(false)
    $('#bmp_crop_id').prop('required',false)
    $('#bmp_animal_id').prop('required',false)
    $('#bmp_irrigation_id').prop('required',false)
    $("#depth").toggle(false)
    $("#width").toggle(false)
    $("#sides").toggle(false)
    $("#area").toggle(false)
    $("#number_of_animals").toggle(false)
    $("#animals").toggle(false)
    $("#days").toggle(false)
    $("#hours").toggle(false)
    $("#dry_manure").toggle(false)
    $("#no3_n").toggle(false)
    $("#po4_p").toggle(false)
    $("#org_n").toggle(false)
    $("#org_p").toggle(false)
    $("#grass_field_portion").toggle(false)
    $("#buffer_slope_upland").toggle(false)
    $("#crop").toggle(false)
    $("#no_input").toggle(false)
    $("#crop_width").toggle(false)
    $("#slow_warning").toggle(false)
    $("#climate_table").toggle(false)
    $("#slope_reduction").toggle(false)
    $("#tr_bmp_pp_area").toggle(false)
    switch_all_labels_off()

switch_all_labels_off = ->
    $("#irrigation_efficiency_label").toggle(false)
    $("#area_control_label").toggle(false)
    $("#depth_ft_label").toggle(false)
    $("#waterways_label").toggle(false)
    $("#width_label").toggle(false)
    $("#contour_buffer_label").toggle(false)
    $("#stream_fencing_label").toggle(false)
    $("#irrigation_frequency_label").toggle(false)

#activate elements on the bmp screen according to the bmp sublist selected
activate_bmp_controls = ->
    switch_all_to_off()
    switch $("#bmp_bmpsublist_id").val()
        when "1" #autoirrigation
            $("#irrigation_efficiency_label").toggle(true)
            $('#irrigation').toggle(true)
            $("#water_stress_factor").toggle(true)
            $("#irrigation_efficiency").toggle(true)
            $("#maximum_single_application").toggle(true)
            $("#days").toggle(true)
            $("#irrigation_frequency_label").toggle(true)
        when "2" #autofertigation
            $("#irrigation_efficiency_label").toggle(true)
            $('#irrigation').toggle(true)
            $("#water_stress_factor").toggle(true)
            $("#irrigation_efficiency").toggle(true)
            $("#maximum_single_application").toggle(true)
            $("#days").toggle(true)
            $("#irrigation_frequency_label").toggle(true)
        when "3" #Tile Drain
            $("#depth").toggle(true)
            $("#depth_ft_label").toggle(true)
        when "4", "5" #Pad and pipes - No Ditch Improvement, Two-stage ditch system
            $("#width").toggle(true)
            $("#width_label").toggle(true)
            $("#sides").toggle(true)
        when "6", "7" #Pad and pipes - ditch enlargement and reservoir system, tailwater irrigation
            $("#width").toggle(true)
            $("#width_label").toggle(true)
            $("#sides").toggle(true)
            $("#area").toggle(true)
        when "8" #wetland
            $("#area").toggle(true)
        when "9" #ponds
            $("#area_control_label").toggle(true)
            $("#irrigation_efficiency").toggle(true)
        when "10" #stream fencing
            $("#animals").toggle(true)
            $("#number_of_animals").toggle(true)
            $("#days").toggle(true)
            $("#stream_fencing_label").toggle(true)
            $("#hours").toggle(true)
            $("#dry_manure").toggle(true)
            $("#no3_n").toggle(true)
            $("#po4_p").toggle(true)
            $("#org_n").toggle(true)
            $("#org_p").toggle(true)
        when "11" #streambank stabilization -nothing is needed no inputs needed
            $("#no_input").toggle(true)
        when "12" #Riparian forest
            $("#area").toggle(true)
            $("#width").toggle(true)
            $("#width_label").toggle(true)
            $("#grass_field_portion").toggle(true)
            $("#buffer_slope_upland").toggle(true)
        when "13" #filter strip
            $("#area").toggle(true)
            $("#width").toggle(true)
            $("#width_label").toggle(true)
            $("#crop").toggle(true)
            $("#buffer_slope_upland").toggle(true)
            $('#bmp_crop_id').prop('required',true)
        when "14" #water ways
            $("#width").toggle(true)
            $("#waterways_label").toggle(true)
            $("#crop").toggle(true)
        when "15" #contour buffer
            $("#width").toggle(true)
            $("#contour_buffer_label").toggle(true)
            $("#crop").toggle(true)
            $("#crop_width").toggle(true)
        when "16" #land leveling
            $("#slope_reduction").toggle(true)
        when "17" #Terrace system
            $("#no_input").toggle(true)
        when "19" #climate change
            $("#climate_table").toggle(true)
            $("#slow_warning").toggle(true)
        when "20" #asphalt or concrete
            $("#no_input").toggle(true)
        when "21" #grass cover
            $("#no_input").toggle(true)
        when "22" #slope adjustment
            $("#no_input").toggle(true)
        when "23" #Shading
            $("#area").toggle(true)
            $("#width").toggle(true)
            $("#width_label").toggle(true)
            $("#crop").toggle(true)
            $("#buffer_slope_upland").toggle(true)
            $("#bmp_crop_id").prop('required',true)

#activate elements on the bmp screen according to the bmp sublist selected
update_irrigation_options = ->
    switch $("#bmp_irrigation_id").val()
        when "7" #furrow diking
            $("#safety_factor").toggle(true)
            $("#area").toggle(false)
            $("#water_stress_factor").toggle(true)
            $("#irrigation_efficiency").toggle(true)
            $("#maximum_single_application").toggle(true)
            $("#days").toggle(true)
            $("#irrigation_frequency_label").toggle(true)

        when "8" #pads and pipes
            $("#safety_factor").toggle(false)
            $("#area").toggle(true)
            $("#water_stress_factor").toggle(true)
            $("#irrigation_efficiency").toggle(true)
            $("#maximum_single_application").toggle(true)
            $("#days").toggle(true)
            $("#irrigation_frequency_label").toggle(true)

        else
            $("#safety_factor").toggle(false)
            $("#area").toggle(false)
            $("#water_stress_factor").toggle(true)
            $("#irrigation_efficiency").toggle(true)
            $("#maximum_single_application").toggle(true)
            $("#days").toggle(true)
            $("#irrigation_frequency_label").toggle(true)


update_fertigation_options = ->
    switch $("#autofertigation").val()
        when "7" #furrow diking
            $("#safety_factor").toggle(true)
            $("#area").toggle(false)
            $("#water_stress_factor").toggle(true)
            $("#irrigation_efficiency").toggle(true)
            $("#maximum_single_application").toggle(true)
            $("#days").toggle(true)
            $("#irrigation_frequency_label").toggle(true)

        else
            $("#safety_factor").toggle(false)
            $("#area").toggle(false)
            $("#water_stress_factor").toggle(true)
            $("#irrigation_efficiency").toggle(true)
            $("#maximum_single_application").toggle(true)
            $("#days").toggle(true)
            $("#irrigation_frequency_label").toggle(true)

rb_td = (opt) ->
    $("#div_td_opt1").toggle(false)
    $("#div_td_opt2").toggle(false)
    $("#div_td_opt3").toggle(false)
    $("#div_td_opt4").toggle(false)
    $("#div_td_opt5").toggle(false)
    switch opt
      when 3 #option 1
            $("#div_td_opt1").toggle(true)
      when 4 #option 2
            $("#div_td_opt2").toggle(true)
            $("#div_td_opt3").toggle(true)
            $("#div_td_opt4").toggle(true)
            $("#div_td_opt5").toggle(true)

pads_and_pipes = (opt) ->
    $("#tr_bmp_pp_area").toggle(false)
    switch opt
        when 6 #Ditch Enlargement and Reservoir System
            $("#tr_bmp_pp_area").toggle(true)
        when 7 #Tailwater Irrigation
            $("#tr_bmp_pp_area").toggle(true)

buffers = (opt) ->
    $("#tr_fs_vegetation").toggle(false)
    $("#tr_grass_field_portion").toggle(false)
    switch opt
        when 12 #Filter Strip
            $("#tr_grass_field_portion").toggle(true)
        when 13 #Forest buffer
            $("#tr_fs_vegetation").toggle(true)

#bmpsublist_irrigation_selector = ->
    #bmp_collection = $('#bmp_bmpsublist_id')
    # Edit the selector to match the actual generated "id" for the collection
    #bmp_collection.change ->
    #value = bmp_collection.val()
    #if value == 2
    #    use_this_list()
    #else
    #    use_this_other_list()

#select_irrigation_drip_options = ->
    #bmp_collection = $('#bmp_bmpsublist_id')
    #drip_collection = $('#bmp_irrigation_id')
    #drip_option = drip_collection.find('option')[2]
    #value = bmp_collection.val()
    #if value == 2
    #  drip_option.attr 'disabled', 'disabled'
    #else
    #  drip_option.removeAttr 'disabled'

#determine the radio button selected for P & P and shows reservoir area if it is 6 or 7.

#bmp_irrigation_id
#["Sprinkle", "Furrow/Flood", "Drip", "Furrow Diking", "Pads and Pipes - Tailwater Irrigation"]
#bmp_bmpsublist_id
$(document).ready ->
    #activate_bmp_controls()
    $("#bmp_ai_irrigation_id").change ->
        take_efficiency()
    $("#bmp_bmp_id").change ->
	    update_bmpsublist()
    $("#bmp_bmpsublist_id").change ->
	    activate_bmp_controls()
    $("#bmp_sf_animal_id").change ->
	    update_animal_options()
    $("#bmp_irrigation_id").change ->
        update_irrigation_options()
    $("#autofertigation").change ->
        update_fertigation_options()
    $("#bmp_mc_animal_id").change ->
	    update_manure_control_options()
    $("#bmp_td_3").click ->
        rb_td(3)
    $("#bmp_td_4").click ->
        rb_td(4)
    $("#fill_max").click ->
        update_max_row()
    $("#fill_pcp").click ->
        update_pcp_row()
    $("#fill_min").click ->
        update_min_row()
    $("#bmp_cb2_4").click ->
        pads_and_pipes(4)
    $("#bmp_cb2_5").click ->
        pads_and_pipes(5)
    $("#bmp_cb2_6").click ->
        pads_and_pipes(6)
    $("#bmp_cb2_7").click ->
        pads_and_pipes(7)
    $("#bmp_cb3_12").click ->
        buffers(12)
    $("#bmp_cb3_13").click ->
        buffers(13)
