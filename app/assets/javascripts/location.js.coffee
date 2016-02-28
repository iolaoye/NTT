updateCounties = ->
  $.getJSON "/states/" + $("#location_state_id").val() + "/counties.json", (counties) ->
    items = []
    items.push "<option value>Select County</option>"
    $.each counties, (key, county) ->
      items.push "<option value=\"" + county.id + "\">" + county.county_name + "</option>"
    $("#location_county_id").html items.join("")
    $("#location_county_id").removeAttr("disabled")

$(document).ready ->
    $("#location_state_id").change ->
      updateCounties()
