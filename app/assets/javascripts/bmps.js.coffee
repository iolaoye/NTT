# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
    activate_bmp_controls()
    $("#bmp_bmp_id").change ->
      update_bmpsublist()
    $("#bmp_bmpsublist_id").change ->
      activate_bmp_controls()

#update bmp sublist depending on the bmp selected.
update_bmpsublist = ->
  $.getJSON "/bmplists/" + $("#bmp_bmp_id").val() + "/bmpsublists.json", (bmpsublists) ->
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
     $("#width").toggle(false)
     $("#sides").toggle(false)
     $("#area").toggle(false)
     $("#number_of_animals").toggle(false)
     $("#animal_id").toggle(false)
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
     $("#crop_width").toggle(true)
     $("#difference_max_temperature").toggle(false)
     $("#difference_min_temperature").toggle(false)
     $("#difference_precipitation").toggle(false)

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
            $("#safety_factor").toggle(true)
            $('#bmp_irrigation_id').prop('required',true)   
        when "2" #autofertigation
            $("#irrigation").toggle(true)
            $("#water_stress_factor").toggle(true)
            $("#irrigation_efficiency").toggle(true)
            $("#maximum_single_application").toggle(true)
            $("#days").toggle(true)
            $("#safety_factor").toggle(true)
            $('#irrigation_id').prop('required',true)   
        when "3" #Tile Drain
            $("#depth").toggle(true)
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
            $("#no3_n").toggle(true)
        when "10" #stream fencing
            $("#number_of_animals").toggle(true)
            $("#animal_id").toggle(true)
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
        when "22" #climate change
            $("#difference_max_temperature").toggle(true)
            $("#difference_min_temperature").toggle(true)
            $("#difference_precipitation").toggle(true)
        when "23" #asfalt or concrete
            $("#no_input").toggle(true)
        when "24" #grass cover
            $("#no_input").toggle(true)
        when "23" #slope adjustmen
            $("#no_input").toggle(true)
        when "13" #Shading
            $("#area").toggle(true)
            $("#width").toggle(true)
            $("#crop").toggle(true)
            $("#buffer_slope_upland").toggle(true)
            $('#bmp_crop_id').prop('required',true)
