# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

select_scenarios = ->
  field = "#field_id"
  scenario = "#scenario_id" 
  url = "/projects/" + $("#project_id").val() + "/fields/" + $(field).val() + "/scenarios.json"
  if $(field).val() > 0
    $.getJSON url, (scenarios) ->
      items = []
      items.push "<option value>Select Scenarios</option>"
      $.each scenarios, (key, scenario) ->
        items.push "<option value=\"" + scenario.id + "\">" + scenario.name + "</option>"
      $(scenario).html items.join("")
      $(scenario).removeAttr("disabled")
  else
    items = []
    items.push "<option value>Select Scenarios</option>"
    $(scenario).html items.join("")
    $(scenario).removeAttr("disabled")

$(document).ready ->
  $("#field_id").change ->
    select_scenarios()
