# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

select_scenarios = (num) ->
  field = "#field" + num + "_id"
  scenario = "#scenario" + num + "_id" 
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
  $("#field1_id").change ->
    select_scenarios(1)

  $("#field2_id").change ->
    select_scenarios(2)

  $("#field3_id").change ->
    select_scenarios(3)

  $("#field4_id").change ->
    select_scenarios(4)

  $("#field5_id").change ->
    select_scenarios(5)

  $("#field_id").change ->
    select6_scenarios(6)

  $("#field7_id").change ->
    select_scenarios(7)

  $("#field8_id").change ->
    select_scenarios(8)

  $("#field9_id").change ->
    select_scenarios(9)

  $("#field10_id").change ->
    select_scenarios(10)

  $("#field11_id").change ->
    select_scenarios(11)

  $("#field12_id").change ->
    select_scenarios(12)

  $("#field13_id").change ->
    select_scenarios(13)

  $("#field14_id").change ->
    select_scenarios(14)

  $("#field15_id").change ->
    select_scenarios(15)

  $("#field16_id").change ->
    select_scenarios(16)

  $("#field17_id").change ->
    select_scenarios(17)

  $("#field18_id").change ->
    select_scenarios(18)

  $("#field19_id").change ->
    select_scenarios(19)

  $("#field20_id").change ->
    select_scenarios(20)
