
update_soilslist = ->
    url = "/soils/" + $("#field_id").val() + "/list.json"
    $.getJSON url, (soilslist) ->
       items = []
       $.each soilslist, (key, soil) ->
           url = "/subareas.json?soil_id=" + soil.id + "&scenario_id=" + $("#subarea_scenario_id").val()
           $.getJSON url, (subareaslist) ->
              $.each subareaslist, (key, subarea ) ->
                 items.push "option value=\"" + subarea.id + "\">" + subarea.description + "</option>" 
       $("#subarea_scenario_id").html items.join("")

$(document).ready ->
    $("#subarea_subarea_id").change ->
       update_soilslist()

