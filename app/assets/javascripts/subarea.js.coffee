
load_subareas = ->
    url = "/soils/" + $("#field_id").val() + "/list.json"
    items = []
    items.push "<option value>Select Subarea</option>"
    $.getJSON url, (soils_list) ->
       $.each soils_list, (key, soil) ->
           url = "/subareas.json?soil_id=" + soil.id + "&scenario_id=" + $("#subarea_scenario_id").val()
           $.getJSON url, (subareas_list) ->
              $.each subareas_list, (key, subarea) ->
                 items.push "<option value=\"" + subarea.id + "\">" + subarea.description + "</option>"
              $("#subarea_subarea_id").html(items.join(""))

$(document).ready ->
    $("#subarea_scenario_id").change ->
       load_subareas()

