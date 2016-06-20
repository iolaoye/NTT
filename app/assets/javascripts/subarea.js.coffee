
update_soilslist = ->
  url = "/soils/" + $("hidden_field_id").val() + "/list.json"
  $.getJSON url, (soilslist) ->
    items = []
    $.each soilslist, (key,soil) ->
      url = "/subareas.json?soil_id=" + soil.id + "&scenario_id=" + $("#scenario_id").val()
      $.getJSON url, subarealist ->
      items.push "option value=\"" + subareaslist[0].id + "\">" + subareaslist[0].discription + "</option>"
    $("#scenario_id").html items.join("")

$(document).ready ->
    $("#scenario_id").change ->
    update_soilslist()

