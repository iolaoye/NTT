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
