# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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
  url = "/fertilizers/" + $("#bmp_animal_id").val() + ".json"
  $.getJSON url, (fertilizer) ->
     $("#bmp_dry_manure").val(fertilizer.dry_matter)
     $("#bmp_no3_n").val(fertilizer.qn)
     $("#bmp_po4_p").val(fertilizer.qp)
     $("#bmp_org_n").val(fertilizer.yn)
     $("#bmp_org_p").val(fertilizer.yp)

#update bmp sublist depending on the bmp selected.
update_bmpsublist = ->
  url = "/bmplists/" + $("#bmp_bmp_id").val() + "/bmpsublists.json"
  $.getJSON url, (bmpsublists) ->
    items = []
    items.push "<option value>Select One</option>"
    $.each bmpsublists, (key, bmpsublist) ->
       items.push "<option value=\"" + bmpsublist.id + "\">" + bmpsublist.name + "</option>"
    $("#bmp_bmpsublist_id").html items.join("")
    $("#bmp_bmpsublist_id").removeAttr("disabled")
	
#switch all of the bmps off to avoid having something on that does not belong to the new selected bmp
switch_all_to_off = ->
     $("#irrigation").toggle(false)
     $("#water_stress_factor").toggle(false)
     $("#irrigation_efficiency").toggle(false)
     $("#maximum_single_application").toggle(false)
     $("#days").toggle(false)
     $("#safety_factor").toggle(false)
     $('#bmp_crop_id').prop('required',false)
     $('#bmp_animal_id').prop('required',false)   
     $('#bmp_irrigation_id').prop('required',false)   
     $("#depth").toggle(false)
     $("#depth_ft_label").toggle(false)
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
     $("#climate_table").toggle(false)
     $("#slope_reduction").toggle(false)

#activate elements on the bmp screen according to the bmp sublist selected
activate_bmp_controls = ->
    switch_all_to_off()
    switch $("#bmp_bmpsublist_id").val()
        when "1" #autoirrigation
            $("#irrigation").toggle(true)
            $("#water_stress_factor").toggle(true)
            $("#irrigation_efficiency").toggle(true)
            $("#maximum_single_application").toggle(true)
            $("#days").toggle(true)
        when "2" #autofertigation
            $("#irrigation").toggle(true)
            $("#water_stress_factor").toggle(true)
            $("#irrigation_efficiency").toggle(true)
            $("#maximum_single_application").toggle(true)
            $("#days").toggle(true) 
        when "3" #Tile Drain
            $("#depth").toggle(true)
            $("#depth_ft_label").toggle(true)
            $("#safety_factor").toggle(false)
        when "4", "5" #Pad and pipes - No Ditch Improvement, Two-stage ditch system
            $("#width").toggle(true)
            $("#sides").toggle(true)
        when "6", "7" #Pad and pipes - ditch enlargement and reservoir system, tailwater irrigation
            $("#width").toggle(true)
            $("#sides").toggle(true)
            $("#area").toggle(true)
        when "8" #wetland
            $("#area").toggle(true)
        when "9" #ponds
            $("#irrigation_efficiency").toggle(true)
        when "10" #stream fencing
            $("#animals").toggle(true)
            $("#number_of_animals").toggle(true)
            $("#days").toggle(true)
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
            $("#grass_field_portion").toggle(true)
            $("#buffer_slope_upland").toggle(true)
        when "13" #filter strip
            $("#area").toggle(true)
            $("#width").toggle(true)
            $("#crop").toggle(true)
            $("#buffer_slope_upland").toggle(true)
            $('#bmp_crop_id').prop('required',true)
        when "14" #water ways
            $("#width").toggle(true)
            $("#crop").toggle(true)
        when "15" #contour buffer
            $("#width").toggle(true)
            $("#crop").toggle(true)
            $("#crop_width").toggle(true)
        when "16" #land leveling
            $("#slope_reduction").toggle(true)
        when "17" #Terrace system
            $("#no_input").toggle(true)
        when "19" #climate change
            $("#climate_table").toggle(true)
        when "20" #asphalt or concrete
            $("#no_input").toggle(true)
        when "21" #grass cover
            $("#no_input").toggle(true)
        when "22" #slope adjustment
            $("#no_input").toggle(true)
        when "23" #Shading
            $("#area").toggle(true)
            $("#width").toggle(true)
            $("#crop").toggle(true)
            $("#buffer_slope_upland").toggle(true)
            $("#bmp_crop_id").prop('required',true)
    
#activate elements on the bmp screen according to the bmp sublist selected
update_irrigation_options = ->
    switch $("#bmp_irrigation_id").val()
        when "7" #furrow diking
            $("#safety_factor").toggle(true)
            $("#area").toggle(false)
            $("#irrigation").toggle(true)
            $("#water_stress_factor").toggle(true)
            $("#irrigation_efficiency").toggle(true)
            $("#maximum_single_application").toggle(true)
            $("#days").toggle(true)
        when "8" #pads and pipes
            $("#safety_factor").toggle(false)
            $("#area").toggle(true)
            $("#irrigation").toggle(true)
            $("#water_stress_factor").toggle(true)
            $("#irrigation_efficiency").toggle(true)
            $("#maximum_single_application").toggle(true)
            $("#days").toggle(true)
        else
            $("#safety_factor").toggle(false)
            $("#area").toggle(false)
            $("#irrigation").toggle(true)
            $("#water_stress_factor").toggle(true)
            $("#irrigation_efficiency").toggle(true)
            $("#maximum_single_application").toggle(true)
            $("#days").toggle(true)



$(document).ready ->
    activate_bmp_controls()
    $("#bmp_bmp_id").change ->
	    update_bmpsublist()
    $("#bmp_bmpsublist_id").change ->
	    activate_bmp_controls()
    $("#bmp_animal_id").change ->
	    update_animal_options()
    $("#bmp_irrigation_id").change ->
        update_irrigation_options()
    $("#fill_max").click ->
        update_max_row()
    $("#fill_min").click ->
        update_min_row()
    $("#fill_pcp").click ->
        update_pcp_row()

