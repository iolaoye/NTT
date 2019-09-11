updateCounties = ->
  $.getJSON "/states/" + $("#stateselect")[0].value + "/counties.json", (counties) ->
    items = []
    items.push "<option value>Select County</option>"
    $.each counties, (key, county) ->
      items.push "<option value=\"" + county.id + "\">" + county.county_name + "</option>"
    $("#countyselect").html items.join("")
    $("#countyselect").removeAttr("disabled")

$(document).ready ->
    $("#location_state_id").change ->
      updateCounties()
	 
    $("#stateselect").change ->
      updateCounties()

 
