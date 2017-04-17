# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

select_scenarios = (num) ->
  field = "#field_id" + num
  scenario = "#scenario_id" + num
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
  $("#field_id1").change ->
    select_scenarios(1)

  $("#field_id2").change ->
    select_scenarios(2)

  $("#field_id3").change ->
    select_scenarios(3)

  $("#field_id4").change ->
    select_scenarios(4)

  $("#field_id5").change ->
    select_scenarios(5)

  $("#field_id6").change ->
    select_scenarios(6)

  $("#field_id7").change ->
    select_scenarios(7)

  $("#field_id8").change ->
    select_scenarios(8)

  $("#field_id9").change ->
    select_scenarios(9)

  $("#field_id10").change ->
    select_scenarios(10)

  $("#field_id11").change ->
    select_scenarios(11)

  $("#field_id12").change ->
    select_scenarios(12)

  $("#field_id13").change ->
    select_scenarios(13)

  $("#field_id14").change ->
    select_scenarios(14)

  $("#field_id15").change ->
    select_scenarios(15)

  $("#field_id16").change ->
    select_scenarios(16)

  $("#field_id17").change ->
    select_scenarios(17)

  $("#field_id18").change ->
    select_scenarios(18)

  $("#field_id19").change ->
    select_scenarios(19)

  $("#field_id20").change ->
    select_scenarios(20)
