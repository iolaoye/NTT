# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

create_watershed = ->
    $("#div_new").toggle(true)

select_scenarios = (num) ->
  if (num==0)
     field = "#field"
     scenario = "#scenario"
  else
     field = "#field" + num 
     scenario = "#scenario" + num
  $("#field_id1").val($(field).val())
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

change_selection = ->
    tbl_watersheds = $("#tbl_watersheds")
    for i in [1..tbl_watersheds[0].rows.length]
        tbl_watersheds[0].rows[i].cells[0].children[0].checked = tbl_watersheds[0].rows[0].cells[0].children[0].checked

loading_screen = ->
    $(".overlay").toggle(true)

$(document).ready ->
  $("#select_todo").click ->
    change_selection()

  $("#new_watershed").click ->
    create_watershed()

  $("#field_id").change ->
    select_scenarios(0)

  $("#field1").change ->
    select_scenarios(1)

  $("#field2").change ->
    select_scenarios(2)

  $("#field3").change ->
    select_scenarios(3)

  $("#field4").change ->
    select_scenarios(4)

  $("#field5").change ->
    select_scenarios(5)

  $("#field6").change ->
    select6_scenarios(6)

  $("#field7").change ->
    select_scenarios(7)

  $("#field8").change ->
    select_scenarios(8)

  $("#field9").change ->
    select_scenarios(9)

  $("#field10").change ->
    select_scenarios(10)

  $("#field11").change ->
    select_scenarios(11)

  $("#field12").change ->
    select_scenarios(12)

  $("#field13").change ->
    select_scenarios(13)

  $("#field14").change ->
    select_scenarios(14)

  $("#field15").change ->
    select_scenarios(15)

  $("#field16").change ->
    select_scenarios(16)

  $("#field17").change ->
    select_scenarios(17)

  $("#field18").change ->
    select_scenarios(18)

  $("#field19").change ->
    select_scenarios(19)

  $("#field20").change ->
    select_scenarios(20)

  $("#simulate_watershed").click ->
    loading_screen()
