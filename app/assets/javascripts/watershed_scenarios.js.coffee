# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

select_scenarios = ->
  url = "/projects/" + $("#project_id").val() + "/fields/" + $("#field_id").val() + "/scenarios.json"
  if $("#field_id").val() > 0
    $.getJSON url, (scenarios) ->
      items = []
      items.push "<option value>Select Scenarios</option>"
      $.each scenarios, (key, scenario) ->
        items.push "<option value=\"" + scenario.id + "\">" + scenario.name + "</option>"
      $("#scenario_id").html items.join("")
      $("#scenario_id").removeAttr("disabled")
  else
    items = []
    items.push "<option value>Select Scenarios</option>"
    $("#scenario_id").html items.join("")
    $("#scenario_id").removeAttr("disabled")

$(document).ready ->
  $("#field_id").change ->
    select_scenarios()