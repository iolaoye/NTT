
update_soilslist = ->
    url = "/soils/" + $("#field_id").val() + "/list.json"
    $.getJSON url, (soilslist) ->
       $.each soilslist, (key, soil) ->
           url = "/subareas.json?soil_id=" + soil.id + "&scenario_id=" + $("#subarea_scenario_id").val()
           $.getJSON url, (subareaslist) ->
              items = []
              items.push "<option value>Select One</option>"
              $.each subareaslist, (key, subarea ) ->
                 items.push "option value=\"" + subarea.id + "\">" + subarea.description + "</option>" 
              $("#subarea_subarea_id").html items.join("")

$(document).ready ->
    $("#subarea_scenario_id").change ->
       update_soilslist()

